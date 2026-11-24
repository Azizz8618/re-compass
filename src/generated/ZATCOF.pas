(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATCOF(output,BUF,BDVECT,BDERRN,input); (*ЗT:PEГИC.KOЭФФ*)
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
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallB(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
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
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallC(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
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
  QMADX(0)
end;
procedure DmlCall(N:integer);
begin
  if N<=260 then DmlCallA(N) else
  if (N>=261) and (N<=264) then DmlCallB(N) else
  if N>=265 then DmlCallC(N)
end;
(* L0 DMLCALL(257);*)
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
WRITE(output,ПAP.ИMЯ,':');WCTP(output,ПAP.HAЗB,32);
WRITE(output,' = ',ДEЙ.ЗH:8:23);
PUTT;
END;



(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR I,J:INT;A:ARRAY 1..100 OF ALFA;
BEGIN
FПAP('ИM-KOЭ');DMLCALL(258);
IF ПYCTO THEN BEGIN WRITE(output,'HET KAPT');PUTT;EXIT END ;
I:=0;WHILE MOЖHO DO BEGIN I:=I+1;DMLCALL(259); END ;
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
  WRITE(output,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
  IF HAЧ THEN EXIT;
  READ(input,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
  IF MOЖHO THEN BEGIN WRITE(output,'ЭTO HAЗBAHИE YЖE ЗAPEГИCTPИPOBAHO');PUTT END ;
UNTIL ПYCTO;
(**)
WRITE(output,'ПOЛHOE HAЗBAHИE:');RCTP;IF HAЧ THEN EXIT;
READ(input,ПAP.HAЗB);
(**)
WRITE(output,'ЗHAЧEHИE:');
ДEЙ.ЗH:=RBEЩ(0.0,999999.9);IF HAЧ THEN EXIT;
(**)
ПAP.COKP[1]:='_377';
(**)
WRITE(output,'BOT, ЧTO BЫ BBEЛИ:');PUTT;ПEЧKOЭФ;
WRITE(output,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(261);
  DMLCALL(262);
  YCTMOД;WRITE(output,'KAPTA ЗAPEГИCTPИPOBAHA') END 
ELSE WRITE(output,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE ! ') OR HAЧ;
END;



(* SECTION ? .ЗAM *)
PROCEDURE ЗAM;
BEGIN
WRITE(output,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(input,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
IF ПYCTO THEN BEGIN 
  WRITE(output,'TAKAЯ KAPTA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT END ;
DMLCALL(263);
WRITE(output,'BOT ЭTA KAPTA:');PUTT;ПEЧKOЭФ;
WRITE(output,'HOBOE ЗHAЧEHИE:');
ДEЙ.ЗH:=RBEЩ(0.0,999999.9);IF HAЧ THEN EXIT;
DMLCALL(264);YCTMOД;ECTЬ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
BEGIN
IF TOЛЬKOCИ THEN EXIT;
WRITE(output,'COKPAЩEHHOE HAЗBAHИE:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(input,ПAP.ИMЯ);FПAP(ПAP.ИMЯ);
IF ПYCTO THEN BEGIN 
  WRITE(output,'TAKAЯ KAPTA HE ЗAPEГИCTPИPOBAHA');PUTT;EXIT END ;
DMLCALL(265);
WRITE(output,'BOT ЭTA KAPTA:');PUTT;ПEЧKOЭФ;
WRITE(output,'ПOДTBEPДИTE ИCKЛЮЧEHИE');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'ИCKЛЮЧEHИE OTMEHЯETCЯ');PUTT;EXIT END ;
DMLCALL(266);
FПAP('ИM-KOЭ');DMLCALL(267);YCTMOД;
END;



(* SECTION ? .PKB *)
BEGIN
WRITE(output,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KOЭФФ');PUTT;
DMLCALL(1);WRITE(output,'PEЖИM: ');PUTT; WHILE FALSE DO BEGIN 
WRITE(output,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ЗAM - ЗAMEHA ЗHAЧEHИЯ KOЭФИЦИEHTA/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
MENU; ДИP:='KOH   ';
IF (ДИP='ПPO   ') THEN BEGIN ПPO END ELSE IF (ДИP='HOB   ') THEN BEGIN HOB END ELSE IF (ДИP='ЗAM   ') THEN BEGIN ЗAM END ELSE IF (ДИP='ИCK   ') THEN BEGIN ИCK END ELSE IF (ДИP='KOH   ') THEN BEGIN BEGIN KYДA:='HAPYЖY';EXIT END END ELSE IF (ДИP='BЫX   ') THEN BEGIN EXIT END ;
END;
END;



(* SECTION ? .B *)
BEGIN
PEKOЭФ;KYДA:='HAPYЖY';
END.