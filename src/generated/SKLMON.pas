(*=y+,s0,s7*)
(*=L1*) PROGRAM SKLMON(output,BUF,BDVECT,BDERRN); (*CK:MOHИTOP *)
type
  alfa = packed array[1..6] of char;
  word = record case integer of
    0:(i:integer); 1:(a:alfa); 2:(c:char) end;
  TBDVec = array[0..167] of word;
  TYPEM = packed array[1..160] of char;
  ZZBUFT = record LEN,H,D,I:integer; M:TYPEM end;
var
  BDVECT: TBDVec;
  BDERRN: integer;
  BUF: ZZBUFT;
  C: char;
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
procedure DmlCall(N:integer);
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
      BUF.M[17]:='M';BUF.M[18]:='П';BUF.M[19]:='A';BUF.M[20]:='C';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    2: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    3: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='S';
      BUF.M[9]:='Y';BUF.M[10]:='S';BUF.M[11]:='T';BUF.M[12]:='E';
      BUF.M[13]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    4: begin
      BUF.LEN:=12;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='S';BUF.M[8]:='Y';
      BUF.M[9]:='S';BUF.M[10]:='T';BUF.M[11]:='E';BUF.M[12]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    5: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    6: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    7: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    8: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    9: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    10: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    11: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    12: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    13: begin
      BUF.LEN:=39;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='O';
      BUF.M[37]:='M';BUF.M[38]:='E';BUF.M[39]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    14: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    15: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    16: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    17: begin
      BUF.LEN:=6;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='B';BUF.M[4]:='E';
      BUF.M[5]:='P';BUF.M[6]:='Ш';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* HEAD block of deck 12, gold line 1122 *)
procedure SKLHEAD;
begin DMLCALL(1) end;
(* L0 DMLCALL(2)*)
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
(* EDITOR !INCLU:WCTP*)
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
SYSTEM.PEЖИMЫ:=ФЛAГИ*[OTЛAД,OTЧCKЛ,OTЧOTД,BXOД];
END;(*=C+*)



(* SECTION ? .ПЗAK *)
(*ДEЙCTBИЯ ДO ЗAKPEПЛEHИЯ*)
PROCEDURE ПPEДЗAK;
BEGIN
SYSTEM.ДATЗП:=CEГOДHЯ;CHЯФЛAГ;
DMLCALL(3)
END;



(* SECTION ? .ПPABA *)
(*ПPOBEPKA ПPAB ПOЛЬЗOBATEЛЯ*)
PROCEDURE ПPABA;
VAR ПPOB:ZZSYSTEM;
BEGIN
DMLCALL(4);PUTT;YCTФЛAГ;
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



(* SECTION ? .ПЗГ *)
(*BЫДAЧA ДЛЯ ПEPEЗAГPYЗKИ*)
PROCEDURE ПЗГ;
CONST EE='_';EF='*';
BEGIN
DMLCALL(5)
WRITELN(' BEЩИ [');
WHILE MOЖHO DO WITH BEЩЬ DO(
  DMLCALL(6)
  WRITE(' ',HOMEP/1000:0:23,EE);
  WCTP(OUTPUT,HAЗB,0);WRITELN(EE,EД[1],EД[2],EE);
  WRITELN('    ',ЦEHA:0:22,EE,
          OCTAT:0:23,EE,ПPИXOД:0:23,EE,PACXOД:0:23,EF);
  DMLCALL(7));
WRITELN(' ]');

DMLCALL(8)
WHILE MOЖHO DO(
  DMLCALL(9)
  WRITELN(' OTДEЛ [',OTДEЛ.HAЗB,EF,']');
  DMLCALL(10)
  WHILE MOЖHO DO(
    DMLCALL(11)
    WRITELN('   CYMMA [',CYMMA.ЦEHA:0:22,EF,']');
    DMLCALL(12)
    WHILE MOЖHO DO(
      DMLCALL(13)
      WRITELN('     BЗЯЛ [',BEЩЬ.HOMEP/1000:0:23,EE,
              BЗЯЛ.KOЛИЧ:0:23,EF,']');
      DMLCALL(14));
    DMLCALL(15));
  DMLCALL(16));
ECTЬ;
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
WRITE(OUT,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/',
          'ПЗГ - BЫДAЧA ДAHHЫX ДЛЯ ПEPEЗAГPYЗKИ/');
MENU;
SELECT
  'ФЛA'=ДИP:SETFLAG;
  'ПЗГ'=ДИP:ПЗГ;
  'BЫX'=ДИP:EXIT;
  'KOH'=ДИP:EXIT);
)
END;



(* SECTION ? .B *)
BEGIN CASE KYДA OF
'HAЧAЛO':(
WRITELN(OUT);
RGEXPORT:=[46];
WRITELN;
WRITE(OUT,'           ************');PUTPT;
WRITE(OUT,'           ИПC CKЛAД-88');PUTPT;
WRITE(OUT,'           ************');PUTPT;
WRITELN;
IF ПYCTO THEN(
    WRITE(OUT,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(OUT,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(OUT,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(17);KYДA:='ЭTOBCE';EXIT);
  ПPABA));
  IF (KYДA!'HAPYЖY') AND (KYДA!'HAЧAЛO') THEN EXIT;
(**)
(* SECTION ? .Д *)
WHILE TRUE DO(
IF ДИP!'KOH' THEN(
WRITE(OUT,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
WRITE(OUT,'KAP - BXOД B БЛOK PEГИCTPAЦИИ KAPT/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/');
MENU);
SELECT
  'KAP'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='SKLCAR';EXIT);
  'OTЧ'=ДИP:IF NOT ЗAKPЫTO THEN(
              KYДA:='SKLOTC';EXIT);
  'OTД'=ДИP:IF NOT HEЛЬЗЯ AND NOT ЗAKPЫTO THEN(
              KYДA:='SKLOTD';EXIT);
  'CИC'=ДИP:БЛOKCИC;
  'ЗAK'=ДИP:ЖYPHAЛ('ЗAK',ПPEДЗAK);
  'CБP'=ДИP:ЖYPHAЛ('CБP',ПPEДЗAK);
  'ПAP'=ДИP:ПAPOЛЬ;
  'KOH'=ДИP:(KOHEЦ(ПPEДЗAK);IF NOT HAЧ THEN(ДИP:='KOH';EXIT));
  'BЫX'=ДИP:(WRITE(OUT,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE "KOH"');
             PUTT)));
END.
