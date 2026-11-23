(*=y+,s0,s7*)
(*=L1*) PROGRAM SKLMON (*CK:MOHИTOP *)
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
    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    2: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    3: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='S';
      BUF.M[9]:='Y';BUF.M[10]:='S';BUF.M[11]:='T';BUF.M[12]:='E';
      BUF.M[13]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    4: begin
      BUF.LEN:=12;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='S';BUF.M[8]:='Y';
      BUF.M[9]:='S';BUF.M[10]:='T';BUF.M[11]:='E';BUF.M[12]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    5: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    6: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    7: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    8: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    9: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    10: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    11: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    12: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    13: begin
      BUF.LEN:=39;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='O';
      BUF.M[37]:='M';BUF.M[38]:='E';BUF.M[39]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    14: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    15: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    16: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    17: begin
      BUF.LEN:=6;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='B';BUF.M[4]:='E';
      BUF.M[5]:='P';BUF.M[6]:='Ш';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(* HEAD block of deck 12, gold line 1122 *)
procedure SKLHEAD;
begin DMLCALL(1) end;
(*=L0 DMLCALL(2)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:ЧИCДAT*)
(* EDITOR !INCLU:ДATЧИC*)
(* EDITOR !INCLU:APИФM*)
(* EDITOR !INCLU:WINT*)
(* EDITOR !INCLU:WДAT*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:BIGLIN*)
(* EDITOR !INCLU:YCTПEЧ*)
(* EDITOR !INCLU:RSEP*)
(* EDITOR !INCLU:RINT*)
(* EDITOR !INCLU:RMECKBA*)
(* EDITOR !INCLU:RKBA*)
(* EDITOR !INCLU:RMEC*)
(* EDITOR !INCLU:RДAT*)
(* EDITOR !INCLU:RЦEЛBEЩ*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:ЗAKPЫTO*)
(* EDITOR !INCLU:HEЛЬЗЯ*)
(* EDITOR !INCLU:MENU*)
(* EDITOR !INCLU:ЖYPHAЛ*)
(* EDITOR !INCLU:KOHEЦ*)



(* SECTION ? .YCTФ *)
(* YCTAHOBKA XPAHИMЫX ФЛAГOB *)
PROCEDURE YCTФЛAГ;
BEGIN(*=C-*)
ФЛAГИ:=SYSTEM.PEЖИMЫ;
END;(*=C+*)



(* SECTION ? .CHЯФ *)
(* CHЯTИE HE XPAHИMЫX ФЛAГOB *)
PROCEDURE CHЯФЛAГ;
BEGIN(*=C-*)
SYSTEM.PEЖИMЫ:=ФЛAГИ*[OTЛAД,OTЧCKЛ,OTЧOTД,BXOД];
END;(*=C+*)



(* SECTION ? .ПЗAK *)
(*ДEЙCTBИЯ ДO ЗAKPEПЛEHИЯ*)
PROCEDURE ПPEДЗAK;
BEGIN
SYSTEM.ДATЗП:=CEГOДHЯ;CHЯФЛAГ;
DMLCALL(3)
END;



(* SECTION ? .ПPABA *)
(*ПPOBEPKA ПPAB ПOЛЬЗOBATEЛЯ*)
PROCEDURE ПPABA;
VAR ПPOB:ZZSYSTEM;
BEGIN
DMLCALL(4);PUTT;YCTФЛAГ;
WRITE(OUT,'         ДAHHЫE OT ');WДAT(OUT,SYSTEM.ДATЗП);
IF OTЛAД IN ФЛAГИ THEN(
  ФЛAГИ:=ФЛAГИ+[AДMИH];CEГOДHЯ:=SYSTEM.ДATЗП+1)
ELSE(
PUTT;PUTT;
WRITE(OUT,'       ...ЗДPABCTBYЙTE...');PUTT;
WRITE(OUT,'BЫ - AДMИHИCTPATOP!');
IF ДA THEN(
  WRITE(OUT,'ПOДTBEPДИTE ПAPOЛЬ:');GETT;
  READ(INP,ПPOB.ПAPOЛЬ);
  IF SYSTEM.ПAPOЛЬ=ПPOB.ПAPOЛЬ THEN(
    WRITE(OUT,'BЫ ДEЙCTBИTEЛЬHO AДMИHИCTPATOP');PUTT;
    WRITE(OUT,'BAM OTKPЫTЫ ПPABA HA ИЗMEHEHИE ДAHHЫX');PUTT;
    ФЛAГИ:=ФЛAГИ+[AДMИH])
  ELSE(
    WRITE(OUT,'HE ЗHAETE ПAPOЛЯ - HE БAЛYЙTECЬ');PUTT));
IF NOT (AДMИH IN ФЛAГИ) THEN(
  WRITE(OUT,'BЫ - ПOЛЬЗOBATEЛЬ');PUTT;
  WRITE(OUT,'BAM MOЖHO TOЛЬKO BЫДABATЬ OTЧETЫ');PUTT);
(**)
WRITE(OUT,'COOБЩИTE CEГOДHЯШHЮЮ ДATY:');
CEГOДHЯ:=RДAT(SYSTEM.ДATЗП,ДATЧИC(31,12,99)));
END;



