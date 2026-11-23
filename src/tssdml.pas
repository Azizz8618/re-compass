(*=y+,s0,s7*)program tssdml(output,BDVECT,BDERRN);
(* TSSDML: minimal working port of the 3142-line TSSDML.PAS of KOMPAS,
   (C) InfoCompass 1991. Sources: TSSDML.PAS, TSSDML.INC, TPCX.INC,
TSLM.PAS, TSPIC.PAS, TSSBAS.PAS from TURK.ARJ~. Dialect Pascal-Monitor
15.1: round-bracket comments, lines <=72 bytes, no underscores, inlined
   types, inlined PUTEOL/PUTALF/PUTINT/PUTPOL. DML(PERV) parses JAM text
from BUF.M and dispatches the working COMTUP entries; COMTUP is reused.
   Subset: 13 operations of docs/PREDT-PORT.md plus the BD-key modifier.
   Not ported: expression evaluator, labels, virtual procedures, WNABO,
   upclass, ZAPISI/PRIW/OBGIE, TSSDMPR/TSSERR GUI layer. *)
const
  DLBUF = 1344;  LENOP = 384;  LENLIT = 383;  LWORD = 2;
  LITI = 191;  LENGMG = 5;  TIRINT = 1;
  kEx = 29;  kKey = 8;  kData = 11;  kLen = 13;
  kNum = 22;  kR = 24;  cBdGet = 7514;  cBdPut = 7513;
type
  ALF6 = alfa;
  TSLANG = array[1..100] of alfa;
  TYPEM = packed array[1..DLBUF] of char;
  TYPEMI = record case integer of
    1:(I:integer); 2:(A:TYPEM)
  end;
  word = record case integer of
    0:(I:integer); 1:(A:alfa);
    2:(P:@integer); 3:(C:char)
  end;
  TBDVec = array[0..167] of word;
  TPICOD = packed array[1..LENOP] of integer;
  TSTEK = record case integer of
    1:(INT:array[1..3] of integer);
    2:(DES:record TIRR,VARR,NZ,NEL,ADROP:integer end)
  end;
  TYPPIC = record
    NC,NM,NA,SSDMO:integer;
    IPCX,SSVAR,SSJUR,SSIDEN,SSPRIV:alfa;
    SSPED,SSD:integer;
    X:record case integer of
      1:(II:integer); 2:(AA:alfa)
    end;
    X2,X3:alfa;
    SMES,NMG,XX4,AIMC,AEXXN,VOT:integer;
    XL:alfa;
    SDL,Y1,Y2,Y21,Y22:integer;
    Y3:real;  ZAV,YPOBE:integer;
    BEGMG:array[1..LENGMG] of TSTEK;
  end;
  TTABCX = record case integer of
    1:(INT:array[1..1350] of integer);
    2:(ALF:array[1..450] of alfa)
  end;
  TRNREC = record
    TRNMQ:alfa; TRN,TRRECN:integer;
    TRDLIC,TRDLIL:integer
  end;
  TROCH = record
    CXCXTL,NOMZP,BEGVIB,AROP:integer;
    TEKPS,BEGPRO,ERBDPR,NOMOP:integer
  end;
TBufRec = record
    LEN,H,D,I:integer;
    M,MV:packed array[1..64] of char;
    SNum,SRes,SNewKey,SNins,SKop,SErr,STokPos,SGuard:integer;
    SPicNc,SPicNm,SPicNa,SPicNmg:integer;
    SPicSsdo,SPicSsped,SPicSsd:integer;
    SImq,STok:alfa; SCh:char; SBdKey,STokDone:boolean;
    SPicPriv,SPicX:alfa
  end;
  TEKOP = integer;  TRN = integer;  NAM = alfa;
var
  BDVECT:TBDVec;  BDERRN:integer;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;
procedure SSBF5; external;
procedure TPCMP1I(var p:integer; k:integer); external;
procedure TPCMPL1(j:integer); external;
procedure TPCMPP1(j:integer); external;
procedure TPCMPIN1(j:integer); external;
function EXN:integer; external;
function ITLEN:integer; external;
procedure PUTEOL; begin writeln end;
procedure PUTALF(A:alfa); begin write(A) end;
procedure PUTINT(A:integer); begin write(A) end;
procedure PUTPOL; begin write('/') end;
procedure GenKey(k:alfa; var BB:TBufRec);
begin
  BDVECT[kKey].A := k
