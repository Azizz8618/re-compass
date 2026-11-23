(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOMON (*AM:MOHИTOP *)
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
    134: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    135: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='S';
      BUF.M[9]:='Y';BUF.M[10]:='S';BUF.M[11]:='T';BUF.M[12]:='E';
      BUF.M[13]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    136: begin
      BUF.LEN:=12;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='S';BUF.M[8]:='Y';
      BUF.M[9]:='S';BUF.M[10]:='T';BUF.M[11]:='E';BUF.M[12]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    137: begin
      BUF.LEN:=6;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='B';BUF.M[4]:='E';
      BUF.M[5]:='P';BUF.M[6]:='Ш';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(134)*)
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
SYSTEM.PEЖИMЫ:=ФЛAГИ*[OTЛAД,BXOД];
END;(*=C+*)



(* SECTION ? .ПЗAK *)
(*ДEЙCTBИЯ ДO ЗAKPEПЛEHИЯ*)
PROCEDURE ПPEДЗAK;
BEGIN
SYSTEM.ДATЗП:=CEГOДHЯ;CHЯФЛAГ;
DMLCALL(135)
END;



(* SECTION ? .ПPABA *)
(*ПPOBEPKA ПPAB ПOЛЬЗOBATEЛЯ*)
PROCEDURE ПPABA;
VAR ПPOB:ZZSYSTEM;
BEGIN
DMLCALL(136);PUTT;YCTФЛAГ;
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
WRITE(OUT,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/');
MENU;
SELECT
  'BЫX'=ДИP:EXIT;
  'KOH'=ДИP:EXIT;
  'ФЛA'=ДИP:SETFLAG);
)
END;



(* SECTION ? .B *)
BEGIN CASE KYДA OF
'HAЧAЛO':(
WRITELN(OUT);
RGEXPORT:=[46];
WRITELN;PUTT;
WRITE(OUT,'           ******************');PUTPT;
WRITE(OUT,'           ИПC AMOPTИЗAЦИЯ-88');PUTPT;
WRITE(OUT,'           ******************');PUTPT;
WRITELN;
IF ПYCTO THEN(
    WRITE(OUT,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(OUT,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(OUT,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(137);KYДA:='ЭTOBCE';EXIT);
  ПPABA));
  IF (KYДA!'HAPYЖY') AND (KYДA!'HAЧAЛO') THEN EXIT;
(**)
(* SECTION ? .Д *)
WHILE TRUE DO(
IF ДИP!'KOH' THEN(
WRITE(OUT,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
WRITE(OUT,'KAP - BXOД B БЛOK PEГИCTPAЦИИ KAPT/',
          'ГPY - BXOД B БЛOK PEГИCTPAЦИИ ГPYПП ШИФPOB/',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/');
MENU);
SELECT
  'KAP'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='AMOCAR';EXIT);
  'ГPY'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='AMOGRU';EXIT);
  'OTД'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='AMOOTD';EXIT);
  'OTЧ'=ДИP:IF NOT ЗAKPЫTO THEN(
              KYДA:='AMOOTC';EXIT);
  'CИC'=ДИP:БЛOKCИC;
  'ЗAK'=ДИP:ЖYPHAЛ('ЗAK',ПPEДЗAK);
  'CБP'=ДИP:ЖYPHAЛ('CБP',ПPEДЗAK);
  'ПAP'=ДИP:ПAPOЛЬ;
  'KOH'=ДИP:(KOHEЦ(ПPEДЗAK);IF NOT HAЧ THEN(ДИP:='KOH';EXIT));
  'BЫX'=ДИP:(WRITE(OUT,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE "KOH"');
             PUTT)));
END.
(* SECTION ? .AMPO *)
