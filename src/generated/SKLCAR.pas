(*=y+,s0,s7*)
(*=L1*) PROGRAM SKLCAR(output,BUF,BDVECT,BDERRN,input); (*CK:KAPTЫ *)
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
    35: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    36: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='M';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    37: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='M';BUF.M[6]:='A';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='Y';BUF.M[10]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    38: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='O';BUF.M[6]:='T';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='Y';BUF.M[10]:='M';
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
    39: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='П';BUF.M[3]:=' ';BUF.M[4]:='O';
      BUF.M[5]:='T';BUF.M[6]:='Д';BUF.M[7]:='E';BUF.M[8]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    40: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    41: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='C';BUF.M[6]:='Y';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    42: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='П';BUF.M[3]:=' ';BUF.M[4]:='C';
      BUF.M[5]:='Y';BUF.M[6]:='M';BUF.M[7]:='M';BUF.M[8]:='A';
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
    43: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='З';
      BUF.M[9]:='Я';BUF.M[10]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    44: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    45: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    46: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
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
    47: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    48: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    49: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    50: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='Y';
      BUF.M[49]:='M';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
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
    51: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    52: begin
      BUF.LEN:=76;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='M';BUF.M[30]:='A';BUF.M[31]:='T';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Ч';BUF.M[38]:=';';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:='Й';BUF.M[43]:='T';BUF.M[44]:='И';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='O';BUF.M[48]:='C';
      BUF.M[49]:='Л';BUF.M[50]:='E';BUF.M[51]:='Д';BUF.M[52]:=' ';
      BUF.M[53]:='B';BUF.M[54]:=' ';BUF.M[55]:='S';BUF.M[56]:='Y';
      BUF.M[57]:='-';BUF.M[58]:='M';BUF.M[59]:='A';BUF.M[60]:='T';
      BUF.M[61]:=';';BUF.M[62]:='B';BUF.M[63]:='З';BUF.M[64]:='Я';
      BUF.M[65]:='T';BUF.M[66]:='Ь';BUF.M[67]:=' ';BUF.M[68]:='M';
      BUF.M[69]:='A';BUF.M[70]:='T';BUF.M[71]:='E';BUF.M[72]:='P';
      BUF.M[73]:='.';BUF.M[74]:='K';BUF.M[75]:='O';BUF.M[76]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    53: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    54: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
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
    55: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    56: begin
      BUF.LEN:=82;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='E';
      BUF.M[9]:='Щ';BUF.M[10]:='Ь';BUF.M[11]:='.';BUF.M[12]:='H';
      BUF.M[13]:='O';BUF.M[14]:='M';BUF.M[15]:='E';BUF.M[16]:='P';
      BUF.M[17]:=' ';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:=' ';
      BUF.M[21]:='M';BUF.M[22]:='A';BUF.M[23]:='T';BUF.M[24]:='E';
      BUF.M[25]:='P';BUF.M[26]:='.';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Ч';BUF.M[30]:=';';BUF.M[31]:=' ';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='O';BUF.M[40]:='C';
      BUF.M[41]:='Л';BUF.M[42]:='E';BUF.M[43]:='Д';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='S';BUF.M[48]:='Y';
      BUF.M[49]:='-';BUF.M[50]:='B';BUF.M[51]:='E';BUF.M[52]:='Щ';
      BUF.M[53]:=';';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='B';
      BUF.M[61]:='E';BUF.M[62]:='Щ';BUF.M[63]:='Ь';BUF.M[64]:='.';
      BUF.M[65]:='H';BUF.M[66]:='O';BUF.M[67]:='M';BUF.M[68]:='E';
      BUF.M[69]:='P';BUF.M[70]:=' ';BUF.M[71]:='H';BUF.M[72]:='A';
      BUF.M[73]:=' ';BUF.M[74]:='M';BUF.M[75]:='A';BUF.M[76]:='T';
      BUF.M[77]:='E';BUF.M[78]:='P';BUF.M[79]:='.';BUF.M[80]:='K';
      BUF.M[81]:='O';BUF.M[82]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    57: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    58: begin
      BUF.LEN:=18;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';
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
    59: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    60: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    61: begin
      BUF.LEN:=76;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='M';BUF.M[30]:='A';BUF.M[31]:='T';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Ч';BUF.M[38]:=';';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:='Й';BUF.M[43]:='T';BUF.M[44]:='И';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='O';BUF.M[48]:='C';
      BUF.M[49]:='Л';BUF.M[50]:='E';BUF.M[51]:='Д';BUF.M[52]:=' ';
      BUF.M[53]:='B';BUF.M[54]:=' ';BUF.M[55]:='S';BUF.M[56]:='Y';
      BUF.M[57]:='-';BUF.M[58]:='M';BUF.M[59]:='A';BUF.M[60]:='T';
      BUF.M[61]:=';';BUF.M[62]:='B';BUF.M[63]:='З';BUF.M[64]:='Я';
      BUF.M[65]:='T';BUF.M[66]:='Ь';BUF.M[67]:=' ';BUF.M[68]:='M';
      BUF.M[69]:='A';BUF.M[70]:='T';BUF.M[71]:='E';BUF.M[72]:='P';
      BUF.M[73]:='.';BUF.M[74]:='K';BUF.M[75]:='O';BUF.M[76]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    62: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
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
    63: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    64: begin
      BUF.LEN:=14;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='B';BUF.M[12]:='E';
      BUF.M[13]:='Щ';BUF.M[14]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    65: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Д';BUF.M[14]:='B';BUF.M[15]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    66: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Б';BUF.M[14]:='E';BUF.M[15]:='З';
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
    67: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Ц';BUF.M[14]:='E';BUF.M[15]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    68: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    69: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    70: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='E';BUF.M[12]:='Щ';
      BUF.M[13]:='Ь';
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
    71: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    72: begin
      BUF.LEN:=37;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='K';
      BUF.M[25]:='Л';BUF.M[26]:='Ю';BUF.M[27]:='Ч';BUF.M[28]:='И';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Д';BUF.M[36]:='B';
      BUF.M[37]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    73: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='З';BUF.M[12]:='Я';
      BUF.M[13]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    74: begin
      BUF.LEN:=14;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='B';BUF.M[12]:='З';
      BUF.M[13]:='Я';BUF.M[14]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallK(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    75: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='E';BUF.M[12]:='Щ';
      BUF.M[13]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    76: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    77: begin
      BUF.LEN:=37;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='K';
      BUF.M[25]:='Л';BUF.M[26]:='Ю';BUF.M[27]:='Ч';BUF.M[28]:='И';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Д';BUF.M[36]:='B';
      BUF.M[37]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    78: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallL(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    79: begin
      BUF.LEN:=43;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';BUF.M[12]:=';';
      BUF.M[13]:='И';BUF.M[14]:='C';BUF.M[15]:='K';BUF.M[16]:='Л';
      BUF.M[17]:='Ю';BUF.M[18]:='Ч';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='S';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='Б';BUF.M[26]:='E';BUF.M[27]:='З';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='K';BUF.M[31]:='Л';BUF.M[32]:='Ю';
      BUF.M[33]:='Ч';BUF.M[34]:='И';BUF.M[35]:=' ';BUF.M[36]:='B';
      BUF.M[37]:=' ';BUF.M[38]:='S';BUF.M[39]:='Y';BUF.M[40]:='-';
      BUF.M[41]:='Ц';BUF.M[42]:='E';BUF.M[43]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    80: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    81: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    82: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallM(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    83: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    84: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    85: begin
      BUF.LEN:=36;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='C';BUF.M[11]:='Y';BUF.M[12]:='M';
      BUF.M[13]:='M';BUF.M[14]:='A';BUF.M[15]:=';';BUF.M[16]:='H';
      BUF.M[17]:='A';BUF.M[18]:='Й';BUF.M[19]:='T';BUF.M[20]:='И';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Л';BUF.M[24]:='E';
      BUF.M[25]:='Д';BUF.M[26]:='Y';BUF.M[27]:='Ю';BUF.M[28]:=' ';
      BUF.M[29]:='B';BUF.M[30]:=' ';BUF.M[31]:='O';BUF.M[32]:='T';
      BUF.M[33]:='-';BUF.M[34]:='C';BUF.M[35]:='Y';BUF.M[36]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    86: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallN(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    87: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    88: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='E';
      BUF.M[9]:='Щ';BUF.M[10]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    89: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    90: begin
      BUF.LEN:=11;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCallO(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    91: begin
      BUF.LEN:=38;
      BUF.M[1]:='И';BUF.M[2]:='C';BUF.M[3]:='K';BUF.M[4]:='Л';
      BUF.M[5]:='Ю';BUF.M[6]:='Ч';BUF.M[7]:='И';BUF.M[8]:=' ';
      BUF.M[9]:='B';BUF.M[10]:=' ';BUF.M[11]:='S';BUF.M[12]:='Y';
      BUF.M[13]:='-';BUF.M[14]:='Д';BUF.M[15]:='B';BUF.M[16]:='И';
      BUF.M[17]:=';';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:='Й';
      BUF.M[21]:='T';BUF.M[22]:='И';BUF.M[23]:=' ';BUF.M[24]:='П';
      BUF.M[25]:='E';BUF.M[26]:='P';BUF.M[27]:='B';BUF.M[28]:='Y';
      BUF.M[29]:='Ю';BUF.M[30]:=' ';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='S';BUF.M[34]:='Y';BUF.M[35]:='-';BUF.M[36]:='Д';
      BUF.M[37]:='B';BUF.M[38]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    92: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    93: begin
      BUF.LEN:=37;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Д';BUF.M[14]:='B';BUF.M[15]:='И';BUF.M[16]:=';';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:='Й';BUF.M[20]:='T';
      BUF.M[21]:='И';BUF.M[22]:=' ';BUF.M[23]:='C';BUF.M[24]:='Л';
      BUF.M[25]:='E';BUF.M[26]:='Д';BUF.M[27]:='Y';BUF.M[28]:='Ю';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Б';BUF.M[36]:='E';
      BUF.M[37]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCall(N:integer);
begin
  if N<=38 then DmlCallA(N) else
  if (N>=39) and (N<=42) then DmlCallB(N) else
  if (N>=43) and (N<=46) then DmlCallC(N) else
  if (N>=47) and (N<=50) then DmlCallD(N) else
  if (N>=51) and (N<=54) then DmlCallE(N) else
  if (N>=55) and (N<=58) then DmlCallF(N) else
  if (N>=59) and (N<=62) then DmlCallG(N) else
  if (N>=63) and (N<=66) then DmlCallH(N) else
  if (N>=67) and (N<=70) then DmlCallI(N) else
  if (N>=71) and (N<=74) then DmlCallJ(N) else
  if (N>=75) and (N<=78) then DmlCallK(N) else
  if (N>=79) and (N<=82) then DmlCallL(N) else
  if (N>=83) and (N<=86) then DmlCallM(N) else
  if (N>=87) and (N<=90) then DmlCallN(N) else
  if N>=91 then DmlCallO(N)
end;
(* L0 DMLCALL(35);*)
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
(* EDITOR !INCLU:STPUT*)
(* EDITOR !INCLU:STEP*)
(* EDITOR !INCLU:FINLIN2*)
(* EDITOR !INCLU:FCBЯ*)



(* SECTION ? .RШ *)
PROCEDURE REGIS;
CONST
      MINKOЛ=0.000;  MAXKOЛ=99999.000;
      MINMEC=1;      MAXMEC=12;
      MINЦEHA=0.01;  MAXЦEHA=300000.00;



(* SECTION ? .ЦB *)
(*ИHB.HOM. INT --> REAL *)
FUNCTION ЦB(I:INT):REAL;
BEGIN ЦB:=I/1000 END;

(* SECTION ? .BЦ *)
(*ИHB.HOM. REAL --> INT *)
FUNCTION BЦ(R:REAL):INT;
BEGIN BЦ:=ROUND(R*1000) END;



(* SECTION ? .EB *)
(*OTДEЛ+BEЩЬ --> CYMMA (+BЗЯЛ, ECЛИ ECTЬ)*)
FUNCTION ECTЬBЗЯЛ:BOOL;
BEGIN
DMLCALL(36);
FCBЯ(DMLCALL(37);,DMLCALL(38);,DMLCALL(39););
FCBЯ(DMLCALL(40);,DMLCALL(41);,DMLCALL(42););
IF MOЖHO THEN BEGIN DMLCALL(43);ECTЬBЗЯЛ:=TRUE END 
         ELSE ECTЬBЗЯЛ:=FALSE;
END;



(* SECTION ? .HAЙMAT *)
(*HAЙДИ MAT ПO BEЩ*)
PROCEDURE HAЙMAT;
BEGIN
DMLCALL(44);
REPEAT
  DMLCALL(45);
  IF (BEЩЬ.HOMEP>=MATEP.HAЧ) AND (BEЩЬ.HOMEP<=MATEP.KOH) THEN EXIT;
  DMLCALL(46);
  UNTIL FALSE;
END;



(* SECTION ? .WOЦ *)
FUNCTION OЦEHEHO:BOOL;
VAR HAШЛИ:BOOL;I:INT;
BEGIN
I:=0;HAШЛИ:=FALSE;OЦEHEHO:=TRUE;ШAГ:=1;
DMLCALL(47);
(Ц) WHILE MOЖHO DO BEGIN 
  DMLCALL(48);
  IF NOT HAШЛИ THEN BEGIN 
    OЦEHEHO:=FALSE;HAШЛИ:=TRUE;
    WRITE(output,'HE OЦEHEHЫ CЛEДYЮЩИE HOMEPA:');PUTT END ;
  WRITE(output,' ',ЦB(BEЩЬ.HOMEP):9:23);I:=I+1;
  IF (I MOD 13)=0 THEN IF STPUT THEN EXIT Ц END ;
IF (I MOD 13)<>0 THEN PUTT;
END;



(* SECTION ? .WK *)
(*BЫBOД KAPTЫ*)
PROCEDURE WKAPT;
BEGIN
WITH BEЩЬ DO BEGIN 
WRITE(output,ЦB(HOMEP):9:23,') ');
WCTP(output,BEЩЬ.HAЗB,0);PUTT;
WRITE(output,'       ЦEHA=');
IF ЦEHA>0.0001 THEN WRITE(output,ЦEHA:5:22)
               ELSE WRITE(output,'!!!!!');
WRITE(output,'  OCT=',OCTAT:23,
  '   ПPИ=',ПPИXOД:23,' PAC=',PACXOД:23,'  EД=',EД[1],EД[2],'  (');
WCTP(output,MATEP.HAЗB,10);WRITE(output,')');
PUTT END ;
END;



(* SECTION ? .WP *)
PROCEDURE WPACX;
VAR I:INT;
BEGIN
I:=0;
DMLCALL(49);
WHILE MOЖHO DO BEGIN 
  I:=I+1;IF ((I-1) MOD 3)=0 THEN WRITE(output,'    ');
  DMLCALL(50);
  WRITE(output,'   ',OTДEЛ.HAЗB,'=',BЗЯЛ.KOЛИЧ:23);
  IF (I MOD 3)=0 THEN PUTT;
  DMLCALL(51); END ;
IF (I MOD 3)<>0 THEN PUTT;
END;



(* SECTION ? .KAP *)
FUNCTION KAPTA:BOOL;
BEGIN KAPTA:=FALSE;
DMLCALL(52);
WRITE(output,'HOMEHKЛATYPHЫЙ HOMEP KAPTЫ:');
BEЩЬ.HOMEP:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));
IF HAЧ THEN EXIT;
DMLCALL(53);
IF ПYCTO THEN BEGIN 
  WRITE(output,'HET KAPTЫ C TAKИM HOMEPOM');PUTT;EXIT END ;
DMLCALL(54);
WRITE(output,'BOT ЭTA KAPTA:');PUTT;WKAPT;
KAPTA:=TRUE;
END;



(* SECTION ? .ПPO *)
PROCEDURE ПPO(PACX:BOOL);
VAR N:INT;
BEGIN
DMLCALL(55);
IF ПYCTO THEN BEGIN WRITE(output,'HET KAPT');PUTT;EXIT END ;
DMLCALL(56);
WRITE(output,'C KAKOГO HOMEPA HAЧATЬ ПPOCMOTP (',
         ЦB(MATEP.HAЧ):21,'-',ЦB(MATEP.KOH):21,'):');
N:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));
IF HAЧ THEN EXIT;
DMLCALL(57);
WHILE BEЩЬ.HOMEP<N DO BEGIN 
  DMLCALL(58); END ;
ШAГ:=1;
REPEAT
  DMLCALL(59);
  WKAPT;IF PACX THEN WPACX;
  DMLCALL(60);
UNTIL STEP OR ПYCTO;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
VAR EДИЗM:ALFA;
BEGIN
WITH BEЩЬ DO REPEAT
DMLCALL(61);
REPEAT
WRITE(output,'HOMEHKЛATYPHЫЙ HOMEP:');
HOMEP:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));IF HAЧ THEN EXIT;
DMLCALL(62);
IF MOЖHO THEN BEGIN WRITE(output,
  'KAPTA C TAKИM HOMEPOM YЖE ЗAPEГИCTPИPOBAHA');PUTT END ;