end;
procedure GenData(var d:integer; len:integer; var BB:TBufRec);
begin
  TPCMP1I(d,kData);
  BDVECT[kLen].I := len
end;
procedure GenBdPrelude(var BB:TBufRec);
begin
  TPCMPP1(36); TPCMPP1(0); TPCMPP1(19712);
  TPCMPP1(36); TPCMPP1(512); TPCMPP1(16896)
end;
procedure GenBdGet(var BB:TBufRec);
begin
  TPCMP1I(BB.SNum,kNum);
  TPCMP1I(BB.SRes,kR);
  GenBdPrelude(BB);
  TPCMPIN1(cBdGet);
  BDVECT[150].I:=BB.SNum; BDVECT[151].I:=BB.SRes
end;
procedure GenBdPut(var BB:TBufRec);
begin
  BB.SNewKey:=10000c;
  TPCMP1I(BB.SNewKey,kR);
  GenBdPrelude(BB);
  TPCMPIN1(cBdPut);
  BDVECT[152].I:=BB.SNewKey
end;
procedure SWED(TIR:integer; var BB:TBufRec);
begin
  if BB.SPicNc > BB.SPicNa*LWORD then
    BB.SPicNa := (BB.SPicNc div LWORD) + (BB.SPicNc mod LWORD);
  BB.SPicNc := BB.SPicNa*LWORD
end;
procedure NextTok(var BB:TBufRec);
var k:integer; ch:char;
begin
  for k:=1 to 6 do BB.STok[k]:=' ';
  while (BB.STokPos<=BB.LEN) and (BB.M[BB.STokPos]=' ') do
    BB.STokPos:=BB.STokPos+1;
  k:=0; BB.STokDone:=false;
  while (BB.STokPos<=BB.LEN) and (not BB.STokDone) do
  begin
    ch:=BB.M[BB.STokPos];
    if (ch=' ') or (ch=';') or (ch='.') or (ch=',') then
    begin
      if k>0 then BB.STokDone:=true else BB.STokPos:=BB.STokPos+1
    end else
    begin
      k:=k+1;
      if k<=6 then BB.STok[k]:=ch;
      BB.STokPos:=BB.STokPos+1
    end
  end;
  BB.SImq:=BB.STok
end;
function SINTB(OT,KOL:integer; var BB:TBufRec):boolean;
var ii:integer; f:boolean;
begin
  ii:=0; f:=false;
  if OT=0 then
  begin
    if BB.SImq='BЗЯTЬ ' then ii:=1
    else if BB.SImq='B     ' then ii:=2
    else if BB.SImq='ЗAMEHИ' then ii:=3
    else if BB.SImq='HAЙTИ ' then ii:=4
    else if BB.SImq='YБP-ИГ' then ii:=5
    else if BB.SImq='BЫДATЬ' then ii:=6
    else if BB.SImq='BB    ' then ii:=7
    else if BB.SImq='ПEPEBK' then ii:=8
    else if BB.SImq='ECЛИ  ' then ii:=9
    else if BB.SImq='ПOCTAB' then ii:=10
    else if BB.SImq='YБPATЬ' then ii:=11
    else if BB.SImq='BKЛЮЧИ' then ii:=12
    else if BB.SImq='ИCKЛЮЧ' then ii:=13
    else if BB.SImq='BЫПOЛH' then ii:=14
    else if BB.SImq='ЗAПYCK' then ii:=15
    else if BB.SImq='ИCПOЛH' then ii:=16
    else if BB.SImq='ФAЙЛ  ' then ii:=17
    else if BB.SImq='ЗAПPOC' then ii:=18
    else if BB.SImq='OT    ' then ii:=19
  end
  else if OT=20 then
  begin
    if BB.SImq='ПAPOЛЬ' then ii:=1
    else if BB.SImq='HA    ' then ii:=2
    else if BB.SImq='PEЖИM ' then ii:=3
    else if BB.SImq='HA-ДYБ' then ii:=4
    else if BB.SImq='БEЗ-ДY' then ii:=5
    else if BB.SImq='ЖYPHAЛ' then ii:=6
    else if BB.SImq='ИДEHTИ' then ii:=7
    else if BB.SImq='BAPИAH' then ii:=8
    else if BB.SImq='ДЛЯ-BЫ' then ii:=9
    else if BB.SImq='TEKДAT' then ii:=10
    else if BB.SImq='TEKBPE' then ii:=11
    else if BB.SImq='ДЛЯ-MO' then ii:=12
  end
  else if OT=55 then
  begin
    if BB.SImq='ПO-KЛЮ' then ii:=1
    else if BB.SImq='ПEPBYЮ' then ii:=2
    else if BB.SImq='ПOCЛEД' then ii:=3
    else if BB.SImq='CЛEДYЮ' then ii:=4
    else if BB.SImq='ПPEДЫД' then ii:=5
    else if BB.SImq='BЛAДEЛ' then ii:=6
    else if BB.SImq='B     ' then ii:=7
  end;
  if ii<=KOL then f:=true;
  BB.SNins:=ii;
  SINTB:=f
