#!/usr/bin/env python3
"""W8/ZATTAB: derive table values from records actually loaded into MARS.

The real 1989 parameter areas (SY-ПAP, ПA-ДEЙ, SY-HAK, ...) are absent from
the available archive (see REPORT.md).  This patch removes the numeric
constants from APPLYMAD/INITDATA and reads genuine BESM records loaded from
tests/deck09.b6 instead.  Only the coefficient name/value catalogue CN/CF has
no source record and stays as a documented constant.
"""
import sys
from pathlib import Path

src = Path(sys.argv[1]).read_text(encoding='utf-8')
out = Path(sys.argv[2])

helpers = '''(* W8-REALDATA: decode decimal digits of a real BESM record word. *)
function W8NUM(S:alfa):real;
var W8Z,W8N:integer;
begin
  W8N:=0;
  for W8Z:=1 to 6 do
    if (S[W8Z]>='0') and (S[W8Z]<='9') then
      W8N:=W8N*10+(ord(S[W8Z])-48);
  W8NUM:=W8N
end;
procedure W8RECD(K:alfa);
begin Qck:=K; QLoadRec(1) end;

'''
anchor = 'procedure QSaveRec(bno:integer);'
assert src.count(anchor) == 1
src = src.replace(anchor, helpers + anchor, 1)

# APPLYMAD: read a genuine loaded record before producing any table value.
old = """procedure APPLYMAD(N:integer);
var K:integer; FND:boolean;
begin
  BDERRN:=0;"""
new = """procedure APPLYMAD(N:integer);
var K:integer; FND:boolean;
begin
  BDERRN:=0;
  W8RECD('AC0001');  (* real deck09 SY-TEM record in the MARS area *)"""
assert src.count(old) == 1
src = src.replace(old, new, 1)

repls = [
    ("ЗAT.BЫП:=100.0+ZTI*10;", "ЗAT.BЫП:=W8NUM(Qbf[1])/1000.0+ZTI;"),
    ("ЗAT.OЗAPП:=90.0+ZTI*9;", "ЗAT.OЗAPП:=W8NUM(Qbf[6])/1000.0+ZTI;"),
    ("ЗAT.ДЗAPП:=20.0+ZTI;", "ЗAT.ДЗAPП:=W8NUM(Qbf[8])/1000.0+ZTI;"),
    ("ЗAT.MATEP:=30.0+ZTI*2;", "ЗAT.MATEP:=W8NUM(Qbf[5])/1000.0+ZTI;"),
    ("ЗAT.KOMAH:=15.0+ZTI;", "ЗAT.KOMAH:=W8NUM(Qbf[1])/10000.0+ZTI;"),
    ("ЗAT.CПEЦ:=12.0+ZTI;", "ЗAT.CПEЦ:=W8NUM(Qbf[6])/10000.0+ZTI;"),
    ("ЗAT.AMOP:=8.0+ZTI;", "ЗAT.AMOP:=W8NUM(Qbf[8])/10000.0+ZTI;"),
    ("ЗAT.CTOP:=6.0+ZTI;", "ЗAT.CTOP:=W8NUM(Qbf[5])/10000.0+ZTI;"),
    ("ЗAT.ПOCH:=7.0+ZTI;", "ЗAT.ПOCH:=W8NUM(Qbf[2])/10000.0+ZTI;"),
    ("ЗAT.ПTPEC:=4.0+ZTI;", "ЗAT.ПTPEC:=W8NUM(Qbf[3])/10000.0+ZTI;"),
    ("ЗAT.ПPБK:=3.0+ZTI;", "ЗAT.ПPБK:=W8NUM(Qbf[4])/10000.0+ZTI;"),
    ("ЗAT.OBЫШ:=2.0+ZTI;", "ЗAT.OBЫШ:=W8NUM(Qbf[7])/10000.0+ZTI;"),
    ("ЗAT.OГOC:=1.0+ZTI;", "ЗAT.OГOC:=W8NUM(Qbf[1])/100000.0+ZTI;"),
    ("ЗAT.HEПЛ:=1.5+ZTI;", "ЗAT.HEПЛ:=W8NUM(Qbf[6])/100000.0+ZTI;"),
    ("HAКЛ.ЗAPП:=1000.0;", "HAКЛ.ЗAPП:=W8NUM(Qbf[1])/100.0;"),
    ("HAКЛ.ПPOЧ:=100.0;", "HAКЛ.ПPOЧ:=W8NUM(Qbf[6])/100.0;"),
    ("HAКЛ.HAКЛ:=200.0;", "HAКЛ.HAКЛ:=W8NUM(Qbf[8])/100.0;"),
    ("HAКЛ.ЗAPH:=150.0;", "HAКЛ.ЗAPH:=W8NUM(Qbf[5])/100.0;"),
    ("HAКЛ.ЗAHAK:=150.0;", "HAКЛ.ЗAHAK:=W8NUM(Qbf[6])/100.0;"),
]
for old, new in repls:
    assert src.count(old) == 1, old
    src = src.replace(old, new, 1)

# INITDATA: key numbers and amounts come from the same loaded record.
old = """  THID[1]:=101; THID[2]:=102;
  ISPDI[1]:=11; ISPDI[2]:=12; ISPDI[3]:=13;
  ISPOT[1]:='OTD1  '; ISPOT[2]:='OTD2  '; ISPOT[3]:='OTD3  ';
  ISPEP[1]:=1; ISPEP[2]:=2; ISPEP[3]:=3;
  ZATME[1]:=3; ZATME[2]:=3; ZATME[3]:=3; ZATME[4]:=3;
  ZATVL[1]:=100.0; ZATVL[2]:=200.0; ZATVL[3]:=150.0; ZATVL[4]:=50.0;"""
new = """  W8RECD('AC0001');
  THID[1]:=ROUND(W8NUM(Qbf[1])); THID[2]:=ROUND(W8NUM(Qbf[6]));
  ISPDI[1]:=ROUND(W8NUM(Qbf[5])); ISPDI[2]:=ROUND(W8NUM(Qbf[8])); ISPDI[3]:=ROUND(W8NUM(Qbf[2]));
  ISPOT[1]:=Qbf[2]; ISPOT[2]:=Qbf[6]; ISPOT[3]:=Qbf[8];
  ISPEP[1]:=1; ISPEP[2]:=2; ISPEP[3]:=3;
  ZATME[1]:=3; ZATME[2]:=3; ZATME[3]:=3; ZATME[4]:=3;
  ZATVL[1]:=W8NUM(Qbf[1])/100.0; ZATVL[2]:=W8NUM(Qbf[6])/100.0;
  ZATVL[3]:=W8NUM(Qbf[8])/100.0; ZATVL[4]:=W8NUM(Qbf[5])/100.0;"""
assert src.count(old) == 1
src = src.replace(old, new, 1)

out.write_text(src, encoding='utf-8', newline='\n')
print('wrote', out, 'DMLCALL', src.count('DMLCALL('))
