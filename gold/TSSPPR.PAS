unit tssppr;
       
interface
uses tssbas,
     comtup,
     tslm,
     tssdmpr,
{     tssdmr6,}
     tspic,
     tsszt,
     tsserr,
     tssdml;
VAR SSCH  : ARRAY[0..1256] OF INTEGER;
    Perv2 : boolean; {** °Î´† ´® "ØÆ§·Â•"  ***}

{   procedure savebib(imqtr:alf6);}

   PROCEDURE OPBIB(NAM:ALF6; VAR SIMOP:TYPEM; TEKOP,TRN:INTEGER);

   PROCEDURE ISPVIP;

   PROCEDURE PODSHE;

   PROCEDURE SSBEG(A:ALF6);
   (**# BõÑAóA àÑEHTàîàKAñàà MOÑYãü*)

   PROCEDURE SSHALT (ELEVEL : INTEGER);



implementation

{!*
procedure savebib(imqtr:alf6);
label 13;
var Pic1na,pic1nm:Integer;
PIC1:  TYPPIC;
begin
     Pic1:=Pic^;
     Pic^.nc:=0;
     Pic^.na:=0;
Pic1na:=Pic1.na*2;
pic1nm:=pic1.nm div 2;
 BEGIN TPCMPP1  (16470);
TPCMPIN1 (29);
 END;

wpasra;
 BEGIN TPCMPAD1 (Imqtr);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (2590);
TPCMPIN1 (7426);
 END;

if exn=0 then
  begin
     BEGIN TPCMPP1  (3358);
TPCMPIN1 (7428);
 END;

  end else
  begin
     BEGIN TPCMPAD1 (Imqtr);
TPCMPP1  (44);
TPCMPP1  (1029);
TPCMPP1  (7746);
TPCMPP1  (524);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (4126);
TPCMPIN1 (7426);
 END;

    IF EXN <> 0 THEN
      BEGIN
        PUTEOL;
        PUTALF('ER.40:');
        PUTALF(slangm[64]);
        PUTALF(Imqtr);
        PUTPOL; ERROR:=40;
        goto 13;
      end;
  end;
 BEGIN TPCMPAD1 (pic1nm);
TPCMPAD1 (pic1na);
TPCMPAD1 (VarPoint);
TPCMPAD1 (PIC1.L);
TPCMPAD1 (PIC1.M);
TPCMPP1  (300);
TPCMPP1  (1281);
TPCMPP1  (9226);
TPCMPP1  (0);
TPCMPP1  (0);
TPCMPP1  (307);
TPCMPP1  (300);
TPCMPP1  (1537);
TPCMPP1  (9226);
TPCMPP1  (0);
TPCMPP1  (2);
TPCMPP1  (307);
TPCMPP1  (300);
TPCMPP1  (1793);
TPCMPP1  (9226);
TPCMPP1  (0);
TPCMPP1  (4);
TPCMPP1  (307);
TPCMPP1  (2597);
TPCMPP1  (1312);
TPCMPP1  (9487);
TPCMPP1  (8202);
TPCMPP1  (3846);
TPCMPP1  (2597);
TPCMPP1  (1824);
TPCMPP1  (9487);
TPCMPP1  (8202);
TPCMPP1  (9226);
TPCMPP1  (0);
TPCMPP1  (6);
TPCMPP1  (834);
TPCMPP1  (2597);
TPCMPP1  (2336);
TPCMPP1  (36);
TPCMPP1  (2048);
TPCMPP1  (16896);
TPCMPIN1 (7427);
 END;

 BEGIN TPCMPAD1 (parep);
TPCMPAD1 (padli);
TPCMPP1  (2597);
TPCMPP1  (2848);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (9475);
TPCMPP1  (8202);
TPCMPP1  (9228);
TPCMPP1  (0);
TPCMPP1  (2);
TPCMPP1  (834);
TPCMPIN1 (285);
 END;

13 :
 BEGIN TPCMPP1  (16470);
TPCMPIN1 (2845);
 END;

vpasr6;
end;
*!}

   PROCEDURE OPBIB;(** (NAM:ALF6;VAR SIMOP:TYPEM; TEKOP,TRN:INTEGER);***)

LABEL 3;

VAR PIC1   : TYPPIC;
    TEKOPL,
    I,j    : INTEGER;
    SIMOPI : TYPEMI;

BEGIN (* OPBIB *)
 PIC1 := PIC^; PIC^.NC := 0; PIC^.NA := 0; TEKOPL:=TEKOP;
  BEGIN TPCMPP1  (16470);
TPCMPIN1 (2845);
 END;


  WPASRA;
  PIC^.X.AA:=PIC1.IPCX;
   BEGIN TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (7746);
TPCMPP1  (524);
TPCMPIN1 (16925);
 END;

 IF TRN = 0 THEN
 BEGIN
  PIC^.X.AA := NAM;
   BEGIN TPCMPP1  (55);
TPCMPP1  (807);
TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (7746);
TPCMPP1  (528);
TPCMPIN1 (8221);
 END;

  IF EXN = 0 THEN
  BEGIN
    BEGIN TPCMPP1  (3614);
TPCMPIN1 (7429);
 END;

  END ELSE
  BEGIN
    BEGIN TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (7746);
TPCMPP1  (522);
TPCMPIN1 (7709);
 END;

   IF EXN <> 0 THEN
   BEGIN
    PUTEOL;PUTALF('ER.40:');
    PUTALF(slangm[64]); PUTALF(PIC^.X.AA);  PUTPOL; ERROR:=40;
    GOTO 3
   END ELSE
    BEGIN TPCMPP1  (3358);
TPCMPIN1 (7428);
 END;

  END;
 END;
 IF TEKOPL = 171 then
 BEGIN
    BEGIN TPCMPAD1 (SIMOPI.I);
TPCMPP1  (1317);
TPCMPP1  (544);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

   SIMOP := SIMOPI.A;
 END;


 IF TEKOPL = 175 then BEGIN
{         FOR I:=1 TO 40 DO BEGIN PUTINT(PIC1.M[I]);PUTEOL END;}
{ & & ¢ßÔ‚Ï trbib.trdlic ≠† @i;
     ¢ßÔ‚Ï      .trdlil ≠† @j;
     BáüTú TRBIB.TRCOD HA @PIC1.M;
     BáüTú      .TRLIT HA @PIC1.L & &}
{         FOR I:=1 TO 40 DO BEGIN PUTINT(PIC1.M[I]);PUTEOL END;
         FOR I:=0 TO 9 DO BEGIN PUTINT(PIC1.L.I[I]);PUTEOL END;}

        END;

 3 :
  BEGIN TPCMPP1  (16470);
TPCMPIN1 (541);
 END;

 PIC^:=PIC1;
 vPASR6
END; (* OPBIB *)


       PROCEDURE ISPVIP;

BEGIN (* ISPVIP *)
 BUF.D:=BUF.I+1;
 BUF.M:=BUF.MV;
 BUF.M[BUF.D]:=CHR(C255);
 BUF.H:=0;
 BUF.I:=0;
 C:=' ';
END; (* ISPVIP *)

procedure Compile_Method;
var dlic,stp:integer;
    cc:byte;
    tt:typem;
    pic4:typpic;
begin
   BEGIN TPCMPAD1 (VarNames[1]);
TPCMPAD1 (parep[1]);
TPCMPAD1 (padli[1]);
TPCMPAD1 (FElFlag);
TPCMPAD1 (tt);
TPCMPAD1 (dlic);
TPCMPP1  (1317);
TPCMPP1  (288);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8197);
TPCMPP1  (9220);
TPCMPP1  (0);
TPCMPP1  (2);
TPCMPP1  (3650);
TPCMPP1  (1317);
TPCMPP1  (1312);
TPCMPP1  (36);
TPCMPP1  (1024);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8197);
TPCMPP1  (9219);
TPCMPP1  (0);
TPCMPP1  (6);
TPCMPP1  (3650);
TPCMPP1  (1317);
TPCMPP1  (544);
TPCMPP1  (36);
TPCMPP1  (2048);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8202);
TPCMPP1  (9218);
TPCMPP1  (0);
TPCMPP1  (10);
TPCMPP1  (3650);
TPCMPIN1 (29);
 END;

  write(mf,dlic);
  pic4:=pic^;
  dlic:=1;
  while tt[dlic]<>chr(C255) do
    begin
      putchr(tt[dlic]);
      inc(dlic);
    end;
  ispvip;
  VarAmount:=1;
  VarPoint:=1;
  {writeln('Compiling of ',VarNames[1]);}
  dml(true);
  dlic:=pic^.nm div 2;
  write(mf,dlic);
  for dlic:=1 to pic^.nm div 2 do
    begin
      stp:=256*pic^.m[dlic*2]+pic^.m[dlic*2-1];
      write(mf,stp);
    end;
  write(mf,pic^.nc);
  for dlic:=0 to (pic^.nc+1) div 2 do
    begin
      stp:=256*byte(pic^.l.c[dlic*2+1])+byte(pic^.l.c[dlic*2]);
      write(mf,stp);
    end;
  dlic:=0;
  for cc:=1 to VarAmount do
    dlic:=dlic+VarLength(cc);
  write(mf,dlic);
{  for dlic:=1 to VarPoint do
    write(mf,parep[dlic]);
  for dlic:=1 to VarPoint do
    write(mf,padli[dlic]);}
  pic^:=pic4;
