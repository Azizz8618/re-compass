(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATOTD (*ЗT:PEГИC.OTДEЛOB*)
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
    244: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    245: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    246: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    247: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    248: begin
      BUF.LEN:=32;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='O';BUF.M[15]:='T';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:='.';BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:='З';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='S';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='O';BUF.M[31]:='T';BUF.M[32]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    249: begin
      BUF.LEN:=15;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='O';BUF.M[12]:='T';
      BUF.M[13]:='Д';BUF.M[14]:='E';BUF.M[15]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    250: begin
      BUF.LEN:=31;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='.';BUF.M[19]:='H';BUF.M[20]:='A';
      BUF.M[21]:='З';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='B';
      BUF.M[25]:=' ';BUF.M[26]:='S';BUF.M[27]:='Y';BUF.M[28]:='-';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    251: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    252: begin
      BUF.LEN:=32;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='O';BUF.M[15]:='T';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:='.';BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:='З';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='S';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='O';BUF.M[31]:='T';BUF.M[32]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    253: begin
      BUF.LEN:=31;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='.';BUF.M[19]:='H';BUF.M[20]:='A';
      BUF.M[21]:='З';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='B';
      BUF.M[25]:=' ';BUF.M[26]:='S';BUF.M[27]:='Y';BUF.M[28]:='-';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    254: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    255: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    256: begin
      BUF.LEN:=12;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='O';
      BUF.M[9]:='T';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(244)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)
(* EDITOR !INCLU:ROTД*)



(* SECTION ? .RШ *)
(*БЛOK PEГИCTPAЦИИ KAPT*)
PROCEDURE REGIS;



(* SECTION ? .W *)
(*ПEЧATЬ OTДEЛA*)
PROCEDURE ПEЧOTД;
BEGIN
WRITE(OUT,OTДEЛ.HAЗB);
END;



(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR I:INT;
BEGIN
DMLCALL(245);
IF ПYCTO THEN(
  WRITE(OUT,'HET OTДEЛOB');PUTT;EXIT);
I:=0;ШAГ:=1;
REPEAT
  I:=I+1;DMLCALL(246);ПEЧOTД;DMLCALL(247)
UNTIL ПYCTO OR NOT EЩE('EЩE ! ') OR HAЧ;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
BEGIN
REPEAT
REPEAT
  WRITE(OUT,'HAЗBAHИE OTДEЛA:');GETHAЧ;
  IF HAЧ THEN EXIT;
  READ(INP,OTДEЛ.HAЗB);
  DMLCALL(248);
  IF MOЖHO THEN(WRITE(OUT,'TAKOЙ OTДEЛ YЖE ЗAPEГИCTPИPOBAH');PUTT);
UNTIL ПYCTO;
(**)
WRITE(OUT,'BOT, ЧTO BЫ BBEЛИ:');PUTT;ПEЧOTД;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(249);YCTMOД;
  WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .ЗAM *)
PROCEDURE ЗAM;
VAR CTOT:ZZOTДEЛ;
BEGIN
WRITE(OUT,'CTAPOE HAЗBAHИE OTДEЛA:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,CTOT.HAЗB);
DMLCALL(250);
IF MOЖHO THEN(DMLCALL(251)) ELSE(
  WRITE(OUT,'TAKOЙ OTДEЛ HE ЗAPEГИCTPИPOBAH');PUTT;EXIT);
WRITE(OUT,'HOBOE HAЗBAHИE OTДEЛA:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,OTДEЛ.HAЗB);
DMLCALL(252);IF COCT=0 THEN(
  WRITE(OUT,'TAKOЙ OTДEЛ YЖE ЗAPEГИCTPИPOBAH');PUTT;EXIT);
DMLCALL(253);
DMLCALL(254);YCTMOД;ECTЬ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
BEGIN
WRITE(OUT,'HAЗBAHИE OTДEЛA:');
OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
DMLCALL(255)
IF NOT ПYCTO THEN(
WRITE(OUT,'OTДEЛ HEЛЬЗЯ ИCKЛЮЧИTЬ ПOKA OH ЗAPEГИCTPИPOBAH',LF,
          'KAK ИCПOЛHИTEЛЬ B TEMAX');PUTT;EXIT);
WRITE(OUT,'ПOДTBEPДИTE ИCKЛЮЧEHИE OTДEЛA');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ИCKЛЮЧEHИE OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(256);YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ OTДEЛOB...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX OTДEЛOB/',
          'HOB - PEГИCTPAЦИЯ HOBЫX OTДEЛOB/',
          'ЗAM - ЗAMEHA HAЗBAHИЯ OTДEЛA/',
          'ИCK - ИCKЛЮЧEHИE OTДEЛA/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO;
  'HOB'=ДИP:HOB;
  'ЗAM'=ДИP:ЗAM;
  'ИCK'=ДИP:ИCK;
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:EXIT);
);
END;



(* SECTION ? .B *)
BEGIN REGIS END.
(* SECTION ? .ЗTKO *)
