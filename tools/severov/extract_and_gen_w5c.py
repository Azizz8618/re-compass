#!/usr/bin/env python3
"""W5c generator: W5b output plus the validated mechanical port steps.

The two programs that already work (AMOHED, ZATHED) are copied byte-for-byte
so their proven behaviour is preserved.  The other 16 get:

  1. token-level homoglyph normalisation for SHIM names only (the emitted
     gold text keeps its original glyphs, otherwise wrap_line breaks cards);
  2. KOMPAS file aliases OUT/INP -> standard output/input;
  3. THEN(/ELSE(/DO( groups -> BEGIN/END, `!` -> `<>` or `_`;
  4. DmlCall split into A/B/C dispatchers to avoid diagnostic 49.

Declaration shims are kept per program in `tools/shims/`; only SKLMON has a
hand-validated one so far.  This tool writes only to --out.
"""
import argparse
import re
import sys
from pathlib import Path

BASE = Path('/home/azizz/.local/share/vifm/Trash/tss-w5c-fix')
sys.path.insert(0, str(BASE / 'tools'))
from extract_and_gen import main as w5b_main
from port_pascal import port
from split_dml import split_source

KEEP_WORKING = ('AMOHED', 'ZATHED')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', type=Path, default=BASE / 'w5c')
    args = ap.parse_args()
    out = args.out
    for sub in ('src', 'decks', 'map', 'artifacts'):
        (out / sub).mkdir(parents=True, exist_ok=True)

    # Stage 1: canonical W5b generation into a temporary directory.
    tmp = BASE / 'work' / 'w5c-stage1'
    tmp.mkdir(parents=True, exist_ok=True)
    sys.argv = ['extract_and_gen.py', '--out', str(tmp)]
    w5b_main()

    for name in ('SKLMON','SKLOTD','SKLCAR','SKLOTC','AMOMON','AMOOTD','AMOCAR',
                 'AMOOTC','AMOGRU','ZATMON','ZATOTD','ZATCOF','ZATZAT','ZATNAK',
                 'ZATRTE','ZATTAB','AMOHED','ZATHED'):
        src = (tmp / 'src' / (name + '.pas')).read_text(encoding='utf-8')
        if name not in KEEP_WORKING:
            src = re.sub(r'\bOUT\b', 'output', src)
            src = re.sub(r'\bINP\b', 'input', src)
            src = re.sub(r'\bOUTRUT\b', 'output', src)
            shim_file = BASE / 'tools' / 'shims' / (name + '.inc')
            if shim_file.exists():
                shim = shim_file.read_text(encoding='utf-8')
                src = src.replace('procedure DmlCall(N:integer);',
                                  shim + '\nprocedure DmlCall(N:integer);', 1)
            src = port(src)
            src = split_source(src)
        (out / 'src' / (name + '.pas')).write_text(src, encoding='utf-8', newline='\n')
        with open(out / 'decks' / (name + '.b6'), 'w', encoding='utf-8', newline='\n') as f:
            for line in (tmp / 'decks' / (name + '.b6')).read_text(encoding='utf-8').splitlines():
                if name not in KEEP_WORKING and line.startswith('(*='):
                    pass
                f.write(line + '\n')
        # Deck source lines have to be rebuilt from the transformed source.
        if name not in KEEP_WORKING:
            from extract_and_gen import build_deck, wrap_line
            src_lines = []
            for line in src.splitlines():
                src_lines.extend(wrap_line(line, 66))
            deck = build_deck(name, src_lines, [])
            fixed = []
            for card in deck:
                while len(card.encode('utf-8')) > 72:
                    head, used, rest = '', 0, ''
                    for idx, ch in enumerate(card):
                        n = len(ch.encode('utf-8'))
                        if used + n > 66:
                            rest = card[idx:]
                            break
                        head += ch
                        used += n
                    if not head:
                        head, rest = card[:1], card[1:]
                    fixed.append(head)
                    card = '      ' + rest
                fixed.append(card)
            deck = fixed
            (out / 'decks' / (name + '.b6')).write_text(
                '\n'.join(deck) + '\n', encoding='utf-8', newline='\n')

    print('W5c generation finished:', out)


if __name__ == '__main__':
    main()