end;

procedure Print_Methods;
var reco,csh:integer;cm:desmeth;f:text;
begin
assign(f,'methods.ret');
rewrite(f);
for reco:=1 to roch.nomzp do
 if recmeths[reco]<>nil then
  begin
    writeln(f,'  Rec number ',reco,' , ',tabcx.alf[reco],' :');
    cm:=recmeths[reco];
    while cm<>nil do
      begin
        writeln(f,' Method number ',cm^.trnum,' , ',cm^.mname,' :');
        writeln(f,'Par amount : ',cm^.numpar);
        writeln(f,'Variables  :   rep  &  dli');
        writeln(f,'--------------------------');
        writeln(f,'Main value : ',mparsrep[cm^.begpar]:5,
                            '   ',mparsdli[cm^.begpar]:5);
        for csh:=2 to cm^.numpar do
          writeln(f,'Par ',csh-1:6,' : ',mparsrep[cm^.begpar+csh-1]:5,
                                   '   ',mparsdli[cm^.begpar+csh-1]:5);
        cm:=cm^.mref;
        writeln(f,'====================================');
      end;
    writeln(f,'**************************************');
  end;
close(f);
end;

          PROCEDURE PODSHE;
LABEL 1;
VAR PIC3:TYPPIC;
    PSSDMO,DliC,ReCo,csh,hc : INTEGER;
    nm:alf6;
    wac:boolean;

