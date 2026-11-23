#!/usr/bin/env python3
"""Generate DISPAK/Pascal-Monitor decks for the MARS chunk-registry experiment.

Modes:
  selfcheck  one process: init KOBLA, NEWD+OPEND one area, PUTD/GETD, print.
  writer     one process per chunk: own KOBLA, own area, PUTD chunk records.
  reader     one process: PASSETAR-switch between KOBLAs, GETD all chunks.
  reader1    one process: read only chunk 1 (fallback when switching breaks).
"""
from pathlib import Path
import argparse

S = Path(__file__).resolve().parent

LU = 0o27  # MARS LU used by all SERVIS/MARS experiments
# KOBLA zones (octal), multiples of 100o; kobla length MMMM = 20o (16 zones)
KOBLA_ZONES = {1: 0o0000, 2: 0o1000, 3: 0o2000}
# Area zones (octal), length 100o = 64 decimal zones for the mechanism test
AREA_ZONES = {1: 0o4001, 2: 0o5001, 3: 0o6001}
AREA_LEN_OCT = 0o16   # 14 decimal zones, below the 32-zone catalog threshold
CHUNK_LOGICAL = {1: 700, 2: 700, 3: 350}
CHUNK_OFFSET = {1: 0, 2: 700, 3: 1400}
CHUNK_DATA = {1: (11, 12, 13), 2: (21, 22, 23), 3: (31, 32, 33)}

WRAPPER_HEAD = """шифр 419995зс5^
лен 40(2348-630)^
лен 41(2348)^
ОЗУ 32^
ее в1а3
*name
*call yesmemory
*perso:412570
*stand
*call *pascal
"""

WRAPPER_TAIL = """*no load list
*execute
КОНЕЦ.
*end file
``````
еконец
"""

PASCAL_DECL = """(*=y+,s0,s7*)program p(output, BDVECT, BDERRN);
type
  word = record case integer of
    0:(i:integer);
    1:(a:alfa)
  end;
var
  BDVECT: array [0..167] of word;
  BDERRN: integer;
  m: array [1..1] of integer;
  i, j, v: integer;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
"""


def info_word(length_oct: int, zone_oct: int, lu: int = LU) -> int:
    return (length_oct << 18) | (lu << 12) | zone_oct


def tar_word(zone_oct: int, lu: int = LU) -> int:
    return (lu << 12) | zone_oct


def f8(n: int) -> str:
    return f"{n:o}c"


def check_lines(text: str, name: str) -> None:
    for n, line in enumerate(text.splitlines(), 1):
        if len(line) > 72:
            raise SystemExit(f"{name}: line {n} is {len(line)} chars: {line!r}")


def gen_selfcheck() -> str:
    body = PASCAL_DECL
    body += "begin\n"
    body += f"  i := {f8(info_word(0o20, KOBLA_ZONES[1]))};\n"
    body += "  PASACD(i);\n"
    body += f"  i := {f8(tar_word(KOBLA_ZONES[1]))};\n"
    body += "  PASSETAR(i);\n"
    body += "  writeln('INIT EXN=', BDERRN);\n"
    body += f"  i := {f8(info_word(AREA_LEN_OCT, AREA_ZONES[1]))};\n"
    body += "  newd('CH1   ', i);\n"
    body += "  opend('CH1   ');\n"
    body += "  writeln('OPEN EXN=', BDERRN);\n"
    body += "  m[1] := 11; putd('C1D0  ', m);\n"
    body += "  m[1] := 12; putd('C1D1  ', m);\n"
    body += "  writeln('PUTD EXN=', BDERRN);\n"
    body += "  getd('C1D0  ', m); writeln('GETD0=', m[1], ' EXN=', BDERRN);\n"
    body += "  getd('C1D1  ', m); writeln('GETD1=', m[1], ' EXN=', BDERRN);\n"
    body += "  writeln('FINAL EXN=', BDERRN)\n"
    body += "end.\n"
    return WRAPPER_HEAD + body + WRAPPER_TAIL


def gen_writer(c: int) -> str:
    body = PASCAL_DECL
    body += "begin\n"
    body += "  (* fresh process: create this task's own KOBLA *)\n"
    body += f"  i := {f8(info_word(0o20, KOBLA_ZONES[c]))};\n"
    body += "  PASACD(i);\n"
    body += f"  i := {f8(tar_word(KOBLA_ZONES[c]))};\n"
    body += "  PASSETAR(i);\n"
    body += "  writeln('W" + str(c) + " INIT EXN=', BDERRN);\n"
    body += f"  i := {f8(info_word(AREA_LEN_OCT, AREA_ZONES[c]))};\n"
    body += f"  newd('CH{c}   ', i);\n"
    body += f"  opend('CH{c}   ');\n"
    body += "  writeln('W" + str(c) + " OPEN EXN=', BDERRN);\n"
    body += f"  m[1] := {CHUNK_LOGICAL[c]}; putd('C{c}LEN ', m);\n"
    body += f"  m[1] := {CHUNK_OFFSET[c]}; putd('C{c}OFF ', m);\n"
    for k, val in enumerate(CHUNK_DATA[c]):
        key = f"C{c}D{k}  "
        assert len(key) == 6, key
        body += f"  m[1] := {val}; putd('{key}', m);\n"
    body += f"  writeln('W" + str(c) + " PUTD EXN=', BDERRN);\n"
    body += f"  writeln('W" + str(c) + " DONE')\n"
    body += "end.\n"
    return WRAPPER_HEAD + body + WRAPPER_TAIL


