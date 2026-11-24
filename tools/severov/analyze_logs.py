#!/usr/bin/env python3
"""Group W5b compiler diagnostics for the 16 failing Severov programs.

A diagnostic looks like `******11 ...`; the offending token is marked by a
`*****` caret line following the printed source line.  The caret indent is a
1-based column inside the source text (the listing prefix is not counted).
"""
import re
from collections import Counter, defaultdict
from pathlib import Path

LOGDIR = Path('/home/azizz/.local/share/vifm/Trash/tss-w5b-run/logs')
OUT = Path('/home/azizz/.local/share/vifm/Trash/tss-w5c-fix/artifacts')
NAMES = ['SKLMON','SKLOTD','SKLCAR','SKLOTC','AMOMON','AMOOTD','AMOCAR',
         'AMOOTC','AMOGRU','ZATMON','ZATOTD','ZATCOF','ZATZAT','ZATNAK',
         'ZATRTE','ZATTAB']

DIAG = re.compile(r'^\s*\*{5,}(\d{1,3})\s+(.*)$')
SRC = re.compile(r'^\s*\d{4,6}[^\s]{0,8}\s+(\d+)\s+(\d+)\s+(.*)$')
CARET = re.compile(r'^(\s*)\*{5}')

ident_re = re.compile(r'[A-Za-zА-Яа-яЁё][A-Za-z0-9А-Яа-яЁё_.]*')

def logpath(name):
    if name == 'SKLMON':
        return LOGDIR / 'pilot-SKLMON.run'
    return LOGDIR / ('run-%s.run' % name)

def extract(lines, i):
    """Return (source line, offending token) for diagnostic at i."""
    src = None; lineno = None; caret = None
    for j in range(i + 1, min(len(lines), i + 5)):
        sm = SRC.match(lines[j])
        if sm:
            src, lineno = sm.group(3), int(sm.group(1))
            continue
        cm = CARET.match(lines[j])
        if cm and src is not None:
            col = len(cm.group(1))
            rest = src[col - 1:] if col >= 1 else src
            m = ident_re.match(rest)
            caret = m.group(0) if m else rest[:12].strip()
            break
        if lines[j].lstrip().startswith('******'):
            break
    return src, lineno, caret

per_prog = {}
all_tokens = Counter()
all_codes = Counter()
for name in NAMES:
    p = logpath(name)
    lines = p.read_text(encoding='utf-8', errors='replace').splitlines()
    codes, rows = Counter(), []
    for i, line in enumerate(lines):
        m = DIAG.match(line)
        if not m:
            continue
        code, text = m.group(1), m.group(2).strip()
        codes[code] += 1
        all_codes[code] += 1
        src, lineno, token = extract(lines, i)
        if token:
            all_tokens[token] += 1
        rows.append((code, text, lineno, src, token))
    per_prog[name] = (codes, rows)

print('=== DIAGNOSTIC CODES (all 16) ===')
for code, n in sorted(all_codes.items(), key=lambda x: (-x[1], x[0])):
    print('%4s %5d' % (code, n))

print('\n=== PER PROGRAM ===')
for name in NAMES:
    codes, rows = per_prog[name]
    print('%-8s diags=%3d  %s' % (name, sum(codes.values()),
          ' '.join('%s:%d' % (c, n) for c, n in sorted(codes.items()))))

print('\n=== TOKENS UNDER CARET (unique, with counts) ===')
for tok, n in all_tokens.most_common():
    print('%4d  %s' % (n, tok))

lines_out = []
for name in NAMES:
    codes, rows = per_prog[name]
    lines_out.append('===== %s (%d diagnostics) =====' % (name, sum(codes.values())))
    seen = set()
    for code, text, lineno, src, token in rows:
        key = (code, text, lineno, token)
        if key in seen:
            continue
        seen.add(key)
        lines_out.append('[%s] line=%s tok=%-18s %s | SRC: %s' % (
            code, lineno, token or '-', text[:55], (src or '')[:90]))
OUT.joinpath('LOG-GROUPS.txt').write_text('\n'.join(lines_out) + '\n', encoding='utf-8')
OUT.joinpath('LOG-TOKENS.txt').write_text(
    '\n'.join('%4d %s' % (n, t) for t, n in all_tokens.most_common()) + '\n', encoding='utf-8')
print('\nwrote artifacts/LOG-GROUPS.txt and LOG-TOKENS.txt')