function SMeth : desmeth;
var dmeth:desmeth;
begin
  new(dmeth);
  with dmeth^ do
    begin
       BEGIN TPCMPAD1 (mname);
TPCMPAD1 (trnum);
TPCMPAD1 (numpar);
TPCMPAD1 (MParsRep[csh]);
TPCMPAD1 (MParsDli[csh]);
TPCMPP1  (2597);
TPCMPP1  (288);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8202);
TPCMPP1  (9218);
TPCMPP1  (0);
TPCMPP1  (2);
TPCMPP1  (3650);
TPCMPP1  (2597);
TPCMPP1  (2080);
TPCMPP1  (36);
TPCMPP1  (1024);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8202);
TPCMPP1  (9227);
TPCMPP1  (0);
TPCMPP1  (6);
TPCMPP1  (3650);
TPCMPP1  (2597);
TPCMPP1  (3104);
TPCMPP1  (36);
TPCMPP1  (2048);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

{      numpar:=itlen div 2;}
      begpar:=csh;
      csh:=csh+numpar;
      mref:=nil;
    end;
  if dmeth^.numpar=0 then
    begin
      dispose(dmeth);
      dmeth:=nil; 
    end;
  SMeth:=dmeth;
end;
procedure Map_Method(NomRec:integer);
var cmeth:desmeth;
begin
  if RecMeths[NomRec]=nil then
    RecMeths[NomRec]:=SMeth else
    begin
      cmeth:=RecMeths[NomRec];
      while cmeth^.mref<>nil do
        cmeth:=cmeth^.mref;
      cmeth^.mref:=SMeth;
    end;
