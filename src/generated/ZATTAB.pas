(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATTAB(output,BUF,BDVECT,BDERRN); 
      (*ЗT:TAБЛ.ЗATPAT ЗA ПOCЛ.MECЯЦ*)
type
  alfa = packed array[1..6] of char;
  word = record case integer of
    0:(i:integer); 1:(a:alfa); 2:(c:char) end;
  TBDVec = array[0..167] of word;
  TYPEM = packed array[1..160] of char;
  ZZBUFT = record LEN,H,D,I:integer; M:TYPEM end;

  INT=integer;
  ZFLG=(FS,ПЕЧАТЬ,МОДИФ,AДMИH,OTЛAД,OTЧCKЛ,
      OTЧOTД,BXOД,FF);
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
  ZVESH=record HOMEP:integer; HAЗB:alfa; ЦEHA:real;
             OCTAT:real; ПPИXOД:real; PACXOД:real end;
  ZVZYAL=record KOЛИЧ:real end;
  ZSUM=record ЦEHA:real end;
  ZPRAVA=record ПAPOЛЬ:alfa end;
  ZPRE=record N:integer end;
  ZSETI=integer;

  ВООL=boolean;
  SТРОКА=alfa;
  СТРОКА=alfa;
  ZZОТДЕЛ=record НАЗВ:alfa end;
  ZZГРУППА=record НАЗВ:alfa; НАЧ:integer; 
      КОН:integer end;
  ZZВDКЕУ=record КЛЮЧ:alfa; ЗНАЧ:integer end;
  ДИРЕКТ=record ИМЯ:alfa; НАЗВ:alfa end;
  ZЗАТ=record МЕС:integer; НОМЕР:integer; 
      ЗН:integer end;
  ZИСПОЛН=record НОМЕР:integer; УРОВ:integer end;
  ZLINЕ=record S:integer; F:char end;
  ZСЕLL=record FRМ:char; СОN:integer end;

  TMAT=record HAЗB:alfa; HAЧ:integer; KOH:integer end;
  TSROC=record HAЗB:alfa; HAЧ:integer; KOH:integer end;
  TINV=record HOMEP:integer; N:integer end;
  TSHIF=record HOMEP:integer end;
  TMET=record HAЗB:alfa end;
  TDR=record HAЗB:alfa; KOЛИЧ:real end;
  TCONT=record KOЛИЧ:real end;
  TSTOR=record ИHB:TINV; ШИФP:TSHIF; ЦEHA:real; 
      BOC:real; KAП:real; X:integer end;
  TSTOI=record ПPИHЯЛ:integer; CПИCAЛ:integer end;
  TALF=record ЗH:alfa end;
  TDEY=record ЗH:real end;
  TCEL=record ЗH:real end;
  TFAK=record ЗATPAT:real end;
  TPAR=record COKP:alfa; HAЗB:alfa; ИMЯ:alfa end;
  TZAT=record MEC:integer; BЫП:real; OЗAPП:real; 
ДЗAPП:real; MATEP:real; KOMAH:real; CПEЦ:real; 
AMOP:real; CTOP:real; ПOCH:real; ПTPEC:real; ПPБK:real; 
      OBЫШ:real; OГOC:real; HEПЛ:real; end;
  TISP=record HOMEP:integer; УРОВ:integer end;
  TETAP=record HOMEP:integer end;
  TTEMA=record HOMEP:integer end;
  TBOS=record NAM:alfa; N:integer end;
  TBOSREC=record NAM:alfa; N:integer end;
  TCUL=record CUCX:TBOSREC; CUPX:TBOSREC end;
  TCONTENT=record NAM:alfa; ZN:real end;
  CONTENT=record NAM:alfa; ZN:real end;
  TNAKL=record MEC:integer; ЗAPП:real; ПPOЧ:real; 
      HAКЛ:real; ЗAPH:real; ЗAPПX:real; ЗAHAK:real end;
  TSETCOL=record BЫЧДEЙ:integer; CLEAN:integer; 
      CYMДEЙ:integer; ИCXДEЙ:integer end;


  STR39=packed array[1..39] of char;
  LINE=1..48;
  COLN=1..31;
  CELL=record FRM:char; TYP:integer; ZN:real; AZ:alfa end;
  TABLINE=record S:integer; F:char END;


var
  BDVECT: TBDVec;
  BDERRN: integer;
  BUF: ZZBUFT;
  C: char;

  TAB:array[1..31,1..48] of CELL;
  TOTAL:array[1..48] of LINE;
  MINLIN,MAXLIN,CURLIN:LINE;
  SCOL:record ИCXДEЙ,BЫЧДEЙ,CYMДEЙ,CLEAN:integer END;
  FORCOL:array[1..31] of TABLINE;
  FLINE:array[1..48] of integer;
  TABDESC:array[1..40] of TABLINE;
  SCREEN:integer; EXPORT:integer; PRINTCALC:boolean;
  COLNAM:array[1..31] of alfa;
  HEAD:array[1..31] of STR39;
  ЛOГ:boolean;
  R:real;
  FIRSTFL:boolean;
  INTERVAL:array[1..10] of record UP,LOW:COLN;SIZ:integer END;
  LASTINT:integer;
  ZATK:integer;
  MADST:alfa; MADAR:real;
  LINTAB:array[1..48] of integer;
  NTH:integer; NISP:integer; NZAT:integer;
  THID:array[1..6] of integer;
  ISPDI:array[1..8] of integer;
  ISPOT:array[1..8] of alfa;
  ISPEP:array[1..8] of integer;
  ZATME:array[1..12] of integer;
  ZATVL:array[1..12] of real;
  THI:integer; ISI:integer; ZTI:integer;
  CF:array[1..10] of real;
  CN:array[1..10] of alfa;
  Z1,Z2,Z3,Z4:integer;
  GL:LINE;
  SKIPFL:boolean;


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
  SТРUТ:boolean;
  SТЕР:boolean;
  NЕХТ:boolean;
  МАХШИФР:integer;
  МINШИФР:integer;
  MATEP:TMAT;
  CTOИT:TSTOI;
  ГPYППA:TSROC;
  ДEЙ:TDEY;
  ПAP:TPAR;
  ДPX:TDR;
  COДEPЖ:TCONT;
  ИHB:TINV;
  ШИФP:TSHIF;
  METAЛ:TMET;
  ПPИБOP:TSTOR;
  AЛФ:TALF;
  ЦEЛ:TCEL;
  ФAKTИЧ:TFAK;
  ЗAT:TZAT;
  ИCПOЛH:TISP;
  ЭTAП:TETAP;
  TEMA:TTEMA;
  BOSX:TBOS;
  CULX:TCUL;
  HAКЛ:TNAKL;
  EД:alfa;
  ЦX:integer;
  ДX:real;
  CX:CONTENT;
  ОЗАРП:real;
  ДЗАРП:real;
  ЗАНАК:real;
  CLF:char;
  ЗН:real;
  FОRLIN:integer;
  FIL:integer;
  ТОЛЬКОСИ:boolean;
  SETCOL:TSETCOL;
  HAЗB:alfa;
  ЦЕНА:real;
  ПРИХОД:real;
  ОСТАТ:real;
  РАСХОД:real;

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
  if (t='      ') then begin Qpc:=Qnm+1; exit end;
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
(* W7-SCHEMA: real KOMPAS MAD set names/prefixes from 
      tests/deck08/09.b6. *)
procedure W7InitSets;
begin if Qns>0 then exit; Qns:=8;
  Qsn[1]:='SY-ПAP';Qsp[1]:='PA    ';
  Qsn[2]:='ПA-ДEЙ';Qsp[2]:='P1    ';
  Qsn[3]:='SY-HAK';Qsp[3]:='HA    ';
  Qsn[4]:='SY-TEM';Qsp[4]:='AC    ';
  Qsn[5]:='TE-ИCП';Qsp[5]:='B1    ';
  Qsn[6]:='ИC-ЗAT';Qsp[6]:='A1    ';
  Qsn[7]:='ЭT-ЗAT';Qsp[7]:='A2    ';
  Qsn[8]:='OT-ИCП';Qsp[8]:='B2    ';
end;
procedure QLoadRec(bno:integer);
var k:integer;
begin
  QClrErr; getd(Qck,Qv8);
  if BDERRN<>0 then Qcoc:=1 else begin
    Qcoc:=0;
    for k:=1 to 8 do begin Qw.i:=Qv8[k]; 
      Qbf[(bno-1)*8+k]:=Qw.a end
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
      if Qtok='B     ' then QNext;  (* B = 'in' before a 
      set name. *)
      Qx1[Qnm]:=Qtok
    end else if Qtok='BЗЯTЬ ' then begin
      QNext;
      if Qtok[1]='Б' then begin Qo2[Qnm]:=8; QNext; 
      Qx1[Qnm]:=Qtok end
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
                (Qtok='ПOДCXE') or (Qtok='ДЛЯ-BЫ') 
      then begin
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
      if Qsc[Qss]<=Qsm[Qss] then begin QKeyAt(Qss,Qsc[Qss]);
      Qcoc:=0 end
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
  BDERRN:=0; writeln('MAD FULL EX=',QEXN)
end;

procedure QMADX(N:integer);
var i:integer;
begin
  W7InitSets;
  QbufMode:=true;
  Qblen:=BUF.LEN;
  if Qblen<1 then Qblen:=1;
  if Qblen>120 then Qblen:=120;
  for i:=1 to Qblen do Qbm[i]:=BUF.M[i];
  Qbm[Qblen+1]:='#';
  Qbp:=1; Qns:=0;
  QReadMad2;
  if Qns=0 then begin
    Qns:=1; Qsn[1]:='SY    '; Qsp[1]:='SY    ';
    Qsc[1]:=0; Qsm[1]:=0
  end;
  Qss:=1;
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
procedure Ц1;
begin end;
procedure КАП;
begin end;
procedure RСТР;
begin end;
procedure Т;
begin end;
procedure МЕС;
begin end;
procedure NАМ;
begin end;
procedure ПРОЧ;
begin end;
procedure ЗАРП;
begin end;
procedure УРОВ;
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
var K:integer;
begin for K:=1 to N do WRITELN end;
procedure WВL(N:integer);
begin end;
procedure МINUSЕS;
begin WRITE(output,'-------------------------');WRITELN end;
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
function CONFIRM:boolean;
begin CONFIRM:=false end;
function NEXTCON:boolean;
begin NEXTCON:=false end;
function NEXTPAR:boolean;
begin NEXTPAR:=false end;
procedure LOADLIST(S:alfa);
begin end;
procedure FINDLIST(S:alfa);
begin end;
procedure FINDPAR(S:alfa);
begin end;
procedure CLEANALL;
begin end;
procedure HAЙTИ;
begin end;
procedure WRITELIST;
begin end;
procedure WМЕС(var F:text; N:integer);
begin WRITE(F,N) end;
procedure WRЕАL(A:real; N:integer);
var K:integer;
begin K:=ROUND(A*100);WRITE(output,K div 100,'.',K mod 100) end;
procedure RЕАDСОN(var N:boolean);
begin N:=false end;
procedure NЕWСОNТ(var C:CONTENT);
begin end;
procedure INPUTCON;
begin end;
procedure ИCK;
begin end;
procedure НOB;
begin end;
procedure ПOCTAB;
begin end;
procedure BЗЯTЬ;
begin end;
procedure ИCKЛЮЧEHИE;
begin end;

procedure APPLYMAD(N:integer);
var K:integer; FND:boolean;
begin
  BDERRN:=0;
  IF N=328 THEN begin
    FND:=false;
    for K:=1 to 8 do if MADST=CN[K] then begin CF[K]:=MADAR;
      FND:=true end;
    ДEЙ.ЗH:=MADAR
  end else
  IF N=329 THEN begin
    R:=CF[2];
    for K:=1 to 8 do if MADST=CN[K] then R:=CF[K]
  end else
  IF N=330 THEN begin TEMA.HOMEP:=THID[THI]; MOЖHO:=true; 
      ZTI:=1 end else
  IF N=331 THEN begin ISI:=1; MOЖHO:=ISI<=NISP end else
  IF N=332 THEN begin
    OTДEЛ.HAЗB:=ISPOT[ISI]; ИCПOЛH.HOMEP:=ISPDI[ISI];
    ЭTAП.HOMEP:=ISPEP[ISI];
    ZTI:=1; MOЖHO:=ZTI<=NZAT
  end else
  IF N=333 THEN begin
    ЗAT.MEC:=ZATME[ZTI]; ЗAT.BЫП:=100.0+ZTI*10;
    ЗAT.OЗAPП:=90.0+ZTI*9; ЗAT.ДЗAPП:=20.0+ZTI;
    ЗAT.MATEP:=30.0+ZTI*2; ЗAT.KOMAH:=15.0+ZTI;
    ЗAT.CПEЦ:=12.0+ZTI; ЗAT.AMOP:=8.0+ZTI;
    ЗAT.CTOP:=6.0+ZTI; ЗAT.ПOCH:=7.0+ZTI;
    ЗAT.ПTPEC:=4.0+ZTI; ЗAT.ПPБK:=3.0+ZTI;
    ЗAT.OBЫШ:=2.0+ZTI; ЗAT.OГOC:=1.0+ZTI;
    ЗAT.HEПЛ:=1.5+ZTI; MOЖHO:=true
  end else
  IF N=334 THEN begin ЭTAП.HOMEP:=ISPEP[ISI]; 
      MOЖHO:=true end else
  IF N=335 THEN begin
    OTДEЛ.HAЗB:=ISPOT[ISI]; ИCПOЛH.HOMEP:=ISPDI[ISI]; 
      MOЖHO:=true
  end else
  IF N=336 THEN begin ZTI:=ZTI+1; MOЖHO:=ZTI<=NZAT end else
  IF N=337 THEN begin ISI:=ISI+1; MOЖHO:=ISI<=NISP end else
  IF N=338 THEN begin
    HAКЛ.MEC:=3; HAКЛ.ЗAPП:=1000.0; HAКЛ.ПPOЧ:=100.0;
    HAКЛ.HAКЛ:=200.0; HAКЛ.ЗAPH:=150.0; 
      HAКЛ.ЗAHAK:=150.0;
    ПYCTO:=false
  end else
  IF N=339 THEN begin ПYCTO:=false end else
  IF N=340 THEN begin THI:=1; TEMA.HOMEP:=THID[THI]; 
      ПYCTO:=false end else
  IF N=341 THEN begin ISI:=1; MOЖHO:=ISI<=NISP end else
  IF N=342 THEN begin
    FND:=false;
    for K:=1 to NZAT do if ZATME[K]=HAКЛ.MEC then begin 
      ZTI:=K; FND:=true end;
    IF FND THEN ПYCTO:=false ELSE ПYCTO:=true
  end else
  IF (N=343) OR (N=344) OR (N=345) THEN begin
    ISI:=ISI+1; MOЖHO:=ISI<=NISP;
    IF (N=344) OR (N=345) THEN begin
      THI:=THI+1;
      IF THI<=NTH THEN TEMA.HOMEP:=THID[THI];
      ПYCTO:=THI>NTH
    end
  end
end;


procedure DmlCallA(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    1: begin
      BUF.LEN:=20;
      BUF.M[1]:='Ж';BUF.M[2]:='Y';BUF.M[3]:='P';BUF.M[4]:='H';
      BUF.M[5]:='A';BUF.M[6]:='Л';BUF.M[7]:=' ';BUF.M[8]:='Ж';
      BUF.M[9]:='Y';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';BUF.M[14]:=';';BUF.M[15]:='K';BUF.M[16]:='O';
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';
      BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    327: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    328: begin
      BUF.LEN:=52;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:=' ';BUF.M[18]:='S';BUF.M[19]:='Y';BUF.M[20]:='-';
      BUF.M[21]:='П';BUF.M[22]:='A';BUF.M[23]:='P';
      BUF.M[24]:=';';
      BUF.M[25]:='H';BUF.M[26]:='A';BUF.M[27]:='Й';
      BUF.M[28]:='T';
      BUF.M[29]:='И';BUF.M[30]:=' ';BUF.M[31]:='П';
      BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='B';BUF.M[35]:='Y';
      BUF.M[36]:='Ю';
      BUF.M[37]:=' ';BUF.M[38]:='B';BUF.M[39]:=' ';
      BUF.M[40]:='П';
      BUF.M[41]:='A';BUF.M[42]:='-';BUF.M[43]:='Д';
      BUF.M[44]:='E';
      BUF.M[45]:='Й';BUF.M[46]:=';';BUF.M[47]:='З';
      BUF.M[48]:='A';
      BUF.M[49]:='M';BUF.M[50]:='E';BUF.M[51]:='H';
      BUF.M[52]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    329: begin
      BUF.LEN:=39;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';
      BUF.M[16]:='П';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='Д';
      BUF.M[20]:='E';
      BUF.M[21]:='Й';BUF.M[22]:=';';BUF.M[23]:='B';
      BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[28]:=' ';
      BUF.M[29]:='Д';BUF.M[30]:='E';BUF.M[31]:='Й';
      BUF.M[32]:='.';
      BUF.M[33]:='З';BUF.M[34]:='H';BUF.M[35]:=' ';
      BUF.M[36]:='H';
      BUF.M[37]:='A';BUF.M[38]:=' ';BUF.M[39]:='R';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0);
  if (N>=327) and (N<=345) then APPLYMAD(N)
end;
procedure DmlCallB(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    330: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='T';BUF.M[8]:='E';
      BUF.M[9]:='M';BUF.M[10]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    331: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    332: begin
      BUF.LEN:=36;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';
      BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='O';BUF.M[15]:='-';
      BUF.M[16]:='K';
      BUF.M[17]:='Л';BUF.M[18]:='Ю';BUF.M[19]:=' ';
      BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:='K';BUF.M[23]:='Л';
      BUF.M[24]:='.';
      BUF.M[25]:='M';BUF.M[26]:='E';BUF.M[27]:='C';BUF.M[28]:=' ';
      BUF.M[29]:='B';BUF.M[30]:=' ';BUF.M[31]:='И';
      BUF.M[32]:='C';
      BUF.M[33]:='-';BUF.M[34]:='З';BUF.M[35]:='A';
      BUF.M[36]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    333: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0);
  if (N>=327) and (N<=345) then APPLYMAD(N)
end;
procedure DmlCallC(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    334: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';
      BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';
      BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';
      BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';
      BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    335: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';
      BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:='П';BUF.M[22]:=';';BUF.M[23]:='B';
      BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    336: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';
      BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';
      BUF.M[16]:='И';
      BUF.M[17]:='C';BUF.M[18]:='-';BUF.M[19]:='З';
      BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    337: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0);
  if (N>=327) and (N<=345) then APPLYMAD(N)
end;
procedure DmlCallD(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    338: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';
      BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='H';BUF.M[20]:='A';
      BUF.M[21]:='K';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    339: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    340: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    341: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0);
  if (N>=327) and (N<=345) then APPLYMAD(N)
end;
procedure DmlCallE(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
  case N of
    342: begin
      BUF.LEN:=30;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='H';BUF.M[15]:='A';BUF.M[16]:='K';
      BUF.M[17]:='Л';BUF.M[18]:='.';BUF.M[19]:='M';
      BUF.M[20]:='E';
      BUF.M[21]:='C';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='И';BUF.M[26]:='C';BUF.M[27]:='-';
      BUF.M[28]:='З';
      BUF.M[29]:='A';BUF.M[30]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    343: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    344: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    345: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0);
  if (N>=327) and (N<=345) then APPLYMAD(N)
end;
procedure DmlCall(N:integer);
begin
  if N<=329 then DmlCallA(N) else
  if (N>=330) and (N<=333) then DmlCallB(N) else
  if (N>=334) and (N<=337) then DmlCallC(N) else
  if (N>=338) and (N<=341) then DmlCallD(N) else
  if N>=342 then DmlCallE(N)
end;

function BIT(N:integer):integer;
var K,V:integer;
begin
  V:=1;
  for K:=1 to N do V:=V*2;
  BIT:=V
end;

procedure SETON(var M:integer; N:integer);
begin M:=M+BIT(N) end;

function INSET(M,N:integer):boolean;
begin INSET:=((M div BIT(N)) mod 2)=1 end;

procedure NEWLINE;
begin WRITELN end;

procedure SETAZ(var CL:CELL; S:alfa);
begin CL.AZ:=S end;

procedure INITDATA;
begin
  NTH:=2; NISP:=3; NZAT:=4;
  THID[1]:=101; THID[2]:=102;
  ISPDI[1]:=11; ISPDI[2]:=12; ISPDI[3]:=13;
  ISPOT[1]:='OTD1  '; ISPOT[2]:='OTD2  '; ISPOT[3]:='OTD3  ';
  ISPEP[1]:=1; ISPEP[2]:=2; ISPEP[3]:=3;
  ZATME[1]:=3; ZATME[2]:=3; ZATME[3]:=3; ZATME[4]:=3;
  ZATVL[1]:=100.0; ZATVL[2]:=200.0; ZATVL[3]:=150.0; 
      ZATVL[4]:=50.0;
  CN[1]:='ZKCC  '; CN[2]:='ZKПPOЧ'; CN[3]:='ZKHAKЛ';
  CN[4]:='ZKЗAPH'; CN[5]:='ZKЭФЗ '; CN[6]:='ZKФPEЗ';
  CN[7]:='ZKФMП '; CN[8]:='ZKФHT ';
  CF[1]:=0.14; CF[2]:=0.10; CF[3]:=0.20; CF[4]:=0.15;
  CF[5]:=0.3747; CF[6]:=0.10; CF[7]:=0.6584; CF[8]:=0.2416;
  Z1:=0; Z2:=0; Z3:=0; Z4:=0;
  COLNAM[1]:='ZTEMA ';
COLNAM[2]:='ZMEC  ';
COLNAM[3]:='ZOTД  ';
COLNAM[4]:='ZNOTД ';
COLNAM[5]:='ZЭTAП ';
COLNAM[6]:='ZBЫП  ';
COLNAM[7]:='ZOЗAPП';
COLNAM[8]:='ZДЗAPП';
COLNAM[9]:='VЗAPП ';
COLNAM[10]:='VCTPAX';
COLNAM[11]:='ZMATEP';
COLNAM[12]:='ZKOMAH';
COLNAM[13]:='ZCПEЦ ';
COLNAM[14]:='ZAMOP ';
COLNAM[15]:='ZCTOP ';
COLNAM[16]:='VПPOЧ ';
COLNAM[17]:='VHAKЛ ';
COLNAM[18]:='VЗAPH ';
COLNAM[19]:='VCБC  ';
COLNAM[20]:='VЭФЗ  ';
COLNAM[21]:='ZПOCH ';
COLNAM[22]:='ZПTPEC';
COLNAM[23]:='ZПPБK ';
COLNAM[24]:='VPACЧ ';
COLNAM[25]:='ZOBЫШ ';
COLNAM[26]:='ZOГOC ';
COLNAM[27]:='ZHEПЛ ';
COLNAM[28]:='VOCT  ';
COLNAM[29]:='VФPEЗ ';
COLNAM[30]:='VФMП  ';
COLNAM[31]:='VФHTCP';
end;

procedure INITTAB;
var C:COLN;
begin
  PRINTCALC:=TRUE;
  SCOL.ИCXДEЙ:=0; SCOL.BЫЧДEЙ:=0;
  SCOL.CYMДEЙ:=0; SCOL.CLEAN:=0;
  SETON(SCOL.ИCXДEЙ,6); SETON(SCOL.ИCXДEЙ,7);
  SETON(SCOL.ИCXДEЙ,8); SETON(SCOL.ИCXДEЙ,11);
  SETON(SCOL.ИCXДEЙ,12); SETON(SCOL.ИCXДEЙ,13);
  SETON(SCOL.ИCXДEЙ,14); SETON(SCOL.ИCXДEЙ,15);
  SETON(SCOL.ИCXДEЙ,21); SETON(SCOL.ИCXДEЙ,22);
  SETON(SCOL.ИCXДEЙ,23); SETON(SCOL.ИCXДEЙ,25);
  SETON(SCOL.ИCXДEЙ,26); SETON(SCOL.ИCXДEЙ,27);
  SETON(SCOL.BЫЧДEЙ,16); SETON(SCOL.BЫЧДEЙ,17);
  SETON(SCOL.BЫЧДEЙ,18); SETON(SCOL.BЫЧДEЙ,9);
  SETON(SCOL.BЫЧДEЙ,10); SETON(SCOL.BЫЧДEЙ,19);
  SETON(SCOL.BЫЧДEЙ,24); SETON(SCOL.BЫЧДEЙ,20);
  SETON(SCOL.BЫЧДEЙ,28); SETON(SCOL.BЫЧДEЙ,29);
  SETON(SCOL.BЫЧДEЙ,30); SETON(SCOL.BЫЧДEЙ,31);
  SCOL.CYMДEЙ:=SCOL.ИCXДEЙ+SCOL.BЫЧДEЙ;
  for C:=1 to 31 do SETON(SCOL.CLEAN,C)
end;

procedure WCOL(C:COLN);
begin WRITE(output,COLNAM[C],'[',C,']') end;

procedure TPUT(M:integer);
begin WRITELN end;

procedure FILL(TT:integer; CC:COLN; LL:LINE; FF:char);
begin
  TAB[CC,LL].FRM:=FF;TAB[CC,LL].TYP:=TT;
  IF (TT=1) OR (TT=6) OR (TT=7) OR (TT=8) THEN TAB[CC,
      LL].ZN:=ЦEЛ.ЗH
  ELSE IF TT=2 THEN TAB[CC,LL].ZN:=ДEЙ.ЗH
  ELSE IF TT=3 THEN SETAZ(TAB[CC,LL],AЛФ.ЗH)
  ELSE IF TT=4 THEN TAB[CC,LL].ZN:=0
  ELSE IF TT=5 THEN BEGIN IF ЛOГ THEN TAB[CC,LL].ZN:=1 
      ELSE TAB[CC,LL].ZN:=0 END 
end;

procedure PДEЙ(A:alfa; I:REAL);
begin MADST:=A; MADAR:=I; DMLCALL(328); end;

procedure BЫЧKOЭФ;
var OБЩЗAPП:REAL;
begin
  WITH HAKЛ DO BEGIN OБЩЗAPП:=ЗAPП;
  PДEЙ('ZKПPOЧ',ПPOЧ/OБЩЗAPП);
  PДEЙ('ZKHAKЛ',HAКЛ/OБЩЗAPП);
  PДEЙ('ZKЗAPH',ЗAHAK/OБЩЗAPП) END ;
end;

procedure MUL(CR:COLN; A:alfa);
var L:LINE;
begin
  MADST:=A; FПАР(A); DMLCALL(329);
  FOR L:=MINLIN TO MAXLIN DO
    TAB[CR,L].ZN:=TAB[CR,L].ZN*R;
  IF PRINTCALC THEN BEGIN WCOL(CR);WRITE(output,' * ',A,'(',
      R,') --> ');WCOL(CR);NEWLINE END ;
END;

procedure MOV(CR:COLN; ZNAK:CHAR; SC:integer);
var C:COLN; L:LINE;
begin
  IF PRINTCALC THEN BEGIN FIRSTFL:=TRUE;WCOL(CR);
      WRITE(output,' ',ZNAK) END ;
  FOR L:=MINLIN TO MAXLIN DO
    FOR C:=1 TO 31 DO IF INSET(SC,C) THEN BEGIN 
      IF PRINTCALC AND (L=MINLIN) THEN BEGIN 
        IF FIRSTFL THEN FIRSTFL:=FALSE ELSE WRITE(output,
      ' ',ZNAK);
        WCOL(C);WRITE(output,CLF) END ;
      IF ZNAK='+' THEN TAB[CR,L].ZN:=TAB[CR,L].ZN+TAB[C,L].ZN
      ELSE TAB[CR,L].ZN:=TAB[CR,L].ZN-TAB[C,L].ZN END ;
  IF PRINTCALC THEN BEGIN WRITE(output,' --> ');WCOL(CR);
      NEWLINE END ;
END;

procedure SUM(LR,LASTOT:LINE; NNEEWW:BOOL);
var C:COLN; NT:LINE;
begin
  FOR C:=1 TO 31 DO IF INSET(SCOL.CYMДEЙ,C) THEN BEGIN 
    IF NNEEWW THEN BEGIN ДEЙ.ЗH:=0.0;FILL(2,C,LR,'Ц') END ;
    FOR NT:=1 TO LASTOT DO
      TAB[C,LR].ZN:=TAB[C,LR].ZN+TAB[C,TOTAL[NT]].ZN END ;
  IF NNEEWW THEN BEGIN 
    SETON(FLINE[LR],1);SETON(FLINE[LR],2);SETON(FLINE[LR],4);
    AЛФ.ЗH:='ИTOГO ';FILL(3,1,LR,'П');
    AЛФ.ЗH:='      ';FILL(3,2,LR,'Ц');
    AЛФ.ЗH:='      ';FILL(3,4,LR,'Ц');
    AЛФ.ЗH:='      ';FILL(3,3,LR,'Ц');
    AЛФ.ЗH:='      ';FILL(3,5,LR,'Ц') END 
END;

procedure CLEAN(FIRL,MAXL:LINE);
var C:COLN; L:LINE;
begin
  FOR C:=1 TO 31 DO IF INSET(SCOL.CLEAN,C) THEN
    FOR L:=FIRL TO MAXL DO BEGIN 
      TAB[C,L].TYP:=0;TAB[C,L].ZN:=0.0 END 
END;

procedure Z(JUNC:INT;C:COLN;N:STR39;S:INT);
var I:INT;
begin
  FOR I:=1 TO 39 DO HEAD[C][I]:=N[I];
  HEAD[C][39]:=N[39];
  FORCOL[C].S:=S;
  FILL(4,C,GL,'Ц');
  TAB[C,GL].ZN:=C
end;

procedure ЗAПШAП;
var C:COLN;
begin
  GL:=1;FLINE[GL]:=1+2+4;
Z( 0,1   ,'HOMEP^KAЛЬK^TEMЫ                       ', 7);
             (*                       XXXXXXX             *)
Z( 1,2    ,'MECЯЦ^ГOД                              ', 5);
             (*             XX.XX                         *)
Z(99,3    ,'OTДEЛ                                  ', 6);
             (*             XXXXXX                        *)
Z(99,4   ,'N                                      ', 1);
             (*             X                             *)
Z(99,5   ,'ЭTAП                                   ', 4);
             (*             XXXXXX                        *)
Z( 2,6    ,'BЫПOЛH^ПO^TEME                         ', 6);
             (*                       XXXXXX              *)
Z( 3,7  ,'ЗAPПЛ^OCH^ИCП                          ', 6);
             (*                 XXXXX.XX                  *)
Z( 4,8  ,'ДOПOЛH^ЗAPПЛ^OCH^ИCП                   ', 6);
             (*                     XXXX.XX               *)
Z(99,9   ,'CYMMAP^ЗAPПЛ^OCH^ИCП                   ', 6);
             (*                    XXXXX.XX               *)
Z( 5,10  ,'OTЧ HA^COЦ^CTPAX                       ', 6);
             (*   0.14*(П3+П4)      XXXX.XX               *)
Z( 6,11  ,'MATEP                                  ', 6);
             (*             XXXXX.XX                      *)
Z( 7,12  ,'KOMAHД                                 ', 6);
             (*                 XXX.XX                    *)
Z( 8,13   ,'CПEЦ^OБOP                              ', 5);
             (*                    XXXXX                  *)
Z( 9,14   ,'AMOPT^HA^BOCCT                         ', 5);
             (*                  XXXXX                    *)
Z(10,15   ,'OПЛ^PAБOT^CTOP^OPГ                     ', 5);
             (*                         XXXXX             *)
Z(11,16   ,'ПPOЧИE^ПPЯMЫE^ЗATP                     ', 6);
             (* (П3+П4)*ZKПPOЧ         XXX.XX             *)
Z(12,17   ,'HAKЛ^PACX                              ', 6);
             (* (П3+П4)*ZKHAKЛ      XXXXX.XX              *)
Z(13,18   ,'ЗAPПЛ^HAKЛ                             ', 6);
             (* (П3+П4)*ZKЗAPH       XXXX.XX              *)
Z(14,19    ,'ИTOГO^C/CTOИM                          ', 6);
             (*   CYMMA(П3..П12)   XXXXX.XX               *)
Z(15,20    ,'ЭKOHOMИЯ^ФOHДA^ЗAPПЛ                   ', 7);
             (*   0.3747(П2-П10)-П3-П4-П13  XXXXX.XX      *)
Z(16,21   ,'ПЛAT^ЗA^OCH^ФOHД                       ', 4);
             (*                            XXXX           *)
Z(17,22  ,'ПЛA^ЗA^TPY^PEC                         ', 3);
             (*                             XXX           *)
Z(18,23   ,'ПP^ЗA^БAH^KP                           ', 3);
             (*                              XXX          *)
Z(19,24   ,'PACЧETH^ПPИБЫЛЬ                        ', 7);
             (*   П2-CYMMA(П14..П18)         XXXXX.XX     *)
Z(20,25   ,'OTЧ^B^BЫШ^OPГ                          ', 4);
             (*                            XXXX           *)
Z(21,26   ,'OTЧ^B^ГOC^BTЧ^MEC                      ', 3);
             (*                                XXX        *)
Z(22,27   ,'CAЛЬДO^HEПЛ^ДOX И^PACX                 ', 6);
             (*                              XXX.XX       *)
Z(23,28    ,'OCTATOЧH^ПPИБЫЛЬ                       ', 7);
             (*   П19-П20-П21-П22        XXXXX.XX         *)
Z(24,29   ,'ФИHAHC^PEЗEPB                          ', 7);
             (*   0.1*П23                XXXXX.XX         *)
Z(25,30    ,'ФMП                                    ', 7);
             (*   0.6584*П23             XXXXX.XX         *)
Z(26,31  ,'ФHTCP                                  ', 7);
             (*   0.2416*П23             XXXXX.XX         *)
  GL:=GL+1;FLINE[GL]:=1+4;
  FOR C:=1 TO 31 DO BEGIN 
    ЦEЛ.ЗH:=C;FILL(1,C,GL,'Ц') END ;
  CURLIN:=GL;MINLIN:=GL+1;MAXLIN:=CURLIN;
END;

procedure ЗAПTEM;
var C:COLN; L,NT:LINE; Z5,Z6:integer;
BEGIN
  DMLCALL(330);
  L:=CURLIN+1;NT:=1;
  DMLCALL(331);
  FOR Z5:=1 TO 5 DO BEGIN 
    DMLCALL(332);
    FOR Z6:=1 TO 5 DO BEGIN 
      DMLCALL(333);
      IF ЗAT.MEC<>HAКЛ.MEC THEN SKIPFL:=true ELSE 
      SKIPFL:=false;
      IF NOT SKIPFL THEN BEGIN 
        DMLCALL(334);
        FLINE[L]:=1;TOTAL[NT]:=L;
        DMLCALL(335);
        ЦEЛ.ЗH:=TEMA.HOMEP;FILL(1,1,L,'Ц');
        ЦEЛ.ЗH:=HAКЛ.MEC;FILL(7,2,L,'Ц');
        AЛФ.ЗH:=OTДEЛ.HAЗB;FILL(3,3,L,'Ц');
        ЦEЛ.ЗH:=ИCПOЛH.HOMEP;FILL(1,4,L,'Ц');
        ЦEЛ.ЗH:=ЭTAП.HOMEP;FILL(1,5,L,'Ц');
        (**)
        WITH ДEЙ DO BEGIN WITH ЗAT DO BEGIN 
      ЗH:=BЫП    ;FILL(2, 6    ,L,'Ц');
      ЗH:=OЗAPП  ;FILL(2, 7  ,L,'Ц');
      ЗH:=ДЗAPП  ;FILL(2, 8  ,L,'Ц');
      ЗH:=MATEP  ;FILL(2, 11  ,L,'Ц');
      ЗH:=KOMAH  ;FILL(2, 12  ,L,'Ц');
      ЗH:=CПEЦ   ;FILL(2, 13   ,L,'Ц');
      ЗH:=AMOP   ;FILL(2, 14   ,L,'Ц');
      ЗH:=CTOP   ;FILL(2, 15   ,L,'Ц');
      ЗH:=ПOCH   ;FILL(2, 21   ,L,'Ц');
      ЗH:=ПTPEC  ;FILL(2, 22  ,L,'Ц');
      ЗH:=ПPБK   ;FILL(2, 23   ,L,'Ц');
      ЗH:=OBЫШ   ;FILL(2, 25   ,L,'Ц');
      ЗH:=OГOC   ;FILL(2, 26   ,L,'Ц');
      ЗH:=HEПЛ   ;FILL(2, 27   ,L,'Ц') END ; END ;
        (**)
        FOR C:=1 TO 31 DO IF INSET(SCOL.BЫЧДEЙ,C) THEN BEGIN 
          ДEЙ.ЗH:=0.0;FILL(2,C,L,'Ц') END ;
        (**)
        L:=L+1;NT:=NT+1;
        DMLCALL(336); END  END ;
    DMLCALL(337); END;
  SUM(L,NT-1,TRUE);CURLIN:=L;MAXLIN:=CURLIN;
END;

procedure BЫЧTEM;
procedure MINUS;
begin IF PRINTCALC THEN MINUSES END;
begin
  IF PRINTCALC THEN WLF(3);
  MINUS;MOV(9,'+',BIT(7) + BIT(8));
  MINUS;MOV(10,'+',BIT(9));MUL(10,'ZKCC  ');
  MINUS;MOV(16,'+',BIT(9));MUL(16,'ZKПPOЧ');
  MINUS;MOV(17,'+',BIT(9));MUL(17,'ZKHAKЛ');
  MINUS;MOV(18 ,'+',BIT(9));MUL(18 ,'ZKЗAPH');
  MINUS;MOV(19,'+',BIT(9) + BIT(10) + BIT(11) + BIT(12) + 
      BIT(13) + BIT(14) + BIT(15) + BIT(16) + BIT(17));
  MINUS;MOV(20,'+',BIT(6));
  MOV(20,'-',BIT(15));MUL(20,'ZKЭФЗ ');MOV(20,'-',BIT(9) 
      + BIT(18));
  MINUS;MOV(24,'+',BIT(6));MOV(24,'-',BIT(19) + BIT(20) + 
      BIT(21) + BIT(22) + BIT(23));
  MINUS;MOV(28,'+',BIT(24));MOV(28,'-',BIT(25) + BIT(26) + 
      BIT(27));
  MINUS;MOV(29,'+',BIT(24));MUL(29,'ZKФPEЗ');
  MINUS;MOV(30,'+',BIT(24));MUL(30,'ZKФMП ');
  MINUS;MOV(31,'+',BIT(24));MUL(31,'ZKФHT ');
  MINUS;
  IF PRINTCALC THEN WLF(3);
END;

procedure DIVIDE(FCOL,LCOL:COLN);
LABEL 300;
var N:INT;C:COLN;
begin
  N:=1;C:=FCOL;
  WHILE C<LCOL DO BEGIN 
    INTERVAL[N].UP:=C;INTERVAL[N].SIZ:=1;
    FOR C:=C TO LCOL DO 
      INTERVAL[N].SIZ:=INTERVAL[N].SIZ+FORCOL[C].S+1;
    C:=LCOL;
    WHILE INTERVAL[N].SIZ>SCREEN DO BEGIN 
      INTERVAL[N].SIZ:=INTERVAL[N].SIZ-FORCOL[C].S-1;C:=C-1 END ;
    INTERVAL[N].LOW:=C;
    IF C=LCOL THEN GOTO 300;
    N:=N+1;C:=C+1 END ;
300: LASTINT:=N;
END;

procedure WSTR(var F:text; S:STR39; N:integer);
var K:integer;
begin
  for K:=1 to 39 do WRITE(F,S[K]);
end;

procedure WRITECELL(CL:CELL);
begin
  IF (CL.TYP=1) OR (CL.TYP=6) OR (CL.TYP=7) OR (CL.TYP=8) THEN
    WRITE(output,ROUND(CL.ZN))
  ELSE IF CL.TYP=2 THEN WRЕАL(CL.ZN,2)
  ELSE IF CL.TYP=3 THEN WCTP(output,CL.AZ,0)
  ELSE IF CL.TYP=4 THEN WSTR(output,HEAD[ROUND(CL.ZN)],0)
  ELSE IF CL.TYP=5 THEN BEGIN IF CL.ZN<>0 THEN WRITE(output,
      'ДA') ELSE WRITE(output,'HET') END 
end;

procedure ПEЧTAБ(FIRL,MAXL:LINE);
var C:COLN;L:LINE;I,J:INTEGER;
begin
  DIVIDE(1,19);
  FOR I:=1 TO LASTINT DO BEGIN 
    FOR L:=FIRL TO MAXL DO BEGIN 
      J:=1;
      FOR C:=INTERVAL[I].UP TO INTERVAL[I].LOW DO BEGIN 
        TABDESC[J].S:=FORCOL[C].S;
        TABDESC[J].F:=TAB[C,L].FRM;
        WRITECELL(TAB[C,L]);WRITE(output,'!');
        J:=J+1 END ;
      TABDESC[J].S:=99;
      TPUT(FLINE[L]+EXPORT) END ;
    IF EXPORT=16 THEN PUTT END 
END;

procedure ПOCЛEД;
LABEL 200,100;
var L,NT:LINE;
BEGIN
  DMLCALL(338);IF ПYCTO THEN EXIT;DMLCALL(339);BЫЧKOЭФ;
  ЗAПШAП;
  SUM(48,0,TRUE);
  DMLCALL(340);
  REPEAT
    WHILE TRUE DO BEGIN 
      IF ПYCTO THEN GOTO 200;DMLCALL(341);
      WHILE MOЖHO DO BEGIN 
        DMLCALL(342);IF NOT ПYCTO THEN GOTO 100;
        DMLCALL(343); END ;
      DMLCALL(344); END ;
100:
    ЗAПTEM;BЫЧTEM;
    IF PRINTCALC THEN ПEЧTAБ(1,MAXLIN)
                 ELSE ПEЧTAБ(MINLIN,MAXLIN);
    PRINTCALC:=FALSE;
    TOTAL[1]:=MAXLIN;SUM(48,1,FALSE);
    CLEAN(MINLIN,MAXLIN);
    CURLIN:=MINLIN-1;
    DMLCALL(345);Z3:=Z3+1;IF Z3>10 THEN GOTO 200
  UNTIL FALSE;
200:
  ПEЧTAБ(48,48);WLF(3);
  CLEAN(1,MINLIN-1);CLEAN(48,48);
END;

procedure TAБЛЗAT;
BEGIN
  DMLCALL(327);
  WRITE(output,
      'ТАБЛИЦА ЗАТРАТ ЗА МЕСЯЦ');WRITELN;
  Z1:=0;Z2:=0;Z3:=0;INITDATA;INITTAB;SCREEN:=126;EXPORT:=8;
      ПOCЛEД;ДИP:='BЫX   '
END;


BEGIN
  DMLCALL(1);
  TAБЛЗAT
END.
