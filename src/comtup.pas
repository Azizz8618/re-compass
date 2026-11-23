(*=y+,s0,s7*)program comtup(output, BDVECT, BDERRN);
(* COMTUP - low level of Kompas on MARS-6. Working version.
   Fixes over comtup.draft.pas:
   1) MarsErrNo removed; *BDERRN* is a COMMON parameter (BDERRN).
   2) local bv arrays replaced by COMMON *BDVECT* (BDVECT).
   3) untyped VAR P replaced by typed wrappers TPCMP1I/A/B/P.
   18 exported entries: 11 real, 4 typed wrappers, 3 stubs.
   TPCMPADR and AROP were unused untyped-VAR stubs and are dropped. *)
const
  cGetd = 221411c;          (* GETD 11-14-22 *)
  cPutd = 26211511c;        (* PUTD 26-21-15-11 *)
  cModd = 20402621001511c;  (* MODD 20-40-26-21-00-15-11 *)
  cDeld = 27231411c;        (* DELD 27-23-14-11 *)
  cOpend = 2512141131c;     (* OPEND 25-12-14-11-31 *)
  cNewd = 2621151131c;      (* NEWD 26-21-15-11-31 *)
  cFirst = 01c;         (* MARS 01: position at beginning *)
  cLast = 02c;
  cPrev = 03c;
  cNext = 04c;
  cFind = 11c;
  cBdKeyGet = 352453c;  (* MARS op53: BDVECT[20] := BDVECT[29] *)
  sBdKeyRes = 24;       (* slot with address of CGetBdKey result R *)
  sBdKeyTmp = 20;       (* scratch slot used by op53 *)
type
  TPath = packed array [1..40] of char;
  PicT = record
    nc, nm, na, smes, ssdmo: integer;
    m: array [0..383] of integer;
    l: array [0..383] of integer
  end;
  Pic2T = record
    x128, x129, x130, x131: integer;
    path: TPath
  end;
  word = record case integer of
    0:(i:integer);
    1:(a:alfa);
    2:(p:@integer);
    3:(c:char);
    4:(pp:@PicT);
    5:(pp2:@Pic2T)
  end;
  TBDVec = array [0..167] of word;
  AnyPtr = @integer;
var
  BDVECT: TBDVec;
  BDERRN: integer;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;
(* PIC address is cached in COMMON BDVECT[160] and BDVECT[161]. *)
procedure GetPic(var q:@PicT);
var i:integer;
begin
  _(
  if BDVECT[160].i = 0 then begin
    new(q);
    q@.nc := 0;
    q@.nm := 0;
    q@.na := 0;
    q@.smes := 0;
    q@.ssdmo := 0;
    for i := 0 to 383 do begin
      q@.m[i] := 0;
      q@.l[i] := 0
    end;
    BDVECT[160].pp := q
  end else
    q := BDVECT[160].pp
  _);
end;
procedure GetPic2(var q:@Pic2T);
begin
  _(
  if BDVECT[161].i = 0 then begin
    new(q);
    q@.x128 := 0;
    q@.x129 := 0;
    q@.x130 := 0;
    q@.x131 := 0;
    BDVECT[161].pp2 := q
  end else
    q := BDVECT[161].pp2
  _);
end;
(* PIC word W(low,high): low byte is the resident operation. *)
(* HYPOTHESIS: mapping of PIC operations to MARS microcode. *)
function PicCode(j:integer):integer;
var op:integer;
begin
  _(
  op := j mod 256;
  PicCode := 0;
  if op = 1 then PicCode := cPutd;
  if op = 2 then PicCode := cFind;
  if op = 3 then PicCode := cModd;
  if op = 4 then PicCode := cFirst;
  if op = 7 then PicCode := cDeld;
  if op = 11 then PicCode := cLast;
  if op = 12 then PicCode := cNext;
  if op = 13 then PicCode := cPrev;
  if op = 15 then PicCode := cModd;
  if op = 16 then PicCode := cGetd;
  if op = 82 then PicCode := cOpend
  _);
end;
(* FACT: availability is probed through interface initialization. *)
function CompassInstalled:boolean;
begin
  _(
  CompassInstalled := false;
  pasbdi;
  if BDERRN = 0 then CompassInstalled := true
  _);
end;
(* Common tail of the typed TPCMPAD1 wrappers. *)
procedure SaveAdr(k:integer);
var q:@PicT;
begin
  _(
  GetPic(q);
  if q@.na <= 382 then begin
    q@.l[q@.na] := BDVECT[k].i;
    q@.na := q@.na + 2
  end
  _);