end;

BEGIN (* PODSHE *)
 PIC3:=PIC^;
 PIC^.NC:=0;
 PIC^.NA:=0;
  IF NKO THEN
 BEGIN
  IMQ;
  PIC^.IPCX:=IMQ1;
 END ELSE
 BEGIN
  IF SSSDM THEN
    SSPERE:=1;
  PIC^.IPCX:=PIC3.IPCX
 END;
 PSSDMO:=0;
 IF (PIC^.SSDMO)>3 THEN
   BEGIN
     PSSDMO:=PIC^.SSDMO;
     PIC^.SSDMO:=0
   END;

{ IF PIC^.ZAV=1 THEN & & áABEPò & &}

 WPASRA;
  BEGIN TPCMPP1  (11350);
TPCMPP1  (1280);
TPCMPP1  (16900);
TPCMPP1  (3102);
TPCMPIN1 (7426);
 END;

 IF EXN<>0 THEN  BEGIN ERM(14);GOTO 1 END;
 PIC3.IPCX:=PIC^.IPCX;

 PIC^.X.II:=6;

  BEGIN TPCMPP1  (1829);
TPCMPP1  (1824);
TPCMPP1  (300);
TPCMPP1  (5381);
TPCMPP1  (3650);
TPCMPIN1 (9501);
 END;

  BEGIN TPCMPP1  (1829);
TPCMPP1  (2080);
TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (3650);
TPCMPIN1 (9501);
 END;


   IF PIC^.X.II<PIC^.SSPED THEN
 BEGIN
  ERM(15);PIC^.SSPED:=PIC^.X.II
 END;
  BEGIN TPCMPP1  (1829);
TPCMPP1  (2336);
TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (3650);
TPCMPIN1 (9501);
 END;

 IF PIC^.X.II<>0 THEN
 BEGIN
   BEGIN TPCMPL1  (0);
TPCMPP1  (44);
TPCMPP1  (1029);
TPCMPP1  (7746);
TPCMPP1  (519);
TPCMPP1  (11352);
TPCMPP1  (1793);
TPCMPP1  (11264);
TPCMPP1  (1);
TPCMPP1  (256);
TPCMPP1  (19015);
TPCMPP1  (5888);
TPCMPP1  (19278);
TPCMPP1  (9216);
TPCMPP1  (805);
TPCMPP1  (800);
TPCMPP1  (300);
TPCMPP1  (2821);
TPCMPP1  (3650);
TPCMPIN1 (9245);
 END;

  IF(EXN<>0)OR(PIC^.SSPED>PIC^.X.II) THEN
  BEGIN
   ERM(16);GOTO 1
  END
 END;
  BEGIN TPCMPP1  (1829);
TPCMPP1  (544);
TPCMPP1  (44);
TPCMPP1  (3077);
TPCMPP1  (3650);
TPCMPIN1 (1821);
 END;

 IF (PIC^.X2 <> XLAM) AND (PIC^.X2 <> PIC^.SSPRIV) THEN
 BEGIN ERM(17);GOTO 1 END;



  BEGIN TPCMPAD1 (ROCH.CXCXTL);
TPCMPP1  (1829);
TPCMPP1  (3616);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

  BEGIN TPCMPAD1 (ROCH.XBOCT.INT[1]);
TPCMPP1  (1829);
TPCMPP1  (3872);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB :=1+ ITLEN DIV 2;

Pbegel:= Addr(roch.xboct.int[konnab-5]);

 BEGIN TPCMPP1  (2846);
TPCMPIN1 (7428);
 END;

  WHILE EXN = 0 DO
BEGIN
  BEGIN TPCMPAD1 (ROCH.XBOCT.INT[KONNAB]);
TPCMPP1  (1573);
TPCMPP1  (1056);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := KONNAB + ITLEN DIV 2;
  BEGIN TPCMPIN1 (7436);
 END;

END;