READER_ONE = """  (* switch to KOBLA {c}; do NOT call PASACD: area must persist *)
  i := {tar};
  PASSETAR(i);
  writeln('R TAR{c} EXN=', BDERRN);
  opend('CH{c}   ');
  writeln('R OPEN{c} EXN=', BDERRN);
  getd('C{c}LEN ', m); v := m[1];
  writeln('R LEN{c}=', v, ' EXN=', BDERRN);
  total := total + v;
  getd('C{c}OFF ', m); v := m[1];
  writeln('R OFF{c}=', v, ' EXN=', BDERRN);
  getd('C{c}D0  ', m); v := m[1];
  writeln('R D{c}0=', v, ' EXN=', BDERRN);
  csum := csum + v;
  getd('C{c}D1  ', m); v := m[1];
  writeln('R D{c}1=', v, ' EXN=', BDERRN);
  csum := csum + v;
  getd('C{c}D2  ', m); v := m[1];
  writeln('R D{c}2=', v, ' EXN=', BDERRN);
  csum := csum + v;
"""

READER_DECL = PASCAL_DECL.replace(
    "  i, j, v: integer;",
    "  i, j, v, total, csum: integer;",
)


def gen_reader(chunks) -> str:
    body = READER_DECL
    body += "begin\n"
    body += "  (* fresh process: no PASACD, just point at existing KOBLAs *)\n"
    body += "  total := 0; csum := 0;\n"
    for c in chunks:
        body += READER_ONE.format(c=c, tar=f8(tar_word(KOBLA_ZONES[c])))
    body += "  writeln('R TOTAL_LEN=', total);\n"
    body += "  writeln('R CHECKSUM=', csum);\n"
    body += "  writeln('R FINAL EXN=', BDERRN)\n"
    body += "end.\n"
    return WRAPPER_HEAD + body + WRAPPER_TAIL


def gen_single() -> str:
    """One process: three KOBLAs via PASACD, then read back via PASSETAR switching."""
    body = READER_DECL
    body += "begin\n"
    body += "  total := 0; csum := 0;\n"
    for c in (1, 2, 3):
        body += f"  (* create KOBLA {c} *)\n"
        body += f"  i := {f8(info_word(0o20, KOBLA_ZONES[c]))};\n"
        body += "  PASACD(i);\n"
        body += f"  i := {f8(tar_word(KOBLA_ZONES[c]))};\n"
        body += "  PASSETAR(i);\n"
        body += f"  writeln('S KOB{c} EXN=', BDERRN);\n"
        body += f"  i := {f8(info_word(AREA_LEN_OCT, AREA_ZONES[c]))};\n"
        body += f"  newd('CH{c}   ', i);\n"
        body += f"  opend('CH{c}   ');\n"
        body += f"  writeln('S OPEN{c} EXN=', BDERRN);\n"
        body += f"  m[1] := {CHUNK_LOGICAL[c]}; putd('C{c}LEN ', m);\n"
        body += f"  m[1] := {CHUNK_OFFSET[c]}; putd('C{c}OFF ', m);\n"
        for k, val in enumerate(CHUNK_DATA[c]):
            key = f"C{c}D{k}  "
            body += f"  m[1] := {val}; putd('{key}', m);\n"
    body += "  (* now read all chunks back by switching KOBLA *)\n"
    for c in (1, 2, 3):
        body += f"  i := {f8(tar_word(KOBLA_ZONES[c]))};\n"
        body += "  PASSETAR(i);\n"
        body += f"  writeln('S RTAR{c} EXN=', BDERRN);\n"
        body += f"  opend('CH{c}   ');\n"
        body += f"  writeln('S ROPEN{c} EXN=', BDERRN);\n"
        body += f"  getd('C{c}LEN ', m); v := m[1];\n"
        body += f"  writeln('S LEN{c}=', v, ' EXN=', BDERRN);\n"
        body += "  total := total + v;\n"
        for k in range(3):
            key = f"C{c}D{k}  "
            body += f"  getd('{key}', m); v := m[1];\n"
            body += f"  writeln('S D{c}{k}=', v, ' EXN=', BDERRN);\n"
            body += "  csum := csum + v;\n"
    body += "  writeln('S TOTAL_LEN=', total);\n"
    body += "  writeln('S CHECKSUM=', csum);\n"
    body += "  writeln('S FINAL EXN=', BDERRN)\n"
    body += "end.\n"
    return WRAPPER_HEAD + body + WRAPPER_TAIL


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", choices=["selfcheck", "writer", "reader", "single"])
    ap.add_argument("--chunk", type=int, choices=[1, 2, 3])
    args = ap.parse_args()

    if args.mode == "selfcheck":
        name, text = "selfcheck.b6", gen_selfcheck()
    elif args.mode == "writer":
        if args.chunk is None:
            raise SystemExit("writer needs --chunk")
        name, text = f"writer_{args.chunk}.b6", gen_writer(args.chunk)
    elif args.mode == "single":
        name, text = "single.b6", gen_single()
    else:
        chunks = [args.chunk] if args.chunk else [1, 2, 3]
        name = f"reader_{''.join(map(str, chunks))}.b6"
        text = gen_reader(chunks)

    check_lines(text, name)
    out = S / "decks" / name
    out.write_text(text, encoding="utf-8")
    print(f"{out.name}: {len(text.splitlines())} lines")


if __name__ == "__main__":
    main()
