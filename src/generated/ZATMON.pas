(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATMON(output,BUF,BDVECT,BDERRN,input); 
      (*ЗT:MOHИTOP*)
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
  TZAT=record MEC:integer; ЗН:real end;
  TISP=record HOMEP:integer; УРОВ:integer end;
  TETAP=record HOMEP:integer end;
  TTEMA=record HOMEP:integer end;
  TBOS=record NAM:alfa; N:integer end;
  TBOSREC=record NAM:alfa; N:integer end;
  TCUL=record CUCX:TBOSREC; CUPX:TBOSREC end;
  TCONTENT=record NAM:alfa; ZN:real end;
  CONTENT=record NAM:alfa; ZN:real end;
  TNAKL=record MEC:integer; ЗAPП:real; ПPOЧ:real; 
      HAКЛ:real; ЗAPH:real; ЗAPПX:real end;
  TSETCOL=record BЫЧДEЙ:integer; CLEAN:integer; 
      CYMДEЙ:integer; ИCXДEЙ:integer end;

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
  EF:char;
  KYДA:alfa;
  ДИP:alfa;
  W6CN:integer; W6CP:integer; W6GG:integer;  (* W6C/W7 test 
      shims *)
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
  MATEP:real;
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
  WFILE:text;
  ВЫП:real;КОМАН:real;СПЕЦ:real;АМОР:real;
СТОР:real;ПОСН:real;ПТРЕС:real;ПРБК:real;
ОВЫШ:real;ОГОС:real;НЕПЛ:real;МЕС:real;
      NАМ:real;ПРОЧ:real;ЗАРП:real;

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
    Qky:array[1..16] of alfa;
    Qnm,Qns,Qss,Qcoc,Qpc:integer;
    Qsn:array[1..8] of alfa; Qsp:array[1..8] of alfa;
    Qsc:array[1..8] of integer; Qsm:array[1..8] of integer;
    Qbf:array[1..8] of alfa;
    Qck:alfa; Qbv:array[1..8] of alfa;
    Qv8:Qv8t; Qcurbuf:integer;
    W8V:array[1..8] of integer;
    QbufMode:boolean; Qbm:array[1..120] of char;
    Qbp,Qblen:integer;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
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
(* W7-SCHEMA: MAD set names/prefixes taken from 
      tests/deck08.b6 and deck09.b6. *)
(* W7-GUARD: bound cursor loops of the test driver only. *)
function W6GUARD:boolean;
begin W6GG:=W6GG+1; W6GUARD:=(W6GG>=4) end;
procedure W7InitSets;
begin if Qns>0 then exit; Qns:=3;
  Qsn[1]:='SY-ПAP';Qsp[1]:='PA    ';
  Qsn[2]:='ПA-AЛФ';Qsp[2]:='P1    ';
  Qsn[3]:='ПA-ЦEЛ';Qsp[3]:='P2    ';
end;
procedure W8LOAD;
var W8IX:integer;
begin
  W8IX:=20270001c; QClrErr; newd('ZGEN  ',W8IX);
  pasbdi; BDERRN:=0;
  QClrErr; opend('ZGEN  ');
  writeln('W8-OPEN-BD36=',BDVECT[36].i,' EXN=',QEXN);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('AC0001',W8V);
  Qw.a:='120048'; W8V[1]:=Qw.i;
  Qw.a:='ОГИ   '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30003'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20002'; W8V[8]:=Qw.i;
  QClrErr; putd('AC0002',W8V);
  Qw.a:='121148'; W8V[1]:=Qw.i;
  Qw.a:='ОГИ   '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30004'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20003'; W8V[8]:=Qw.i;
  QClrErr; putd('AC0003',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('B10001',W8V);
  Qw.a:='120048'; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20002'; W8V[8]:=Qw.i;
  QClrErr; putd('B10002',W8V);
  Qw.a:='121148'; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20003'; W8V[8]:=Qw.i;
  QClrErr; putd('B10003',W8V);
  Qw.a:='HMOЭИ '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='      '; W8V[8]:=Qw.i;
  QClrErr; putd('B20001',W8V);
  Qw.a:='ОГИ   '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='      '; W8V[8]:=Qw.i;
  QClrErr; putd('B20002',W8V);
  Qw.a:='OМATИ '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='      '; W8V[8]:=Qw.i;
  QClrErr; putd('B20003',W8V);
  Qw.a:='CO-1  '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='000001'; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('B30001',W8V);
  Qw.a:='CO-2  '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='000002'; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20002'; W8V[8]:=Qw.i;
  QClrErr; putd('B30002',W8V);
  Qw.a:='CO-3  '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='000003'; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20002'; W8V[8]:=Qw.i;
  QClrErr; putd('B30003',W8V);
  Qw.a:='CO-4  '; W8V[1]:=Qw.i;
  Qw.a:='      '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='000004'; W8V[5]:=Qw.i;
  Qw.a:='      '; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20003'; W8V[8]:=Qw.i;
  QClrErr; putd('B30004',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('PA0001',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('P10001',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('P20001',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('ФЛAГИ ',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('ДATЗП ',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('ПAPOЛЬ',W8V);
  Qw.a:='102188'; W8V[1]:=Qw.i;
  Qw.a:='HMOЭИ '; W8V[2]:=Qw.i;
  Qw.a:='      '; W8V[3]:=Qw.i;
  Qw.a:='      '; W8V[4]:=Qw.i;
  Qw.a:='      '; W8V[5]:=Qw.i;
  Qw.a:='B30001'; W8V[6]:=Qw.i;
  Qw.a:='      '; W8V[7]:=Qw.i;
  Qw.a:='B20001'; W8V[8]:=Qw.i;
  QClrErr; putd('ПAPCИC',W8V);
  writeln('W8-LOAD-EXN=',QEXN,' KEYS=',20);
  Qsm[1]:=1; Qsc[1]:=1;
  Qsm[2]:=1; Qsc[2]:=1;
  Qsm[3]:=1; Qsc[3]:=1;
  ЦX:=1;
end;
procedure QLoadRec(bno:integer);
var k:integer;
begin
  QClrErr; getd(Qck,Qv8);
  writeln('W8-GETD KEY=',Qck,' EXN=',QEXN);
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
function QLitKey(var dest:alfa):boolean;
var c:char; n:integer;
begin
  for n:=1 to 6 do dest[n]:=' ';
  while (Qp<=72) and (Qln[Qp]=' ') do Qp:=Qp+1;
  QLitKey:=false;
  if Qp>72 then exit;
  if Qln[Qp]<>chr(39) then exit;
  Qp:=Qp+1; n:=0;
  while (Qp<=72) and (Qln[Qp]<>chr(39)) do begin
    c:=Qln[Qp];
    if n<6 then begin n:=n+1; dest[n]:=c end;
    Qp:=Qp+1
  end;
  if (Qp<=72) and (Qln[Qp]=chr(39)) then begin
    Qp:=Qp+1; QLitKey:=true
  end
end;
procedure QReadMad2;
label 2,3;
var z:integer; s:alfa; ok:boolean; Qp0:integer;
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
      Qky[Qnm]:='      ';
    if Qtok='HAЙTИ ' then begin
      QNext;
      if (Qtok[1]='П') and (Qtok[3]='-') then begin
        (* W8-BYKEY: keep the key variable and the set name 
      separately. *)
        Qo2[Qnm]:=24;
        Qp0:=Qp;
        if QLitKey(Qky[Qnm]) then begin
          (* W9A-LITERAL: explicit key, Qx1 is left untouched. *)
          QNext;
          if Qtok='B     ' then QNext;
          Qx2[Qnm]:=Qtok
        end else begin
          Qp:=Qp0;
          QNext;
          if Qtok='B     ' then begin
            Qx1[Qnm]:='      '; QNext
          end else begin
            Qx1[Qnm]:=Qtok; QNext;
            if Qtok='B     ' then QNext
          end;
          Qx2[Qnm]:=Qtok
        end
      end else begin
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
      end
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
      Qck:=Qbf[(Qcurbuf-1)*8+8]; QNumKey;
      if Qck='      ' then QKeyAt(Qss,1);
      QLoadRec(1)
    end else if z=24 then begin
      (* W8-BYKEY: key = set prefix + 4-digit value of MAD 
      Ц!/A!. *)
      Qss:=QFindSet(Qx2[Qpc]); if Qss=0 then Qss:=1;
      if Qky[Qpc]<>'      ' then Qck:=Qky[Qpc]
      else if Qx1[Qpc]<>'      ' then QKeyAt(Qss,ЦX)
      else begin
        if Qsc[Qss]<1 then Qsc[Qss]:=1;
        QKeyAt(Qss,Qsc[Qss])
      end;
      QLoadRec(1);
      writeln('W8-BYKEY SET=',Qsn[Qss],' ARG=',Qx1[Qpc],
              ' KEY=',Qck,' EXN=',QEXN)
    end else if z=7 then begin
      bno:=ord(Qx1[Qpc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      Qcurbuf:=bno;
      if Qck='      ' then begin
        if Qss<1 then Qss:=1;
        QKeyAt(Qss,1)
      end;
      QLoadRec(bno)
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
  W7InitSets;
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
procedure ЖYPHAЛ(A:alfa; P:integer);
begin end;
procedure ZKOHEЦ(P:integer);
begin end;
procedure MENU;
(* W6C-TEST-DRIVER-BEGIN: menu selector from the normal 
      dispak INPUT file *)
begin READ(input,ДИP);READLN(input);if ДИP='      ' 
      then ДИP:='KOH   ' end;
(* W6C-TEST-DRIVER-END *)
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
function CONFIRM:boolean;
begin CONFIRM:=false end;
function NEXTCON:boolean;
(* W6C-TEST-DRIVER: cursor shim, one content record then EOF *)
begin W6CN:=W6CN+1;NEXTCON:=(W6CN>=1) end;
function NEXTPAR:boolean;
(* W6C-TEST-DRIVER: parameter cursor, one pass then EOF *)
begin W6CP:=W6CP+1;NEXTPAR:=(W6CP>=2) end;
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
begin end;
procedure WRЕАL(A:real; N:integer);
begin end;
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

procedure DmlP1;
begin
      BUF.LEN:=74;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=CHR(39);BUF.M[15]:='Ф';
      BUF.M[16]:='Л';
      BUF.M[17]:='A';BUF.M[18]:='Г';BUF.M[19]:='И';
      BUF.M[20]:=CHR(39);
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';
      BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';
      BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';
      BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';
      BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';
      BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';
      BUF.M[52]:=';';
end;
procedure DmlP2;
begin
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';
      BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';
      BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';
      BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Ф';BUF.M[71]:='Л';
      BUF.M[72]:='A';
      BUF.M[73]:='Г';BUF.M[74]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
end;
procedure DmlP3;
begin
      BUF.LEN:=152;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=CHR(39);BUF.M[15]:='Д';
      BUF.M[16]:='A';
      BUF.M[17]:='T';BUF.M[18]:='З';BUF.M[19]:='П';
      BUF.M[20]:=CHR(39);
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';
      BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';
      BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';
      BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';
      BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';
      BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';
      BUF.M[52]:=';';
end;
procedure DmlP4;
begin
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';
      BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';
      BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';
      BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Д';BUF.M[71]:='A';
      BUF.M[72]:='T';
      BUF.M[73]:='З';BUF.M[74]:='П';BUF.M[75]:=';';
      BUF.M[76]:=' ';
      BUF.M[77]:='H';BUF.M[78]:='A';BUF.M[79]:='Й';
      BUF.M[80]:='T';
      BUF.M[81]:='И';BUF.M[82]:=' ';BUF.M[83]:='П';
      BUF.M[84]:='O';
      BUF.M[85]:='-';BUF.M[86]:='K';BUF.M[87]:='Л';
      BUF.M[88]:='Ю';
      BUF.M[89]:=' ';BUF.M[90]:=CHR(39);BUF.M[91]:='П';
      BUF.M[92]:='A';
      BUF.M[93]:='P';BUF.M[94]:='O';BUF.M[95]:='Л';
      BUF.M[96]:='Ь';
      BUF.M[97]:=CHR(39);BUF.M[98]:=' ';BUF.M[99]:='B';
      BUF.M[100]:=' ';
      BUF.M[101]:='S';BUF.M[102]:='Y';BUF.M[103]:='-';
      BUF.M[104]:='П';
end;
procedure DmlP5;
begin
      BUF.M[105]:='A';BUF.M[106]:='P';BUF.M[107]:=';';
      BUF.M[108]:='H';
      BUF.M[109]:='A';BUF.M[110]:='Й';BUF.M[111]:='T';
      BUF.M[112]:='И';
      BUF.M[113]:=' ';BUF.M[114]:='П';BUF.M[115]:='E';
      BUF.M[116]:='P';
      BUF.M[117]:='B';BUF.M[118]:='Y';BUF.M[119]:='Ю';
      BUF.M[120]:=' ';
      BUF.M[121]:='B';BUF.M[122]:=' ';BUF.M[123]:='П';
      BUF.M[124]:='A';
      BUF.M[125]:='-';BUF.M[126]:='A';BUF.M[127]:='Л';
      BUF.M[128]:='Ф';
      BUF.M[129]:=';';BUF.M[130]:=' ';BUF.M[131]:='B';
      BUF.M[132]:='З';
      BUF.M[133]:='Я';BUF.M[134]:='T';BUF.M[135]:='Ь';
      BUF.M[136]:=' ';
      BUF.M[137]:='A';BUF.M[138]:='Л';BUF.M[139]:='Ф';
      BUF.M[140]:='.';
      BUF.M[141]:='З';BUF.M[142]:='H';BUF.M[143]:=' ';
      BUF.M[144]:='H';
      BUF.M[145]:='A';BUF.M[146]:=' ';BUF.M[147]:='П';
      BUF.M[148]:='A';
      BUF.M[149]:='P';BUF.M[150]:='O';BUF.M[151]:='Л';
      BUF.M[152]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
end;
procedure DmlP6;
begin
      BUF.LEN:=59;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=CHR(39);BUF.M[15]:='П';
      BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='O';BUF.M[19]:='Л';
      BUF.M[20]:='Ь';
      BUF.M[21]:=CHR(39);BUF.M[22]:=' ';BUF.M[23]:='B';
      BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';
      BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';
      BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';
      BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';
      BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';
      BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';
      BUF.M[52]:='Ф';
end;
procedure DmlP7;
begin
      BUF.M[53]:=';';BUF.M[54]:='З';BUF.M[55]:='A';
      BUF.M[56]:='M';
      BUF.M[57]:='E';BUF.M[58]:='H';BUF.M[59]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
end;
procedure DmlP8;
begin
      BUF.LEN:=58;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';
      BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=CHR(39);BUF.M[15]:='П';
      BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='C';BUF.M[19]:='И';
      BUF.M[20]:='C';
      BUF.M[21]:=CHR(39);BUF.M[22]:=' ';BUF.M[23]:='B';
      BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';
      BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';
      BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';
      BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';
      BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';
      BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';
      BUF.M[52]:='Ф';
end;
procedure DmlP9;
begin
      BUF.M[53]:=';';BUF.M[54]:='B';BUF.M[55]:='З';
      BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
end;
procedure DmlCallA(N:integer);
var J:integer;
begin
  for J:=1 to 160 do BUF.M[J]:=' ';
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
      DmlP1;
      DmlP2;
    end;
    239: begin
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
      BUF.M[41]:='A';BUF.M[42]:='-';BUF.M[43]:='Ц';
      BUF.M[44]:='E';
      BUF.M[45]:='Л';BUF.M[46]:=';';BUF.M[47]:='З';
      BUF.M[48]:='A';
      BUF.M[49]:='M';BUF.M[50]:='E';BUF.M[51]:='H';
      BUF.M[52]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    240: begin
      DmlP3;
      DmlP4;
      DmlP5;
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
    241: begin
      DmlP6;
      DmlP7;
    end;
    242: begin
      DmlP8;
      DmlP9;
    end;
    243: begin
      BUF.LEN:=6;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='B';BUF.M[4]:='E';
      BUF.M[5]:='P';BUF.M[6]:='Ш';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
procedure DmlCall(N:integer);
begin
  if N<=240 then DmlCallA(N) else
  if N>=241 then DmlCallB(N)
end;
(* L0 DMLCALL(237);*)
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
DMLCALL(238);
END;



(* SECTION ? .PЦEЛ *)
(*ЗAMEHИTЬ ПEPBOE ЗHAЧEHИE ЦEЛOГO ПAPAMETPA*)
PROCEDURE PЦEЛ(A:ALFA;I:INT);
BEGIN;DMLCALL(239);
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
DMLCALL(240);
PUTT;YCTФЛAГ;
WRITE(output,'         ДAHHЫE OT ');WДAT(output,ДATЗП);
IF OTЛAД IN ФЛAГИ THEN BEGIN 
  ФЛAГИ:=ФЛAГИ+[AДMИH];CEГOДHЯ:=ДATЗП+1 END 
ELSE BEGIN 
PUTT;PUTT;
WRITE(output,'       ...ЗДPABCTBYЙTE...');PUTT;
WRITE(output,'BЫ - AДMИHИCTPATOP!');
IF ДA THEN BEGIN 
  WRITE(output,'ПOДTBEPДИTE ПAPOЛЬ:');GETHAЧ;
  READ(input,PAROL);
  IF ПAPOЛЬ=PAROL THEN BEGIN 
    WRITE(output,'BЫ ДEЙCTBИTEЛЬHO AДMИHИCTPATOP');PUTT;
    WRITE(output,
      'BAM OTKPЫTЫ ПPABA HA ИЗMEHEHИE ДAHHЫX');PUTT;
    ФЛAГИ:=ФЛAГИ+[AДMИH] END 
  ELSE BEGIN 
    WRITE(output,'HE ЗHAETE ПAPOЛЯ - HE БAЛYЙTECЬ');
      PUTT END; END ;
IF NOT (AДMИH IN ФЛAГИ) THEN BEGIN 
  WRITE(output,'BЫ - ПOЛЬЗOBATEЛЬ');PUTT;
  WRITE(output,'BAM MOЖHO TOЛЬKO BЫДABATЬ OTЧETЫ');
      PUTT END ;
(**)
WRITE(output,'COOБЩИTE CEГOДHЯШHЮЮ ДATY:');
CEГOДHЯ:=RДAT(ДATЗП,ДATЧИC(31,12,99)) END ;
END;



(* SECTION ? .ПAPOЛЬ *)
(*ИЗMEHEHИE ПAPOЛЯ*)
PROCEDURE ПAPOЛЬ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN EXIT;
WRITE(output,'COOБЩИTE HOBЫЙ ПAPOЛЬ:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(input,AЛФ.ЗH);
DMLCALL(241);
YCTMOД;ECTЬ;
END;



(* SECTION ? .БPEГ *)
(*PEГИCTPAЦИOHHЫЙ БЛOK-MEHЮ*)
PROCEDURE БЛOKPEГ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN BEGIN KYДA:='HAPYЖY';EXIT END ;
WHILE TRUE DO BEGIN
WRITE(output,
      '      ...BЫ B PEГИCTPAЦИOHHOM БЛOKE...  ');PUTT;
WRITE(output,'KOФ - BXOД B БЛOK PEГИCTPAЦИИ KOЭФФ',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB',
          'TEM - BXOД B БЛOK PEГИCTPAЦИИ TEM/',
          'ФAK - BXOД B БЛOK PEГИCTPAЦИИ ФAKTИЧ',
          'OБЩ - BXOД B БЛOK PEГИCTPAЦИИ OБЩИX');
MENU;
IF 'KOФ   '=ДИP THEN BEGIN WRITE(output,'W6C/01/01');
PUTT; KYДA:='ZATCOF';EXIT END ELSE IF 'OTД   '=ДИP THEN 
BEGIN WRITE(output,'W6C/01/02');PUTT; KYДA:='ZATOTD';EXIT 
END ELSE IF 'TEM   '=ДИP THEN BEGIN WRITE(output,
'W6C/01/03');PUTT; KYДA:='ZATRTE';EXIT END ELSE IF 
'ФAK   '=ДИP THEN BEGIN WRITE(output,'W6C/01/04');PUTT; 
KYДA:='ZATZAT';EXIT END ELSE IF 'OБЩ   '=ДИP THEN 
BEGIN WRITE(output,'W6C/01/05');PUTT; KYДA:='ZATNAK';EXIT 
END ELSE IF 'KOH   '=ДИP THEN BEGIN WRITE(output,
'W6C/01/06');PUTT; KYДA:='HAPYЖY';EXIT END ELSE IF 
'BЫX   '=ДИP THEN BEGIN WRITE(output,'W6C/01/07');PUTT; 
      KYДA:='HAPYЖY';EXIT END;
END;



(* SECTION ? .БOTЧ *)
(*БЛOK-MEHЮ BЫДAЧИ OTЧETOB*)
END; PROCEDURE БЛOKOTЧ;
BEGIN
IF ЗAKPЫTO THEN BEGIN KYДA:='HAPYЖY';EXIT END ;
IF KYДA='ZATTAB' THEN ECTЬ;
WHILE TRUE DO BEGIN
WRITE(output,
      '      ...BЫ B БЛOKE BЫДAЧИ OTЧETOB...  ');PUTT;
WRITE(output,'ПOC - BЫДAЧA OTЧETA ПO ПOCЛEДHEMY MECЯ');
MENU;
IF 'ПOC   '=ДИP THEN BEGIN WRITE(output,'W6C/02/01');
PUTT; YCTПEЧ;YCTMOД;KYДA:='ZATTAB';EXIT END ELSE IF 
'KOH   '=ДИP THEN BEGIN WRITE(output,'W6C/02/02');PUTT; 
KYДA:='HAPYЖY';EXIT END ELSE IF 'BЫX   '=ДИP THEN 
      BEGIN WRITE(output,'W6C/02/03');PUTT; KYДA:='HAPYЖY';EXIT END;
END;



(* SECTION ? .SF *)
(* YCT/CHЯ ФЛAГOB *)
END; PROCEDURE SETFLAG;
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
(*CИCTEMHЫЙ БЛOK*)
PROCEDURE БЛOKCИC;
VAR ПAPCИC:ALFA;
BEGIN
KYДA:='HAPYЖY';
WRITE(output,'ПAPOЛЬ:');GETT;
READ(input,ПAPCИC);
DMLCALL(242);
PUTT;YCTФЛAГ;
IF AЛФ.ЗH <> ПAPCИC THEN BEGIN 
  WRITE(output,'HE ЛEЗЬ, KYДA HE HYЖHO???');PUTT;EXIT END ;
PUTT;
WHILE TRUE DO BEGIN
WRITE(output,'      ...BЫ B CИCTEMHOM БЛOKE...  ');PUTT;
WRITE(output,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/');
MENU;
IF 'KOH   '=ДИP THEN BEGIN WRITE(output,'W6C/03/01');PUTT;
EXIT END ELSE IF 'BЫX   '=ДИP THEN BEGIN WRITE(output,
'W6C/03/02');PUTT; EXIT END ELSE IF 'ФЛA   '=ДИP THEN 
      BEGIN WRITE(output,'W6C/03/03');PUTT; SETFLAG END;
END;
END;



(* SECTION ? .B *)
BEGIN
  if BDVECT[36].i + 0 = 0 then begin
    for i:=0 to 167 do BDVECT[i].i:=0;
    i:=20270000c; PASACD(i); PASSETAR(270000c)
  end;
  W8LOAD;
KYДA:='HAPYЖY'; AЛФ.ЗH:='TECT  ';  (* W6C test password *)
 IF KYДA='HAЧAЛO' THEN BEGIN

WRITELN;PUTT;
RGEXPORT:=46;
PUTT;WRITELN;
WRITE(output,'           **************');PUTPT;
WRITE(output,'           ИПC ЗATPATЫ-89');PUTPT;
WRITE(output,'           **************');PUTPT;
WRITELN;
IF ПYCTO THEN BEGIN 
    WRITE(output,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(output,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(output,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(243);KYДA:='ЭTOBCE';EXIT END ;
  ПPABA END
(**)
  ELSE IF KYДA='ZATTAB' THEN БЛOKOTЧ ELSE BEGIN END;

(**)
IF (KYДA<>'HAPYЖY') AND (KYДA<>'HAЧAЛO') THEN EXIT;
(**)
DMLCALL(1);WRITE(output,'PEЖИM: ');PUTT; WHILE TRUE DO BEGIN
IF ДИP<>'KOH   ' THEN BEGIN
WRITE(output,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT; END;
(* SECTION ? .Д *)
WRITE(output,'PEГ - BXOД B PEГИCTPAЦИOHHЫЙ БЛOK/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/');
MENU;
IF 'PEГ   '=ДИP THEN BEGIN WRITE(output,'W6C/04/01');
PUTT; БЛOKPEГ;IF KYДA<>'HAPYЖY' THEN EXIT END ELSE IF 
'OTЧ   '=ДИP THEN BEGIN WRITE(output,'W6C/04/02');PUTT; 
БЛOKOTЧ;IF KYДA<>'HAPYЖY' THEN EXIT END ELSE IF 
'CИC   '=ДИP THEN BEGIN WRITE(output,'W6C/04/03');PUTT; 
БЛOKCИC;IF KYДA<>'HAPYЖY' THEN EXIT END ELSE IF 
'ЗAK   '=ДИP THEN BEGIN WRITE(output,'W6C/04/04');PUTT; 
ЖYPHAЛ('ЗAK   ',0) END ELSE IF 'CБP   '=ДИP THEN 
BEGIN WRITE(output,'W6C/04/05');PUTT; ЖYPHAЛ('CБP   ',0) 
END ELSE IF 'ПAP   '=ДИP THEN BEGIN WRITE(output,
'W6C/04/06');PUTT; ПAPOЛЬ END ELSE IF 'KOH   '=ДИP 
THEN BEGIN WRITE(output,'W6C/04/07');PUTT; ZKOHEЦ(0);IF 
NOT HAЧ THEN BEGIN ДИP:='KOH   ';EXIT END; END ELSE IF 
'BЫX   '=ДИP THEN BEGIN WRITE(output,'W6C/04/08');PUTT; 
WRITE(output,              
'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE ');        
      PUTT END;
END; END.
