(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATCOF (*ЗT:PEГИC.KOЭФФ*)
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
    257: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    258: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='A';BUF.M[20]:='Л';
      BUF.M[21]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    259: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='A';BUF.M[8]:='Л';
      BUF.M[9]:='Ф';BUF.M[10]:='.';BUF.M[11]:='З';BUF.M[12]:='H';
      BUF.M[13]:=' ';BUF.M[14]:='H';BUF.M[15]:='A';BUF.M[16]:=' ';
      BUF.M[17]:='A';BUF.M[18]:='[';BUF.M[19]:='I';BUF.M[20]:=']';
      BUF.M[21]:=';';BUF.M[22]:='H';BUF.M[23]:='A';BUF.M[24]:='Й';
      BUF.M[25]:='T';BUF.M[26]:='И';BUF.M[27]:=' ';BUF.M[28]:='C';
      BUF.M[29]:='Л';BUF.M[30]:='E';BUF.M[31]:='Д';BUF.M[32]:='Y';
      BUF.M[33]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    260: begin
      BUF.LEN:=44;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='E';
      BUF.M[21]:='Й';BUF.M[22]:=';';BUF.M[23]:=' ';BUF.M[24]:=' ';
      BUF.M[25]:=' ';BUF.M[26]:='B';BUF.M[27]:='З';BUF.M[28]:='Я';
      BUF.M[29]:='T';BUF.M[30]:='Ь';BUF.M[31]:=' ';BUF.M[32]:='П';
      BUF.M[33]:='A';BUF.M[34]:='P';BUF.M[35]:=';';BUF.M[36]:='B';
      BUF.M[37]:='З';BUF.M[38]:='Я';BUF.M[39]:='T';BUF.M[40]:='Ь';
      BUF.M[41]:=' ';BUF.M[42]:='Д';BUF.M[43]:='E';BUF.M[44]:='Й';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    261: begin
      BUF.LEN:=43;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='П';BUF.M[12]:='A';
      BUF.M[13]:='P';BUF.M[14]:=';';BUF.M[15]:='П';BUF.M[16]:='O';
      BUF.M[17]:='C';BUF.M[18]:='T';BUF.M[19]:='A';BUF.M[20]:='B';
      BUF.M[21]:='И';BUF.M[22]:='T';BUF.M[23]:='Ь';BUF.M[24]:=' ';
      BUF.M[25]:='Д';BUF.M[26]:='E';BUF.M[27]:='Й';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='K';BUF.M[31]:='Л';BUF.M[32]:='Ю';
      BUF.M[33]:='Ч';BUF.M[34]:='И';BUF.M[35]:=' ';BUF.M[36]:='B';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='A';BUF.M[40]:='-';
      BUF.M[41]:='Д';BUF.M[42]:='E';BUF.M[43]:='Й';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    262: begin
      BUF.LEN:=57;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='И';BUF.M[16]:='M';
      BUF.M[17]:='-';BUF.M[18]:='K';BUF.M[19]:='O';BUF.M[20]:='Э';
      BUF.M[21]:=''';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='П';
      BUF.M[33]:='O';BUF.M[34]:='C';BUF.M[35]:='T';BUF.M[36]:='A';
      BUF.M[37]:='B';BUF.M[38]:=' ';BUF.M[39]:='A';BUF.M[40]:='Л';
      BUF.M[41]:='Ф';BUF.M[42]:=';';BUF.M[43]:='B';BUF.M[44]:='K';
      BUF.M[45]:='Л';BUF.M[46]:='Ю';BUF.M[47]:='Ч';BUF.M[48]:='И';
      BUF.M[49]:=' ';BUF.M[50]:='B';BUF.M[51]:=' ';BUF.M[52]:='П';
      BUF.M[53]:='A';BUF.M[54]:='-';BUF.M[55]:='A';BUF.M[56]:='Л';
      BUF.M[57]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    263: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='П';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='Д';BUF.M[26]:='E';BUF.M[27]:='Й';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    264: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    265: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='П';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='Д';BUF.M[26]:='E';BUF.M[27]:='Й';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    266: begin
      BUF.LEN:=21;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='Д';
      BUF.M[9]:='E';BUF.M[10]:='Й';BUF.M[11]:=';';BUF.M[12]:='Y';
      BUF.M[13]:='Б';BUF.M[14]:='P';BUF.M[15]:='A';BUF.M[16]:='T';
      BUF.M[17]:='Ь';BUF.M[18]:=' ';BUF.M[19]:='П';BUF.M[20]:='A';
      BUF.M[21]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    267: begin
      BUF.LEN:=36;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='П';BUF.M[15]:='A';BUF.M[16]:='P';
      BUF.M[17]:='.';BUF.M[18]:='И';BUF.M[19]:='M';BUF.M[20]:='Я';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='П';
      BUF.M[25]:='A';BUF.M[26]:='-';BUF.M[27]:='A';BUF.M[28]:='Л';
      BUF.M[29]:='Ф';BUF.M[30]:=';';BUF.M[31]:='Y';BUF.M[32]:='Б';
      BUF.M[33]:='P';BUF.M[34]:='A';BUF.M[35]:='T';BUF.M[36]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(257)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:RЦEЛBEЩ*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)
(* EDITOR !INCLU:FПAP*)
(* EDITOR !INCLU:STEP*)
(* EDITOR !INCLU:TOЛЬKOCИ*)



(* SECTION ? .PK *)
(*PEГИCTPAЦИЯ KOЭФФИЦИEHTOB И OTДEЛЬHЫX ПAPAMETPOB*)
PROCEDURE PEKOЭФ;
VAR Д:ДИPEKT;



(* SECTION ? .W *)
(*ПEЧATЬ KOЭФФИЦИEHTA*)
PROCEDURE ПEЧKOЭФ;
BEGIN
WRITE(OUT,ПAP.ИMЯ,':');WCTP(OUT,ПAP.HAЗB,32);
WRITE(OUT,' = ',ДEЙ.ЗH:8:23);
PUTT;
END;



(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR I,J:INT;A:ARRAY 1..100 OF ALFA;
BEGIN
FПAP('ИM-KOЭ');DMLCALL(258)
IF ПYCTO THEN(WRITE(OUT,'HET KAPT');PUTT;EXIT);
I:=0;WHILE MOЖHO DO(I:=I+1;DMLCALL(259));
J:=1;ШAГ:=1;
REPEAT
  FПAP(A[J]);DMLCALL(260);ПEЧKOЭФ;J:=J+1;
UNTIL STEP OR (J>I);
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
VAR I:INT;
BEGIN
IF TOЛЬKOCИ THEN EXIT;
REPEAT
REPEAT
  WRITE(OUT,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
  IF HAЧ THEN EXIT;
  READ(INP,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
  IF MOЖHO THEN(WRITE(OUT,'ЭTO HAЗBAHИE YЖE ЗAPEГИCTPИPOBAHO');PUTT);
UNTIL ПYCTO;
(**)
WRITE(OUT,'ПOЛHOE HAЗBAHИE:');RCTP;IF HAЧ THEN EXIT;
READ(INP,ПAP.HAЗB);
(**)
WRITE(OUT,'ЗHAЧEHИE:');
ДEЙ.ЗH:=RBEЩ(0.0,999999.9);IF HAЧ THEN EXIT;
(**)
ПAP.COKP[1]:='_377';
(**)
WRITE(OUT,'BOT, ЧTO BЫ BBEЛИ:');PUTT;ПEЧKOЭФ;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(261);
  DMLCALL(262)
  YCTMOД;WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE ! ') OR HAЧ;
END;



(* SECTION ? .ЗAM *)
PROCEDURE ЗAM;
BEGIN
WRITE(OUT,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
IF ПYCTO THEN(
  WRITE(OUT,'TAKAЯ KAPTA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT);
DMLCALL(263)
WRITE(OUT,'BOT ЭTA KAPTA:');PUTT;ПEЧKOЭФ;
WRITE(OUT,'HOBOE ЗHAЧEHИE:');
ДEЙ.ЗH:=RBEЩ(0.0,999999.9);IF HAЧ THEN EXIT;
DMLCALL(264);YCTMOД;ECTЬ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
BEGIN
IF TOЛЬKOCИ THEN EXIT;
WRITE(OUT,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
IF ПYCTO THEN(
  WRITE(OUT,'TAKAЯ KAPTA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT);
DMLCALL(265)
WRITE(OUT,'BOT ЭTA KAPTA:');PUTT;ПEЧKOЭФ;
WRITE(OUT,'ПOДTBEPДИTE ИCKЛЮЧEHИE');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ИCKЛЮЧEHИE OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(266)
FПAP('ИM-KOЭ');DMLCALL(267);YCTMOД;
END;



(* SECTION ? .PKB *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KOЭФФИЦИEHTOB...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ЗAM - ЗAMEHA ЗHAЧEHИЯ KOЭФИЦИEHTA/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
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
BEGIN
PEKOЭФ;KYДA:='HAPYЖY';
END.
(* SECTION ? .ЗTPЗ *)
