#!/usr/bin/env python3
"""ZATTAB declaration repair before the KOMPAS -> 15.1 transform."""
import re


def pre(src):
    a = src.find('CELL=PACKED RECORD')
    b = src.find('ATCЛOГ=RECORD ЗH:BOOL);')
    if a >= 0 and b >= 0:
        b += len('ATCЛOГ=RECORD ЗH:BOOL);')
        repl = """CELL=record FRM:char; CON:CONTENT end;
CONTENT=record TYP:TYPPAR; ЗН:real; ЦX:ATCЦEЛ; ДX:ATCДEЙ; AX:ATCAЛФ; CX:ATCCTP; ЛX:ATCЛOГ end;
ATCЦEЛ=record ЗH:integer end;
ATCДEЙ=record ЗH:real end;
ATCAЛФ=record ЗH:alfa end;
ATCCTP=record ЗH:alfa end;
ATCЛOГ=record ЗH:boolean end;"""
        src = src[:a] + repl + src[b:]
    # The local COLUMN enumeration is replaced by global integer constants.
    m = re.search(r'TYPE\s*\nCOLUMN=\((.*?)\);', src, re.S)
    if m:
        names = re.findall(r'[A-Za-zА-Яа-яЁё][\wА-Яа-яЁё]*', m.group(1))
        consts = 'CONST ' + ';'.join('%s=%d' % (n, i + 1)
                                    for i, n in enumerate(names)) + ';'
        src = src[:m.start()] + consts + src[m.end():]
    src = src.replace('CONST FIRCOL=ZTEMA;LASCOL=VФHTCP;',
                      'CONST FIRCOL=1;LASCOL=18;')
    src = src.replace('TYPE LINE=FIRLIN..LASLIN;',
                      'TYPE LINE=FIRLIN..LASLIN; COLUMN=1..18; TABLEREG=1..30;')
    src = src.replace('SET OF COLUMN)', 'SET OF COLUMN end')
    src = re.sub(r'\bNEW\([^)]*\);', '', src)
    src = re.sub(r'\bDISPOSE\([^)]*\);', '', src)
    src = src.replace('F<>=', 'F<>')
    return src
