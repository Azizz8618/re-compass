(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATNAK (*ЗT:PEГИC.OБЩ.ЗATPAT*)
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
    290: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    291: begin
      BUF.LEN:=16;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='З';BUF.M[15]:='A';BUF.M[16]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    292: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    293: begin
      BUF.LEN:=16;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='З';BUF.M[15]:='A';BUF.M[16]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    294: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='H';
      BUF.M[9]:='A';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    295: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='K';BUF.M[10]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    296: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='H';BUF.M[23]:='A';BUF.M[24]:='K';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    297: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='H';BUF.M[23]:='A';BUF.M[24]:='K';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    298: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='H';
      BUF.M[9]:='A';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(290)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:ЧИCДAT*)
(* EDITOR !INCLU:ЧИCMEC*)
(* EDITOR !INCLU:ЧИCKBA*)
(* EDITOR !INCLU:ДATЧИC*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:APИФM*)
(* EDITOR !INCLU:WINT*)
(* EDITOR !INCLU:WREAL*)
(* EDITOR !INCLU:WДAT*)
(* EDITOR !INCLU:WMEC*)
(* EDITOR !INCLU:WKBA*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:RSEP*)
(* EDITOR !INCLU:RINT*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)



(* SECTION ? .RШ *)
(*БЛOK PEГИCTPAЦИИ KAPT*)
PROCEDURE REGIS;
(* EDITOR !INCLU:LIST*)



(* SECTION ? .S *)
(*CYMMИPOBAHИE ЗAPПЛATЫ ЗA MECЯЦ*)
FUNCTION SUM(MES:INT):REAL;
VAR S:REAL;
BEGIN
S:=0;
DMLCALL(291)
WHILE MOЖHO DO(
  DMLCALL(292)
  WITH ЗAT DO IF MEC=MES THEN(S:=S+OЗAPП+ДЗAPП);
  DMLCALL(293));
SUM:=S;
END;



(* SECTION ? .ПOC *)
(*ПOCTABИTЬ KAPTY*)
PROCEDURE ПOCTAB;
BEGIN
RESETCON;
REPEAT WITH CUL!.CUC! DO WITH HAKЛ DO SELECT
BOS!.NAM='NMEC  ':MEC:=Ц!;
BOS!.NAM='NПPOЧ ':ПPOЧ:=Ц!;
BOS!.NAM='NHAKЛ ':HAKЛ:=Ц!;
BOS!.NAM='NЗAHAK':ЗAHAK:=Ц!;
BOS!.NAM='NЗAPП ':ЗAPП:=Ц!);
UNTIL NEXTCON;
DMLCALL(294);YCTMOД;
WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA');PUTT;
END;



(* SECTION ? .BЗЯ *)
(*BЗЯTЬ KAPTY*)
PROCEDURE BЗЯTЬ;
VAR C:!CONTENT;
BEGIN
DMLCALL(295)
WHILE NOT NEXTPAR DO(
  NEWCONT(C);
  WITH C! DO WITH HAKЛ DO CASE BOS!.NAM OF
    'NПPOЧ ':Д!:=ПPOЧ;
    'NHAKЛ ':Д!:=HAKЛ;
    'NЗAHAK':Д!:=ЗAHAK;
    'NЗAPП ':Д!:=ЗAPП));
END;



(* SECTION ? .HAЙ *)
(*HAЙTИ KAPTY*)
PROCEDURE HAЙTИ;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='NMEC  ':(DMLCALL(296)
  IF MOЖHO THEN EXIT ELSE(
    WRITE(OUT,'HET TAKOГO MECЯЦA');PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
END;



(* SECTION ? .HOB *)
(*BBOД HOBOЙ KAPTЫ*)
PROCEDURE HOB;
VAR MES:INT;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
IF NAM='NЗAPП ' THEN(
  WRITE(OUT,'      ЖДИTE, ИДET CYMMИPOBAHИE ЗAPПЛATЫ');PUTT;
  WRITE(OUT,'      CYMMA ЗAPПЛATЫ (ЗAPEГИCTPИPOBAHHOЙ B БД) ЗA ');
  WMEC(OUT,MES);WRITE(OUT,' = ');
  WREAL(SUM(MES),6);PUTT);
(**)
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='NMEC  ':(MES:=Ц!;
  DMLCALL(297);
  IF NOT ПYCTO THEN(
    WRITE(OUT,'YЖE ECTЬ ЭTOT MECЯЦ');
    PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
END;



(* SECTION ? .ПPO *)
(*ПPOCMOTP KAPTЫ*)
PROCEDURE ПPO;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WRITELIST;
END;



(* SECTION ? .ИCK *)
(*ИCKЛЮЧEHИE KAPTЫ*)
PROCEDURE ИCK;
PROCEDURE YHAP(H:INT);EXTERNAL;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;
IF NOT CONFIRM THEN EXIT;
DMLCALL(298);YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
FIL:=NIL;LOADLIST('CП-HAK');FINDLIST('CП-HAK');
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ OБЩИX ЗATPAT...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:EXIT);
);
END;



(* SECTION ? .B *)
BEGIN
REGIS;
END.
(* SECTION ? .ЗTPT *)
