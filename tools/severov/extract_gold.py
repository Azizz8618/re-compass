#!/usr/bin/env python3
"""Slice gold decks 6/7/11 and MAD decks 3/8/9 into plain LF card files."""
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
GOLD = REPO / 'gold/BESM-6 (Pavel Severov, NIS GIDROPROEKT) KOMPAS-based systems 1988-1989.txt'
OUT = Path.cwd()

text = GOLD.read_text(encoding='utf-8-sig').splitlines()

# 1-based inclusive ranges from docs/GOLD-MATERIALS.md
SPEC = {
    6: [(419, 450), (460, 496)],
    7: [(542, 587), (598, 635)],
    11: [(919, 981), (993, 1110)],
}
MAD = {3: (169, 189), 8: (637, 667), 9: (669, 695)}

cards = []
for d in (6, 7, 11):
    cards.append('@DECK %d' % d if d != 11 else '@DECK A')
    for a, b in SPEC[d]:
        for x in text[a-1:b]:
            x = x.replace('\r', '').strip()
            if not x or x.startswith('*') or x.startswith('?'):
                continue
            cards.append(x)
Path(OUT / 'cards-gen.txt').write_text('\n'.join(cards) + '\n', encoding='utf-8', newline='\n')

for d, (a, b) in MAD.items():
    Path(OUT / ('mad%d.txt' % d)).write_text(
        '\n'.join(text[a-1:b]) + '\n', encoding='utf-8', newline='\n')

for name in ('cards-gen.txt', 'mad3.txt', 'mad8.txt', 'mad9.txt'):
    p = OUT / name
    print(name, len(p.read_text(encoding='utf-8').splitlines()), 'lines', p.stat().st_size, 'bytes')
