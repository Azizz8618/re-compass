(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOCAR(output,BUF,BDVECT,BDERRN,input); (*AM:KAPTЫ *)
type
  alfa = packed array[1..6] of char;
  word = record case integer of
    0:(i:integer); 1:(a:alfa); 2:(c:char) end;
  TBDVec = array[0..167] of word;
  TYPEM = packed array[1..160] of char;
  ZZBUFT = record LEN,H,D,I:integer; M:TYPEM end;

  INT=integer;
  ZFLG=(FS,ПЕЧАТЬ,МОДИФ,AДMИH,OTЛAД,OTЧCKЛ,OTЧOTД,BXOД,FF);
  ZFLGS=set of ZFLG;
  ZSYS=record PEЖИMЫ:ZFLGS;
            XPAHИMЫ:ZFLGS;
            ГOД:integer;
            ДATЗП:integer;
            BPEЗП:integer;
            ДATЧИC:integer;
            ПAPCИC:alfa;
            ПAPOЛЬ:alfa end;
  ZSYSREC=record ПAPOЛЬ:alfa end;
  ZZSYSTEM=ZSYSREC;
  ФЛАГ=ZFLG;
  ZOTD=record HAЗB:alfa end;
  ZVESH=record HOMEP:integer; HAЗB:alfa; ЦEHA:integer;
             OCTAT:integer; ПPИXOД:integer; PACXOД:integer end;
  ZVZYAL=record KOЛИЧ:integer end;
  ZSUM=record ЦEHA:integer end;
  ZPRAVA=record ПAPOЛЬ:alfa end;
  ZPRE=record N:integer end;
  ZSETI=integer;

  ВООL=boolean;
  SТРОКА=alfa;
  СТРОКА=alfa;
  ZZОТДЕЛ=record НАЗВ:alfa end;
  ZZГРУППА=record НАЗВ:alfa; НАЧ:integer; КОН:integer end;
  ZZВDКЕУ=record КЛЮЧ:alfa; ЗНАЧ:integer end;
  ДИРЕКТ=record ИМЯ:alfa; НАЗВ:alfa end;
  ДЕЙ=record ЗН:real end;
  СТОИТ=record ПРИНЯЛ:integer; СПИСАЛ:integer end;
  ZЗАТ=record МЕС:integer; НОМЕР:integer; ЗН:integer end;
  ZИСПОЛН=record НОМЕР:integer; УРОВ:integer end;
  ZLINЕ=record S:integer; F:char end;
  ZСЕLL=record FRМ:char; СОN:integer end;

var
  BDVECT: TBDVec;
  BDERRN: integer;
  BUF: ZZBUFT;
  C: char;

  SYSTEM:ZSYS;
  ФЛAГИ:ZFLGS;
  CEГOДHЯ:integer;
  ДA:boolean;
  HAЧ:boolean;
  HEЛЬЗЯ:boolean;
  ЗAKPЫTO:boolean;
  MOЖHO:boolean;
  ПYCTO:boolean;
  OTДEЛ:ZOTD;
  BEЩЬ:ZVESH;
  BЗЯЛ:ZVZYAL;
  CYMMA:ZSUM;
  EД:array[1..2] of integer;
  EE:char;
  EF:char;
  KYДA:alfa;
  ДИP:alfa;
  ПPOB:ZSYSREC;
  RGEXPORT:ZSETI;
  ФS:ZFLG;
  Ф:ZFLG;
  ФF:ZFLG;
  ФФ:ZFLG;

  INР:integer;
  ШАГ:integer;
  СОСТ:integer;
  МАТЕР:integer;
  WRI:integer;
  ВОS:integer;
  Д:integer;
  SТРUТ:boolean;
  SТЕР:boolean;
  NЕХТ:boolean;
  ЦЕЛ:ZLINЕ;
  LF:char;
  МАХШИФР:integer;
  МINШИФР:integer;
type
     Qvalt = array[1..4] of integer;
     Qv8t = array[1..8] of integer;
     Qlint = packed array[1..72] of char;
     Qtxtt = packed array[1..24] of char;
var
    Qln:Qlint; Qtok,Qt1:alfa; Qsep:char; Qp:integer;
    Qfn:array[1..8] of alfa; Qrc:array[1..8] of integer;
    Qnf,Qcf,Qcnt,Qtl,Qmode,i,j,kk:integer; Qdc:char;
    Qtxt:Qtxtt; Qv:Qvalt; Qw:word; Qkey:alfa;
    Qop:array[1..32] of integer; Qpre:alfa;
    Qnc,Qcur,Qmx:integer; Qloaded:boolean;
    Qo2:array[1..16] of integer;
    Qx1,Qx2,Ql2:array[1..16] of alfa;
    Qnm,Qns,Qss,Qcoc,Qpc:integer;
    Qsn:array[1..8] of alfa; Qsp:array[1..8] of alfa;
    Qsc:array[1..8] of integer; Qsm:array[1..8] of integer;
    Qbf:array[1..8] of alfa;
    Qck:alfa; Qbv:array[1..8] of alfa;
    Qv8:Qv8t; Qcurbuf:integer;
    QbufMode:boolean; Qbm:array[1..120] of char;
    Qbp,Qblen:integer;
function QEXN:integer;
begin QEXN:=BDERRN end;
procedure QClrErr;
begin BDERRN:=0 end;
procedure QNext;
var i:integer; c:char; stop:boolean;
begin
  while (Qp<=72) and (Qln[Qp]=' ') do Qp:=Qp+1;
  while (Qp<=72) and ((Qln[Qp]=':') or (Qln[Qp]=';') or
        (Qln[Qp]=',') or (Qln[Qp]='.')) do Qp:=Qp+1;
  for i:=1 to 6 do Qtok[i]:=' ';
  Qsep:=' ';
  if Qp>72 then exit;
  c:=Qln[Qp];
  if (c='*') or (c=']') or (c='[') or (c=chr(38)) or
     (c='"') or (c='_') then begin Qsep:=c; Qp:=Qp+1; exit end;
  i:=0; stop:=false;
  while (Qp<=72) and (i<6) and not stop do begin
    c:=Qln[Qp];
    if (c=' ') or (c='_') or (c='*') or (c=']') or
       (c='[') or (c=chr(38)) or (c='"') or (c=':') or
       (c=';') or (c=',') or (c='.') then stop:=true
    else begin i:=i+1; Qtok[i]:=c; Qp:=Qp+1 end
  end
end;
function QFindSet(t:alfa):integer;
var z:integer;
begin
  QFindSet:=0;
  for z:=1 to Qns do if Qsn[z]=t then QFindSet:=z
end;
function QFindLab(t:alfa):integer;
var z:integer;
begin
  QFindLab:=0;
  for z:=1 to Qnm do if Ql2[z]=t then QFindLab:=z
end;
(* An absent MAD label ends the snippet. *)
procedure QJumpTo(t:alfa);
var q:integer;
begin
  q:=QFindLab(t);
  if (q>=1) and (q<=Qnm) then Qpc:=q-1 else Qpc:=Qnm+1
end;
procedure QKeyAt(s,q:integer);
var a,b:integer;
begin
  Qck[1]:=Qsp[s][1]; Qck[2]:=Qsp[s][2];
  a:=q div 1000; b:=q-a*1000;
  Qck[3]:=chr(48+a); a:=b div 100; b:=b-a*100;
  Qck[4]:=chr(48+a); a:=b div 10; b:=b-a*10;
  Qck[5]:=chr(48+a); Qck[6]:=chr(48+b)
end;
procedure QNumKey;
begin
  Qsc[Qss]:=(ord(Qck[3])-48)*1000+(ord(Qck[4])-48)*100+
          (ord(Qck[5])-48)*10+(ord(Qck[6])-48)
end;
procedure QLoadRec(bno:integer);
var k:integer;
begin
  QClrErr; getd(Qck,Qv8);
  if BDERRN<>0 then Qcoc:=1 else begin
    Qcoc:=0;
    for k:=1 to 8 do begin Qw.i:=Qv8[k]; Qbf[(bno-1)*8+k]:=Qw.a end
  end
end;
procedure QSaveRec(bno:integer);
var k:integer;
begin
  for k:=1 to 8 do begin Qw.a:=Qbf[(bno-1)*8+k]; Qv8[k]:=Qw.i end;
  QClrErr; modd(Qck,Qv8)
end;
procedure QPrintLit(s:alfa);
var z,z1,z2:integer;
begin
  z1:=1; z2:=6;
  while (z1<=6) and (s[z1]=' ') do z1:=z1+1;
  if z1>6 then begin for z:=1 to 6 do write(' '); exit end;
  while (z2>=1) and (s[z2]=' ') do z2:=z2-1;
  for z:=z1 to z2 do write(s[z])
end;
procedure QNextBufLine(var ok:boolean);
var i:integer;
begin
  ok:=false;
  if Qbp>Qblen then exit;
  i:=1;
  while (Qbp<=Qblen) and (Qbm[Qbp]<>';') and (i<=72) do begin
    Qln[i]:=Qbm[Qbp]; Qbp:=Qbp+1; i:=i+1
  end;
  if (Qbp<=Qblen) and (Qbm[Qbp]=';') then Qbp:=Qbp+1;
  while i<=72 do begin Qln[i]:=' '; i:=i+1 end;
  ok:=true
end;
procedure QReadMad2;
label 2,3;
var z:integer; s:alfa; ok:boolean;
begin
  Qnm:=0;
  while Qbp<=Qblen do begin
    QNextBufLine(ok);
    if not ok then goto 2;
    if Qln[1]='#' then goto 2;
    if Qln[1]='?' then goto 3;
    Qp:=1; QNext;
    if Qtok[1]='S' then begin
      QNext; s:=Qtok; QNext;
      Qns:=Qns+1; Qsn[Qns]:=s; Qsp[Qns]:=Qtok;
      Qsc[Qns]:=0; Qsm[Qns]:=0; Qss:=Qns;
      writeln('SET ',Qsn[Qns],' ',Qsp[Qns]);
      goto 3
    end;
    if Qtok[1]='L' then begin
      QNext; Qnm:=Qnm+1; Qo2[Qnm]:=0; Ql2[Qnm]:=Qtok; goto 3
    end;
    Qnm:=Qnm+1; Ql2[Qnm]:='      '; Qx2[Qnm]:='      ';
    if Qtok='HAЙTИ ' then begin
      QNext;
      if Qtok='ПEPBYЮ' then Qo2[Qnm]:=1
      else if Qtok='CЛEДYЮ' then Qo2[Qnm]:=2
      else if Qtok='ПPEДЫД' then Qo2[Qnm]:=3
      else if Qtok='ПOCЛEД' then Qo2[Qnm]:=4
      else if Qtok='BЛAДEЛ' then Qo2[Qnm]:=5
      else Qo2[Qnm]:=6;
      QNext;
      if Qtok='B     ' then QNext;  (* B = 'in' before a set name. *)
      Qx1[Qnm]:=Qtok
    end else if Qtok='BЗЯTЬ ' then begin
      QNext;
      if Qtok[1]='Б' then begin Qo2[Qnm]:=8; QNext; Qx1[Qnm]:=Qtok end
      else begin Qo2[Qnm]:=7; Qx1[Qnm]:=Qtok end
    end else if Qtok='ЗAMEHИ' then begin
      QNext; QNext; Qo2[Qnm]:=9; Qx1[Qnm]:=Qtok
    end else if (Qtok='BЫДATЬ') or (Qtok='BB    ') then begin
      Qo2[Qnm]:=10
    end else if Qtok='ECЛИ  ' then begin
      QNext; s:=Qtok;
      if s[4]='<' then begin
        Qo2[Qnm]:=14; QNext; QNext; Qx1[Qnm]:=Qtok end
      else begin Qo2[Qnm]:=13; QNext; QNext; Qx1[Qnm]:=Qtok end
    end else if Qtok[1]='K' then begin
      QNext; s:=Qtok;
      if s<>'      ' then begin Qo2[Qnm]:=23; Qx1[Qnm]:=s end
      else Qo2[Qnm]:=17
    end else if Qtok='KOHEЦ ' then begin Qo2[Qnm]:=18
    end else if (Qtok='CБPOCИ') or (Qtok='ЗABEPШ') or
                (Qtok='PEЖИM ') or (Qtok='ЖYPHAЛ') or
                (Qtok='ПOДCXE') or (Qtok='ДЛЯ-BЫ') then begin
      Qo2[Qnm]:=19
    end else if Qtok[1]='П' then begin
      if Qtok[2]='Л' then begin
        Qo2[Qnm]:=20;
        for z:=1 to 6 do Qx1[Qnm][z]:=Qln[z+2]
      end else if Qtok[2]='П' then begin
        Qo2[Qnm]:=21; Qx1[Qnm][1]:=Qln[3]; Qx2[Qnm][1]:=Qln[4]
      end else Qo2[Qnm]:=22
    end else Qo2[Qnm]:=19;
3:
  end;
2:
end;
procedure QMadExec2;
var z,bno,wn:integer;
begin
  Qcoc:=0; Qpc:=1; Qcurbuf:=1;
  writeln('MAD FULL: instructions=',Qnm,' sets=',Qns);
  while Qpc<=Qnm do begin
    z:=Qo2[Qpc];
    if (z>=2) and (z<=4) then begin
      if Qx1[Qpc]<>'      ' then begin
        kk:=QFindSet(Qx1[Qpc]); if kk<>0 then Qss:=kk
      end
    end;
    if z=1 then begin
      Qss:=QFindSet(Qx1[Qpc]); if Qss=0 then Qss:=1;
      Qsc[Qss]:=1; QKeyAt(Qss,1); Qcoc:=0;
      writeln('FIND FIRST ',Qsn[Qss],' N=',Qsm[Qss])
    end else if z=2 then begin
      Qsc[Qss]:=Qsc[Qss]+1;
      if Qsc[Qss]<=Qsm[Qss] then begin QKeyAt(Qss,Qsc[Qss]); Qcoc:=0 end
      else begin Qcoc:=1; writeln('FIND QNext END') end
    end else if z=3 then begin
      Qsc[Qss]:=Qsc[Qss]-1;
      if Qsc[Qss]>=1 then begin
        QKeyAt(Qss,Qsc[Qss]); Qcoc:=0 end else Qcoc:=1
    end else if z=4 then begin
      Qsc[Qss]:=Qsm[Qss];
      if Qsc[Qss]>=1 then begin
        QKeyAt(Qss,Qsc[Qss]); Qcoc:=0 end else Qcoc:=1
    end else if z=5 then begin
      Qss:=QFindSet(Qx1[Qpc]); if Qss=0 then Qss:=1;
      if Qbf[(Qcurbuf-1)*8+8]<>'      ' then begin
        Qck:=Qbf[(Qcurbuf-1)*8+8]; QNumKey; Qcoc:=0
      end else Qcoc:=1;
      writeln('FIND OWNER ',Qsn[Qss],' Qkey=',Qck)
    end else if z=6 then begin
      Qss:=QFindSet(Qx1[Qpc]); if Qss=0 then Qss:=1;
      Qck:=Qbf[(Qcurbuf-1)*8+8]; QNumKey; QLoadRec(1)
    end else if z=7 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qcurbuf:=bno; QLoadRec(bno)
    end else if z=8 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qbv[bno]:=Qbf[(Qcurbuf-1)*8+6]
    end else if z=9 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qbf[(Qcurbuf-1)*8+6]:=Qbv[bno]; QSaveRec(Qcurbuf)
    end else if z=20 then QPrintLit(Qx1[Qpc])
    else if z=21 then begin
      bno:=ord(Qx1[Qpc][1])-48; wn:=ord(Qx2[Qpc][1])-48;
      if (bno>=1) and (bno<=8) and (wn>=1) and (wn<=8) then
        write(Qbf[(bno-1)*8+wn])
    end else if z=22 then writeln
    else if z=13 then begin if Qcoc=0 then QJumpTo(Qx1[Qpc]) end
    else if z=14 then begin if Qcoc<>0 then QJumpTo(Qx1[Qpc]) end
    else if z=15 then begin
      if Qcoc=0 then QJumpTo(Qx1[Qpc]) else QJumpTo(Qx2[Qpc])
    end else if z=16 then begin
      if Qcoc<>0 then QJumpTo(Qx1[Qpc]) else QJumpTo(Qx2[Qpc])
    end else if z=18 then Qpc:=Qnm+1
    else if z=23 then QJumpTo(Qx1[Qpc]);
    Qpc:=Qpc+1
  end;
  writeln('MAD FULL EX=',QEXN)
end;

procedure QMADX(N:integer);
var i:integer;
begin
  QbufMode:=true;
  Qblen:=BUF.LEN;
  if Qblen<1 then Qblen:=1;
  if Qblen>120 then Qblen:=120;
  for i:=1 to Qblen do Qbm[i]:=BUF.M[i];
  Qbm[Qblen+1]:='#';
  Qbp:=1;
  QReadMad2;
  QMadExec2;
  QbufMode:=false
end;

procedure PUTT;
begin writeln end;
procedure PUTPT;
begin writeln end;
procedure WДAT(var F:text; D:integer);
begin write(F,D) end;
procedure GETT;
begin KYДA:='HAЧAЛO'; ДИР:='KOH   ' end;
procedure GETHAЧ;
begin HAЧ:=false end;
procedure GETD(var F:text);
begin end;
procedure YCTMOД;
begin end;
procedure ECTЬ;
begin end;
procedure ПЗГ;
begin end;
procedure SETFLAG;
begin end;
procedure ЖYPHAЛ(A:alfa; P:integer);
begin end;
procedure ZKOHEЦ(P:integer);
begin end;
procedure MENU;
begin end;
procedure WCTP(var F:text; S:alfa; N:integer);
begin write(F,S) end;
procedure STOP;
begin end;
function RЦEЛ(A,B:integer):integer;
begin RЦEЛ:=0 end;
function RДAT(A,B:integer):integer;
begin RДAT:=A end;
function ДATЧИC(A,B,C:integer):integer;
begin ДATЧИC:=A end;

procedure ОUТ;
begin end;
procedure ЕХIТ;
begin end;
procedure Ц;
begin end;
procedure FСВЯ;
begin end;
procedure FСОРУ;
begin end;
procedure МЕТАЛ;
begin end;
procedure ИНВ;
begin end;
procedure Ц1;
begin end;
procedure ШИФР;
begin end;
procedure ГРУППА;
begin end;
procedure ВОС;
begin end;
procedure КАП;
begin end;
procedure RСТР;
begin end;
procedure ПАР;
begin end;
procedure Т;
begin end;
procedure ТОЛЬКОСИ;
begin end;
procedure ВЫП;
begin end;
procedure ОЗАРП;
begin end;
procedure ДЗАРП;
begin end;
procedure КОМАН;
begin end;
procedure СПЕЦ;
begin end;
procedure АМОР;
begin end;
procedure СТОР;
begin end;
procedure ПОСН;
begin end;
procedure ПТРЕС;
begin end;
procedure ПРБК;
begin end;
procedure ОВЫШ;
begin end;
procedure ОГОС;
begin end;
procedure НЕПЛ;
begin end;
procedure ИСПОЛН;
begin end;
procedure СLF;
begin end;
procedure ЗАТ;
begin end;
procedure NЕХТРАR;
begin end;
procedure RЕАDСОN;
begin end;
procedure МЕС;
begin end;
procedure NАМ;
begin end;
procedure WRЕАL;
begin end;
procedure ПРОЧ;
begin end;
procedure НАКЛ;
begin end;
procedure ЗАНАК;
begin end;
procedure ЗАРП;
begin end;
procedure WМЕС;
begin end;
procedure УРОВ;
begin end;
procedure ТЕМА;
begin end;
procedure ЭТАП;
begin end;
procedure АТХ;
begin end;
procedure СR;
begin end;
procedure ZNАК;
begin end;
procedure РUТР;
begin end;
function ЕЩЕ(S:alfa):boolean;
begin ЕЩЕ:=false end;
function ОЦЕНЕНО:boolean;
begin ОЦЕНЕНО:=false end;
function ЕСТЬВЗЯЛ:boolean;
begin ЕСТЬВЗЯЛ:=false end;
function ЭТОТМЕС:boolean;
begin ЭТОТМЕС:=false end;
function ЕСТЬЗАТ:boolean;
begin ЕСТЬЗАТ:=false end;
function RОТД:alfa;
begin RОТД:='      ' end;
procedure FПАР(S:alfa);
begin end;
procedure WLF(N:integer);
begin end;
procedure WВL(N:integer);
begin end;
procedure МINUSЕS;
begin end;
procedure FWRIТЕ(var F:text);
begin end;
procedure УСТПЕЧ;
begin end;
procedure RЕSЕТСОN;
begin end;
procedure RЕSЕТРАR;
begin end;
procedure СLЕАNСОN;
begin end;
procedure ПЕЧКОЭФ;
begin end;
procedure РЕGIS;
begin end;
procedure WТRЕЕ;
begin end;
function RВЕЩ(A,B:real):real;
begin RВЕЩ:=A end;
procedure DmlCallA(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    150: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    151: begin
      BUF.LEN:=67;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='H';
      BUF.M[9]:='B';BUF.M[10]:=';';BUF.M[11]:=' ';BUF.M[12]:='H';
      BUF.M[13]:='A';BUF.M[14]:='Й';BUF.M[15]:='T';BUF.M[16]:='И';
      BUF.M[17]:=' ';BUF.M[18]:='B';BUF.M[19]:='Л';BUF.M[20]:='A';
      BUF.M[21]:='Д';BUF.M[22]:='E';BUF.M[23]:='Л';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='П';BUF.M[28]:='P';
      BUF.M[29]:='-';BUF.M[30]:='И';BUF.M[31]:='H';BUF.M[32]:='B';
      BUF.M[33]:=';';BUF.M[34]:='B';BUF.M[35]:='З';BUF.M[36]:='Я';
      BUF.M[37]:='T';BUF.M[38]:='Ь';BUF.M[39]:=';';BUF.M[40]:=' ';
      BUF.M[41]:='H';BUF.M[42]:='A';BUF.M[43]:='Й';BUF.M[44]:='T';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:='Л';
      BUF.M[49]:='A';BUF.M[50]:='Д';BUF.M[51]:='E';BUF.M[52]:='Л';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:=' ';BUF.M[56]:='Ш';
      BUF.M[57]:='И';BUF.M[58]:='-';BUF.M[59]:='П';BUF.M[60]:='P';
      BUF.M[61]:='И';BUF.M[62]:=';';BUF.M[63]:='B';BUF.M[64]:='З';
      BUF.M[65]:='Я';BUF.M[66]:='T';BUF.M[67]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    152: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='O';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    153: begin
      BUF.LEN:=113;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='M';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='O';
      BUF.M[21]:='Д';BUF.M[22]:=';';BUF.M[23]:=' ';BUF.M[24]:=' ';
      BUF.M[25]:=' ';BUF.M[26]:='B';BUF.M[27]:='З';BUF.M[28]:='Я';
      BUF.M[29]:='T';BUF.M[30]:='Ь';BUF.M[31]:=' ';BUF.M[32]:='M';
      BUF.M[33]:='E';BUF.M[34]:='T';BUF.M[35]:='A';BUF.M[36]:='Л';
      BUF.M[37]:='.';BUF.M[38]:='H';BUF.M[39]:='A';BUF.M[40]:='З';
      BUF.M[41]:='B';BUF.M[42]:=' ';BUF.M[43]:='H';BUF.M[44]:='A';
      BUF.M[45]:=' ';BUF.M[46]:='Д';BUF.M[47]:='P';BUF.M[48]:='!';
      BUF.M[49]:='.';BUF.M[50]:='H';BUF.M[51]:='A';BUF.M[52]:='З';
      BUF.M[53]:='B';BUF.M[54]:=';';BUF.M[55]:=' ';BUF.M[56]:=' ';
      BUF.M[57]:=' ';BUF.M[58]:='B';BUF.M[59]:='З';BUF.M[60]:='Я';
      BUF.M[61]:='T';BUF.M[62]:='Ь';BUF.M[63]:=' ';BUF.M[64]:='C';
      BUF.M[65]:='O';BUF.M[66]:='Д';BUF.M[67]:='E';BUF.M[68]:='P';
      BUF.M[69]:='Ж';BUF.M[70]:='.';BUF.M[71]:='K';BUF.M[72]:='O';
      BUF.M[73]:='Л';BUF.M[74]:='И';BUF.M[75]:='Ч';BUF.M[76]:=' ';
      BUF.M[77]:='H';BUF.M[78]:='A';BUF.M[79]:=' ';BUF.M[80]:='Д';
      BUF.M[81]:='P';BUF.M[82]:='!';BUF.M[83]:='.';BUF.M[84]:='K';
      BUF.M[85]:='O';BUF.M[86]:='Л';BUF.M[87]:='И';BUF.M[88]:='Ч';
      BUF.M[89]:=';';BUF.M[90]:=' ';BUF.M[91]:=' ';BUF.M[92]:=' ';
      BUF.M[93]:='H';BUF.M[94]:='A';BUF.M[95]:='Й';BUF.M[96]:='T';
      BUF.M[97]:='И';BUF.M[98]:=' ';BUF.M[99]:='C';BUF.M[100]:='Л';
      BUF.M[101]:='E';BUF.M[102]:='Д';BUF.M[103]:='Y';BUF.M[104]:='Ю';
      BUF.M[105]:=' ';BUF.M[106]:='B';BUF.M[107]:=' ';BUF.M[108]:='П';
      BUF.M[109]:='P';BUF.M[110]:='-';BUF.M[111]:='C';BUF.M[112]:='O';
      BUF.M[113]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallB(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    154: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='E';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    155: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    156: begin
      BUF.LEN:=30;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Д';BUF.M[15]:='P';BUF.M[16]:='!';
      BUF.M[17]:='.';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:='З';
      BUF.M[21]:='B';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='M';
      BUF.M[29]:='E';BUF.M[30]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    157: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='O';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='P';
      BUF.M[13]:='Ж';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallC(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    158: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    159: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='T';BUF.M[27]:='O';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    160: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    161: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallD(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    162: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    163: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    164: begin
      BUF.LEN:=71;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='H';
      BUF.M[9]:='B';BUF.M[10]:='.';BUF.M[11]:='H';BUF.M[12]:='O';
      BUF.M[13]:='M';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:=' ';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:=' ';BUF.M[20]:='F';
      BUF.M[21]:='I';BUF.M[22]:='R';BUF.M[23]:='S';BUF.M[24]:='T';
      BUF.M[25]:=';';BUF.M[26]:=' ';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Й';BUF.M[30]:='T';BUF.M[31]:='И';BUF.M[32]:=' ';
      BUF.M[33]:='П';BUF.M[34]:='O';BUF.M[35]:='C';BUF.M[36]:='Л';
      BUF.M[37]:='E';BUF.M[38]:='Д';BUF.M[39]:=' ';BUF.M[40]:='B';
      BUF.M[41]:=' ';BUF.M[42]:='S';BUF.M[43]:='Y';BUF.M[44]:='-';
      BUF.M[45]:='И';BUF.M[46]:='H';BUF.M[47]:='B';BUF.M[48]:=';';
      BUF.M[49]:='B';BUF.M[50]:='З';BUF.M[51]:='Я';BUF.M[52]:='T';
      BUF.M[53]:='Ь';BUF.M[54]:=' ';BUF.M[55]:='И';BUF.M[56]:='H';
      BUF.M[57]:='B';BUF.M[58]:='.';BUF.M[59]:='H';BUF.M[60]:='O';
      BUF.M[61]:='M';BUF.M[62]:='E';BUF.M[63]:='P';BUF.M[64]:=' ';
      BUF.M[65]:='H';BUF.M[66]:='A';BUF.M[67]:=' ';BUF.M[68]:='L';
      BUF.M[69]:='A';BUF.M[70]:='S';BUF.M[71]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    165: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallE(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    166: begin
      BUF.LEN:=28;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';BUF.M[19]:=' ';BUF.M[20]:='И';
      BUF.M[21]:='H';BUF.M[22]:='B';BUF.M[23]:='.';BUF.M[24]:='H';
      BUF.M[25]:='O';BUF.M[26]:='M';BUF.M[27]:='E';BUF.M[28]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    167: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    168: begin
      BUF.LEN:=18;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';BUF.M[12]:='Д';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    169: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallF(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    170: begin
      BUF.LEN:=32;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ш';BUF.M[15]:='И';BUF.M[16]:='Ф';
      BUF.M[17]:='P';BUF.M[18]:='.';BUF.M[19]:='H';BUF.M[20]:='O';
      BUF.M[21]:='M';BUF.M[22]:='E';BUF.M[23]:='P';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='S';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='Ш';BUF.M[31]:='И';BUF.M[32]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    171: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='Ш';
      BUF.M[9]:='И';BUF.M[10]:='Ф';BUF.M[11]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    172: begin
      BUF.LEN:=37;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';BUF.M[11]:='Б';BUF.M[12]:='O';
      BUF.M[13]:='P';BUF.M[14]:=';';BUF.M[15]:='П';BUF.M[16]:='O';
      BUF.M[17]:='C';BUF.M[18]:='T';BUF.M[19]:='A';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='И';BUF.M[23]:='H';BUF.M[24]:='B';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='C';BUF.M[34]:='T';BUF.M[35]:='O';BUF.M[36]:='И';
      BUF.M[37]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    173: begin
      BUF.LEN:=23;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';BUF.M[11]:=';';BUF.M[12]:='П';
      BUF.M[13]:='O';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='A';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:='И';BUF.M[23]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallG(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    174: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    175: begin
      BUF.LEN:=23;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';BUF.M[11]:=';';BUF.M[12]:='П';
      BUF.M[13]:='O';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='A';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:='И';BUF.M[23]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    176: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='И';BUF.M[6]:='H';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    177: begin
      BUF.LEN:=10;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallH(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    178: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='П';BUF.M[6]:='P';BUF.M[7]:='-';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    179: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='П';BUF.M[6]:='P';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='O';BUF.M[10]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    180: begin
      BUF.LEN:=13;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';BUF.M[11]:='Б';BUF.M[12]:='O';
      BUF.M[13]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    181: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='Ш';BUF.M[6]:='И';BUF.M[7]:='-';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallI(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    182: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='Ш';
      BUF.M[9]:='И';BUF.M[10]:='Ф';BUF.M[11]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    183: begin
      BUF.LEN:=55;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='T';
      BUF.M[49]:='O';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    184: begin
      BUF.LEN:=14;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='C';BUF.M[11]:='T';BUF.M[12]:='O';
      BUF.M[13]:='И';BUF.M[14]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    185: begin
      BUF.LEN:=55;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='T';
      BUF.M[49]:='O';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallJ(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    186: begin
      BUF.LEN:=12;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';BUF.M[11]:='И';BUF.M[12]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    187: begin
      BUF.LEN:=12;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';BUF.M[11]:='И';BUF.M[12]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    188: begin
      BUF.LEN:=40;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='H';BUF.M[15]:='O';BUF.M[16]:='B';
      BUF.M[17]:='O';BUF.M[18]:='T';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='S';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='O';BUF.M[26]:='T';BUF.M[27]:='Д';BUF.M[28]:=';';
      BUF.M[29]:='П';BUF.M[30]:='O';BUF.M[31]:='C';BUF.M[32]:='T';
      BUF.M[33]:='A';BUF.M[34]:='B';BUF.M[35]:=' ';BUF.M[36]:='C';
      BUF.M[37]:='T';BUF.M[38]:='O';BUF.M[39]:='И';BUF.M[40]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCall(N:integer);
begin
  if N<=153 then DmlCallA(N) else
  if (N>=154) and (N<=157) then DmlCallB(N) else
  if (N>=158) and (N<=161) then DmlCallC(N) else
  if (N>=162) and (N<=165) then DmlCallD(N) else
  if (N>=166) and (N<=169) then DmlCallE(N) else
  if (N>=170) and (N<=173) then DmlCallF(N) else
  if (N>=174) and (N<=177) then DmlCallG(N) else
  if (N>=178) and (N<=181) then DmlCallH(N) else
  if (N>=182) and (N<=185) then DmlCallI(N) else
  if N>=186 then DmlCallJ(N)
end;
(* L0 DMLCALL(150);*)
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
(* EDITOR !INCLU:ROTД*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:STEP*)



(* SECTION ? .BB *)
(*BЗЯTЬ ПPИБOP И BЛAДEЛ B SY-OTД И SY-ШИФ*)
PROCEDURE BЗЯTЬBCE;
BEGIN
DMLCALL(151);
END;



(* SECTION ? .RШ *)
PROCEDURE REGIS;
CONST
      MINИHBN=100  ; MAXИHBN=99999;
      MINШИФP=10000; MAXШИФP=110001;
      MINMEC=1;      MAXMEC=12;
      MINПPOЦ=0.01;  MAXПPOЦ=50.0;
      MINЦEHA=0.0;  MAXЦEHA=5000000.0;
VAR ДP:FILE OF RECORD HAЗB:CTPOKA;KOЛИЧ:REAL END;



(* SECTION ? .BЗЯMET *)
(*BЗЯTЬ METAЛЛЫ*)
PROCEDURE BЗЯMET;
BEGIN
DMLCALL(152);REWRITE(ДP);
WHILE MOЖHO DO BEGIN 
  DMLCALL(153);PUT(ДP) END ;
END;



(* SECTION ? .ДAЙMET *)
(*ДAЙ METAЛЛЫ*)
PROCEDURE ДAЙMET;
BEGIN
DMLCALL(154);REWRITE(ДP);
WHILE MOЖHO DO BEGIN 
  DMLCALL(155);
  WCTP(output,METAЛ.HAЗB,8);WRITE(output,':');
  ДP_.HAЗB:=METAЛ.HAЗB;
  ДP_.KOЛИЧ:=RBEЩ(0.0,9999.0);IF HAЧ THEN EXIT;
  IF ДP_.KOЛИЧ>0.00000001 THEN PUT(ДP) END ;
END;



(* SECTION ? .ПOCMET *)
(*ПOCTAB METAЛЫ*)
PROCEDURE ПOCMET;
BEGIN
RESET(ДP);
WHILE NOT EOF(ДP) DO BEGIN 
  DMLCALL(156);
  COДEPЖ.KOЛИЧ:=ДP_.KOЛИЧ;
  DMLCALL(157);GET(ДP) END ;
END;



(* SECTION ? .WMET *)
(*ПEЧATЬ METAЛOB*)
PROCEDURE WMET;
VAR I:INT;
BEGIN
RESET(ДP);I:=0;
IF EOF(ДP) THEN EXIT;
WHILE NOT EOF(ДP) DO BEGIN 
  IF (I MOD 4)=0 THEN WRITE(output,'       ');
  I:=I+1;WCTP(output,ДP_.HAЗB,6);
  WRITE(output,'=',ДP_.KOЛИЧ:25);
  IF (I MOD 4)=0 THEN PUTT ELSE WRITE(output,'  ');
  GET(ДP) END ;
IF (I MOD 4)<>0 THEN PUTT;
END;



(* SECTION ? .WCTO *)
PROCEDURE WCTO;
BEGIN
  WRITE(output,'       OTДEЛ=',OTДEЛ.HAЗB);
  IF CTOИT.ПPИHЯЛ<>0 THEN WRITE(output,' ПPИ=',CTOИT.ПPИHЯЛ:2);
  IF CTOИT.CПИCAЛ<>0 THEN WRITE(output,' CПИ=',CTOИT.CПИCAЛ:2);
  PUTT;
END;



(* SECTION ? .WC *)
(*BЫBOД "CTOИT ПO OTДEЛAM"*)
PROCEDURE WCTOИT;
BEGIN
DMLCALL(158);
WHILE MOЖHO DO BEGIN 
  DMLCALL(159);
  WCTO;
  DMLCALL(160); END ;
END;



(* SECTION ? .WK *)
(*BЫBOД ПPИБOPA*)
PROCEDURE WKAPT;
BEGIN
WITH ПPИБOP DO BEGIN 
WRITE(output,ИHB.HOMEP:5,') Ш=',ШИФP.HOMEP:6,
          ' Ц=',ЦEHA:6:22,' !B=',BOC:5:22,' !K=',KAП:5:22,' ');
WCTP(output,HAЗB,0);PUTT;WMET;
 END END;



(* SECTION ? .KAPTA *)
FUNCTION KAPTA:BOOL;
BEGIN
KAPTA:=FALSE;
WRITE(output,'ИHBEHTAPHЫЙ HOMEP KAPTЫ:');
ИHB.HOMEP:=RЦEЛ(MINИHBN,MAXИHBN);
IF HAЧ THEN EXIT;
DMLCALL(161);
IF ПYCTO THEN BEGIN 
  WRITE(output,'HET KAPTЫ C TAKИM ИHB.N');PUTT;EXIT END ;
BЗЯTЬBCE;BЗЯMET;
WRITE(output,'BOT ЭTA KAPTA:');PUTT;WKAPT;WCTOИT;
KAPTA:=TRUE;
END;



(* SECTION ? .ИHB *)
FUNCTION ИHBHOM:BOOL;
BEGIN
ИHBHOM:=FALSE;
REPEAT
WRITE(output,'HOBЫЙ ИHBEHTAPHЫЙ HOMEP:');
ИHB.HOMEP:=RЦEЛ(MINИHBN,MAXИHBN);IF HAЧ THEN EXIT;
DMLCALL(162);
IF MOЖHO THEN BEGIN WRITE(output,
  'KAPTA C TAKИM ИHB.N YЖE ЗAPEГИCTPИPOBAHA,');PUTT END ;
UNTIL ПYCTO;
ИHBHOM:=TRUE;
END;




(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR N,FIRST,LAST:INT;
BEGIN
DMLCALL(163);
IF ПYCTO THEN BEGIN WRITE(output,'HET KAPT');PUTT;EXIT END ;
DMLCALL(164);
WRITE(output,'C KAKOГO HOMEPA HAЧATЬ ПPOCMOTP (',FIRST:0,'-',LAST:0,'):');
N:=RЦEЛ(FIRST,LAST);IF HAЧ THEN EXIT;
(**)
IF N < (LAST-FIRST) DIV 2 THEN BEGIN 
  DMLCALL(165);
  WHILE ИHB.HOMEP<N DO BEGIN 
    DMLCALL(166); END  END 
ELSE BEGIN 
  DMLCALL(167);
  WHILE ИHB.HOMEP>N DO BEGIN 
    DMLCALL(168); END  END ;
ШAГ:=1;
REPEAT
  BЗЯTЬBCE;BЗЯMET;
  WKAPT;WCTOИT;DMLCALL(169);
UNTIL STEP OR ПYCTO;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
BEGIN
WITH ПPИБOP DO REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(output,'ШИФP OБOPYДOBAHИЯ:');
ШИФP.HOMEP:=RЦEЛ(MINШИФP,MAXШИФP);IF HAЧ THEN EXIT;
(**)
WRITE(output,'HAИMEHOBAHИE:');RCTP;IF HAЧ THEN EXIT;
READ(input,HAЗB);
(**)
WRITE(output,'ЦEHA:');
ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA);IF HAЧ THEN EXIT;
(**)
WRITE(output,'ECTЬ ЛИ ДPAГ.METAЛЛЫ!');
IF ДA AND NOT HAЧ THEN ДAЙMET ELSE REWRITE(ДP);
IF HAЧ THEN EXIT;
(**)
WRITE(output,'! HA BOCCTAHOBЛEHИE:');
BOC:=RBEЩ(MINПPOЦ,MAXПPOЦ);IF HAЧ THEN EXIT;
(**)
WRITE(output,'! HA KAП.PEMOHT:');
KAП:=RBEЩ(0.0,MAXПPOЦ);IF HAЧ THEN EXIT;
(**)
WRITE(output,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
(**)
WRITE(output,'MECЯЦ ПPИOБPETEHИЯ:');
CTOИT.ПPИHЯЛ:=RЦEЛ(MINMEC,MAXMEC);IF HAЧ THEN EXIT;
(**)
CTOИT.CПИCAЛ:=0;
(**)
WRITE(output,'BOT, ЧTO BЫ BBEЛИ:');PUTT;WKAPT;WCTO;
WRITE(output,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(170);
  IF ПYCTO THEN BEGIN DMLCALL(171); END ;
  DMLCALL(172);ПOCMET;
  YCTMOД;
  WRITE(output,'KAPTA ЗAPEГИCTPИPOBAHA') END 
ELSE WRITE(output,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .KOП *)
PROCEDURE KOП;
BEGIN
IF NOT KAPTA THEN EXIT;
REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(output,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
(**)
WRITE(output,'MECЯЦ ПPИOБPETEHИЯ:');
CTOИT.ПPИHЯЛ:=RЦEЛ(MINMEC,MAXMEC);
IF HAЧ THEN EXIT;
(**)
CTOИT.CПИCAЛ:=0;
(**)
WRITE(output,'BOT, ЧTO ПOЛYЧИЛOCЬ:');PUTT;WKAPT;WCTO;
WRITE(output,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(173);YCTMOД;
  WRITE(output,'KAPTA ЗAPEГИCTPИPOBAHA') END 
ELSE WRITE(output,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .ПOB *)
PROCEDURE ПOB;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(174);
IF CTOИT.CПИCAЛ<>0 THEN BEGIN WRITE(output,
  'ПOBTOPЯTЬ MOЖHO TOЛЬKO HИ PAЗY HE CПИC');
  PUTT;EXIT END ;
REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(output,'BOT, ЧTO ПOЛYЧИЛOCЬ:');PUTT;WKAPT;WCTO;
WRITE(output,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(175);YCTMOД;
  WRITE(output,'KAPTA ЗAPEГИCTPИPOBAHA') END 
ELSE WRITE(output,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
VAR OTД:ALFA;DEL:BOOL;
PROCEDURE YHAP(I:INT);EXTERNAL;
FUNCTION COUNT(I:INT):INT;EXTERNAL;
BEGIN
IF NOT KAPTA THEN EXIT;
WRITE(output,'ПOДTBEPДИTE EE ИCKЛЮЧEHИE:');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(176);DMLCALL(177);
  IF COUNT(DMLCALL(178);)=0 THEN BEGIN 
    DMLCALL(179);DMLCALL(180); END ;
  IF COUNT(DMLCALL(181);)=0 THEN BEGIN DMLCALL(182); END ;
  YCTMOД;WRITE(output,'KAPTA AHYЛИPOBAHA') END 
ELSE WRITE(output,'KAPTA OCTABЛEHA');PUTT;
END;



(* SECTION ? .CПИ *)
PROCEDURE CПИ;
VAR N:INT;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(183);
IF CTOИT.CПИCAЛ<>0 THEN BEGIN 
  WRITE(output,'ЭTO HAИMEHOBAHИE YЖE CПИCAHO');PUTT;EXIT END ;
(**)
WRITE(output,'MECЯЦ CПИCAHИЯ:');
N:=CTOИT.ПPИHЯЛ;IF N=0 THEN N:=MINMEC;
CTOИT.CПИCAЛ:=RЦEЛ(N,MAXMEC);
IF HAЧ THEN EXIT;
(**)
WRITE(output,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WCTO;
WRITE(output,'ПOДTBEPДИTE CПИCAHИE');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'CПИCAHИE OTMEHЯETCЯ');PUTT;EXIT END ;
DMLCALL(184);YCTMOД;ECTЬ;
END;



(* SECTION ? .ПEP *)
PROCEDURE ПEP;
VAR N,KYП,ПPOД,MECПEP:INT;HOBOT:ALFA;HECTOЯЛ:BOOL;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(185);
IF CTOИT.CПИCAЛ<>0 THEN BEGIN 
  WRITE(output,'ЭTO HAИMEHOBAHИE YЖE CПИCAHO');PUTT;EXIT END ;
(**)
WRITE(output,'HAЗBAHИE OTДEЛA:');HOBOT:=ROTД;IF HAЧ THEN EXIT;
IF HOBOT=OTДEЛ.HAЗB THEN BEGIN 
  WRITE(output,'ЭTO HAИMEHOBAHИE YЖE ЧИCЛИTCЯ B ЭTOM O');
  PUTT;EXIT END ;
WRITE(output,'MECЯЦ ПEPEДAЧИ:');
N:=CTOИT.ПPИHЯЛ;IF N=0 THEN N:=MINMEC;
MECПEP:=RЦEЛ(N+1,MAXMEC);
IF HAЧ THEN EXIT;
(**)
IF MECПEP=1 THEN CTOИT.CПИCAЛ:=12
            ELSE CTOИT.CПИCAЛ:=MECПEP-1;
HECTOЯЛ:=CTOИT.ПPИHЯЛ>CTOИT.CПИCAЛ;
WRITE(output,'CПИCAH:');WCTO;
KYП:=CTOИT.ПPИHЯЛ;ПPOД:=CTOИT.CПИCAЛ;
CTOИT.ПPИHЯЛ:=MECПEP;CTOИT.CПИCAЛ:=0;OTДEЛ.HAЗB:=HOBOT;
WRITE(output,'ПPИHЯT:');WCTO;
IF HECTOЯЛ THEN BEGIN WRITE(output,
  'ПEPEДAЮЩИЙ OTДEЛ БYДET ИCKЛЮЧEH И');
  PUTT END ;
WRITE(output,'ПOДTBEPДИTE ПEPEBOД');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'ПEPEBOД OTMEHЯETCЯ');PUTT;EXIT END ;
CTOИT.ПPИHЯЛ:=KYП;CTOИT.CПИCAЛ:=ПPOД;
IF HECTOЯЛ THEN BEGIN DMLCALL(186); END 
           ELSE BEGIN DMLCALL(187); END ;
CTOИT.ПPИHЯЛ:=MECПEP;CTOИT.CПИCAЛ:=0;
DMLCALL(188);YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(output,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KAPT...');PUTT;
KYДA:='HAPYЖY';
DMLCALL(1);WRITE(output,'PEЖИM: ');PUTT; WHILE FALSE DO BEGIN 
WRITE(output,'ПPO - ПPOCMOTP XPAHЯЩИXCЯ KAPT/',
          'HOB - BBOД HOBЫX KAPT/',
          'ПOB - ПOBTOPEHИE KAPTЫ B OTДEЛE/',
          'KOП - KOПИPOBAHИE KAPTЫ ИЗ OTДEЛA B OT',
          'ИCK - ИCKЛЮЧEHИE KAPT/',
          'ПEP - ПEPEДAЧA HAИM.B ДPYГOЙ OTДEЛ/',
          'CПИ - CПИCAHИE HAИMEHOBAHИЙ/');
MENU; ДИP:='KOH   ';
IF (ДИP='ПPO   ') THEN BEGIN ПPO END ELSE IF (ДИP='ПOB   ') THEN BEGIN ПOB END ELSE IF (ДИP='KOП   ') THEN BEGIN KOП END ELSE IF (ДИP='ПEP   ') THEN BEGIN ПEP END ELSE IF (ДИP='HOB   ') THEN BEGIN HOB END ELSE IF (ДИP='ИCK   ') THEN BEGIN ИCK END ELSE IF (ДИP='CПИ   ') THEN BEGIN CПИ END ELSE IF (ДИP='KOH   ') THEN BEGIN EXIT END ELSE IF (ДИP='BЫX   ') THEN BEGIN EXIT END );
END;



(* SECTION ? .B *)
BEGIN REGIS END.