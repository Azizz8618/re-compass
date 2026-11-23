(*=y+,s7*)program comtup(output);
(* ВНИМАНИЕ: ЧЕРНОВИК. НЕ КОМПИЛИРОВАЛСЯ НА БЭСМ-6.
   Не использовать как рабочий модуль. См. docs/COMTUP-MAPPING.md,
   docs/BDVECT-ADDRESS.md и docs/GAPS.md. Проверенная оснастка сборки:
   src/comtup.stub.pas и tests/comtup_build.b6.
   Ошибки черновика: MarsErrNo не существует в библиотеке 02570;
   локальные bv вместо COMMON-переменных; нетипизированный VAR P
   невозможен в Паскаль-Мониторе ( ошибка 106 ).
*)
(* COMTUP - low level of Kompas on MARS-6. DRAFT.
   17 entries of the 10_09_TURK version (no ArePath).
   11 are really called by upper levels and are implemented;
   6 are kept as marked stubs with the original signatures.
   10_14 has 18 PIC entries plus 12 service entries (50..68)
   and BindCom; they are out of this draft's scope.
   IMPORTANT: shared MARS sheets *BDVECT* and *BDERRN* and the
   emulated PIC must be COMMON parameters of the program in the
   final build (pascal-monitor.txt 1.3). Here they are local
   placeholders, as required by the "local variables only" rule. *)
type
  TPath = packed array [1..40] of char;
  PicT = record
    nc, nm, na, smes, ssdmo: integer;
    m: array [0..383] of integer;
    l: array [0..383] of alfa
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
  BDVecT = array [0..167] of word;

const
  cGetd = 221411c;          (* GETD 11-14-22 *)
  cPutd = 26211511c;        (* PUTD 26-21-15-11 *)
  cModd = 20402621001511c;  (* MODD 20-40-26-21-00-15-11 *)
  cDeld = 27231411c;        (* DELD 27-23-14-11 *)
  cOpend = 2512141131c;     (* OPEND 25-12-14-11-31 *)
  cNewd = 2621151131c;      (* NEWD 26-21-15-11-31 *)
  cLast = 02c;
  cPrev = 03c;
  cNext = 04c;
  cFind = 11c;
  cZav = 59c;

procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;
(* HYPOTHESIS: MarsErrNo is a new wrapper over *BDERRN*. *)
function MarsErrNo:integer; external;

(* PIC lives in the heap; its address is cached in COMMON bv[160]. *)
procedure GetPic(var q:@PicT);
var bv:BDVecT; i:integer;
begin
  _(
  if bv[160].i = 0 then begin
    new(q);
    q@.nc := 0;
    q@.nm := 0;
    q@.na := 0;
    q@.smes := 0;
    q@.ssdmo := 0;
    for i := 0 to 383 do begin
      q@.m[i] := 0;
      q@.l[i] := '      '
    end;
    bv[160].pp := q
  end else
    q := bv[160].pp
  _);
end;

procedure GetPic2(var q:@Pic2T);
var bv:BDVecT;
begin
  _(
  if bv[161].i = 0 then begin
    new(q);
    q@.x128 := 0;
    q@.x129 := 0;
    q@.x130 := 0;
    q@.x131 := 0;
    bv[161].pp2 := q
  end else
    q := bv[161].pp2
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
  if op = 4 then PicCode := cLast;
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
  if MarsErrNo = 0 then CompassInstalled := true
  _);
end;

(* === 11 procedures really called by upper layers === *)

(*=e+*)procedure SSBF5;
(* FACT: reset state. HYPOTHESIS: KOBLA on LU 52, as in
   mars_smoke.b6; clear bdvect[0..167], then pasbdi. *)
var bv:BDVecT; i,j:integer;
begin
  _(
  for j := 0 to 167 do bv[j].i := 0;
  i := 1270000c;
  PASACD(i);
  PASSETAR(270000c);
  pasbdi;
  bv[3].i := 0
  _);
end;

