#!/usr/bin/env python3
"""W4: static inventory of COMTUP calls in historical TSSPPR.PAS (final)."""
import re
from collections import Counter, defaultdict
from pathlib import Path

SRC = Path('/home/azizz/.local/share/vifm/Trash/tss-chain/floppy/TSSPPR.PAS')
raw = SRC.read_bytes()
text = raw.decode('cp866', errors='replace')

# strip { ... } and (* ... *) comments, preserving original line numbers
out, lmap = [], []
state, i, line = 'code', 0, 1
while i < len(text):
    c = text[i]; n = text[i+1] if i+1 < len(text) else ''
    if state == 'code':
        if c == '{':
            state = 'brace'; out.append(' '); lmap.append(line); i += 1; continue
        if c == '(' and n == '*':
            state = 'paren'; out.extend('  '); lmap.extend([line, line]); i += 2; continue
        out.append(c); lmap.append(line)
        if c == '\n': line += 1
        i += 1
    elif state == 'brace':
        if c == '\n': line += 1
        if c == '}': state = 'code'
        out.append(' '); lmap.append(line); i += 1
    else:
        if c == '\n': line += 1
        if c == '*' and n == ')':
            state = 'code'; out.extend('  '); lmap.extend([line, line]); i += 2; continue
        out.append(' '); lmap.append(line); i += 1
clean = ''.join(out)

RANGES = [
    ('OPBIB', 156, 253, 0),
    ('Compile_Method', 267, 350, None),
    ('PODSHE(+SMeth)', 381, 879, 0),
    ('SSBEG', 881, 931, 0),
    ('SSHALT', 934, 952, 0),
]
def proc_of(lineno):
    for name, a, b, _ in RANGES:
        if a <= lineno <= b: return name
    return '<other>'

call_re = re.compile(r'\b(TPCMPP1|TPCMPIN1|TPCMPL1|TPCMPAD1)\s*\(\s*([^)]*)\)')
calls = []
for m in call_re.finditer(clean):
    ln = lmap[m.start()]
    arg = m.group(2).strip()
    c = dict(proc=proc_of(ln), line=ln, name=m.group(1).upper(), arg=arg)
    if re.fullmatch(r'\d+', arg):
        c['val'] = int(arg); c['lo'] = c['val'] % 256; c['hi'] = (c['val']//256) % 256
    calls.append(c)

print('SOURCE:', SRC.name, 'bytes:', len(raw), 'lines:', text.count('\n')+1)
print('TOTAL active calls (comments stripped):', len(calls))
print('BY NAME:', dict(Counter(c['name'] for c in calls)))
print('NUMERIC (P1+IN1+L1):', sum('val' in c for c in calls))
print()
print('BY PROCEDURE')
for p, a, b, reset in RANGES:
    sub = [c for c in calls if c['proc'] == p]
    print(f'  {p:17s} P1={sum(c["name"]=="TPCMPP1" for c in sub):3d} '
          f'IN1={sum(c["name"]=="TPCMPIN1" for c in sub):3d} '
          f'L1={sum(c["name"]=="TPCMPL1" for c in sub):2d} '
          f'AD1={sum(c["name"]=="TPCMPAD1" for c in sub):2d} '
          f'total={len(sub):3d}')

# --- map to current MARS port ---------------------------------------------
PICCODE = {1:'PUTD', 2:'FIND', 3:'MODD', 4:'first(01)', 7:'DELD', 11:'last(02)',
           12:'next(04)', 13:'prev(03)', 15:'MODD', 16:'GETD', 82:'OPEND'}
STATE = {19712:'sNrec(27) mgth', 16896:'sTret(26) mgfal',
         17152:'sNset(28) mgtrue', 19456:'sNel(23) mgel'}
HARD = {7514:'op53 GET bdkey', 7513:'op53 PUT bdkey'}

def status(c):
    if c['name'] == 'TPCMPP1':
        if c.get('val') in STATE: return STATE[c['val']]
        return '-'  # only buffered in Pic.M, no MARS action
    if c['name'] == 'TPCMPIN1':
        if c.get('val') in HARD: return HARD[c['val']]
        if c.get('lo') in PICCODE: return PICCODE[c['lo']] + ' + ex(29)'
        return '-'
    if c['name'] == 'TPCMPL1': return 'literal only (NA)'
    return 'address -> BDVECT[k] + L[NA]'

print('\nMAPPING COVERAGE (words with direct MARS-side action)')
for name in ('TPCMPIN1','TPCMPP1'):
    sub = [c for c in calls if c['name']==name and 'val' in c]
    ok = [c for c in sub if status(c) != '-']
    print(f'  {name}: {len(ok)}/{len(sub)} mapped; distinct mapped words: {sorted(set(c["val"] for c in ok))}')
    print(f'  {name}: distinct unmapped words: {len(set(c["val"] for c in sub if status(c)=="-"))}')

# --- block/slot table ------------------------------------------------------
print('\nPIC BLOCKS (static order; NC byte offset within procedure)')
print('proc | lines | NC start | words (value@offset) | last IN1 | mapped?')
for p, a, b, reset in RANGES:
    sub = [c for c in calls if c['proc']==p]
    nc = 0 if reset is not None else None
    block = []
    def flush():
        global nc
        if not block: return
        local = 0
        words = []
        for c in block:
            if c['name'] in ('TPCMPP1','TPCMPIN1'):
                words.append(f'{c["arg"]}@{local}')
                local += 2
                if nc is not None: nc += 2
        last = block[-1]
        mapped = sum(1 for c in block if status(c) != '-' and c['name'] in ('TPCMPP1','TPCMPIN1'))
        print(f'{p:17s} | {block[0]["line"]:4d}-{last["line"]:4d} | '
              f'{nc if nc is not None else "?"} | {", ".join(words)} | '
              f'{last["arg"]} | {mapped}/{len([c for c in block if c["name"] in ("TPCMPP1","TPCMPIN1")])}')
    for c in sub:
        if c['name'] in ('TPCMPP1','TPCMPIN1'):
            block.append(c)
        elif c['name'] == 'TPCMPIN1' and block:
            flush(); block = []
        if c['name'] == 'TPCMPIN1':
            flush(); block = []
    flush()

# --- all distinct words and status ----------------------------------------
print('\nALL DISTINCT WORDS WITH STATUS (P1+IN1)')
allw = sorted(set(c['val'] for c in calls if c['name'] in ('TPCMPP1','TPCMPIN1') and 'val' in c))
for v in allw:
    cc = [c for c in calls if c.get('val')==v and c['name'] in ('TPCMPP1','TPCMPIN1')]
    st = '/'.join(sorted(set(status(c) for c in cc)))
    print(f'{v:6d} ({v%256:3d},{(v//256)%256:3d}) x{len(cc):2d} {st}')
