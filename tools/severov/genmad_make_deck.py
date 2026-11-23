#!/usr/bin/env python3
"""Wrap a Pascal-Monitor source and its input cards into a dispak deck."""
import sys
from pathlib import Path

ROOT = Path('/home/azizz/.local/share/vifm/Trash/gen-mad-port')
HEADER = [
    'шифр 419995зс5^',
    'лен 40(2348-630)^',
    'лен 41(2348)^',
    'ОЗУ 32^',
    'ее в1а3',
    '*name ',
    '*call yesmemory',
    '*perso:412570',
    '*stand',
    '*call *pascal',
]

def main():
    src, cards, out = sys.argv[1:4]
    lines = [x.rstrip('\r\n') for x in Path(src).read_text(encoding='utf-8').splitlines()]
    bad = [(i + 1, len(x)) for i, x in enumerate(lines) if len(x) > 72]
    if bad:
        print('LONG LINES:', bad[:10])
        sys.exit(1)
    card_lines = [x.rstrip('\r\n') for x in Path(cards).read_text(encoding='utf-8').splitlines()]
    deck = HEADER + lines + ['*execute'] + card_lines + [
        '*end file', '``````', 'еконец']
    Path(out).write_text('\n'.join(deck) + '\n', encoding='utf-8', newline='\n')
    print(out, len(deck), 'lines, max source line', max(len(x) for x in lines))

if __name__ == '__main__':
    main()