(*=e+*)procedure TPCMPAD1(var p);
(* UNTYPED VAR preserved: callers pass longint, alf6, boolean,
   record fields and pointers. HYPOTHESIS: value in PIC.L and
   reference in bv[10]; exact coercion needs an emulator run.
   DECISION NEEDED: BDVECT slots or value parameters in UCOMPAS. *)
var q:@PicT; bv:BDVecT; r:@integer;
begin
  _(
  r := ref(p);
  bv[10].p := r;
  GetPic(q);
  q@.l[q@.na].i := p;
  q@.na := q@.na + 2
  _);
end;

(*=e+*)procedure TPCMPP1(j:integer);
(* FACT (PC): PIC.M[NC]:=J; NC:=NC+2. Index range 0..383. *)
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
  q@.l[q@.na].i := j;
  q@.na := q@.na + 2
  _);
end;

(*=e+*)procedure TPCMPIN1(j:integer);
(* HYPOTHESIS: store the word in PIC.M, then put the decoded
   microcode into bdvect[3] and run pasbd. *)
var q:@PicT; bv:BDVecT; code:integer;
begin
  _(
  GetPic(q);
  if q@.nc <= 382 then begin
    q@.m[q@.nc] := j;
    q@.nc := q@.nc + 2
  end;
  code := PicCode(j);
  if code <> 0 then begin
    bv[3].i := code;
    pasbd
  end
  _);
end;

(*=e+*)function APIC:@PicT;
(* FACT (PC): returns a segment pointer to ADPIC. Here it is the
   address of emulated M[0..383], L[0..383], NC/NM/NA/SSDMO. *)
var q:@PicT;
begin
  _(
  GetPic(q);
  APIC := q
  _);
end;

(*=e+*)function apic2:@Pic2T;
(* HYPOTHESIS: second local PIC with x128..x131 and path.
   ArePath (10_14, index 19) is not part of these 17 entries. *)
var q:@Pic2T;
begin
  _(
  GetPic2(q);
  apic2 := q
  _);
end;

(*=e+*)function EXN:integer;
(* HYPOTHESIS: read *BDERRN* after pasbd via MarsErrNo.
   PC and MARS error code correspondence is UNKNOWN. *)
begin
  _(
  EXN := MarsErrNo
  _);
end;

(*=e+*)function ITLEN:integer;
(* FACT: mars_smoke.b6 reads bdvect[39].c times 6. *)
var bv:BDVecT;
begin
  _(
  ITLEN := ord(bv[39].c) * 6
  _);
end;

(*=e+*)procedure WPASRA;
(* HYPOTHESIS: OPEND of the administrative area plus op 25.
   The area name and LU need confirmation on the emulator. *)
var bv:BDVecT; i:integer;
begin
  _(
  i := 1270002c;
  PASACD(i);
  opend('admin ');
  bv[3].i := 25c;
  pasbd
  _);
end;

(*=e+*)procedure VPASR6;
(* HYPOTHESIS: symmetric switch to the user's area. *)
var bv:BDVecT;
begin
  _(
  bv[3].i := 31c;
  pasbd
  _);
end;

(* === 6 unused entries: signatures kept, bodies are stubs === *)

(*=e+*)function SSREZK:boolean;
(* FACT: the PC version is an empty stub, always False. *)
begin
  SSREZK := false
end;

(*=e+*)procedure TPCMPADR(i:integer; var p);
(* UNUSED by upper layers. Stub, untyped VAR preserved. *)
begin
end;

(*=e+*)procedure TPCMPNNA(j:integer);
(* UNUSED by upper layers. Stub. *)
begin
end;

(*=e+*)procedure AROP(var p);
(* UNUSED by upper layers. Stub, untyped VAR preserved. *)
begin
end;

(*=e+*)procedure TCMPIN;
(* UNUSED by upper layers. Stub: no interpreter call. *)
begin
end;

(*=e+*)procedure TCMPINP;
(* UNUSED by upper layers. Stub: no interpreter call. *)
begin
end;

begin
end.