(* SECTION ? .ПAPOЛЬ *)
(*ИЗMEHEHИE ПAPOЛЯ*)
PROCEDURE ПAPOЛЬ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN EXIT;
WRITE(OUT,'COOБЩИTE HOBЫЙ ПAPOЛЬ:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,SYSTEM.ПAPOЛЬ);YCTMOД;
ECTЬ;
END;



(* SECTION ? .БCИCШ *)
(*БЛOK-MEHЮ ДЛЯ CИCTEMHЫX PAБOT*)
PROCEDURE БЛOKCИC;



(* SECTION ? .SF *)
(* YCT/CHЯ ФЛAГOB *)
PROCEDURE SETFLAG;
VAR Ф,ФФ:ФЛAГ;N:INT;
BEGIN
WRITE(OUT,'TEKYЩEE COCTOЯHИE ФЛAГOB:');PUTT;
FOR Ф:=SUCC(ФS) TO PRED(ФF) DO(
  WRITE(OUT,ORD(Ф):0,'.',Ф,' ');
  IF Ф IN ФЛAГИ THEN WRITE(OUT,'(+)')
                ELSE WRITE(OUT,'(-)');
  PUTT);
WRITE(OUT,'YKAЖИTE HOMEP ИHBEPTИPYEMOГO ФЛAГA:');
N:=RЦEЛ(1,ORD(ФF)-1);IF HAЧ THEN EXIT;
Ф:=ФF;
FOR ФФ:=SUCC(ФS) TO PRED(ФF) DO IF N=ORD(ФФ) THEN Ф:=ФФ;
ФЛAГИ:=ФЛAГИ MOD [Ф];
WRITE(OUT,ORD(Ф):0,'.',Ф);
IF Ф IN ФЛAГИ THEN WRITE(OUT,' (-) --> (+)')
              ELSE WRITE(OUT,' (+) --> (-)');
PUTT;
END;



(* SECTION ? .ПЗГ *)
(*BЫДAЧA ДЛЯ ПEPEЗAГPYЗKИ*)
PROCEDURE ПЗГ;
CONST EE='_';EF='*';
BEGIN
DMLCALL(5)
WRITELN(' BEЩИ [');
WHILE MOЖHO DO WITH BEЩЬ DO(
  DMLCALL(6)
  WRITE(' ',HOMEP/1000:0:23,EE);
  WCTP(OUTPUT,HAЗB,0);WRITELN(EE,EД[1],EД[2],EE);
  WRITELN('    ',ЦEHA:0:22,EE,
          OCTAT:0:23,EE,ПPИXOД:0:23,EE,PACXOД:0:23,EF);
  DMLCALL(7));
WRITELN(' ]');

DMLCALL(8)
WHILE MOЖHO DO(
  DMLCALL(9)
  WRITELN(' OTДEЛ [',OTДEЛ.HAЗB,EF,']');
  DMLCALL(10)
  WHILE MOЖHO DO(
    DMLCALL(11)
    WRITELN('   CYMMA [',CYMMA.ЦEHA:0:22,EF,']');
    DMLCALL(12)
    WHILE MOЖHO DO(
      DMLCALL(13)
      WRITELN('     BЗЯЛ [',BEЩЬ.HOMEP/1000:0:23,EE,
              BЗЯЛ.KOЛИЧ:0:23,EF,']');
      DMLCALL(14));
    DMLCALL(15));
  DMLCALL(16));
ECTЬ;
END;



(* SECTION ? .БCИC *)
BEGIN
KYДA:='HAPYЖY';
IF HEЛЬЗЯ THEN EXIT;
WRITE(OUT,'ПAPOЛЬ:');GETT;
READ(INP,OTДEЛ.HAЗB);
IF SYSTEM.ПAPCИC!OTДEЛ.HAЗB THEN(
  WRITE(OUT,'HE ЛEЗЬ, KYДA HE HYЖHO???');PUTT;EXIT);
PUTT;
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B CИCTEMHOM БЛOKE...  ');PUTT;
WRITE(OUT,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/',
          'ПЗГ - BЫДAЧA ДAHHЫX ДЛЯ ПEPEЗAГPYЗKИ/');
MENU;
SELECT
  'ФЛA'=ДИP:SETFLAG;
  'ПЗГ'=ДИP:ПЗГ;
  'BЫX'=ДИP:EXIT;
  'KOH'=ДИP:EXIT);
)
END;



(* SECTION ? .B *)
BEGIN CASE KYДA OF
'HAЧAЛO':(
WRITELN(OUT);
RGEXPORT:=[46];
WRITELN;
WRITE(OUT,'           ************');PUTPT;
WRITE(OUT,'           ИПC CKЛAД-88');PUTPT;
WRITE(OUT,'           ************');PUTPT;
WRITELN;
IF ПYCTO THEN(
    WRITE(OUT,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(OUT,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(OUT,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(17);KYДA:='ЭTOBCE';EXIT);
  ПPABA));
  IF (KYДA!'HAPYЖY') AND (KYДA!'HAЧAЛO') THEN EXIT;
(**)
(* SECTION ? .Д *)
WHILE TRUE DO(
IF ДИP!'KOH' THEN(
WRITE(OUT,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
WRITE(OUT,'KAP - BXOД B БЛOK PEГИCTPAЦИИ KAPT/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/');
MENU);
SELECT
  'KAP'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='SKLCAR';EXIT);
  'OTЧ'=ДИP:IF NOT ЗAKPЫTO THEN(
              KYДA:='SKLOTC';EXIT);
  'OTД'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='SKLOTD';EXIT);
  'CИC'=ДИP:БЛOKCИC;
  'ЗAK'=ДИP:ЖYPHAЛ('ЗAK',ПPEДЗAK);
  'CБP'=ДИP:ЖYPHAЛ('CБP',ПPEДЗAK);
  'ПAP'=ДИP:ПAPOЛЬ;
  'KOH'=ДИP:(KOHEЦ(ПPEДЗAK);IF NOT HAЧ THEN(ДИP:='KOH';EXIT));
  'BЫX'=ДИP:(WRITE(OUT,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE "KOH"');
             PUTT)));
END.
(* SECTION ? .CKPO *)
