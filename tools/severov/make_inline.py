#!/usr/bin/env python3
"""Turn the tested genmadrun interpreter body into an app-local Pascal block.

The PERSO entry at 3370 is built and 0-diagnostic, but 15.1 produces
'НЕВЕРНАЯ ДЛИНА Р/1D' for any caller that references it when the module
declares globals besides its program parameters.  Applications are main
programs, not PERSO libraries, so the very same source is inlined there.
No second MAD parser is introduced: procedures are copied verbatim and only
renamed with an MX prefix to avoid collisions with the application code.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src' / 'genmadrun_min.pas'
OUT = ROOT / 'src' / 'madx_inline.pas'

PROCS = ['EXN', 'ClrErr', 'Next', 'FindSet', 'FindLab', 'JumpTo',
         'KeyAt', 'NumKey', 'LoadRec', 'SaveRec', 'PrintLit',
         'NextBufLine', 'ReadMad2', 'MadExec2', 'MADX', 'pasbdi']
TYPES = ['valt', 'v8t', 'lint', 'txtt']
GLOBALS = ['ln', 'tok', 't1', 'sep', 'p', 'fn', 'rc', 'nf', 'cf', 'cnt',
           'tl', 'mode', 'dc', 'txt', 'v', 'w', 'key', 'op', 'pre', 'nc',
           'cur', 'mx', 'loaded', 'o2', 'x1', 'x2', 'l2', 'nm', 'ns', 'ss',
           'coc', 'pc', 'sn', 'sp', 'sc', 'sm', 'bf', 'ck', 'bv', 'v8',
           'curbuf', 'bufMode', 'bm', 'bp', 'blen']


def main():
    lines = SRC.read_text(encoding='utf-8').splitlines()
    starts = [i for i, x in enumerate(lines)
              if re.match(r'^(procedure|function)\s', x, re.I)]
    head = lines[:starts[0]]
    chunks = {}
    for n, i in enumerate(starts):
        j = starts[n + 1] if n + 1 < len(starts) else len(lines)
        name = re.match(r'^(?:procedure|function)\s+(\w+)', lines[i], re.I).group(1)
        chunks[name.lower()] = lines[i:j]

    # Only type declarations not already present in the application prelude.
    vi = next(i for i, x in enumerate(head) if x.startswith('var '))
    types = []
    for x in head[:vi]:
        s = x.strip()
        if s.startswith('type') or s.startswith('program'):
            continue
        if any(t in s for t in TYPES):
            types.append(x)

    globals_ = []
    for x in head[vi + 1:]:
        s = x.strip()
        if s.startswith('procedure') or not s or 'BDVECT' in s or s.startswith('BUF:'):
            continue
        globals_.append(x)

    raw = dict(chunks)
    body = []
    for name in PROCS:
        chunk = chunks.get(name.lower(), [])
        if name == 'MADX':
            chunk = raw.get('madexec2', [])
        if name == 'MadExec2':
            cut = next((i for i, x in enumerate(chunk)
                        if 'procedure MADHELLO' in x or 'procedure MADX' in x),
                       len(chunk))
            chunk = chunk[:cut]
        elif name == 'MADX':
            start = next(i for i, x in enumerate(chunk) if 'procedure MADX' in x)
            end = next(i for i, x in enumerate(chunk)
                       if x.strip() == 'end;' and i > start)
            chunk = chunk[start:end + 1]
            chunk = [x.replace('(*=e+*)', '') for x in chunk]
        elif name == 'pasbdi':
            chunk = [x for x in chunk if x.strip().startswith('procedure')]
        body += chunk

    body = [x for x in body if x.strip().startswith('procedure pasbdi')] + \
        [x for x in body if not x.strip().startswith('procedure pasbdi')]
    src = ['type'] + types + ['var'] + globals_ + body
    mapping = {p.lower(): 'Q' + p for p in PROCS + TYPES + GLOBALS if p != 'pasbdi'}
    pattern = re.compile(r'\b(' + '|'.join(sorted(mapping, key=len, reverse=True)) + r')\b', re.I)
    out = [pattern.sub(lambda m: mapping[m.group(0).lower()], x) for x in src]
    # Splitting four 15.1 cards whose renamed identifiers cross 72 bytes.
    fixes = {
        '      Qns:=Qns+1; Qsn[Qns]:=s; Qsp[Qns]:=Qtok; Qsc[Qns]:=0; Qsm[Qns]:=0; Qss:=Qns;':
        ['      Qns:=Qns+1; Qsn[Qns]:=s; Qsp[Qns]:=Qtok;',
         '      Qsc[Qns]:=0; Qsm[Qns]:=0; Qss:=Qns;'],
        "      if s[4]='<' then begin Qo2[Qnm]:=14; QNext; QNext; Qx1[Qnm]:=Qtok end":
        ["      if s[4]='<' then begin",
         "        Qo2[Qnm]:=14; QNext; QNext; Qx1[Qnm]:=Qtok end"],
        '      if Qsc[Qss]>=1 then begin QKeyAt(Qss,Qsc[Qss]); Qcoc:=0 end else Qcoc:=1':
        ['      if Qsc[Qss]>=1 then begin',
         '        QKeyAt(Qss,Qsc[Qss]); Qcoc:=0 end else Qcoc:=1'],
    }
    fixed = []
    for x in out:
        fixed.extend(fixes.get(x, [x]))
    out = fixed
    bad = [(i + 1, len(x)) for i, x in enumerate(out) if len(x) > 72]
    if bad:
        raise SystemExit('long lines: %s' % bad[:5])
    OUT.write_text('\n'.join(out) + '\n', encoding='utf-8', newline='\n')
    print(OUT, len(out), 'lines')


if __name__ == '__main__':
    main()
