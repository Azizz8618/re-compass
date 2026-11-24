#!/usr/bin/env python3
"""Find likely undeclared identifiers in the generated Pascal sources.

Uses the exact W5b diagnostic source lines for `******11` and a conservative
declaration scan.  GOST canonicalisation makes homoglyph spellings comparable.
"""
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gostnorm

BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5c-fix')
LOGDIR = Path('/home/azizz/.local/share/vifm/Trash/tss-w5b-run/logs')
NAMES = ['SKLMON','SKLOTD','SKLCAR','SKLOTC','AMOMON','AMOOTD','AMOCAR',
         'AMOOTC','AMOGRU','ZATMON','ZATOTD','ZATCOF','ZATZAT','ZATNAK',
         'ZATRTE','ZATTAB']

KEYWORDS = set(gostnorm.canon(x) for x in '''
AND ARRAY BEGIN CASE CONST DIV DO ELSE END FILE FOR FUNCTION GOTO IF IN
LABEL MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT SET THEN TO
TYPE UNTIL VAR WHILE WITH OUTPUT INPUT INTEGER REAL BOOLEAN CHAR TEXT TRUE
FALSE WRITE WRITELN READ READLN NEW DISPOSE CHR ORD SUCC PRED ABS SQR SQRT
SIN COS ARCTAN EXP LN TRUNC ROUND EOF EOLN PAGE PUT GET RESET REWRITE CLOSE
INTEGER LONGINT SHORTINT BYTE WORD
'''.split())

ID = re.compile(r'[A-Za-zА-Яа-яЁё][A-Za-z0-9А-Яа-яЁё_]*')


def strip_comments_strings(s):
    out = []
    i = 0
    n = len(s)
    while i < n:
        if s.startswith('(*', i):
            j = s.find('*)', i + 2)
            i = n if j < 0 else j + 2
            continue
        if s[i] in ("'", '\u2019', '\u2018'):
            quote = s[i]
            j = i + 1
            while j < n:
                if s[j] == quote:
                    if j + 1 < n and s[j + 1] == quote:
                        j += 2
                        continue
                    break
                j += 1
            i = j + 1
            continue
        out.append(s[i])
        i += 1
    return ''.join(out)


def declaration_names(src_canon):
    decl = set()
    lines = strip_comments_strings(src_canon).splitlines()
    text = '\n'.join(lines)
    # program / procedure / function / unit names
    K = lambda w: gostnorm.canon(w)
    decl |= set(re.findall(
        r'\b(?:%s|%s|%s|%s|%s)\s+([A-ZА-ЯЁ][A-ZА-ЯЁ0-9_]*)' %
        tuple(K(x) for x in ('PROGRAM', 'PROCEDURE', 'FUNCTION', 'UNIT', 'LABEL')), text))
    # var/const/type blocks: names before ':' or '=' at statement level
    for m in re.finditer(
            r'\b(?:%s)\b(.*?)(?=\b(?:%s)\b)' %
            ('|'.join(K(x) for x in ('VAR', 'CONST', 'TYPE')),
             '|'.join(K(x) for x in ('VAR', 'CONST', 'TYPE', 'PROCEDURE',
                                     'FUNCTION', 'BEGIN', 'END'))), text, re.S):
        block = m.group(1)
        for stmt in block.split(';'):
            names = re.findall(r'([A-ZА-ЯЁ][A-ZА-ЯЁ0-9_]*)\s*(?::|=[^=]|,)', stmt)
            decl |= set(names)
    # inline `var X:` and `X: type` inside procedures
    decl |= set(re.findall(r'\b%s\s+([A-ZА-ЯЁ][A-ZА-ЯЁ0-9_]*)' % K('VAR'), text))
    # for loop variables
    decl |= set(re.findall(r'\b%s\s+([A-ZА-ЯЁ][A-ZА-ЯЁ0-9_]*)\s*:=' % K('FOR'), text))
    # record variant field labels like 0:(i:integer)
    # (fields are referenced with '.' and should not be reported)
    return {x for x in decl if x not in KEYWORDS}


def diag_source_lines(name):
    p = LOGDIR / ('pilot-%s.run' % name if name == 'SKLMON' else 'run-%s.run' % name)
    lines = p.read_text(encoding='utf-8', errors='replace').splitlines()
    out = []
    src_re = re.compile(r'^\s*\d{4,6}[^\s]{0,8}\s+(\d+)\s+(\d+)\s+(.*)$')
    for i, line in enumerate(lines):
        if re.match(r'^\s*\*{5,}11\s', line):
            for j in range(i + 1, min(len(lines), i + 4)):
                m = src_re.match(lines[j])
                if m:
                    out.append((int(m.group(2)), m.group(3)))
                    break
    return out


report = {}
all_missing = Counter()
for name in NAMES:
    src = (BASE / 'src' / (name + '.pas')).read_text(encoding='utf-8')
    canon = gostnorm.canon(src)
    declared = declaration_names(canon)
    missing = Counter()
    for lineno, text in diag_source_lines(name):
        clean = strip_comments_strings(gostnorm.canon(text))
        for m in ID.finditer(clean):
            tok = m.group(0)
            if tok in KEYWORDS or tok.isdigit():
                continue
            if tok in declared:
                continue
            if m.start() > 0 and clean[m.start() - 1] == '.':
                continue  # record field, declared in the record type
            missing[tok] += 1
    report[name] = missing
    all_missing.update(missing)

print('=== CANDIDATE UNDECLARED IDENTIFIERS (canonical spelling) ===')
for tok, n in all_missing.most_common():
    print('%4d %s' % (n, tok))

lines_out = []
for name in NAMES:
    lines_out.append('===== %s =====' % name)
    for tok, n in report[name].most_common():
        lines_out.append('%4d %s' % (n, tok))
(BASE / 'artifacts' / 'MISSING-IDS.txt').write_text('\n'.join(lines_out) + '\n', encoding='utf-8')
print('\nwrote artifacts/MISSING-IDS.txt')
