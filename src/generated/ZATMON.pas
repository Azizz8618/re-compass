(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATMON (*ЗT:MOHИTOP*)
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
    237: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    238: begin
      BUF.LEN:=74;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='Ф';BUF.M[16]:='Л';
      BUF.M[17]:='A';BUF.M[18]:='Г';BUF.M[19]:='И';BUF.M[20]:=''';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';BUF.M[52]:=';';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Ф';BUF.M[71]:='Л';BUF.M[72]:='A';
      BUF.M[73]:='Г';BUF.M[74]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    239: begin
      BUF.LEN:=52;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:=' ';BUF.M[18]:='S';BUF.M[19]:='Y';BUF.M[20]:='-';
      BUF.M[21]:='П';BUF.M[22]:='A';BUF.M[23]:='P';BUF.M[24]:=';';
      BUF.M[25]:='H';BUF.M[26]:='A';BUF.M[27]:='Й';BUF.M[28]:='T';
      BUF.M[29]:='И';BUF.M[30]:=' ';BUF.M[31]:='П';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='B';BUF.M[35]:='Y';BUF.M[36]:='Ю';
      BUF.M[37]:=' ';BUF.M[38]:='B';BUF.M[39]:=' ';BUF.M[40]:='П';
      BUF.M[41]:='A';BUF.M[42]:='-';BUF.M[43]:='Ц';BUF.M[44]:='E';
      BUF.M[45]:='Л';BUF.M[46]:=';';BUF.M[47]:='З';BUF.M[48]:='A';
      BUF.M[49]:='M';BUF.M[50]:='E';BUF.M[51]:='H';BUF.M[52]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    240: begin
      BUF.LEN:=152;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='Д';BUF.M[16]:='A';
      BUF.M[17]:='T';BUF.M[18]:='З';BUF.M[19]:='П';BUF.M[20]:=''';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';BUF.M[52]:=';';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Д';BUF.M[71]:='A';BUF.M[72]:='T';
      BUF.M[73]:='З';BUF.M[74]:='П';BUF.M[75]:=';';BUF.M[76]:=' ';
      BUF.M[77]:='H';BUF.M[78]:='A';BUF.M[79]:='Й';BUF.M[80]:='T';
      BUF.M[81]:='И';BUF.M[82]:=' ';BUF.M[83]:='П';BUF.M[84]:='O';
      BUF.M[85]:='-';BUF.M[86]:='K';BUF.M[87]:='Л';BUF.M[88]:='Ю';
      BUF.M[89]:=' ';BUF.M[90]:=''';BUF.M[91]:='П';BUF.M[92]:='A';
      BUF.M[93]:='P';BUF.M[94]:='O';BUF.M[95]:='Л';BUF.M[96]:='Ь';
      BUF.M[97]:=''';BUF.M[98]:=' ';BUF.M[99]:='B';BUF.M[100]:=' ';
      BUF.M[101]:='S';BUF.M[102]:='Y';BUF.M[103]:='-';BUF.M[104]:='П';
      BUF.M[105]:='A';BUF.M[106]:='P';BUF.M[107]:=';';BUF.M[108]:='H';
      BUF.M[109]:='A';BUF.M[110]:='Й';BUF.M[111]:='T';BUF.M[112]:='И';
      BUF.M[113]:=' ';BUF.M[114]:='П';BUF.M[115]:='E';BUF.M[116]:='P';
      BUF.M[117]:='B';BUF.M[118]:='Y';BUF.M[119]:='Ю';BUF.M[120]:=' ';
      BUF.M[121]:='B';BUF.M[122]:=' ';BUF.M[123]:='П';BUF.M[124]:='A';
      BUF.M[125]:='-';BUF.M[126]:='A';BUF.M[127]:='Л';BUF.M[128]:='Ф';
      BUF.M[129]:=';';BUF.M[130]:=' ';BUF.M[131]:='B';BUF.M[132]:='З';
      BUF.M[133]:='Я';BUF.M[134]:='T';BUF.M[135]:='Ь';BUF.M[136]:=' ';
      BUF.M[137]:='A';BUF.M[138]:='Л';BUF.M[139]:='Ф';BUF.M[140]:='.';
      BUF.M[141]:='З';BUF.M[142]:='H';BUF.M[143]:=' ';BUF.M[144]:='H';
      BUF.M[145]:='A';BUF.M[146]:=' ';BUF.M[147]:='П';BUF.M[148]:='A';
      BUF.M[149]:='P';BUF.M[150]:='O';BUF.M[151]:='Л';BUF.M[152]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    241: begin
      BUF.LEN:=59;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='П';BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='O';BUF.M[19]:='Л';BUF.M[20]:='Ь';
      BUF.M[21]:=''';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';BUF.M[52]:='Ф';
      BUF.M[53]:=';';BUF.M[54]:='З';BUF.M[55]:='A';BUF.M[56]:='M';
      BUF.M[57]:='E';BUF.M[58]:='H';BUF.M[59]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    242: begin
      BUF.LEN:=58;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='П';BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='C';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:=''';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';BUF.M[52]:='Ф';
      BUF.M[53]:=';';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    243: begin
      BUF.LEN:=6;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='B';BUF.M[4]:='E';
      BUF.M[5]:='P';BUF.M[6]:='Ш';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(237)*)
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
BEGIN
DMLCALL(238)
END;



