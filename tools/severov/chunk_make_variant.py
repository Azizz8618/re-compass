#!/usr/bin/env python3
"""Build the chunk-registry variant of servis.pas and its DISPAK decks.

Pristine port: /home/azizz/Yandex.Disk/re-compass/src/servis.pas (never written).
Emits src/servis_chunks.pas, src/servis_chunkonly.pas and the DISPAK decks.

Layout (LU 41 octal, from the proven chunk-registry scale experiment):
  task 1: KOBLA 4100, one area REGIST at 4201, 1000 zones:
          registry keys RGLEN/RGNCHK/RC1../RC2.. and chunk-1 data C1..
  task 2: KOBLA 6000, one area SCL2 at 6101, 750 zones: chunk-2 data C2..
  reader: open REGIST, read descriptors, open SCL2, emit 1750 / 912.

Each writer calls PASACD exactly once; a second PASACD in one process
corrupts the first KOBLA root page. All MARS keys are literal six-character
constants: alfa values returned by functions are not reliable PUTD keys.
"""
from pathlib import Path

S = Path(__file__).resolve().parent.parent
SRC = Path("/home/azizz/Yandex.Disk/re-compass/src/servis.pas")

VARS = """  (* chunk registry state *)
  ckz, caz, cln, cof, cd0, cd1, cd2: array [1..4] of integer;
  cnm: array [1..4] of alfa;
  gi: integer;
  mw: array [1..1] of integer;
"""

