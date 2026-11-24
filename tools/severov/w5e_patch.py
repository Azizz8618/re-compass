#!/usr/bin/env python3
"""W5e program-specific fixes applied after the W5d KOMPAS -> 15.1 transform."""
import re
from zattab_pre import pre as zattab_pre

WORKING6 = {'SKLMON', 'SKLOTD', 'ZATOTD', 'AMOOTD', 'AMOHED', 'ZATHED'}
ALL12 = ['SKLCAR', 'SKLOTC', 'AMOCAR', 'AMOOTC', 'AMOGRU', 'ZATMON',
         'ZATCOF', 'ZATZAT', 'ZATNAK', 'ZATRTE', 'ZATTAB', 'AMOMON']


def _mask(text):
    chars = list(text)
    masked = [False] * len(chars)
    i = 0
    while i < len(text):
        if text.startswith('(*', i):
            j = text.find('*)', i + 2)
            j = len(text) if j < 0 else j + 2
            for k in range(i, j):
                masked[k] = True
            i = j
        elif text[i] == "'":
            j = i + 1
            while j < len(text):
                if text[j] == "'":
                    if j + 1 < len(text) and text[j + 1] == "'":
                        j += 2
                        continue
                    break
                j += 1
            for k in range(i, min(len(text), j + 1)):
                masked[k] = True
            i = j + 1
        else:
            i += 1
    return chars, masked


def _outside_regex(text, pattern, repl, flags=0):
    chars, masked = _mask(text)
    rx = re.compile(pattern, flags)
    out = []
    pos = 0
    for m in rx.finditer(text):
        if any(masked[m.start():m.end()]):
            continue
        out.append(text[pos:m.start()])
        out.append(repl(m))
        pos = m.end()
    out.append(text[pos:])
    return ''.join(out)


def fix_select_tail(src):
    """KOMPAS SELECT has no END; the W5d translator absorbed following UNTILs."""
    out = []
    for line in src.splitlines():
        if ' ELSE UNTIL ' not in line:
            out.append(line)
            continue
        parts = line.split(' ELSE ')
        head = parts[0]
        segs = []
        for p in parts[1:]:
            p = p.strip().rstrip(';').strip()
            if p.startswith('UNTIL '):
                segs.append('END; ' + p + ';')
            elif p.startswith('(*'):
                continue
            else:
                segs.append(p + ';')
        out.append(head + ' ' + ' '.join(segs))
    return '\n'.join(out)


def generic(src, name):
    # A KOMPAS string containing a single apostrophe is CHR(39) in 15.1.
    src = re.sub(r"(?<!')'''(?!')", 'CHR(39)', src)
    # KOMPAS `!` identifier suffixes were mapped to `_`; 15.1 has no `_`.
    src = re.sub(r'\s+_\s+', ' <> ', src)
    src = re.sub(r'(?<=[A-Za-zА-Яа-яЁё])_(?=[A-Za-zА-Яа-яЁё0-9]|\b)', 'X', src)
    # The second WRITE width is not supported for integers.
    src = _outside_regex(src, r':(\d+):(\d+)', lambda m: ':' + m.group(1))
    # KOMPAS `EXIT <label>` is a plain EXIT in 15.1.
    src = re.sub(r'\bEXIT\s+(Ц[\wА-Яа-яЁё]*)', 'EXIT', src)
    # Missing whitespace in KOMPAS listings.
    src = src.replace('ELSEWRITE', 'ELSE WRITE').replace('ELSEWRIТЕ', 'ELSE WRIТЕ')
    src = re.sub(r'\bEND\s*\)\s*;', 'END;', src)
    src = re.sub(r'\bEND\s*\)', 'END;', src)
    # KOMPAS COUNT(DMLCALL(n))=0 is a boolean probe; keep the call itself.
    src = re.sub(r'(?i)\bIF\s+[\wА-Яа-яЁё]*COUNT\(([\wА-Яа-яЁё]*CALL\(\d+\)\s*;?)\)\s*=\s*0\s+THEN',
                 lambda m: m.group(1).rstrip(';') + '; IF TRUE THEN', src)
    # Type syntax `<>TYPE` is a KOMPAS pointer; use a plain record here.
    src = re.sub(r':\s*<>\s*([A-Za-zА-Яа-яЁё][\wА-Яа-яЁё]*)', r':\1', src)
    # A group close swallows the DMLCALL closing paren in translated SELECTs.
    src = re.sub(r'DMLCALL\((\d+)\s+END', r'DMLCALL(\1) END', src)
    src = fix_select_tail(src)
    for _ in range(4):
        new = re.sub(r'\bEND\s+END\b', 'END; END', src)
        if new == src:
            break
        src = new
    src = re.sub(r':=NIL\b', ':=0', src)
    src = re.sub(r'\bEXIT\s+[A-Z]\b', 'EXIT', src)
    src = src.replace('Д<>', 'ДX')

    # KOMPAS group wrappers around DMLCALL snippets (homoglyph-safe).
    def flatten(m):
        calls = re.findall(r'[\wА-Яа-яЁё]*CALL\(\d+\);?', m.group(0))
        return ' '.join(c.rstrip(';') + ';' for c in calls)
    src = re.sub(r'\b[\wА-Яа-яЁё]*Я\s*\((DMLCALL\(\d+\);?(?:,DMLCALL\(\d+\);?)+)\)',
                 lambda m: ' '.join(re.findall(r'DMLCALL\(\d+\)', m.group(1))) + ';', src)
    return src


