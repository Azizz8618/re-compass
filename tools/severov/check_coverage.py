#!/usr/bin/env python3
"""Verify the 97 branch/output pairs against the W9a branch logs."""
from pathlib import Path

S = Path('/home/azizz/.local/share/vifm/Trash/w9a-literal')
EV = Path('/home/azizz/Yandex.Disk/re-compass/docs/severov-apps/W7-BRANCH-EVIDENCE.md')

rows = []
for line in EV.read_text(encoding='utf-8').splitlines():
    if not line.startswith('| '):
        continue
    cells = [c.strip() for c in line.strip('|').split('|')]
    if len(cells) < 5 or cells[0] in ('прог', '---'):
        continue
    rows.append((cells[0], cells[1], cells[4]))

logs = {}
for p in S.glob('logs/w9a-*.run'):
    if '-app-' in p.name or 'proof' in p.name or 'smoke' in p.name:
        continue
    prog = p.name[4:].split('-')[0]
    logs.setdefault(prog, []).append(p.read_bytes())

hits = misses = 0
missing = []
for prog, branch, needle in rows:
    blob = b''.join(logs.get(prog, []))
    if needle.encode('utf-8') in blob:
        hits += 1
    else:
        misses += 1
        missing.append((prog, branch, needle))

print('branch-evidence rows=%d hits=%d misses=%d' % (len(rows), hits, misses))
for m in missing:
    print('MISS', m)
(S / 'reports/coverage-final.txt').write_text(
    'branch-evidence rows=%d hits=%d misses=%d\n' % (len(rows), hits, misses) +
    ''.join('MISS %s %s %s\n' % m for m in missing), encoding='utf-8')
