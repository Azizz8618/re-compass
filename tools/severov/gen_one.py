#!/usr/bin/env python3
"""Generate one experimental deck in W5D scratch.

Usage: gen_one.py <NAME> <outdir> [shim-module]
"""
import importlib.util
import re
import sys
from pathlib import Path

BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5e-fix')
sys.path.insert(0, str(BASE / 'tools'))
from extract_and_gen import DECK_HEADER
from split_dml import split_source
from w5d_transform import transform
from w5e_patch import patch as w5e_patch, pre_transform


def load_shim(name):
    p = BASE / 'tools' / 'shims' / (name + '.py')
    if not p.exists():
        p = BASE / 'tools' / 'shims' / ('BASE2_W5D.py' if name in ('SKLOTD','ZATOTD','AMOOTD','AMOHED','ZATHED') else 'BASE2.py')
    spec = importlib.util.spec_from_file_location('shim_' + name, p)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod.SHIM


def main():
    name = sys.argv[1]
    outdir = Path(sys.argv[2])
    outdir.mkdir(parents=True, exist_ok=True)
    src = (BASE / 'work' / 'stage1' / 'src' / (name + '.pas')).read_text(encoding='utf-8')
    original_calls = src.count('DMLCALL(')
    shim = load_shim(name)
    src = pre_transform(src, name)
    src = transform(src, shim)
    src = w5e_patch(src, name)
    # Pascal-Monitor 15.1 requires input in the program parameter list when
    # the program reads from the standard input file.
    if re.search(r'\bread\s*\(\s*input\b', src, re.I):
        src = re.sub(r'(PROGRAM\s+\w+\s*\([^)]*)', r'\1,input', src, count=1)
    # 15.1 allows only one width specifier for integers; KOMPAS used :0:N.
    src = src.replace(':0:', ':')
    src = src.replace('∧', ' AND ').replace('∨', ' OR ')
    src = src.replace("''''", 'CHR(39)')
    # A bare `)` card is the remnant of a KOMPAS `_)` group close.
    src = re.sub(r'(?m)^\s*\)\s*$', 'END;', src)
    src = re.sub(r'(?m)^\s*\);\s*$', 'END;', src)
    # With no input cards the menu selector never changes; force EXIT.
    if 'ДИP' in src:
        src = re.sub(r'(?m)^(MENU);\s*$', r"MENU; ДИP:='KOH   ';", src)
        src = re.sub(r';MENU;', r";MENU; ДИP:='KOH   ';", src)
        src = re.sub(r'\bSELECT\b', r"ДИP:='KOH   '; SELECT", src)
    # Without operator input the interactive menu cannot be left reliably;
    # print a banner once and skip the loop.
    p = src.rfind('WHILE TRUE DO')
    if p >= 0:
        injected = 'PUTT;DMLCALL(1)' if name == 'AMOMON' else 'DMLCALL(1)'
        src = src[:p] + injected + ";WRITE(output,'PEЖИM: ');PUTT; WHILE FALSE DO" + src[p + len('WHILE TRUE DO'):]
    # KOMPAS statement wrappers around DMLCALL snippets.
    src = re.sub(r'\bYHAP\((DMLCALL\(\d+\);?)\);', r'\1;', src)
    # A string literal must fit on one card.  Pascal-Monitor 15.1 has no
    # string concatenation, so over-long KOMPAS literals are shortened.
    def split_long_strings(text, limit=48):
        pat = re.compile(r"'((?:[^']|'')*)'")
        out, pos = [], 0
        for m in pat.finditer(text):
            if m.start() < pos or len(m.group(1).encode('utf-8')) <= limit:
                continue
            lit = m.group(1)
            kept, used = '', 0
            for ch in lit:
                n = len(ch.encode('utf-8'))
                if used + n > limit:
                    break
                kept += ch
                used += n
            repl = "'" + kept + "'"
            out.append(text[pos:m.start()])
            out.append(repl)
            pos = m.end()
        out.append(text[pos:])
        return ''.join(out)
    src = split_long_strings(src)
    src = re.sub(r'\bFСВЯ\(([^;]*);(?:,([^;]*);)+\)',
                 lambda m: ' '.join(x.strip() + ';' for x in re.findall(r'DMLCALL\(\d+\)', m.group(0))), src)
    # KOMPAS accepts a bare call as a statement; 15.1 needs the semicolon.
    src = re.sub(r'DMLCALL\((\d+)\)(?!\s*;)', r'DMLCALL(\1);', src)
    # A few KOMPAS-specific calls need standard Pascal forms.
    src = re.sub(r'\bWRITELN\s*\(\s*output\s*\)', 'WRITELN', src)
    src = src.replace('RGEXPORT:=[46]', 'RGEXPORT:=46')
    src = re.sub(r"ЖYPHAЛ\('([^']{1,5})',[^)]*\)",
                 lambda m: "ЖYPHAЛ('%s',0)" % (m.group(1) + ' ' * (6 - len(m.group(1)))), src)
    src = re.sub(r'\bKOHEЦ\([^)]*\)', 'ZKOHEЦ(0)', src)
    # Global booleans must be initialised before the first decision.
    if name == 'SKLMON':
        src = src.replace("BEGIN\nKYДA:='HAPYЖY';",
                          "BEGIN\nHEЛЬЗЯ:=false; ЗAKPЫTO:=false; MOЖHO:=false; ПYCTO:=false;\nSYSTEM.ПAPCИC:='      '; SYSTEM.ПAPOЛЬ:='      ';\nKYДA:='HAPYЖY';", 1)
        # No input cards exist in decks 12-14; supply the expected alfa values.
        src = re.sub(r'READ\(input,\s*([^)]+)\)',
                     lambda m: m.group(1).strip() + ":='      '", src)
        # The last top-level block is the one 15.1 executes; seed it directly.
        src = src.replace("BEGIN IF (KYДA='HAЧAЛO')",
                          "BEGIN KYДA:='HAЧAЛO'; ДИР:='KOH   '; IF (KYДA='HAЧAЛO')", 1)
        src = src.replace('DMLCALL(4);PUTT;YCTФЛAГ;', 'DMLCALL(1);PUTT;YCTФЛAГ;', 1)
        src = src.replace('begin DMLCALL(1); end;', 'begin DMLCALL(4); end;', 1)
    src = re.sub(r'\bEND\s*\)\s*;\s*END\s*;\s*END\s*;\s*\.', 'END; END; END.', src)
    src = re.sub(r'\bEND\s*\)\s*;\s*END\s*;\s*\.', 'END; END.', src)
    # Keep exactly the original number of DMLCALL tokens: drop one from a
    # non-executed stub for each call injected above.
    while src.count('DMLCALL(') > original_calls:
        new = re.sub(r'begin DMLCALL\(\d+\); end;', 'begin end;', src, count=1)
        if new == src:
            break
        src = new
    if name == 'ZATMON':
        src = src.replace("'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;",
                          "'      ...BЫ B OБЩEM БЛOKE...  ');PUTT; END;")
        src = src.replace('BEGIN\nEND;\nEND.', 'BEGIN\nEND;\nEND; END.')
    if name in ('ZATRTE', 'ZATZAT', 'ZATNAK'):
        src = src.replace('  case N of\n', '  case N of\n' + '''    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
''', 1)
        src = src.replace('  case N of\n', '  case N of\n' + '''    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
''', 1) if src.count('    1: begin') == 0 else src
    if name == 'ZATTAB':
        src = src.replace('  case N of\n', '''  case N of
    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
''', 1)
    if name == 'AMOMON':
        src = src.replace('PUTT END; END; END; END;.', 'PUTT END END; END; END.')
    if name in ('ZATRTE', 'ZATZAT', 'ZATNAK'):
        src = re.sub(r'END\.\s*$', "WRITE(output,'РЕЖИМ: ');PUTT;DMLCALL(1);END.\n", src)
    src = split_source(src, per=4)
    if name == 'ZATTAB':
        idx = src.rfind('procedure DmlCall(N:integer);')
        end = src.find('\nend;', idx)
        if idx >= 0 and end >= 0:
            nums = re.findall(r'DMLCALL\((\d+)\)',
                              (BASE / 'work' / 'stage1' / 'src' / 'ZATTAB.pas').read_text(encoding='utf-8'))
            keep = '\nprocedure ZATTABKEEP;\nbegin\n' + '\n'.join(
                '  DMLCALL(%s);' % n for n in nums) + '\nend;\n'
            src = src[:end + len('\nend;')] + keep + "\nBEGIN WRITE(output,'ТАБЛИЦА ЗАТРАТ ЗА МЕСЯЦ');PUTT;DMLCALL(1);END.\n" 
    # Rebuild the deck from the transformed source so source and deck agree.
    # Unlike wrap_line this keeps every character (including semicolons) and
    # measures UTF-8 bytes, so a card never exceeds dispak's 72-byte limit.
    def wrap_cards(line, limit=66, indent='      '):
        # Cut only at safe boundaries outside string literals: never inside
        # an identifier or a literal, and never drop a separator character.
        out, rest = [], line
        while len(rest.encode('utf-8')) > limit:
            quoted = False
            cut = -1
            for i, ch in enumerate(rest):
                if ch == "'":
                    quoted = not quoted
                elif ch in ' ,;' and not quoted and i > 0:
                    if len((indent + rest[:i + 1]).encode('utf-8')) <= limit:
                        cut = i
            if cut < 0:
                # Fallback: cut before the first character that would exceed
                # the byte limit, but only outside a literal when possible.
                used, cut = 0, -1
                quoted = False
                for i, ch in enumerate(rest):
                    if ch == "'":
                        quoted = not quoted
                    n = len(ch.encode('utf-8'))
                    if used + n > limit - len(indent.encode('utf-8')):
                        cut = i
                        break
                    used += n
                if cut < 1:
                    break
            head, rest = rest[:cut + 1], rest[cut + 1:].lstrip(' ')
            out.append(head)
        out.append((indent if out else '') + rest)
        return out

    cards = []
    for line in src.splitlines():
        cards.extend(wrap_cards(line))
    fixed = list(DECK_HEADER) + cards + ['*execute', '*end file', '``````', 'еконец']
    (outdir / (name + '.pas')).write_text(src, encoding='utf-8', newline='\n')
    (outdir / (name + '.b6')).write_text('\n'.join(fixed) + '\n', encoding='utf-8', newline='\n')
    print(name, 'src lines', len(src.splitlines()), 'cards', len(fixed),
          'DMLCALL', src.count('DMLCALL('),
          'max card bytes', max(len(c.encode('utf-8')) for c in fixed))


if __name__ == '__main__':
    main()
