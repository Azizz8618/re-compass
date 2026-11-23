#!/usr/bin/env python3
"""External registry stored as a MARS area on LU 41 (-wr): registrar writes
chunk descriptors, reader consumes them before opening the chunk areas."""
from pathlib import Path
import gen_decks as G
import gen_persist_chain as C

S = Path(__file__).resolve().parent
REG_KOB = 0o5600
REG_AREA = 0o5701


def registrar():
    b = G.PASCAL_DECL
    b += "begin\n"
    b += f"  i := {G.f8(C.iw(C.KOBLA_LEN, REG_KOB))};\n  PASACD(i);\n"
    b += f"  i := {G.f8(C.tw(REG_KOB))};\n  PASSETAR(i);\n"
    b += f"  i := {G.f8(C.iw(C.AREA_LEN, REG_AREA))};\n"
    b += "  newd('REGIST', i);\n  opend('REGIST');\n"
    b += "  writeln('RG OPEN EXN=', BDERRN);\n"
    b += "  m[1] := 1750; putd('RGLEN ', m);\n"
    b += "  m[1] := 3;    putd('RGNCHK', m);\n"
    for c in (1, 2, 3):
        b += f"  m[1] := {c}; putd('RC{c}NO ', m);\n"
        b += f"  m[1] := {C.tw(C.KOBLA_Z[c])}; putd('RC{c}KB ', m);\n"
        b += f"  m[1] := {C.AREA_Z[c]}; putd('RC{c}ZN ', m);\n"
        b += f"  m[1] := {C.LOGICAL[c]}; putd('RC{c}LN ', m);\n"
        b += f"  m[1] := {C.OFFSET[c]}; putd('RC{c}OF ', m);\n"
    b += "  writeln('RG PUTD EXN=', BDERRN);\n  writeln('RG DONE')\nend.\n"
    return C.WRAPPER + b + G.WRAPPER_TAIL


def reader():
    b = G.READER_DECL.replace("total, csum: integer;", "total, csum, n, kob, len, off: integer;")
    b += "begin\n  total := 0; csum := 0;\n"
    b += f"  i := {G.f8(C.tw(REG_KOB))};\n  PASSETAR(i);\n"
    b += "  opend('REGIST');\n"
    b += "  writeln('RR REG OPEN EXN=', BDERRN);\n"
    b += "  getd('RGLEN ', m); n := m[1];\n"
    b += "  writeln('RR FULL_LEN=', n, ' EXN=', BDERRN);\n"
    b += "  getd('RGNCHK', m); n := m[1];\n"
    b += "  writeln('RR NCHUNKS=', n, ' EXN=', BDERRN);\n"
    for c in (1, 2, 3):
        b += f"  i := {G.f8(C.tw(REG_KOB))}; PASSETAR(i);\n"
        b += "  opend('REGIST');\n"
        b += f"  getd('RC{c}KB ', m); kob := m[1];\n"
        b += f"  writeln('RR KOB{c}=', kob, ' EXN=', BDERRN);\n"
        b += f"  getd('RC{c}LN ', m); len := m[1];\n"
        b += f"  writeln('RR LEN{c}=', len, ' EXN=', BDERRN);\n"
        b += f"  getd('RC{c}OF ', m); off := m[1];\n"
        b += f"  writeln('RR OFF{c}=', off, ' EXN=', BDERRN);\n"
        b += "  total := total + len;\n"
        b += f"  i := kob; PASSETAR(i);\n"
        b += f"  opend('{C.AREA_NAME[c]}');\n"
        b += f"  writeln('RR OPEN{c} EXN=', BDERRN);\n"
        b += f"  getd('C{c}LEN ', m); v := m[1];\n"
        b += f"  writeln('RR CLEN{c}=', v, ' EXN=', BDERRN);\n"
        for k in range(3):
            key = f"C{c}D{k}  "
            b += f"  getd('{key}', m); v := m[1];\n"
            b += f"  writeln('RR D{c}{k}=', v, ' EXN=', BDERRN);\n"
            b += "  csum := csum + v;\n"
    b += "  writeln('RR LOGICAL_LENGTH=', total);\n"
    b += "  writeln('RR CHECKSUM=', csum);\n"
    b += "  writeln('RR FINAL EXN=', BDERRN)\nend.\n"
    return C.WRAPPER + b + G.WRAPPER_TAIL


def main():
    for name, text in (("reg_w.b6", registrar()), ("reg_reader.b6", reader())):
        G.check_lines(text, name)
        (S / "decks" / name).write_text(text, encoding="utf-8")
        print(name, len(text.splitlines()), "lines")


if __name__ == "__main__":
    main()