(* SECTION ? .PЦEЛ *)
(*ЗAMEHИTЬ ПEPBOE ЗHAЧEHИE ЦEЛOГO ПAPAMETPA*)
PROCEDURE PЦEЛ(A:ALFA;I:INT);
BEGIN;DMLCALL(239)
END;



(* SECTION ? .CHЯФ *)
(* CHЯTИE HE XPAHИMЫX ФЛAГOB *)
PROCEDURE CHЯФЛAГ;
BEGIN(*=C-*)
PЦEЛ('ФЛAГИ ',ФЛAГИ*[OTЛAД,BXOД]);
END;(*=C+*)



(* SECTION ? .ПЗAK *)
(*ДEЙCTBИЯ ДO ЗAKPEПЛEHИЯ*)
PROCEDURE ПPEДЗAK;
BEGIN
PЦEЛ('ДATЗП ',CEГOДHЯ);CHЯФЛAГ;
END;



(* SECTION ? .ПPABA *)
(*ПPOBEPKA ПPAB ПOЛЬЗOBATEЛЯ*)
PROCEDURE ПPABA;
VAR ДATЗП:INT;ПAPOЛЬ,PAROL:ALFA;
BEGIN
DMLCALL(240)
PUTT;YCTФЛAГ;
WRITE(OUT,'         ДAHHЫE OT ');WДAT(OUT,ДATЗП);
IF OTЛAД IN ФЛAГИ THEN(
  ФЛAГИ:=ФЛAГИ+[AДMИH];CEГOДHЯ:=ДATЗП+1)
