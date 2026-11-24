(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOMON(output,BUF,BDVECT,BDERRN,input); (*AM:MOHИTOP *)
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
procedure DmlCall(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
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
  QMADX(0)
end;
(* L0 DMLCALL(134);*)
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
DMLCALL(135);
END;



(* SECTION ? .ПPABA *)
(*ПPOBEPKA ПPAB ПOЛЬЗOBATEЛЯ*)
PROCEDURE ПPABA;
VAR ПPOB:ZZSYSTEM;
BEGIN
DMLCALL(136);PUTT;YCTФЛAГ;
WRITE(output,'         ДAHHЫE OT ');WДAT(output,SYSTEM.ДATЗП);
IF OTЛAД IN ФЛAГИ THEN BEGIN 
  ФЛAГИ:=ФЛAГИ+[AДMИH];CEГOДHЯ:=SYSTEM.ДATЗП+1 END 
ELSE BEGIN 
PUTT;PUTT;
WRITE(output,'       ...ЗДPABCTBYЙTE...');PUTT;
WRITE(output,'BЫ - AДMИHИCTPATOP!');
IF ДA THEN BEGIN 
  WRITE(output,'ПOДTBEPДИTE ПAPOЛЬ:');GETT;
  READ(input,ПPOB.ПAPOЛЬ);
  IF SYSTEM.ПAPOЛЬ=ПPOB.ПAPOЛЬ THEN BEGIN 
    WRITE(output,'BЫ ДEЙCTBИTEЛЬHO AДMИHИCTPATOP');PUTT;
    WRITE(output,'BAM OTKPЫTЫ ПPABA HA ИЗMEHEHИE ДAHHЫX');PUTT;
    ФЛAГИ:=ФЛAГИ+[AДMИH] END 
  ELSE BEGIN 
    WRITE(output,'HE ЗHAETE ПAPOЛЯ - HE БAЛYЙTECЬ');PUTT END  END ;
IF NOT (AДMИH IN ФЛAГИ) THEN BEGIN 
  WRITE(output,'BЫ - ПOЛЬЗOBATEЛЬ');PUTT;
  WRITE(output,'BAM MOЖHO TOЛЬKO BЫДABATЬ OTЧETЫ');PUTT END ;
(**)
WRITE(output,'COOБЩИTE CEГOДHЯШHЮЮ ДATY:');
CEГOДHЯ:=RДAT(SYSTEM.ДATЗП,ДATЧИC(31,12,99)) END ;
END;



(* SECTION ? .ПAPOЛЬ *)
(*ИЗMEHEHИE ПAPOЛЯ*)
PROCEDURE ПAPOЛЬ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN EXIT;
WRITE(output,'COOБЩИTE HOBЫЙ ПAPOЛЬ:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(input,SYSTEM.ПAPOЛЬ);YCTMOД;
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
WRITE(output,'TEKYЩEE COCTOЯHИE ФЛAГOB:');PUTT;
FOR Ф:=SUCC(ФS) TO PRED(ФF) DO BEGIN 
  WRITE(output,ORD(Ф):0,'.',Ф,' ');
  IF Ф IN ФЛAГИ THEN WRITE(output,'(+)')
                ELSE WRITE(output,'(-)');
  PUTT END ;
WRITE(output,'YKAЖИTE HOMEP ИHBEPTИPYEMOГO ФЛAГA:');
N:=RЦEЛ(1,ORD(ФF)-1);IF HAЧ THEN EXIT;
Ф:=ФF;
FOR ФФ:=SUCC(ФS) TO PRED(ФF) DO IF N=ORD(ФФ) THEN Ф:=ФФ;
ФЛAГИ:=ФЛAГИ MOD [Ф];
WRITE(output,ORD(Ф):0,'.',Ф);
IF Ф IN ФЛAГИ THEN WRITE(output,' (-) --> (+)')
              ELSE WRITE(output,' (+) --> (-)');
PUTT;
END;



(* SECTION ? .БCИC *)
BEGIN
KYДA:='HAPYЖY';
IF HEЛЬЗЯ THEN EXIT;
WRITE(output,'ПAPOЛЬ:');GETT;
READ(input,OTДEЛ.HAЗB);
IF SYSTEM.ПAPCИC<>OTДEЛ.HAЗB THEN BEGIN 
  WRITE(output,'HE ЛEЗЬ, KYДA HE HYЖHO???');PUTT;EXIT END ;
PUTT;
WHILE TRUE DO BEGIN 
WRITE(output,'      ...BЫ B CИCTEMHOM БЛOKE...  ');PUTT;
WRITE(output,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/');
MENU; ДИP:='KOH   ';
IF (ДИP='BЫX   ') THEN BEGIN EXIT END ELSE IF (ДИP='KOH   ') THEN BEGIN EXIT END ELSE IF (ДИP='ФЛA   ') THEN BEGIN SETFLAG END ;
END;
END;



(* SECTION ? .B *)
BEGIN IF (KYДA='HAЧAЛO') THEN BEGIN BEGIN WRITELN;
RGEXPORT:=46;
WRITELN;PUTT;
WRITE(output,'           ******************');PUTPT;
WRITE(output,'           ИПC AMOPTИЗAЦИЯ-88');PUTPT;
WRITE(output,'           ******************');PUTPT;
WRITELN;
IF ПYCTO THEN BEGIN 
    WRITE(output,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(output,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(output,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(137);KYДA:='ЭTOBCE';EXIT END ;
  ПPABA END END ELSE IF (KYДA<>'HAPYЖY') AND (KYДA<>'HAЧAЛO') THEN EXIT ELSE (**)
(* SECTION ? .Д *)
DMLCALL(1);WRITE(output,'PEЖИM: ');PUTT; WHILE FALSE DO BEGIN 
IF ДИP<>'KOH   ' THEN BEGIN 
WRITE(output,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
WRITE(output,'KAP - BXOД B БЛOK PEГИCTPAЦИИ KAPT/',
          'ГPY - BXOД B БЛOK PEГИCTPAЦИИ ГPYПП ',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/');
MENU END ;
IF (ДИP='KAP   ') THEN BEGIN IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN BEGIN 
              KYДA:='AMOCAR';EXIT END END ELSE IF (ДИP='ГPY   ') THEN BEGIN IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN BEGIN 
              KYДA:='AMOGRU';EXIT END END ELSE IF (ДИP='OTД   ') THEN BEGIN IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN BEGIN 
              KYДA:='AMOOTD';EXIT END END ELSE IF (ДИP='OTЧ   ') THEN BEGIN IF NOT ЗAKPЫTO THEN BEGIN 
              KYДA:='AMOOTC';EXIT END END ELSE IF (ДИP='CИC   ') THEN BEGIN БЛOKCИC END ELSE IF (ДИP='ЗAK   ') THEN BEGIN ЖYPHAЛ('ЗAK   ',0) END ELSE IF (ДИP='CБP   ') THEN BEGIN ЖYPHAЛ('CБP   ',0) END ELSE IF (ДИP='ПAP   ') THEN BEGIN ПAPOЛЬ END ELSE IF (ДИP='KOH   ') THEN BEGIN BEGIN ZKOHEЦ(0);IF NOT HAЧ THEN BEGIN ДИP:='KOH   ';EXIT END END END ELSE IF (ДИP='BЫX   ') THEN BEGIN BEGIN WRITE(output,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE ');
             PUTT END END; END; END.
