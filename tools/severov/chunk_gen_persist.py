#!/usr/bin/env python3
"""Decks that place MARS KOBLA/area on mounted disk pack LU 41 with -wr,
so MARS metadata can survive across separate dispak invocations."""
from pathlib import Path
import gen_decks as G

S = Path(__file__).resolve().parent
LU_DISK = 0o41
KOBLA_ZONE = 0o5000      # free range 4013..7633 on 2348; multiple of 100o
AREA_ZONE = 0o5101       # ends in 1, free range, no overlap with KOBLA
AREA_LEN = 0o16          # 14 decimal zones, below the 32-zone catalog threshold
KOBLA_LEN = 0o20

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
""".replace("*call yesmemory", "*call yesmemory")


def iw(length, zone):
    return G.info_word(length, zone, LU_DISK)


def tw(zone):
    return G.tar_word(zone, LU_DISK)


def writer():
    b = G.PASCAL_DECL
    b += "begin\n"
    b += f"  i := {G.f8(iw(KOBLA_LEN, KOBLA_ZONE))};\n"
    b += "  PASACD(i);\n"
    b += f"  i := {G.f8(tw(KOBLA_ZONE))};\n"
    b += "  PASSETAR(i);\n"
    b += "  writeln('PW INIT EXN=', BDERRN);\n"
    b += f"  i := {G.f8(iw(AREA_LEN, AREA_ZONE))};\n"
    b += "  newd('PCH1  ', i);\n"
    b += "  opend('PCH1  ');\n"
    b += "  writeln('PW OPEN EXN=', BDERRN);\n"
    for k, v in enumerate((101, 102, 103)):
        key = f"P1D{k}  "
        b += f"  m[1] := {v}; putd('{key}', m);\n"
    b += f"  m[1] := 1000; putd('P1LEN ', m);\n"
    b += "  writeln('PW PUTD EXN=', BDERRN);\n"
    b += "  writeln('PW DONE')\n"
    b += "end.\n"
    return WRAPPER + b + G.WRAPPER_TAIL


def reader():
    b = G.READER_DECL
    b += "begin\n"
    b += "  total := 0; csum := 0;\n"
    b += f"  i := {G.f8(tw(KOBLA_ZONE))};\n"
    b += "  PASSETAR(i);\n"
    b += "  writeln('PR TAR EXN=', BDERRN);\n"
    b += "  opend('PCH1  ');\n"
    b += "  writeln('PR OPEN EXN=', BDERRN);\n"
    b += "  getd('P1LEN ', m); v := m[1];\n"
    b += "  writeln('PR LEN=', v, ' EXN=', BDERRN);\n"
    for k in range(3):
        key = f"P1D{k}  "
        b += f"  getd('{key}', m); v := m[1];\n"
        b += f"  writeln('PR D{k}=', v, ' EXN=', BDERRN);\n"
        b += "  total := total + v;\n"
    b += "  writeln('PR CHECKSUM=', total);\n"
    b += "  writeln('PR FINAL EXN=', BDERRN)\n"
    b += "end.\n"
    return WRAPPER + b + G.WRAPPER_TAIL


def main():
    for name, text in (("persist_writer.b6", writer()), ("persist_reader.b6", reader())):
        G.check_lines(text, name)
        (S / "decks" / name).write_text(text, encoding="utf-8")
        print(name, len(text.splitlines()), "lines")


if __name__ == "__main__":
    main()