end;
function POSHAG(var BB:TBufRec):boolean;
begin
  POSHAG:=SINTB(55,7,BB);
  if POSHAG(BB) then
    case BB.SNins of
      1:BB.SKop:=2;
      2:BB.SKop:=4;
      3:BB.SKop:=11;
      4:BB.SKop:=12;
      5:BB.SKop:=13;
      6,7:BB.SKop:=5
    end
end;
procedure DM1(var BB:TBufRec);
begin
  case BB.SNins of
    1: if BB.SBdKey then begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(18+kEx*256)
end else begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(16+kEx*256)
end;
    2: BB.SKop:=0;
    3: if BB.SBdKey then begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(17+kEx*256)
end else begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(15+kEx*256)
end;
    4: begin NextTok(BB); if POSHAG(BB) then begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(BB.SKop+kEx*256)
end end;
    5: begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(7+kEx*256) end;
    6: begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(160+kEx*256) end;
    7: begin
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(16+kEx*256);
  BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(160+kEx*256)
end;
    8: begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(8+kEx*256) end;
    10:begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(1+kEx*256) end;
    11:begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(7+kEx*256) end;
    12:begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(6+kEx*256) end;
    13:begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(8+kEx*256) end;
    19:begin BB.SPicNm:=BB.SPicNm+1; TPCMPIN1(81+kEx*256) end
  end
end;
procedure DM2(var BB:TBufRec);
begin
  case BB.SNins of
    1:BB.SPicSsdo:=1;
    2:begin NextTok(BB); BB.SPicPriv:=BB.SImq end;
    3:begin NextTok(BB); BB.SPicX:=BB.SImq end;
    4:BB.SPicSsped:=1;
    5:BB.SPicSsd:=1;
    6:BB.SPicSsd:=0;
    13:BB.SPicSsped:=3
  end
end;
(*=e+*)procedure DML(PERV:boolean);
var
  Loc:TBufRec;
  kx:integer;
begin
  Loc.LEN:=BDVECT[139].I; Loc.I:=1; Loc.H:=1;
  for kx:=1 to Loc.LEN do Loc.M[kx]:=BDVECT[139+kx].C;
  if PERV then
  begin
    Loc.SPicNc:=0; Loc.SPicNm:=1; Loc.SPicNa:=0;
    Loc.SPicNmg:=0; Loc.SErr:=0
  end;
  Loc.STokPos:=Loc.I;
  if Loc.STokPos<1 then Loc.STokPos:=1;
  Loc.SBdKey:=false;
  Loc.SGuard:=0;
  while (Loc.STokPos<=Loc.LEN) and (Loc.SErr=0) and (Loc.SGuard<200) do
  begin
    Loc.SGuard:=Loc.SGuard+1;
    NextTok(Loc);
    if Loc.SImq='      ' then begin end
    else if Loc.SImq='БД-КЛЮ' then Loc.SBdKey:=true
    else if (Loc.SImq='БДGET ') or (Loc.SImq='BDGET ') then
      GenBdGet(Loc)
    else if (Loc.SImq='БДPUT ') or (Loc.SImq='BDPUT ') then
      GenBdPut(Loc)
    else if SINTB(0,19,Loc) then DM1(Loc)
    else if SINTB(20,12,Loc) then DM2(Loc)
    else if SINTB(55,7,Loc) then begin
      Loc.SPicNm:=Loc.SPicNm+1; TPCMPIN1(Loc.SKop+kEx*256)
    end
    else Loc.SErr:=102
  end;
  SWED(TIRINT,Loc)
end;
begin
end.




