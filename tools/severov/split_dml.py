#!/usr/bin/env python3
"""Split the generated DmlCall dispatcher into several procedures.

15.1 caps the number of statements in one compound statement (diagnostic 49).
The generated dispatcher holds every MAD snippet as literal assignments in a
single CASE, so long programs exceed the cap.  The split keeps all 345 call
sites and the single QMADX entry per sub-dispatcher.
"""
import re

BRANCH = re.compile(r'^    (\d+): begin$')
ASSIGN = re.compile(r"^\s*BUF\.M\[\d+\]:=.*$")
END_BRANCH = re.compile(r'^    end;$')


def split_source(src, per=6):
    lines = src.splitlines()
    start = next((i for i, l in enumerate(lines)
                  if l.startswith('procedure DmlCall(')), None)
    if start is None:
        return src
    # The dispatcher ends with `QMADX(0)` followed by `end;`.
    end = None
    for i in range(start, len(lines)):
        if lines[i].strip() == 'QMADX(0)':
            for j in range(i + 1, min(i + 4, len(lines))):
                if lines[j].strip() == 'end;':
                    end = j
                    break
            break
    if end is None:
        return src
    block = lines[start:end + 1]
    branches = []
    i = 0
    while i < len(block):
        m = BRANCH.match(block[i])
        if not m:
            i += 1
            continue
        j = i + 1
        while j < len(block) and not END_BRANCH.match(block[j]):
            j += 1
        branches.append((int(m.group(1)), block[i:j + 1]))
        i = j + 1
    if len(branches) <= per:
        return src
    groups = [branches[k:k + per] for k in range(0, len(branches), per)]
    tail = [l for l in block
            if l.strip().startswith('BUF.D:=') or l.strip().startswith('BUF.I:=') or
            l.strip().startswith('BUF.H:=') or l.strip().startswith("C:=' '") or
            l.strip().startswith('QMADX(0)')]
    out = []
    for gi, group in enumerate(groups):
        name = 'DmlCall' + chr(ord('A') + gi)
        out.append('procedure %s(N:integer);' % name)
        out.append('var J:integer;')
        out.append('begin')
        out.append('  for J:=1 to 160 do BUF.M[J]:=\' \';')
        out.append('  case N of')
        for _, br in group:
            out.extend(br)
        out.append('  end;')
        out.extend(tail)
        out.append('end;')
    out.append('procedure DmlCall(N:integer);')
    out.append('begin')
    for gi, group in enumerate(groups):
        name = 'DmlCall' + chr(ord('A') + gi)
        lo, hi = group[0][0], group[-1][0]
        cond = 'N<=%d' % hi if gi == 0 else (
            'N>=%d' % lo if gi == len(groups) - 1 else
            '(N>=%d) and (N<=%d)' % (lo, hi))
        out.append('  if %s then %s(N)' % (cond, name))
        if gi < len(groups) - 1:
            out[-1] += ' else'
    out.append('end;')
    return '\n'.join(lines[:start] + out + lines[end + 1:])
