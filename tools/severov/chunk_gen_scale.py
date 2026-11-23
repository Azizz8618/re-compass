#!/usr/bin/env python3
"""Scale variant: two writers with physical areas 1000 and 750 zones on LU 41 (-wr),
plus a reader that assembles the 1750-zone logical area from the registry records."""
from pathlib import Path
import gen_decks as G
import gen_persist_chain as C

S = Path(__file__).resolve().parent
C.KOBLA_Z.update({1: 0o4100, 2: 0o6000})
C.AREA_Z.update({1: 0o4201, 2: 0o6101})
C.AREA_LEN = 0o1750   # 1000 decimal zones for writer 1
C.LOGICAL.update({1: 1000, 2: 750})
C.OFFSET.update({1: 0, 2: 1000})
C.DATA.update({1: (101, 102, 103), 2: (201, 202, 203)})
C.AREA_NAME.update({1: "SCL1  ", 2: "SCL2  "})
# writer 2 needs its own physical length (750 = 1356o); patch its generated text
LENGTHS = {1: 0o1750, 2: 0o1356}


def main():
    for c in (1, 2):
        text = C.writer(c)
        wrong = G.f8(C.iw(C.AREA_LEN, C.AREA_Z[c]))
        right = G.f8(C.iw(LENGTHS[c], C.AREA_Z[c]))
        text = text.replace(wrong, right)
        name = f"scale_w{c}.b6"
        G.check_lines(text, name)
        (S / "decks" / name).write_text(text, encoding="utf-8")
        print(name, len(text.splitlines()), "lines", "area info", right)

    text = C.reader()  # reader still expects 3 chunks; build a 2-chunk reader below
    b = G.READER_DECL
    b += "begin\n  total := 0; csum := 0;\n"
    for c in (1, 2):
        b += f"  i := {G.f8(C.tw(C.KOBLA_Z[c]))};\n  PASSETAR(i);\n"
        b += f"  writeln('SR TAR{c} EXN=', BDERRN);\n"
        b += f"  opend('{C.AREA_NAME[c]}');\n"
        b += f"  writeln('SR OPEN{c} EXN=', BDERRN);\n"
        b += f"  getd('C{c}LEN ', m); v := m[1];\n"
        b += f"  writeln('SR LEN{c}=', v, ' EXN=', BDERRN);\n"
        b += "  total := total + v;\n"
        b += f"  getd('C{c}OFF ', m); v := m[1];\n"
        b += f"  writeln('SR OFF{c}=', v, ' EXN=', BDERRN);\n"
        for k in range(3):
            key = f"C{c}D{k}  "
            b += f"  getd('{key}', m); v := m[1];\n"
            b += f"  writeln('SR D{c}{k}=', v, ' EXN=', BDERRN);\n"
            b += "  csum := csum + v;\n"
    b += "  writeln('SR LOGICAL_LENGTH=', total);\n"
    b += "  writeln('SR CHECKSUM=', csum);\n"
    b += "  writeln('SR FINAL EXN=', BDERRN)\nend.\n"
    text = C.WRAPPER + b + G.WRAPPER_TAIL
    name = "scale_reader.b6"
    G.check_lines(text, name)
    (S / "decks" / name).write_text(text, encoding="utf-8")
    print(name, len(text.splitlines()), "lines")


if __name__ == "__main__":
    main()