CODE = r"""
(* ---------- chunk registry, six-character MARS keys ----------
   RGLEN = full logical length, RGNCHK = number of chunks.
   RCcKB = TAR (LU<<12 | KOBLA zone), RCcZN = area zone,
   RCcLN = chunk length, RCcOF = offset, RCcNM = area name (alfa bits).
   C<c>LEN / C<c>OFF / C<c>D0..D2 hold per-chunk data.
   PUTD records are one word; a 72-word record breaks the catalog. *)

function Info41(l,z:integer):integer;
var q,d0,d1,d2,d3:integer;
begin
  _(
  q := l; d0 := q mod 8; q := q div 8;
  d1 := q mod 8; q := q div 8;
  d2 := q mod 8; q := q div 8;
  d3 := q mod 8;
  Info41 := p3[d3] + p2[d2] + p1[d1] + p0[d0] + 410000c + z
  _);
end;

procedure InitLayout;
begin
  _(
  ckz[1] := 4100c; caz[1] := 4201c; cnm[1] := 'REGIST';
  cln[1] := 1000;  cof[1] := 0;
  cd0[1] := 101; cd1[1] := 102; cd2[1] := 103;
  ckz[2] := 6000c; caz[2] := 6101c; cnm[2] := 'SCL2  ';
  cln[2] := 750;   cof[2] := 1000;
  cd0[2] := 201; cd1[2] := 202; cd2[2] := 203
  _);
end;

(* MARS accepts at most 14 PUTD calls in one Pascal block here; the
   registry is written in two procedures while REGIST stays open. *)
procedure RegPut;
var w:word;
begin
  _(
  w.i := 410000c + ckz[2]; mw[1] := w.i; putd('RC2KB ', mw);
  mw[1] := caz[2]; putd('RC2ZN ', mw);
  mw[1] := cln[2]; putd('RC2LN ', mw);
  mw[1] := cof[2]; putd('RC2OF ', mw);
  w.a := cnm[2];   mw[1] := w.i;        putd('RC2NM ', mw)
  _);
end;

procedure RegCreate;
var w:word;
begin
  _(
  gi := Info41(16, ckz[1]);
  PASACD(gi);
  gi := 410000c + ckz[1];
  PASSETAR(gi);
  gi := Info41(14, caz[1]);   (* 14-zone catalog root holds 17 keys *)
  newd('REGIST', gi);
  opend('REGIST');
  mw[1] := 1750;  putd('RGLEN ', mw);
  mw[1] := 2;     putd('RGNCHK', mw);
  w.i := 410000c + ckz[1]; mw[1] := w.i; putd('RC1KB ', mw);
  mw[1] := caz[1]; putd('RC1ZN ', mw);
  mw[1] := cln[1]; putd('RC1LN ', mw);
  mw[1] := cof[1]; putd('RC1OF ', mw);
  w.a := cnm[1];   mw[1] := w.i;        putd('RC1NM ', mw);
  RegPut;
  mw[1] := cln[1]; putd('C1LEN ', mw);
  mw[1] := cof[1]; putd('C1OFF ', mw);
  mw[1] := cd0[1]; putd('C1D0  ', mw);
  mw[1] := cd1[1]; putd('C1D1  ', mw);
  mw[1] := cd2[1]; putd('C1D2  ', mw);
  writeln('REGISTRY CREATED EXN=', BDERRN)
  _);
end;

procedure ChunkNew;
begin
  _(
  if Number <> 2 then Err(76)
  else begin
    gi := Info41(16, ckz[2]);
    PASACD(gi);
    gi := 410000c + ckz[2];
    PASSETAR(gi);
    gi := Info41(cln[2], caz[2]);
    newd('SCL2  ', gi);
    opend('SCL2  ');
    mw[1] := cln[2]; putd('C2LEN ', mw);
    mw[1] := cof[2]; putd('C2OFF ', mw);
    mw[1] := cd0[2]; putd('C2D0  ', mw);
    mw[1] := cd1[2]; putd('C2D1  ', mw);
    mw[1] := cd2[2]; putd('C2D2  ', mw);
    writeln('CHUNK 2 CREATED EXN=', BDERRN)
  end
  _);
end;

procedure RegGet(var kb2,zn2,ln2:integer; var nm2:alfa);
var w:word;
begin
  _(
  getd('RC2KB ', mw); ckz[2] := mw[1] - 410000c;
  getd('RC2ZN ', mw); caz[2] := mw[1];
  getd('RC2LN ', mw); cln[2] := mw[1];
  getd('RC2NM ', mw); w.i := mw[1]; nm2 := w.a;
  kb2 := ckz[2]; zn2 := caz[2]; ln2 := cln[2]
  _);
end;

procedure RegOpen;
begin
  _(
  gi := 410000c + ckz[1];
  PASSETAR(gi);
  opend('REGIST')
  _);
end;

procedure ChunkOpen(kob:integer);
begin
  _(
  gi := 410000c + kob;
  PASSETAR(gi);
  opend(cnm[2])
  _);
end;

procedure Assemble(var d:RecT);
var total,csum,kb2,zn2,ln2:integer; nm2:alfa;
begin
  _(
  RegOpen;
  getd('RGLEN ', mw); total := mw[1];
  getd('RGNCHK', mw); mw[1] := mw[1];
  writeln('REGISTRY FULL_LEN=', total, ' NCHUNKS=', mw[1],
          ' OPEN EXN=', BDERRN);
  RegGet(kb2, zn2, ln2, nm2);
  getd('C1LEN ', mw);
  writeln('CHUNK 1 LEN=', mw[1], ' EXN=', BDERRN);
  getd('C1OFF ', mw);
  getd('C1D0  ', mw); csum := mw[1];
  getd('C1D1  ', mw); csum := csum + mw[1];
  getd('C1D2  ', mw); csum := csum + mw[1];
  ChunkOpen(kb2);
  getd('C2LEN ', mw);
  writeln('CHUNK 2 LEN=', mw[1], ' OPEN EXN=', BDERRN);
  getd('C2OFF ', mw);
  getd('C2D0  ', mw); csum := csum + mw[1];
  getd('C2D1  ', mw); csum := csum + mw[1];
  getd('C2D2  ', mw); csum := csum + mw[1];
  writeln('LOGICAL_LENGTH=', total);
  writeln('CHECKSUM=', csum);
  writeln('ASSEMBLY FINAL EXN=', BDERRN);
  d[2] := total
  _);
end;

procedure AsmOp;
var nm:alfa;
begin
  _(
  kw2 := Tok;
  if kw2 <> 'ОБЛАСТ' then Err(78)
  else begin
    GetName(nm);
    if nm = '      ' then Err(78)
    else if Kfind(nm) then Err(80)
    else begin
      InitLayout;
      ncode := ncode + 1;
      Kadd(nm);
      UstOBL(r, 1750, 1);
      r[1] := ncode;
      ades[ncnt] := r;
      k := nm;
      writeln('LOGICAL AREA N=', ncode, ' LEN=', r[2]);
      Assemble(r);
      PutRec(nm, r)
    end
  end
  _);
end;

"""

