(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOGRU (*AM:ШИФPЫ *)
type
  alfa = packed array[1..6] of char;
  TYPEM = packed array[1..1344] of char;
  ZZBUFT = record LEN,H,D,I:integer; M,MV:TYPEM end;
var
  BUF: ZZBUFT;
  C: char;
procedure DML(B:boolean); external;
procedure DmlCall(N:integer);
var J:integer;
begin
  for J:=1 to 1344 do BUF.M[J]:=' ';
  case N of
    229: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    230: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Г';BUF.M[20]:='P';
      BUF.M[21]:='Y';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    231: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    232: begin
      BUF.LEN:=16;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='Г';BUF.M[12]:='P';
      BUF.M[13]:='Y';BUF.M[14]:='П';BUF.M[15]:='П';BUF.M[16]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    233: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Г';BUF.M[15]:='.';BUF.M[16]:='H';
      BUF.M[17]:='A';BUF.M[18]:='Ч';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='S';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='Г';BUF.M[26]:='P';BUF.M[27]:='Y';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    234: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    235: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';BUF.M[12]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    236: begin
      BUF.LEN:=6;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(229)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:RЦEЛBEЩ*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:STEP*)



(* SECTION ? .RШ *)
PROCEDURE REGIS;
CONST
      MINШИФP=10000; MAXШИФP=110001;



(* SECTION ? .WГ *)
PROCEDURE WГPYП;
BEGIN
  WRITE(OUT,ГPYППA.HAЧ:6,' - ',ГPYППA.KOH,'   ');
  WCTP(OUT,ГPYППA.HAЗB,0);PUTT;
END;



(* SECTION ? .PГП *)
PROCEDURE ПPO;
VAR I:INT;
BEGIN
DMLCALL(230);
IF ПYCTO THEN(
  WRITE(OUT,'HET ГPYПП');PUTT;EXIT);
I:=0;ШAГ:=1;
REPEAT
  I:=I+1;DMLCALL(231);
  WГPYП;
UNTIL STEP OR ПYCTO;
END;



(* SECTION ? .PГH *)
PROCEDURE HOB;
BEGIN
REPEAT
  WRITE(OUT,'HAЗBAHИE ГPYППЫ:');RCTP;
  IF HAЧ THEN EXIT;
  READ(INP,ГPYППA.HAЗB);
(**)
  WRITE(OUT,'HAЧAЛЬHЫЙ ШИФP:');
  ГPYППA.HAЧ:=RЦEЛ(MINШИФP,MAXШИФP);
  IF HAЧ THEN EXIT;
(**)
  WRITE(OUT,'KOHEЧHЫЙ ШИФP:');
  ГPYППA.KOH:=RЦEЛ(ГPYППA.HAЧ,MAXШИФP);
  IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'BOT, ЧTO BЫ BBEЛИ:');PUTT;WГPYП;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ ГPYППЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(232)YCTMOД;
  WRITE(OUT,'ГPYППA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'ГPYППA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .PГИ *)
PROCEDURE ИCK;
VAR Г:ZZГPYППA;
BEGIN
WRITE(OUT,'HAЧAЛЬHЫЙ ШИФP ГPYППЫ:');
Г.HAЧ:=RЦEЛ(MINШИФP,MAXШИФP);
IF HAЧ THEN EXIT;
DMLCALL(233);
IF ПYCTO THEN(
  WRITE(OUT,'TAKAЯ ГPYППA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT);
WRITE(OUT,'KOHEЧHЫЙ ШИФP ГPYППЫ:');
Г.KOH:=RЦEЛ(Г.HAЧ,MAXШИФP);
IF HAЧ THEN EXIT;
(Ц) WHILE TRUE DO(
  DMLCALL(234)
  IF ГPYППA.KOH=Г.KOH THEN EXIT Ц;
  DMLCALL(235)
  IF (ГPYППA.HAЧ!Г.HAЧ) OR ПYCTO THEN(
    WRITE(OUT,'TAKAЯ ГPYППA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT));
(**)
WRITE(OUT,'BOT ЭTA ГPYППA:');PUTT;WГPYП;
WRITE(OUT,'ПOДTBEPДИTE EE ИCKЛЮЧEHИE');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ИCKЛЮЧEHИE OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(236);YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ ГPYПП ШИФPOB...');PUTT;
KYДA:='HAPYЖY';
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX ГPYПП/',
          'HOB - PEГИCTPAЦИЯ HOBЫX ГPYПП/',
          'ИCK - ИCKЛЮЧEHИE ГPYППЫ/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT);
);
END;



(* SECTION ? .B *)
BEGIN REGIS END.
(* SECTION ? .E *)
.
(* DECK EE *)
(* DECK AREA:36 *)
(* DECK INCLUD:1,2 *)
(* DECK ROLL:2 *)
(* DECK REL:03 *)
(* DECK REL:05 *)
(* DECK PASEDIT:31,41 *)
(* DECK PASCAL *)
(* DECK READ:41 *)
(* DECK WHAT:T-S *)
(* DECK INSALL *)
DRUM
(* DECK WHAT:66-S *)
(* DECK END F *)
(* SECTION ?P *)
(* SECTION ?.ЗT *)
ШИФP 410900 ЗMП^OЗY 32^TPA 88^BPE 1000^ЛEH 31(2C)41(2C)^EEB1A3
(* DECK NAME *)
(* DECK ИПC.HAЧ *)
(* DECK EDIT *)
(* DECK W *)
(* DECK L:PREDT *)
(* SECTION ? .ЗTГO *)