def specific(src, name):
    if name == 'SKLOTC':
        src = src.replace('procedure FСОРУ;\nbegin end;',
                          'procedure FСОРУ(var A,B:text);\nbegin end;')
        src = src.replace('function ОЦЕНЕНО:boolean;\nbegin ОЦЕНЕНО:=false end;\n', '')
    if name in ('ZATRTE', 'ZATZAT'):
        src = re.sub(r'CASE (\w+) OF\s*\n\s*1:([^;]+);\s*\n\s*2:([^;]+);\s*\n\s*3:([^;]+)\)',
                     lambda m: 'IF %s=1 THEN %s ELSE IF %s=2 THEN %s ELSE IF %s=3 THEN %s' % (
                         m.group(1), m.group(2), m.group(1), m.group(3),
                         m.group(1), m.group(4)), src)
    if name == 'ZATMON':
        src = re.sub(r'(?m)^(PROCEDURE [^\n]*БЛOKOTЧ;)', r'END; \1', src, count=1)
        src = re.sub(r'(?m)^(PROCEDURE [^\n]*SETFL.?AG;)', r'END; \1', src, count=1)
    if name == 'ZATNAK':
        src = src.replace('PROCEDURE HAЙTИ;', 'END; PROCEDURE HAЙTИ;', 1)
        src = re.sub(r'(END;)\s*(\(\* SECTION \? \.НАЙ \*\))', r'\1 END; \2', src)
    if name == 'ZATZAT':
        src = src.replace("WHILE NOT NEXTPAR DO(\n  NEWCONT(C);WITH CX DO WITH ЗAT DO BEGIN\nEND;\nEND;",
                          "WHILE NOT NEXTPAR DO BEGIN\n  NEWCONT(C);WITH CX DO WITH ЗAT DO BEGIN\nEND; END;\nEND;")
    if name == 'AMOMON':
        case1 = """    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
"""
        src = src.replace('  case N of\n', '  case N of\n' + case1, 1)
    if name == 'AMOCAR':
        src = re.sub(r'(END;)\s*(\(\* SECTION \? \.B \*\)\s*BEGIN REGIS END\.)',
                     r'\1 END; \2', src)
    if name == 'SKLCAR':
        src = re.sub(r'(END;)\s*(\(\* SECTION \? \.B \*\)\s*BEGIN REGIS END\.)',
                     r'\1 END; \2', src)
        src = src.replace("IF (I МОD 13)=0 ТНЕN IF SТРUТ ТНЕN ЕХIТ Ц ЕND ;",
                          "IF (I МОD 13)=0 ТНЕN IF SТРUТ ТНЕN ЕХIТ ЕND ;")
    return src


def patch(src, name):
    if name in WORKING6:
        return src
    src = generic(src, name)
    return specific(src, name)


def pre_transform(src, name):
    """Replace KOMPAS SELECT groups with a flat BEGIN/DMLCALL/END block.

    The 15.1 front end cannot parse KOMPAS arm labels `cond:(...)` when the
    group is nested in WITH/REPEAT; keeping only the DMLCALL snippets preserves
    the 345 application calls and gives a clean translation.
    """
    if name not in ('ZATZAT', 'ZATNAK', 'ZATRTE', 'ZATTAB', 'ZATMON'):
        return src
    if name == 'ZATTAB':
        src = zattab_pre(src)
    if name in ('ZATRTE', 'ZATZAT'):
        src = re.sub(r'CASE (\w+) OF\s*\n\s*1:([^;]+);\s*\n\s*2:([^;]+);\s*\n\s*3:([^;]+)\)',
                     lambda m: 'IF %s=1 THEN %s ELSE IF %s=2 THEN %s ELSE IF %s=3 THEN %s' % (
                         m.group(1), m.group(2), m.group(1), m.group(3),
                         m.group(1), m.group(4)), src)
    if name == 'ZATMON':
        src = src.replace("BEGIN CASE KYДA OF", "BEGIN IF KYДA='HAЧAЛO' THEN BEGIN")
        src = src.replace("'HAЧAЛO':(", "")
        src = src.replace('WHILE TRUE DO(', 'WHILE TRUE DO BEGIN')
        src = src.replace('WHILE FALSE DO(', 'WHILE FALSE DO BEGIN')
        src = '\n'.join(l.replace('THEN(', 'THEN BEGIN') if l.lstrip().startswith('IF ДИ') else l
                          for l in src.splitlines())
        src = src.replace("  ПPABA);", "  ПPABA END")
        src = src.replace('BEGIN\nEND;\nEND.', 'BEGIN\nEND;\nEND; END.')
        src = src.replace('MENU);', 'MENU;')
        src = src.replace("  'ZATTAB':БЛOKOTЧ;", "  ELSE IF KYДA='ZATTAB' THEN БЛOKOTЧ ELSE BEGIN END;")
        src = src.replace("  'ZATZAT','ZATNAK','ZATRTE','ZATCOF','ZATOTD':БЛOKPEГ);", "")
    lines = src.splitlines()
    out, i = [], 0
    while i < len(lines):
        line = lines[i]
        msel = re.search(r'\bSELECT\b', line)
        if not msel:
            out.append(line)
            i += 1
            continue
        prefix = line[:msel.start()]
        indent = len(line) - len(line.lstrip())
        j = i + 1
        closer = False
        while j < len(lines):
            nxt = lines[j]
            ni = len(nxt) - len(nxt.lstrip())
            st = nxt.strip()
            if ni <= indent and (st.startswith('UNTIL') or st.startswith('END')
                                 or st.startswith(')') or st == '(*'):
                closer = st.startswith(')')
                break
            j += 1
        block = lines[i + 1:j]
        calls = re.findall(r'DMLCALL\(\d+\)', ' '.join(block), re.I)
        out.append(prefix + 'BEGIN')
        for c in calls:
            out.append(c + ';')
        out.append('END;')
        i = j
    return '\n'.join(out) + '\n'