end;
(* === 11 procedures really called by upper layers === *)
(*=e+*)procedure SSBF5;
(* FACT: reset state. HYPOTHESIS: KOBLA on LU 52. *)
var i,j:integer;
begin
  _(
  for j := 0 to 167 do BDVECT[j].i := 0;
  i := 1270000c;
  PASACD(i);
  PASSETAR(270000c);
  pasbdi;
  BDVECT[3].i := 0
  _);
end;
(*=e+*)procedure TPCMP1I(var p:integer; k:integer);
begin
  _(
  BDVECT[k].i := ord(ref(p));
  SaveAdr(k)
  _);
end;
(*=e+*)procedure TPCMP1A(var p:alfa; k:integer);
begin
  _(
  BDVECT[k].i := ord(ref(p));
  SaveAdr(k)
  _);
end;
(*=e+*)procedure TPCMP1B(var p:boolean; k:integer);
begin
  _(
  BDVECT[k].i := ord(ref(p));
  SaveAdr(k)
  _);
end;
(*=e+*)procedure TPCMP1P(var p:AnyPtr; k:integer);
begin
  _(
  BDVECT[k].i := ord(ref(p));
  SaveAdr(k)
  _);
end;
(*=e+*)procedure TPCMPP1(j:integer);
(* FACT (PC): PIC.M[NC]:=J; NC:=NC+2. *)
var q:@PicT;
begin
  _(
  GetPic(q);
  if q@.nc <= 382 then begin
    q@.m[q@.nc] := j;
    q@.nc := q@.nc + 2
  end
  _);
end;
(*=e+*)procedure TPCMPL1(j:integer);
(* FACT (PC): PIC.L[NA]:=J; NA:=NA+2. *)
var q:@PicT;
begin
  _(
  GetPic(q);
  if q@.na <= 382 then begin
    q@.l[q@.na] := j;
    q@.na := q@.na + 2
  end
  _);
end;
(*=e+*)procedure TPCMPIN1(j:integer);
(* HYPOTHESIS: decoded microcode into COMMON BDVECT[3], then pasbd.
   op90 (7514, CGetBdKey) is verified: op53 copies the bd-key from
   slot 29 into the scratch slot 20, then the value is written to
   the address kept in slot 24. Callers must use those slots. *)
var q:@PicT; code:integer; rp:@integer;
begin
  _(
  GetPic(q);
  if q@.nc <= 382 then begin
    q@.m[q@.nc] := j;
    q@.nc := q@.nc + 2
  end;
  code := PicCode(j);
  if code <> 0 then begin
    BDVECT[3].i := code;
    pasbd
  end;
  if j = 7514 then begin
    BDVECT[3].i := cBdKeyGet;
    pasbd;
    rp := BDVECT[sBdKeyRes].p;
    rp@ := BDVECT[sBdKeyTmp].i
  end
  _);
end;
(*=e+*)function APIC:@PicT;
var q:@PicT;
begin
  _(
  GetPic(q);
  APIC := q
  _);
end;
(*=e+*)function APIC2:@Pic2T;
var q:@Pic2T;
begin
  _(
  GetPic2(q);
  APIC2 := q
  _);
end;
(*=e+*)function EXN:integer;
(* FACT: *BDERRN* is the MARS error-number COMMON word. *)
begin
  _(
  EXN := BDERRN
  _);
end;
(*=e+*)function ITLEN:integer;
(* FACT: sorucom.b6 reads BDVECT[39].c times 6. *)
begin
  _(
  ITLEN := ord(BDVECT[39].c) * 6
  _);
end;
(*=e+*)procedure WPASRA;
(* HYPOTHESIS: OPEND of the administrative area plus op 25. *)
var i:integer;
begin
  _(
  i := 1270002c;
  PASACD(i);
  opend('admin ');
  BDVECT[3].i := 25c;
  pasbd
  _);
end;
(*=e+*)procedure VPASR6;
(* HYPOTHESIS: symmetric switch to the user's area. *)
begin
  _(
  BDVECT[3].i := 31c;
  pasbd
  _);
end;
(* === 3 unused entries kept as stubs (type-safe) === *)
(*=e+*)function SSREZK:boolean;
(* FACT: the PC version is an empty stub, always False. *)
begin
  SSREZK := false
end;
(*=e+*)procedure TPCMPNNA(j:integer);
begin
end;
(*=e+*)procedure TCMPIN;
begin
end;
(*=e+*)procedure TCMPINP;
begin
end;
begin
end.