MIN_INIT = """procedure Init;
var i,j:integer;
begin
  _(
  InitPows;
  un := 0;
  rn := 0;
  unms[1] := 'ADMIN ';
  un := 1;
  rnms[1] := 'ADMIN ';
  robj[1] := 'ADA   ';
  rtyp[1] := 'ДЛЯ-ВЫ';
  rn := 1
  _);
end;

"""

BUILD_HEAD = """шифр 419999 зс5^
лен 40(2348-wr)^
лен 41(2196-wr)^
eeв1а3
*name
*call yesmemory
*perso:402570
*stand
*call *pascal
"""

BUILD_TAIL = """*to perso:402570
*end file
``````
еконец
"""

RUN_HEAD = """шифр 419995зс5^
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

RUN_TAIL = """*end file
``````
еконец
"""


def check(text, name):
    for n, line in enumerate(text.splitlines(), 1):
        if len(line) > 72:
            raise SystemExit(f"{name}: line {n} is {len(line)} chars: {line!r}")


def main():
    src = SRC.read_text(encoding="utf-8")
    anchor = "(* Parameters of CREATE/CHANGE AREA. *)\n"
    assert "nxt: char;" in src and anchor in src
    src = src.replace("  nxt: char;\n", "  nxt: char;\n" + VARS, 1)
    src = src.replace(anchor, CODE + anchor, 1)
    src = src.replace("begin\n  Init;\n  ncode := 0;\n",
                      "begin\n  Init;\n  InitLayout;\n  ncode := 0;\n", 1)
    old = "      else if (kw = 'B     ') then p := 73\n"
    assert old in src
    branch = ("      else if (kw = 'РЕГИСТ') then RegCreate\n"
              "      else if (kw = 'КУСОК ') then ChunkNew\n"
              "      else if (kw = 'СОБРАТ') then AsmOp\n")
    src = src.replace(old, branch + old, 1)
    (S / "src/servis_chunks.pas").write_text(src, encoding="utf-8")

    start = src.index("procedure Init;\n")
    end = src.index("\nbegin\n  Init;\n", start)
    chunkonly = src[:start] + MIN_INIT + src[end:]
    (S / "src/servis_chunkonly.pas").write_text(chunkonly, encoding="utf-8")

    build = BUILD_HEAD + src + BUILD_TAIL
    check(build, "servis_chunks_build.b6")
    (S / "decks/servis_chunks_build.b6").write_text(build, encoding="utf-8")

    decks = {
        "chunk_w1.b6": "РЕГИСТ;\n",
        "chunk_w2.b6": "КУСОК 2;\n",
        "chunk_reader.b6": "СОБРАТЬ ОБЛАСТЬ LOG175;\n",
    }
    for name, body in decks.items():
        text = RUN_HEAD + chunkonly + "*execute\n" + body + RUN_TAIL
        check(text, name)
        (S / "decks" / name).write_text(text, encoding="utf-8")
        print(name, len(text.splitlines()), "lines")
    print("servis_chunks.pas", len(src.splitlines()), "lines")


if __name__ == "__main__":
    main()