Pbegnab:= Addr(roch.xboct.int[konnab-7]);


  BEGIN TPCMPAD1 (ROCH.XBOCT.INT[KONNAB]);
TPCMPP1  (1829);
TPCMPP1  (4384);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := KONNAB+ITLEN DIV 2;
  BEGIN TPCMPAD1 (ROCH.XBOCT.INT[KONNAB]);
TPCMPP1  (1829);
TPCMPP1  (4640);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := KONNAB+ITLEN DIV 2;
  BEGIN TPCMPAD1 (ROCH.XBOCT.INT[KONNAB]);
TPCMPP1  (1829);
TPCMPP1  (4896);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;


  BEGIN TPCMPAD1 (TABCX.INT[1]);
TPCMPP1  (1829);
TPCMPP1  (5152);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := 1+ITLEN DIV 2;

 BEGIN TPCMPP1  (2846);
TPCMPIN1 (7428);
 END;

  WHILE EXN = 0 DO
BEGIN
  BEGIN TPCMPAD1 (TABCX.INT[KONNAB]);
TPCMPP1  (1573);
TPCMPP1  (800);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := KONNAB + ITLEN DIV 2;
  BEGIN TPCMPIN1 (7436);
 END;

END;

  BEGIN TPCMPAD1 (TABCX.INT[KONNAB]);
TPCMPP1  (1829);
TPCMPP1  (5664);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

 KONNAB := KONNAB+ITLEN DIV 2-1;

 KONZAP := ROCH.NOMZP;
 BEGNAB := ROCH.TH+KONZAP+1;
 KONNAB := KONNAB DIV 3;

 {   SSLIN(ROCH.CXCXTL); !!! }
 if SSSDM then
   PIC3.SDL:=sizeof(roch)-10 else
   PIC3.SDL:=PIC^.SDL;

for ReCo:=1 to roch.nomzp do
  begin
    if odd(roch.xboct.rec[ReCo].persys) then
      nomsys:=ReCo; { !! }
    RecMeths[ReCo]:=nil;
  end;
csh:=1;
 BEGIN TPCMPP1  (2590);
TPCMPIN1 (7428);
 END;

while exn=0 do
  begin
     BEGIN TPCMPAD1 (FElFlag);
TPCMPP1  (3358);
TPCMPP1  (9476);
TPCMPP1  (8202);
TPCMPP1  (9220);
TPCMPP1  (0);
TPCMPP1  (0);
TPCMPP1  (3650);
TPCMPIN1 (29);
 END;

    if not FElFlag then
    Map_Method(nomsys);
     BEGIN TPCMPP1  (2590);
TPCMPIN1 (7436);
 END;

  end;
 BEGIN TPCMPP1  (4126);
TPCMPIN1 (7428);
 END;

while exn=0 do
  begin
     BEGIN TPCMPAD1 (ReCo);
TPCMPAD1 (FElFlag);
TPCMPP1  (2597);
TPCMPP1  (800);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (9486);
TPCMPP1  (8202);
TPCMPP1  (9220);
TPCMPP1  (0);
TPCMPP1  (2);
TPCMPP1  (3650);
TPCMPIN1 (19229);
 END;

    if not FElFlag then
    if ReCo=0 then
      Map_Method(nomsys) else
      Map_Method(ReCo);
     BEGIN TPCMPP1  (4126);
TPCMPIN1 (7436);
 END;

  end;
Print_Methods;

assign(mf,'methods.tmp');
rewrite(mf);
wac:=false;
hc:=0;
 BEGIN TPCMPP1  (2590);
TPCMPIN1 (7428);
 END;

while exn=0 do
  begin
     BEGIN TPCMPAD1 (dlic);
TPCMPP1  (3358);
TPCMPP1  (9476);
TPCMPP1  (8202);
TPCMPP1  (9221);
TPCMPP1  (0);
TPCMPP1  (0);
TPCMPP1  (3650);
TPCMPIN1 (9245);
 END;

    if dlic=0 then
      begin
         BEGIN TPCMPAD1 (nm);
TPCMPP1  (2597);
TPCMPP1  (288);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

        if hc=0 then
          hc:=howcom(nm);
        if hc in [1,2] then
          begin
             BEGIN TPCMPAD1 (MethOwner);