ELSE(
PUTT;PUTT;
WRITE(OUT,'       ...ЗДPABCTBYЙTE...');PUTT;
WRITE(OUT,'BЫ - AДMИHИCTPATOP!');
IF ДA THEN(
  WRITE(OUT,'ПOДTBEPДИTE ПAPOЛЬ:');GETHAЧ;
  READ(INP,PAROL);
  IF ПAPOЛЬ=PAROL THEN(
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
CEГOДHЯ:=RДAT(ДATЗП,ДATЧИC(31,12,99)));
END;



(* SECTION ? .ПAPOЛЬ *)
(*ИЗMEHEHИE ПAPOЛЯ*)
PROCEDURE ПAPOЛЬ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN EXIT;
WRITE(OUT,'COOБЩИTE HOBЫЙ ПAPOЛЬ:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,AЛФ.ЗH);
DMLCALL(241)
YCTMOД;ECTЬ;
END;



(* SECTION ? .БPEГ *)
(*PEГИCTPAЦИOHHЫЙ БЛOK-MEHЮ*)
PROCEDURE БЛOKPEГ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN(KYДA:='HAPYЖY';EXIT);
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B PEГИCTPAЦИOHHOM БЛOKE...  ');PUTT;
WRITE(OUT,'KOФ - BXOД B БЛOK PEГИCTPAЦИИ KOЭФФИЦИEHTOB/',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB/',
          'TEM - BXOД B БЛOK PEГИCTPAЦИИ TEM/',
          'ФAK - BXOД B БЛOK PEГИCTPAЦИИ ФAKTИЧ.ЗATPAT/',
          'OБЩ - BXOД B БЛOK PEГИCTPAЦИИ OБЩИX ЗATPAT/');
MENU;
SELECT
  'KOФ'=ДИP:(KYДA:='ZATCOF';EXIT);
  'OTД'=ДИP:(KYДA:='ZATOTD';EXIT);
  'TEM'=ДИP:(KYДA:='ZATRTE';EXIT);
  'ФAK'=ДИP:(KYДA:='ZATZAT';EXIT);
  'OБЩ'=ДИP:(KYДA:='ZATNAK';EXIT);
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:(KYДA:='HAPYЖY';EXIT)));
END;



(* SECTION ? .БOTЧ *)
(*БЛOK-MEHЮ BЫДAЧИ OTЧETOB*)
PROCEDURE БЛOKOTЧ;
BEGIN
IF ЗAKPЫTO THEN(KYДA:='HAPYЖY';EXIT);
IF KYДA='ZATTAB' THEN ECTЬ;
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B БЛOKE BЫДAЧИ OTЧETOB...  ');PUTT;
WRITE(OUT,'ПOC - BЫДAЧA OTЧETA ПO ПOCЛEДHEMY MECЯЦY/');
MENU;
SELECT
  'ПOC'=ДИP:(YCTПEЧ;YCTMOД;KYДA:='ZATTAB';EXIT);
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:(KYДA:='HAPYЖY';EXIT)));
END;



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
(*CИCTEMHЫЙ БЛOK*)
PROCEDURE БЛOKCИC;
VAR ПAPCИC:ALFA;
BEGIN
KYДA:='HAPYЖY';
WRITE(OUT,'ПAPOЛЬ:');GETT;
READ(INP,ПAPCИC);
DMLCALL(242)
PUTT;YCTФЛAГ;
IF AЛФ.ЗH ! ПAPCИC THEN(
  WRITE(OUT,'HE ЛEЗЬ, KYДA HE HYЖHO???');PUTT;EXIT);
PUTT;
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B CИCTEMHOM БЛOKE...  ');PUTT;
WRITE(OUT,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/');
MENU;
SELECT
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT;
  'ФЛA'=ДИP:SETFLAG);
)
END;



(* SECTION ? .B *)
BEGIN CASE KYДA OF
'HAЧAЛO':(
WRITELN(OUT);PUTT;
RGEXPORT:=[46];
PUTT;WRITELN;
WRITE(OUT,'           **************');PUTPT;
WRITE(OUT,'           ИПC ЗATPATЫ-89');PUTPT;
WRITE(OUT,'           **************');PUTPT;
WRITELN;
IF ПYCTO THEN(
    WRITE(OUT,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(OUT,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(OUT,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(243);KYДA:='ЭTOBCE';EXIT);
  ПPABA);
(**)
  'ZATTAB':БЛOKOTЧ;
  'ZATZAT','ZATNAK','ZATRTE','ZATCOF','ZATOTD':БЛOKPEГ);
(**)
IF (KYДA!'HAPYЖY') AND (KYДA!'HAЧAЛO') THEN EXIT;
(**)
WHILE TRUE DO(
IF ДИP!'KOH' THEN(
WRITE(OUT,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
(* SECTION ? .Д *)
WRITE(OUT,'PEГ - BXOД B PEГИCTPAЦИOHHЫЙ БЛOK/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/');
MENU);
SELECT
  'PEГ'=ДИP:(БЛOKPEГ;IF KYДA!'HAPYЖY' THEN EXIT);
  'OTЧ'=ДИP:(БЛOKOTЧ;IF KYДA!'HAPYЖY' THEN EXIT);
  'CИC'=ДИP:(БЛOKCИC;IF KYДA!'HAPYЖY' THEN EXIT);
  'ЗAK'=ДИP:ЖYPHAЛ('ЗAK',ПPEДЗAK);
  'CБP'=ДИP:ЖYPHAЛ('CБP',ПPEДЗAK);
  'ПAP'=ДИP:ПAPOЛЬ;
  'KOH'=ДИP:(KOHEЦ(ПPEДЗAK);IF NOT HAЧ THEN(ДИP:='KOH';EXIT));
  'BЫX'=ДИP:(WRITE(OUT,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE "KOH"');
             PUTT)));
END.
(* SECTION ? .ЗTPO *)
