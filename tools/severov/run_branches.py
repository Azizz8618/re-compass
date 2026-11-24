#!/usr/bin/env python3
"""Rebuild and run every W7 branch deck against the W8 ports, with fresh disks."""
import re
import sys
from pathlib import Path

sys.path.insert(0, '/home/azizz/.local/share/vifm/Trash/w8-realdata/tools')
import run_deck as R

S = R.S
REPO = R.REPO
BR = REPO / 'tests/severov-apps/branches'
OUT = S / 'et/w8'
OUT.mkdir(parents=True, exist_ok=True)


def main():
    decks = sorted(BR.glob('*.b6'))
    rows = []
    for deck in decks:
        name = deck.stem
        prog = name.split('-')[0]
        tag = 'w8-' + name
        if prog == 'ZATTAB':
            src = S / 'src/ZATTAB-w8-real.pas'
            target = S / ('decks/w8-%s.b6' % name)
        elif prog in ('ZATMON', 'ZATZAT', 'ZATNAK', 'ZATRTE'):
            src = S / ('src/%s-w8.pas' % prog)
            target = S / ('decks/w8-%s.b6' % name)
            if not target.exists() or target.stat().st_mtime < src.stat().st_mtime:
                import subprocess
                subprocess.run(['python3', str(S / 'tools/rebuild_deck.py'),
                                str(src), str(target), str(deck)], check=True,
                               stdout=subprocess.DEVNULL)
            path = target
        else:
            path = deck
        R.reset()
        rc, el, out = R.run(path, tag)
        (OUT / (name + '.expected.txt')).write_bytes(R.norm(out))
        marks = out.count('W6С/'.encode('utf-8'))
        ex_re = re.compile(('МАD FULL ЕХ=\\s+([0-9]+)').encode('utf-8'))
        found = ex_re.findall(out)
        ex0 = sum(1 for m in found if int(m) == 0)
        exbad = sum(1 for m in found if int(m) != 0)
        zrc, zout = R.zone()
        (S / 'logs' / (tag + '.zone.txt')).write_text(zout, encoding='utf-8')
        rows.append((name, rc, el, marks, ex0, exbad, zout.strip().splitlines()[-1]))
        print('%-32s rc=%d err=%3d marks=%3d ex0=%3d exbad=%2d %s' %
              rows[-1], flush=True)
    print('TOTAL decks=%d marks=%d exbad=%d' %
          (len(rows), sum(r[3] for r in rows), sum(r[5] for r in rows)))


if __name__ == '__main__':
    main()