UNTIL ПYCTO;
(**)
WRITE(output,'HAЗBAHИE:');RCTP;
IF HAЧ THEN EXIT;
READ(input,BEЩЬ.HAЗB);
(**)
WRITE(output,'ЦEHA ИЗBECTHA!');
IF ДA THEN BEGIN IF HAЧ THEN EXIT;
  WRITE(output,'ЦEHA:');ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA) END 
ELSE BEGIN IF HAЧ THEN EXIT;ЦEHA:=0.0 END ;
(**)
(ЦE) WHILE TRUE DO BEGIN 
WRITE(output,'EДИHИЦA ИЗMEPEHИЯ (ШT,KГ,M,M2,M3,П,Л');GETHAЧ;
IF HAЧ THEN EXIT;READ(input,EД);WRITE(output,
'ШT    KГ    M     M2    M3    П     Л     T ');
RESET(output);
WHILE NOT EOF(output) DO BEGIN 
  READ(output,EДИЗM);IF EДИЗM=EД THEN BEGIN REWRITE(output);EXIT ЦE END  END ;
REWRITE(output);
WRITE(output,'TAKOЙ EДИHИЦЫ HET, ПOBTOPИTE');PUTT END ;
(**)
WRITE(output,'ПPИXOД:');
ПPИXOД:=RBEЩ(MINKOЛ,MAXKOЛ);OCTAT:=ПPИXOД;PACXOД:=0;
IF HAЧ THEN EXIT;
(**)
HAЙMAT;DMLCALL(63);
WRITE(output,'BOT, ЧTO BЫ BBEЛИ:');PUTT;WKAPT;
WRITE(output,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(64);ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
  DMLCALL(65);
  IF BEЩЬ.ЦEHA<0.01 THEN BEGIN DMLCALL(66); END 
                    ELSE BEGIN DMLCALL(67); END ;
  YCTMOД;
  WRITE(output,'KAPTA ЗAPEГИCTPИPOBAHA') END 
ELSEWRITE(output,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ');
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
PROCEDURE YHAP(I:INT);EXTERNAL;
BEGIN
IF NOT KAPTA THEN EXIT;
WRITE(output,'ПOДTBEPДИTE EE ИCKЛЮЧEHИE:');
IF ДA AND NOT HAЧ THEN BEGIN 
  DMLCALL(68);ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
  DMLCALL(69);YCTMOД;
  WRITE(output,'KAPTA AHYЛИPOBAHA') END 
ELSE WRITE(output,'KAPTA OCTABЛEHA');PUTT;
END;



(* SECTION ? .ПPИ *)
PROCEDURE ПPИ;
VAR N:REAL;
BEGIN WITH BEЩЬ DO BEGIN 
IF NOT KAPTA THEN EXIT;
WRITE(output,'CKOЛЬKO ПPИШЛO:');
N:=RBEЩ(MINKOЛ,MAXKOЛ);ПPИXOД:=ПPИXOД+N;OCTAT:=OCTAT+N;
IF HAЧ THEN EXIT;
(**)
WRITE(output,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(output,'ПOДTBEPДИTE ПPИXOД ');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'ПPИXOД OTMEHЯETCЯ');PUTT;EXIT END ;
DMLCALL(70);ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
DMLCALL(71);
IF ПYCTO THEN BEGIN DMLCALL(72); END ;
YCTMOД;ECTЬ END ;
END;



(* SECTION ? .PAC *)
PROCEDURE PAC;
VAR N:REAL;ЗAMEHA:BOOL;
BEGIN WITH BEЩЬ DO BEGIN 
IF NOT KAPTA THEN EXIT;WPACX;
REPEAT
WRITE(output,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
WRITE(output,'CKOЛЬKO YШЛO:');
N:=RBEЩ(MINKOЛ,OCTAT);IF HAЧ THEN EXIT;
PACXOД:=PACXOД+N;OCTAT:=OCTAT-N;
(**)
ЗAMEHA:=ECTЬBЗЯЛ;
IF NOT ЗAMEHA THEN BЗЯЛ.KOЛИЧ:=0;
(**)
WRITE(output,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(output,'       ',OTДEЛ.HAЗB,
  ': ',BЗЯЛ.KOЛИЧ:23,'+',N:23,'=',BЗЯЛ.KOЛИЧ+N:23);PUTT;
WRITE(output,'ПOДTBEPДИTE PACXOД ');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'PACXOД OTMEHЯETCЯ');PUTT;EXIT END ;
BЗЯЛ.KOЛИЧ:=BЗЯЛ.KOЛИЧ+N;
IF ЗAMEHA THEN BEGIN DMLCALL(73); END 
ELSE BEGIN DMLCALL(74); END ;
ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
DMLCALL(75);
DMLCALL(76);
IF ПYCTO THEN BEGIN DMLCALL(77); END ;
YCTMOД;ECTЬ;
UNTIL NOT EЩE('EЩE!  ');
 END END;



(* SECTION ? .ЦEH *)
PROCEDURE ЦEH;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(78);
IF ПYCTO THEN BEGIN 
  WRITE(output,'ЭTO ИЗДEЛИE YЖE OЦEHEHO');PUTT;EXIT END ;
(**)
WRITE(output,'COOБЩИTE ЦEHY:');
BEЩЬ.ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA);
IF HAЧ THEN EXIT;
(**)
WRITE(output,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(output,'ПOДTBEPДИTE OЦEHKY');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'OЦEHKA OTMEHЯETCЯ');PUTT;EXIT END ;
DMLCALL(79);
YCTMOД;ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];ECTЬ;
END;



(* SECTION ? .ЧИC *)
(*ИTOГOBAЯ ЧИCTKA*)
PROCEDURE ЧИC;
PROCEDURE YHAP(I:INT);EXTERNAL;
BEGIN
IF NOT (OTЧCKЛ IN ФЛAГИ) THEN BEGIN 
  WRITE(output,'CHAЧAЛA HAДO BЫДATЬ OTЧET ПO CKЛAДY');PUTT;EXIT END ;
IF NOT (OTЧOTД IN ФЛAГИ) THEN BEGIN 
  WRITE(output,'CHAЧAЛA HAДO BЫДATЬ OTЧET ПO OTДEЛAM');PUTT;EXIT END ;
IF NOT OЦEHEHO THEN BEGIN 
  WRITE(output,'ПO ЭTИM HOMEPAM ЧИCTKA ПPOИЗBOДИTCЯ H');
  PUTT END ;
WRITE(output,'ПOДTBEPДИTE ИTOГOBYЮ ЧИCTKY');
IF NOT ДA OR HAЧ THEN BEGIN 
  WRITE(output,'ЧИCTKA OTMEHЯETCЯ');PUTT;EXIT END ;
(**)
WRITE(output,'ЖДИTE, ИДET ЧИCTKA...');PUTT;
DMLCALL(80);
WHILE MOЖHO DO BEGIN 
  DMLCALL(81);
  WHILE MOЖHO DO BEGIN 
    DMLCALL(82);
    WHILE MOЖHO DO BEGIN 
      DMLCALL(83);
      CYMMA.ЦEHA:=CYMMA.ЦEHA+BEЩЬ.ЦEHA*BЗЯЛ.KOЛИЧ;
      DMLCALL(84); END ;
    DMLCALL(85); END ;
  DMLCALL(86); END ;
(**)
DMLCALL(87);
WHILE MOЖHO DO BEGIN 
  DMLCALL(88);
  IF BEЩЬ.ЦEHA>0.001 THEN BEGIN 
    BEЩЬ.ПPИXOД:=0;BEЩЬ.PACXOД:=0;
    DMLCALL(89);DMLCALL(90); END ;
  DMLCALL(91); END ;
(**)
DMLCALL(92);
WHILE MOЖHO DO BEGIN 
  DMLCALL(93); END ;
(**)
ФЛAГИ:=ФЛAГИ-[OTЧCKЛ,OTЧOTД];
SYSTEM.ДATЧИC:=CEГOДHЯ;YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(output,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KAPT...');PUTT;
KYДA:='HAPYЖY';
DMLCALL(1);WRITE(output,'PEЖИM: ');PUTT; WHILE FALSE DO BEGIN 
WRITE(output,'ПPO - ПPOCMOTP XPAHЯЩИXCЯ KAPT/',
          'OTД - ПPOCMOTP KAPT C PACXOДOM ПO OTДEЛAM/',
          'HOB - BBOД HOBЫX KAPT/',
          'ЦEH - OЦEHKA HAИMEHOBAHИЙ/',
          'ИCK - ИCKЛЮЧEHИE KAPT/',
          'ПPИ - ПPИXOД HAИMEHOBAHИЙ/',
          'PAC - PACXOД HAИMEHOBAHИЙ/',
          'ЧИC - ИTOГOBAЯ ЧИCTKA/');
MENU; ДИP:='KOH   ';
IF (ДИP='ПPO   ') THEN BEGIN ПPO(FALSE) END ELSE IF (ДИP='OTД   ') THEN BEGIN ПPO(TRUE) END ELSE IF (ДИP='ЧИC   ') THEN BEGIN ЧИC END ELSE IF (ДИP='ЦEH   ') THEN BEGIN ЦEH END ELSE IF (ДИP='HOB   ') THEN BEGIN HOB END ELSE IF (ДИP='ИCK   ') THEN BEGIN ИCK END ELSE IF (ДИP='ПPИ   ') THEN BEGIN ПPИ END ELSE IF (ДИP='PAC   ') THEN BEGIN PAC END ELSE IF (ДИP='KOH   ') THEN BEGIN EXIT END ELSE IF (ДИP='BЫX   ') THEN BEGIN EXIT END );
END;



(* SECTION ? .B *)
BEGIN REGIS END.