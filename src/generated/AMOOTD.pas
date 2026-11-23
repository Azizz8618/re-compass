(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOOTD (*AM:OTДEЛЫ *)
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
    138: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    139: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    140: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    141: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    142: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    143: begin
      BUF.LEN:=15;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='O';BUF.M[12]:='T';
      BUF.M[13]:='Д';BUF.M[14]:='E';BUF.M[15]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    144: begin
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
    145: begin
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
    146: begin
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
    147: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    148: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    149: begin
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
(*=L0 DMLCALL(138)*)
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
(* EDITOR !INCLU:STPUT*)



(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR I:INT;
BEGIN
DMLCALL(139);
IF ПYCTO THEN(
  WRITE(OUT,'HET OTДEЛOB');PUTT;EXIT);
I:=0;ШAГ:=1;
REPEAT
  I:=I+1;DMLCALL(140)
  WRITE(OUT,I:3,') ',OTДEЛ.HAЗB);
  DMLCALL(141)
UNTIL STPUT OR ПYCTO;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
BEGIN
REPEAT
  WRITE(OUT,'HAЗBAHИE OTДEЛA:');GETHAЧ;
  IF HAЧ THEN EXIT;
  READ(INP,OTДEЛ.HAЗB);
  DMLCALL(142)
  IF ПYCTO THEN(
    DMLCALL(143);YCTMOД)
  ELSE(WRITE(OUT,'TAKOЙ OTДEЛ YЖE ЗAPEГИCTPИPOBAH');PUTT);
UNTIL NOT EЩE('EЩE!  ');
END;



(* SECTION ? .ЗAM *)
PROCEDURE ЗAM;
VAR CTOT:ZZOTДEЛ;
BEGIN
WRITE(OUT,'CTAPOE HAЗBAHИE OTДEЛA:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,CTOT.HAЗB);
DMLCALL(144);
IF ПYCTO THEN(
  WRITE(OUT,'TAKOЙ OTДEЛ HE ЗAPEГИCTPИPOBAH');PUTT;EXIT);
WRITE(OUT,'HOBOE HAЗBAHИE OTДEЛA:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,OTДEЛ.HAЗB);
DMLCALL(145);IF COCT=0 THEN(
  WRITE(OUT,'TAKOЙ OTДEЛ YЖE ЗAPEГИCTPИPOBAH');PUTT;EXIT);
DMLCALL(146);
DMLCALL(147);YCTMOД;ECTЬ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
BEGIN
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
DMLCALL(148)
IF NOT ПYCTO THEN(
  WRITE(OUT,'ЗA ЭTИM OTДEЛOM ЗAKPEПЛEHO OБOPYДOBAHИE');
  PUTT;EXIT);
WRITE(OUT,'ПOДTBEPДИTE ИCKЛЮЧEHИE');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ИCKЛЮЧEHИE OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(149);YCTMOД;ECTЬ;
END;



(* SECTION ? .B *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ OTДEЛOB...');PUTT;
KYДA:='HAPYЖY';
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
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT);
);
END.
(* SECTION ? .AMPK *)
