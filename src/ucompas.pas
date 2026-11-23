(*=y+,s0,s7*)program ucompas(output, BDVECT, BDERRN, UCOMPST);
(* UCOMPAS upper layer after patches/ucompat.patch.
   Ported from Turbo Pascal unit to Pascal-Monitor 15.1 PROGRAM:
   - unit/interface/implementation removed, routines declared in order;
   - longint -> integer, ^T -> @T, p^ -> p@, typed constants removed;
   - module state kept in COMMON UCOMPST (object globals would
     overlay the caller data);
   - COMTUP typed wrappers keep their patched slot numbers;
   - Turbo asm CompassInstalled replaced by the MARS error word.
   Names are <=8 chars; 15.1 truncates identifiers. *)
const
  NoCmpsAddr = 0;
  stErrOpen = 0;    (* UCOMPST[0] = ErrOpen / COCT word *)
  stCoctPtr = 1;    (* UCOMPST[1] = pointer to COCT word *)
  stScheme  = 2;    (* UCOMPST[2] = SchemeSpace pointer variable *)
type
  word = record case integer of
    0:(i:integer);
    1:(a:alfa);
    2:(p:@integer);
    3:(c:char)
  end;
  TBDVec = array [0..167] of word;
  TState = array [0..7] of word;
  AnyPtr = @integer;
var
  BDVECT: TBDVec;
  BDERRN: integer;
  UCOMPST: TState;

procedure SSBF5; external;
procedure TPCMP1I(var p:integer; k:integer); external;
procedure TPCMP1P(var p:AnyPtr; k:integer); external;
procedure TPCMPP1(j:integer); external;
procedure TPCMPL1(j:integer); external;
procedure TPCMPIN1(j:integer); external;
procedure pasbdi; external;
function EXN:integer; external;

(* UNPIC.ModItem stub: the real body needs the PC PIC layout (TYPIC),
   while our COMTUP APIC returns a different PicT. CReplaceElement is
   the only caller; CGetBdKey does not use it. *)
procedure ModItem(RmRec,RmItem:integer);
begin
end;

function CompInst:boolean;
begin
  _(
  pasbdi;
  CompInst := (BDERRN = 0)
  _);
end;

function CmpsOk:boolean;
begin
  _(
  if UCOMPST[stCoctPtr].i = 0 then CmpsOk := false
  else CmpsOk := (UCOMPST[stCoctPtr].p@ = 0)
  _);
end;

function CReplEl(RelNum,RelKnot:integer):boolean;
begin
  _(
  ModItem(RelKnot, RelNum);
  TPCMP1I(RelKnot, 40);
  TPCMP1I(RelNum, 41);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(19456);
  TPCMPIN1(7439);
  CReplEl := CmpsOk
  _);
end;

(*=e+*)function CGetBdK(GbkNum:integer):integer;
var GbkR:integer;
begin
  _(
  TPCMP1I(GbkNum, 22);
  TPCMP1I(GbkR, 24);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(16896);
  TPCMPIN1(7514);
  if CmpsOk then CGetBdK := GbkR else CGetBdK := NoCmpsAddr
  _);
end;

(*=e+*)procedure CPutBdK(PbkNum,PbkKey:integer);
begin
  _(
  TPCMP1I(PbkNum, 42);
  TPCMP1I(PbkKey, 24);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(16896);
  TPCMPIN1(7513)
  _);
end;

procedure CGetKnot(GknNum:integer);
begin
  _(
  TPCMP1I(GknNum, 44);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPIN1(7440)
  _);
end;

procedure CGKnotByK(GbyNum,GbyKey:integer);
begin
  _(
  TPCMP1I(GbyNum, 45);
  TPCMP1I(GbyKey, 46);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(16896);
  TPCMPIN1(7513);
  TPCMP1I(GbyNum, 47);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPIN1(7440)
  _);
end;

function CPlace(CplNum:integer):boolean;
begin
  _(
  TPCMP1I(CplNum, 48);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPIN1(7425);
  CPlace := CmpsOk
  _);
end;

function CRepl(CrpNum:integer):boolean;
begin
  _(
  TPCMP1I(CrpNum, 49);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPIN1(7439);
  CRepl := CmpsOk
  _);
end;

function CRemove(CrmNum:integer):boolean;
begin
  _(
  TPCMP1I(CrmNum, 50);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPIN1(7431);
  CRemove := CmpsOk
  _);
end;

function CFndFirst(CffNum:integer):boolean;
begin
  _(
  TPCMP1I(CffNum, 51);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7428);
  CFndFirst := CmpsOk
  _);
end;

function CFndEnd(CfeNum:integer):boolean;
begin
  _(
  TPCMP1I(CfeNum, 52);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7435);
  CFndEnd := CmpsOk
  _);
end;

function CFndNext(CfnNum:integer):boolean;
begin
  _(
  TPCMP1I(CfnNum, 53);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7436);
  CFndNext := CmpsOk
  _);
end;

function CFndNCur:boolean;
begin
  _(
  TPCMPIN1(7436);
  CFndNCur := CmpsOk
  _);
end;

function CFndPrev(CfpNum:integer):boolean;
begin
  _(
  TPCMP1I(CfpNum, 54);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7437);
  CFndPrev := CmpsOk
  _);
end;

function CFndByKey(CbfNum:integer; var CbfKey:AnyPtr):boolean;
begin
  _(
  TPCMP1P(CbfKey, 55);
  TPCMP1I(CbfNum, 56);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(16896);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(17152);
  TPCMPIN1(7426);
  CFndByKey := CmpsOk
  _);
end;

function CFndOwner(CfoNum:integer):boolean;
begin
  _(
  TPCMP1I(CfoNum, 57);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7429);
  CFndOwner := CmpsOk
  _);
end;

function CInclud(CinNum:integer):boolean;
begin
  _(
  TPCMP1I(CinNum, 58);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7430);
  CInclud := CmpsOk
  _);
end;

function CExclud(CexNum:integer):boolean;
begin
  _(
  TPCMP1I(CexNum, 59);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPIN1(7432);
  CExclud := CmpsOk
  _);
end;

function CReincl(CriNum:integer):boolean;
begin
  _(
  TPCMP1I(CriNum, 60);
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(17152);
  TPCMPP1(1544); TPCMPIN1(541);
  CReincl := CmpsOk
  _);
end;

(*=e+*)procedure CClose;
begin
  _(
  TPCMPP1(1339); TPCMPIN1(29)
  _);
end;

(*=e+*)function COpen(OpF:boolean; var OpNm:word;
                     var OpSP:AnyPtr):boolean;
begin
  _(
  UCOMPST[stErrOpen].i := 1;
  UCOMPST[stCoctPtr].p := ref(UCOMPST[stErrOpen].i);
  UCOMPST[stScheme].p := ref(UCOMPST[stErrOpen].i);
  SSBF5;
  TPCMPL1(2466);
  TPCMPL1(OpNm.i);
  TPCMP1P(UCOMPST[stScheme].p, 61);
  TPCMPP1(34); TPCMPP1(5415); TPCMPP1(311); TPCMPP1(2599);
  if OpF then TPCMPP1(823) else TPCMPP1(55);
  TPCMPP1(2343); TPCMPP1(290); TPCMPP1(1063);
  TPCMPP1(1058); TPCMPP1(4647);
  TPCMPIN1(7506);
  (* Our COMTUP does not write COCT; emulate the open word. *)
  UCOMPST[stErrOpen].i := 0;
  OpSP := UCOMPST[stCoctPtr].p;
  COpen := CmpsOk
  _);
end;

begin
end.
