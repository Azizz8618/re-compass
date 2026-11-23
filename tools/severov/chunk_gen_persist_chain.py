#!/usr/bin/env python3
"""Full chain: 3 writer tasks, each own KOBLA+area on disk pack LU 41 (-wr),
then one reader task that switches KOBLAs and assembles the logical area."""
from pathlib import Path
import gen_decks as G

S = Path(__file__).resolve().parent
LU = 0o41
KOBLA_LEN = 0o20
AREA_LEN = 0o16                      # 14 decimal zones
KOBLA_Z = {1: 0o5000, 2: 0o5200, 3: 0o5400}
AREA_Z  = {1: 0o5101, 2: 0o5301, 3: 0o5501}
LOGICAL = {1: 700, 2: 700, 3: 350}
OFFSET  = {1: 0, 2: 700, 3: 1400}
DATA    = {1: (11, 12, 13), 2: (21, 22, 23), 3: (31, 32, 33)}
AREA_NAME = {c: f"CH{c}   " for c in (1, 2, 3)}

WRAPPER = """шифр 419995зс5^
лен 40(2348-630)^
лен 41(2348-wr)^
ОЗУ 32^
ее в1а3
*name
*call yesmemory
*perso:412570
*stand
*call *pascal
"""


def iw(length, zone):
    return G.info_word(length, zone, LU)


def tw(zone):
    return G.tar_word(zone, LU)


def writer(c):
    b = G.PASCAL_DECL
    b += "begin\n"
    b += f"  i := {G.f8(iw(KOBLA_LEN, KOBLA_Z[c]))};\n"
    b += "  PASACD(i);\n"
    b += f"  i := {G.f8(tw(KOBLA_Z[c]))};\n"
    b += "  PASSETAR(i);\n"
    b += f"  writeln('W{c} KOB EXN=', BDERRN);\n"
    b += f"  i := {G.f8(iw(AREA_LEN, AREA_Z[c]))};\n"
    b += f"  newd('{AREA_NAME[c]}', i);\n"
    b += f"  opend('{AREA_NAME[c]}');\n"
    b += f"  writeln('W{c} OPEN EXN=', BDERRN);\n"
    b += f"  m[1] := {LOGICAL[c]}; putd('C{c}LEN ', m);\n"
    b += f"  m[1] := {OFFSET[c]}; putd('C{c}OFF ', m);\n"
    for k, v in enumerate(DATA[c]):
        key = f"C{c}D{k}  "
        b += f"  m[1] := {v}; putd('{key}', m);\n"
    b += f"  writeln('W{c} PUTD EXN=', BDERRN);\n"
    b += f"  writeln('W{c} DONE')\n"
    b += "end.\n"
    return WRAPPER + b + G.WRAPPER_TAIL


def reader():
    b = G.READER_DECL
    b += "begin\n"
    b += "  total := 0; csum := 0;\n"
    for c in (1, 2, 3):
        b += f"  (* KOBLA {c} *)\n"
        b += f"  i := {G.f8(tw(KOBLA_Z[c]))};\n"
        b += "  PASSETAR(i);\n"
        b += f"  writeln('R TAR{c} EXN=', BDERRN);\n"
        b += f"  opend('{AREA_NAME[c]}');\n"
        b += f"  writeln('R OPEN{c} EXN=', BDERRN);\n"
        b += f"  getd('C{c}LEN ', m); v := m[1];\n"
        b += f"  writeln('R LEN{c}=', v, ' EXN=', BDERRN);\n"
        b += "  total := total + v;\n"
        b += f"  getd('C{c}OFF ', m); v := m[1];\n"
        b += f"  writeln('R OFF{c}=', v, ' EXN=', BDERRN);\n"
        for k in range(3):
            key = f"C{c}D{k}  "
            b += f"  getd('{key}', m); v := m[1];\n"
            b += f"  writeln('R D{c}{k}=', v, ' EXN=', BDERRN);\n"
            b += "  csum := csum + v;\n"
    b += "  writeln('R LOGICAL_LENGTH=', total);\n"
    b += "  writeln('R CHECKSUM=', csum);\n"
    b += "  writeln('R FINAL EXN=', BDERRN)\n"
    b += "end.\n"
    return WRAPPER + b + G.WRAPPER_TAIL


def main():
    decks = {}
    for c in (1, 2, 3):
        decks[f"pchain_w{c}.b6"] = writer(c)
    decks["pchain_reader.b6"] = reader()
    for name, text in decks.items():
        G.check_lines(text, name)
        (S / "decks" / name).write_text(text, encoding="utf-8")
        print(name, len(text.splitlines()), "lines")


if __name__ == "__main__":
    main()