TPCMPP1  (2597);
TPCMPP1  (800);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

            Compile_Method;
            wac:=true;
          end;
        if hc in [2,3] then
          hc:=0;
      end;
     BEGIN TPCMPP1  (2590);
TPCMPIN1 (7436);
 END;

  end;
 BEGIN TPCMPP1  (4126);
TPCMPIN1 (7428);
 END;

while exn=0 do
  begin
     BEGIN TPCMPAD1 (dlic);
TPCMPP1  (2597);
TPCMPP1  (1312);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

    if dlic=0 then
      begin
         BEGIN TPCMPAD1 (nm);
TPCMPP1  (2597);
TPCMPP1  (288);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPIN1 (7438);
 END;

        if hc=0 then
          hc:=howcom(nm);
        if hc in [1,2] then
          begin
             BEGIN TPCMPAD1 (MethOwner);
TPCMPP1  (2597);
TPCMPP1  (800);
TPCMPP1  (36);
TPCMPP1  (0);
TPCMPP1  (16896);
TPCMPP1  (7694);
TPCMPP1  (1294);
TPCMPIN1 (9245);
 END;

            Compile_Method;
            wac:=true;
          end;
        if hc in [2,3] then
          hc:=0;
      end;
     BEGIN TPCMPP1  (4126);
TPCMPIN1 (7436);
 END;

  end;
close(mf);
if wac then
  zamtrb;
erase(mf);
VarAmount:=0;

 PIC^:=PIC3;
 PIC^.ZAV:=0;
IF PSSDMO>0 THEN
  BEGIN
    PIC^.SSDMO:=PSSDMO;
    PSSDMO:=0
  END;
IF SSSDM THEN
  BEGIN
    INKOMP;
    INBPEM
  END;
1: END; (* PODSHE *)

      PROCEDURE  SSBEG;
var SI :  Pointer;

BEGIN (* SSBEG *)

 {OLDTIMES := TIMES;}
 STOBM    := 0;   (* ·‚†‡Æ• óàCãO OÅMEHOB *)
 SSVERK('8F2709',A);
 SSON     := 0;
 NEMAD    := FALSE;
 RABORT   := TRUE;
 Konzap :=0;
 Konnab :=0;
 Begnab :=0;

 (* OTKPõTàE èOÑCXEMõ CCÑ *)
 SSBF5;

  BEGIN TPCMPL1  (1255);
TPCMPL1  (18771);
TPCMPL1  (8224);
TPCMPL1  (8224);
TPCMPAD1 (SI    );
TPCMPP1  (34);
TPCMPP1  (5415);
TPCMPP1  (55);
TPCMPP1  (2599);
TPCMPP1  (823);
TPCMPP1  (2343);
TPCMPP1  (290);
TPCMPP1  (1063);
TPCMPP1  (1058);
TPCMPP1  (4647);
TPCMPIN1 (7506);
 END;


 PIC := APIC;
 Pic2:= apic2;{ Ptr (Seg( PIC^.L),Pic^.Y2);}

 (* àÑEHTàîàKAñàü èOãúáOBATEãü *)
{ (*+B+!)
 PIC.X.II := SHIFR;
 
 (!--*)}
 PTABCX   := addr( TABCX);
 PIC^.SSD  := 0;   (*PEÜàM HA ÑYÅãüX*)
 PIC^.SSPED:= 3;   (*PEÜàM Ñãü-MO *)
 PAIMC := addr (roch);
 {     PIC^.AIMC := SEG( ROCH);   }
END; (* SSBEG *)


PROCEDURE SSHALT (ELEVEL : INTEGER);

BEGIN {* SSHALT *}
 PIC^.NM := 1;
 PIC^.NC := 0;
 PIC^.NA := 0;
 if Perv2 then
   begin
      BEGIN TPCMPP1  (1339);
TPCMPIN1 (5405);
 END;

   end;
 { CLMAG; }
 BUF.I := 0;
 Obmeny:=pic2^.x129;
 SSENDM;
 HALT(ELEVEL);
END; {* SSHALT *}

end.
