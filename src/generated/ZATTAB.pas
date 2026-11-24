(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATTAB(output,BUF,BDVECT,BDERRN); (*ЗT:TAБЛ.ЗATPAT ЗA ПOCЛ.MECЯЦ*)
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
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:=' ';BUF.M[18]:='S';BUF.M[19]:='Y';BUF.M[20]:='-';
      BUF.M[21]:='П';BUF.M[22]:='A';BUF.M[23]:='P';BUF.M[24]:=';';
      BUF.M[25]:='H';BUF.M[26]:='A';BUF.M[27]:='Й';BUF.M[28]:='T';
      BUF.M[29]:='И';BUF.M[30]:=' ';BUF.M[31]:='П';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='B';BUF.M[35]:='Y';BUF.M[36]:='Ю';
      BUF.M[37]:=' ';BUF.M[38]:='B';BUF.M[39]:=' ';BUF.M[40]:='П';
      BUF.M[41]:='A';BUF.M[42]:='-';BUF.M[43]:='Д';BUF.M[44]:='E';
      BUF.M[45]:='Й';BUF.M[46]:=';';BUF.M[47]:='З';BUF.M[48]:='A';
      BUF.M[49]:='M';BUF.M[50]:='E';BUF.M[51]:='H';BUF.M[52]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    329: begin
      BUF.LEN:=39;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='E';
      BUF.M[21]:='Й';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='Д';BUF.M[30]:='E';BUF.M[31]:='Й';BUF.M[32]:='.';
      BUF.M[33]:='З';BUF.M[34]:='H';BUF.M[35]:=' ';BUF.M[36]:='H';
      BUF.M[37]:='A';BUF.M[38]:=' ';BUF.M[39]:='R';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
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
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    332: begin
      BUF.LEN:=36;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='O';BUF.M[15]:='-';BUF.M[16]:='K';
      BUF.M[17]:='Л';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:='K';BUF.M[23]:='Л';BUF.M[24]:='.';
      BUF.M[25]:='M';BUF.M[26]:='E';BUF.M[27]:='C';BUF.M[28]:=' ';
      BUF.M[29]:='B';BUF.M[30]:=' ';BUF.M[31]:='И';BUF.M[32]:='C';
      BUF.M[33]:='-';BUF.M[34]:='З';BUF.M[35]:='A';BUF.M[36]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    333: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    334: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    335: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    336: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='C';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    337: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    338: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
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
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    342: begin
      BUF.LEN:=30;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='H';BUF.M[15]:='A';BUF.M[16]:='K';
      BUF.M[17]:='Л';BUF.M[18]:='.';BUF.M[19]:='M';BUF.M[20]:='E';
      BUF.M[21]:='C';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='И';BUF.M[26]:='C';BUF.M[27]:='-';BUF.M[28]:='З';
      BUF.M[29]:='A';BUF.M[30]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    343: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    344: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    345: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* L0 DMLCALL(327)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:FWRITE*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:ЧИCДAT*)
(* EDITOR !INCLU:ЧИCMEC*)
(* EDITOR !INCLU:ЧИCKBA*)
(* EDITOR !INCLU:ДATЧИC*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:APИФM*)
(* EDITOR !INCLU:WINT*)
(* EDITOR !INCLU:WREAL*)
(* EDITOR !INCLU:WДAT*)
(* EDITOR !INCLU:WMEC*)
(* EDITOR !INCLU:WKBA*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:FПAP*)
(* EDITOR !INCLU:TPUT*)
(* EDITOR !INCLU:MINUSES*)
(* EDITOR !INCLU:WLF*)



(* SECTION ? .TЗ *)
PROCEDURE TAБЛЗAT;
(*=Y+*)
TYPE
COLUMN=(
        ZTEMA   ,
        ZMEC    ,
        ZOTД    ,
        ZNOTД   ,
        ZЭTAП   ,
        ZBЫП    ,
        ZOЗAPП  ,
        ZДЗAPП  ,
        VЗAPП   ,
        VCTPAX  ,
        ZMATEP  ,
        ZKOMAH  ,
        ZCПEЦ   ,
        ZAMOP   ,
        ZCTOP   ,
        VПPOЧ   ,
        VHAKЛ   ,
        VЗAPH   ,
        VCБC    ,
        VЭФЗ    ,
        ZПOCH   ,
        ZПTPEC  ,
        ZПPБK   ,
        VPACЧ   ,
        ZOBЫШ   ,
        ZOГOC   ,
        ZHEПЛ   ,
        VOCT    ,
        VФPEЗ   ,
        VФMП    ,
        VФHTCP  );
TYPPAR=(CEL,DEY,ALF,STR,LOG,DAT,MES,KVA);
CELL=PACKED RECORD FRM:CHAR;CON:!CONTENT);
CONTENT=RECORD CASE TYP:TYPPAR OF
                   CEL,DAT,MES,KVA:(Ц:!ATCЦEЛ);
                   DEY:(Д:!ATCДEЙ);
                   ALF:(A:!ATCAЛФ);
                   STR:(C:!ATCCTP);
                   LOG:(Л:!ATCЛOГ));
ATCЦEЛ=RECORD ЗH:INT);
ATCДEЙ=RECORD ЗH:REAL);
ATCAЛФ=RECORD ЗH:ALFA);
ATCCTP=RECORD ЗH:CTPOKA);
ATCЛOГ=RECORD ЗH:BOOL);



CONST FIRCOL=ZTEMA;LASCOL=VФHTCP;
      FIRLIN=1;LASLIN=48;

TYPE LINE=FIRLIN..LASLIN;



VAR
SCREEN:INT;EXPORT:TABLEREG;PRINTCALC:BOOL;
T:ARRAY FIRCOL..LASCOL,FIRLIN..LASLIN OF CELL;
TOTAL:ARRAY FIRLIN..LASLIN OF LINE;
MINLIN,MAXLIN,CURLIN:LINE;
SETCOL:RECORD ИCXДEЙ,BЫЧДEЙ,CYMДEЙ,CLEAN:SET OF COLUMN);
FORCOL:ARRAY FIRCOL..LASCOL OF RECORD S:INT;F:CHAR END;
FORLIN:ARRAY FIRLIN..LASLIN OF SET OF TABLEREG;
(*=Y-*)






(* SECTION ? .WSET *)
(*PACПEЧATKA HAБOPA
PROCEDURE WSET(S:SET OF TABLEREG);
CONST F=PAЗ;L=БEЗ;
VAR I:TABLEREG;
BEGIN
WRITE(OUT,'HAБOP:[');
FOR I:=F TO L DO IF I IN S THEN WRITE(OUT,I);
WRITE(OUT,' ]');PUTT;
END;*)



(* SECTION ? .ИMЯ *)
(*TИПЫ: ПEPEЧИCЛИMЫЙ --> ALFA*)
FUNCTION ИMЯ(И:COLUMN):ALFA;VAR F:TEXT;A:ALFA;
BEGIN REWRITE(F);WRITE(F,И,'      ');RESET(F);
WHILE F!=' ' DO GET(F);READ(F,A);ИMЯ:=A END;


(* SECTION ? .IT *)
(*ИHИЦИAЛИЗAЦИЯ TAБЛИЦЫ*)
PROCEDURE INITTAB;
VAR C:COLUMN;L:LINE;
BEGIN
PRINTCALC:=TRUE;
WITH SETCOL DO(
  ИCXДEЙ:=[ZBЫП,ZOЗAPП,ZДЗAPП,ZMATEP,
           ZKOMAH,ZCПEЦ,ZAMOP,ZCTOP,
           ZПOCH,ZПTPEC,ZПPБK,ZOBЫШ,ZOГOC,ZHEПЛ];
  BЫЧДEЙ:=[VПPOЧ,VHAKЛ,VЗAPH ,
           VЗAPП,VCTPAX,VCБC,VPACЧ,VЭФЗ,VOCT,VФPEЗ,VФMП,VФHTCP];
  CYMДEЙ:=ИCXДEЙ+BЫЧДEЙ;
  CLEAN:=[FIRCOL..LASCOL];
);
END;



(* SECTION ? .WCOL *)
(*BЫBOД CTOЛБЦA*)
PROCEDURE WCOL(C:COLUMN);
BEGIN WRITE(OUT,C,'[',ORD(C)+1:0,']') END;



(* SECTION ? .BK *)
(*BЫЧИCЛEHИE BЫЧИCЛЯEMЫX KOЭФФИЦИEHTOB*)
PROCEDURE BЫЧKOЭФ;
VAR OБЩЗAPП:REAL;
PROCEDURE PДEЙ(A:ALFA;I:REAL);
BEGIN;DMLCALL(328)
END;
BEGIN
WITH HAKЛ DO(OБЩЗAPП:=ЗAPП;
PДEЙ('ZKПPOЧ',ПPOЧ/OБЩЗAPП);
PДEЙ('ZKHAKЛ',HAKЛ/OБЩЗAPП);
PДEЙ('ZKЗAPH',ЗAHAK/OБЩЗAPП));
END;



(* SECTION ? .MUL *)
(*YMHOЖИTЬ CTOЛБEЦ HA KOЭФФИЦИEHT*)
PROCEDURE MUL(CR:COLUMN;A:ALFA);
VAR L:LINE;R:REAL;
BEGIN
FПAP(A);DMLCALL(329)
FOR L:=MINLIN TO MAXLIN DO
  T[CR,L].CON!.Д!.ЗH:=T[CR,L].CON!.Д!.ЗH * R;
IF PRINTCALC THEN(
  WCOL(CR);WRITE(OUT,' * ',A,'(',R:0:23,') --> ');WCOL(CR);PUTP);
END;



(* SECTION ? .MOV *)
(*ДEЙCTBИE HAД CTOЛБЦAMИ*)
PROCEDURE MOV(CR:COLUMN;ZNAK:CHAR;SC:SET OF COLUMN);
VAR C:COLUMN;L:LINE;ПEPBЫЙ:BOOL;
BEGIN
IF PRINTCALC THEN(ПEPBЫЙ:=TRUE;WCOL(CR);WRITE(OUT,' ',ZNAK));
FOR L:=MINLIN TO MAXLIN DO WITH T[CR,L].CON!.Д! DO(
  FOR C:=FIRCOL TO LASCOL DO IF C IN SC THEN(
    IF PRINTCALC AND (L=MINLIN) THEN(
      IF ПEPBЫЙ THEN ПEPBЫЙ:=FALSE ELSE WRITE(OUT,' ',ZNAK);
      WCOL(C);WRITE(OUT,CLF));
    SELECT
      ZNAK='+':ЗH:=ЗH+T[C,L].CON!.Д!.ЗH;
      ZNAK='-':ЗH:=ЗH-T[C,L].CON!.Д!.ЗH)));
IF PRINTCALC THEN(WRITE(OUT,' --> ');WCOL(CR);PUTP);
END;



(* SECTION ? .FILL *)
(*ЗAПOЛHEHИE ЯЧEЙKИ*)
PROCEDURE FILL(TT:TYPPAR;CC:COLUMN;LL:LINE;FF:CHAR);
VAR I:INT;
BEGIN
WITH T[CC,LL] DO(
  NEW(CON);FRM:=FF;
  WITH CON! DO(
    TYP:=TT;
    CASE TYP OF
      CEL,DAT,MES,KVA:(NEW(Ц);Ц!.ЗH:=ЦEЛ.ЗH);
      DEY:(NEW(Д);Д!.ЗH:=ДEЙ.ЗH);
      ALF:(NEW(A);A!.ЗH:=AЛФ.ЗH);
      STR:(NEW(C);C!.ЗH:=CTP.ЗH);
      LOG:(NEW(Л);Л!.ЗH:=ЛOГ.ЗH))));
END;



(* SECTION ? .SUM *)
(*CYMMИPOBAHИE CTOЛБЦOB*)
PROCEDURE SUM(LR,LASTOT:LINE;NNEEWW:BOOL);
VAR C:COLUMN;L,NT:LINE;
BEGIN
FOR C:=FIRCOL TO LASCOL DO IF C IN SETCOL.CYMДEЙ THEN(
  IF NNEEWW THEN(ДEЙ.ЗH:=0.0;FILL(DEY,C,LR,'Ц'));
  WITH T[C,LR].CON!.Д! DO(
    FOR NT TO LASTOT DO
      ЗH:=ЗH+T[C,TOTAL[NT]].CON!.Д!.ЗH));
(**)
IF NNEEWW THEN(
FORLIN[LR]:=[PAЗ,HAД,ПOД];
AЛФ.ЗH:='ИTOГO ';FILL(ALF,ZTEMA,LR,'П');
AЛФ.ЗH:='      ';FILL(ALF,ZMEC,LR,'Ц');
AЛФ.ЗH:='      ';FILL(ALF,ZNOTД,LR,'Ц');
AЛФ.ЗH:='      ';FILL(ALF,ZOTД,LR,'Ц');
AЛФ.ЗH:='      ';FILL(ALF,ZЭTAП,LR,'Ц'));
END;



(* SECTION ? .CA *)
(*DISPOSE BCEЙ TAБЛИЦЫ*)
PROCEDURE CLEAN(FIRLIN,MAXLIN:LINE);
VAR C:COLUMN;L:LINE;CONT:!CONTENT;
BEGIN
FOR C:=FIRCOL TO LASCOL DO IF C IN SETCOL.CLEAN THEN
  FOR L:=FIRLIN TO MAXLIN DO(
    WITH T[C,L].CON! DO CASE TYP OF
      CEL,DAT,MES,KVA:DISPOSE(Ц);
      DEY:DISPOSE(Д);
      ALF:DISPOSE(A);
      STR:DISPOSE(C);
      LOG:DISPOSE(Л));
    CONT:=T[C,L].CON;DISPOSE(CONT));
END;



(* SECTION ? .ЗШШ *)
(*ЗAПOЛHEHИE ШAПKИ TAБЛИЦЫ*)
PROCEDURE ЗAПШAП;
CONST SIZE=39;
VAR C:COLUMN;L:LINE;

(*FILL ШAПKИ*)
PROCEDURE Z(JUNC:INT;C:COLUMN;N:PACKED ARRAY 1..SIZE OF CHAR;S:INT);
VAR I:INT;
BEGIN
FOR I TO SIZE DO CTP.ЗH[I]:=N[I];
FOR I:=SIZE+1 TO SCTPOKA DO CTP.ЗH[I]:=' ';
FORCOL[C].S:=S;
FILL(STR,C,L,'Ц');
END;

(* SECTION ? .ЗШ *)
BEGIN
L:=FIRLIN;FORLIN[L]:=[PAЗ,HAД,ПOД];
(* SECTION ? .Z *)
(* SECTION ?P *)
Z( 0,ZTEMA   ,'HOMEP^KAЛЬK^TEMЫ                       ', 7);
             (*                       XXXXXXX             *)
Z( 1,ZMEC    ,'MECЯЦ^ГOД                              ', 5);
             (*             XX.XX                         *)
Z(99,ZOTД    ,'OTДEЛ                                  ', 6);
             (*             XXXXXX                        *)
Z(99,ZNOTД   ,'N                                      ', 1);
             (*             X                             *)
Z(99,ZЭTAП   ,'ЭTAП                                   ', 4);
             (*             XXXXXX                        *)
Z( 2,ZBЫП    ,'BЫПOЛH^ПO^TEME                         ', 6);
             (*                       XXXXXX              *)
Z( 3,ZOЗAPП  ,'ЗAPПЛ^OCH^ИCП                          ', 6);
             (*                 XXXXX.XX                  *)
Z( 4,ZДЗAPП  ,'ДOПOЛH^ЗAPПЛ^OCH^ИCП                   ', 6);
             (*                     XXXX.XX               *)
Z(99,VЗAPП   ,'CYMMAP^ЗAPПЛ^OCH^ИCП                   ', 6);
             (*                    XXXXX.XX               *)
Z( 5,VCTPAX  ,'OTЧ HA^COЦ^CTPAX                       ', 6);
             (*   0.14*(П3+П4)      XXXX.XX               *)
Z( 6,ZMATEP  ,'MATEP                                  ', 6);
             (*             XXXXX.XX                      *)
Z( 7,ZKOMAH  ,'KOMAHД                                 ', 6);
             (*                 XXX.XX                    *)
Z( 8,ZCПEЦ   ,'CПEЦ^OБOP                              ', 5);
             (*                    XXXXX                  *)
Z( 9,ZAMOP   ,'AMOPT^HA^BOCCT                         ', 5);
             (*                  XXXXX                    *)
Z(10,ZCTOP   ,'OПЛ^PAБOT^CTOP^OPГ                     ', 5);
             (*                         XXXXX             *)
Z(11,VПPOЧ   ,'ПPOЧИE^ПPЯMЫE^ЗATP                     ', 6);
             (* (П3+П4)*ZKПPOЧ         XXX.XX             *)
Z(12,VHAKЛ   ,'HAKЛ^PACX                              ', 6);
             (* (П3+П4)*ZKHAKЛ      XXXXX.XX              *)
Z(13,VЗAPH   ,'ЗAPПЛ^HAKЛ                             ', 6);
             (* (П3+П4)*ZKЗAPH       XXXX.XX              *)
Z(14,VCБC    ,'ИTOГO^C/CTOИM                          ', 6);
             (*   CYMMA(П3..П12)   XXXXX.XX               *)
Z(15,VЭФЗ    ,'ЭKOHOMИЯ^ФOHДA^ЗAPПЛ                   ', 7);
             (*   0.3747(П2-П10)-П3-П4-П13  XXXXX.XX      *)
Z(16,ZПOCH   ,'ПЛAT^ЗA^OCH^ФOHД                       ', 4);
             (*                            XXXX           *)
Z(17,ZПTPEC  ,'ПЛA^ЗA^TPY^PEC                         ', 3);
             (*                             XXX           *)
Z(18,ZПPБK   ,'ПP^ЗA^БAH^KP                           ', 3);
             (*                              XXX          *)
Z(19,VPACЧ   ,'PACЧETH^ПPИБЫЛЬ                        ', 7);
             (*   П2-CYMMA(П14..П18)         XXXXX.XX     *)
Z(20,ZOBЫШ   ,'OTЧ^B^BЫШ^OPГ                          ', 4);
             (*                            XXXX           *)
Z(21,ZOГOC   ,'OTЧ^B^ГOC^BTЧ^MEC                      ', 3);
             (*                                XXX        *)
Z(22,ZHEПЛ   ,'CAЛЬДO^HEПЛ^ДOX И^PACX                 ', 6);
             (*                              XXX.XX       *)
Z(23,VOCT    ,'OCTATOЧH^ПPИБЫЛЬ                       ', 7);
             (*   П19-П20-П21-П22        XXXXX.XX         *)
Z(24,VФPEЗ   ,'ФИHAHC^PEЗEPB                          ', 7);
             (*   0.1*П23                XXXXX.XX         *)
Z(25,VФMП    ,'ФMП                                    ', 7);
             (*   0.6584*П23             XXXXX.XX         *)
Z(26,VФHTCP  ,'ФHTCP                                  ', 7);
             (*   0.2416*П23             XXXXX.XX         *)
(* SECTION ?P *)
(* SECTION ? .ENDZ *)
(**)
L:=L+1;FORLIN[L]:=[PAЗ,ПOД];
FOR C:=FIRCOL TO LASCOL DO(
  ЦEЛ.ЗH:=ORD(C)+1;FILL(CEL,C,L,'Ц'));
CURLIN:=L;MINLIN:=L+1;MAXLIN:=CURLIN;
END;



(* SECTION ? .ЗT *)
(*ЗAПOЛHEHИE TAБЛИЦЫ TEMOЙ ЗA MECЯЦ*)
PROCEDURE ЗAПTEM;
VAR C:COLUMN;L,NT:LINE;
BEGIN
DMLCALL(330)
L:=CURLIN+1;NT:=1;
DMLCALL(331)
WHILE MOЖHO DO(
  DMLCALL(332)
  (W)WHILE MOЖHO DO(
    DMLCALL(333);IF ЗAT.MEC!HAKЛ.MEC THEN EXIT W;
    DMLCALL(334)
    FORLIN[L]:=[PAЗ];TOTAL[NT]:=L;
    DMLCALL(335)
    ЦEЛ.ЗH:=TEMA.HOMEP;FILL(CEL,ZTEMA,L,'Ц');
    ЦEЛ.ЗH:=HAKЛ.MEC;FILL(MES,ZMEC,L,'Ц');
    AЛФ.ЗH:=OTДEЛ.HAЗB;FILL(ALF,ZOTД,L,'Ц');
    ЦEЛ.ЗH:=ИCПOЛH.HOMEP;FILL(CEL,ZNOTД,L,'Ц');
    ЦEЛ.ЗH:=ЭTAП.HOMEP;FILL(CEL,ZЭTAП,L,'Ц');
    (**)
    WITH ДEЙ DO WITH ЗAT DO(
      ЗH:=BЫП    ;FILL(DEY, ZBЫП    ,L,'Ц');
      ЗH:=OЗAPП  ;FILL(DEY, ZOЗAPП  ,L,'Ц');
      ЗH:=ДЗAPП  ;FILL(DEY, ZДЗAPП  ,L,'Ц');
      ЗH:=MATEP  ;FILL(DEY, ZMATEP  ,L,'Ц');
      ЗH:=KOMAH  ;FILL(DEY, ZKOMAH  ,L,'Ц');
      ЗH:=CПEЦ   ;FILL(DEY, ZCПEЦ   ,L,'Ц');
      ЗH:=AMOP   ;FILL(DEY, ZAMOP   ,L,'Ц');
      ЗH:=CTOP   ;FILL(DEY, ZCTOP   ,L,'Ц');
      ЗH:=ПOCH   ;FILL(DEY, ZПOCH   ,L,'Ц');
      ЗH:=ПTPEC  ;FILL(DEY, ZПTPEC  ,L,'Ц');
      ЗH:=ПPБK   ;FILL(DEY, ZПPБK   ,L,'Ц');
      ЗH:=OBЫШ   ;FILL(DEY, ZOBЫШ   ,L,'Ц');
      ЗH:=OГOC   ;FILL(DEY, ZOГOC   ,L,'Ц');
      ЗH:=HEПЛ   ;FILL(DEY, ZHEПЛ   ,L,'Ц'));
    (**)
    FOR C:=FIRCOL TO LASCOL DO IF C IN SETCOL.BЫЧДEЙ THEN(
      ДEЙ.ЗH:=0.0;FILL(DEY,C,L,'Ц'));
    (**)
    L:=L+1;NT:=NT+1;
    DMLCALL(336)); (*W*)
  DMLCALL(337));
SUM(L,NT-1,TRUE);CURLIN:=L;MAXLIN:=CURLIN;
END;






(* SECTION ? .BT *)
(*BЫЧИCЛEHИE TAБЛИЦЫ ПO TEME*)
PROCEDURE BЫЧTEM;

PROCEDURE MINUS;
BEGIN IF PRINTCALC THEN MINUSES END;

BEGIN
IF PRINTCALC THEN WLF(3);
(*VЗAPП*)
MINUS;
MOV(VЗAPП,'+',[ZOЗAPП,ZДЗAPП]);
(*VCTPAX*)
MINUS;
MOV(VCTPAX,'+',[VЗAPП]);
MUL(VCTPAX,'ZKCC  ');
(*VПPOЧ*)
MINUS;
MOV(VПPOЧ,'+',[VЗAPП]);
MUL(VПPOЧ,'ZKПPOЧ');
(*VHAKЛ*)
MINUS;
MOV(VHAKЛ,'+',[VЗAPП]);
MUL(VHAKЛ,'ZKHAKЛ');
(*VЗAPH *)
MINUS;
MOV(VЗAPH ,'+',[VЗAPП]);
MUL(VЗAPH ,'ZKЗAPH');
(*VCБC*)
MINUS;
MOV(VCБC,'+',[VЗAPП..VHAKЛ]);
(*VЭФЗ*)
MINUS;
MOV(VЭФЗ,'+',[ZBЫП]);
MOV(VЭФЗ,'-',[ZCTOP]);
MUL(VЭФЗ,'ZKЭФЗ ');
MOV(VЭФЗ,'-',[VЗAPП,VЗAPH ]);
(*VPACЧ*)
MINUS;
MOV(VPACЧ,'+',[ZBЫП]);
MOV(VPACЧ,'-',[VCБC..ZПPБK]);
(*VOCT*)
MINUS;
MOV(VOCT,'+',[VPACЧ]);
MOV(VOCT,'-',[ZOBЫШ..ZHEПЛ]);
(*VФPEЗ*)
MINUS;
MOV(VФPEЗ,'+',[VOCT]);
MUL(VФPEЗ,'ZKФPEЗ');
(*VФMП*)
MINUS;
MOV(VФMП,'+',[VOCT]);
MUL(VФMП,'ZKФMП ');
(*VФHTCP*)
MINUS;
MOV(VФHTCP,'+',[VOCT]);
MUL(VФHTCP,'ZKФHT ');
MINUS;
IF PRINTCALC THEN WLF(3);
END;



(* SECTION ? .ПTШ *)
(*ПEЧATЬ TAБЛИЦЫ ПO TEME*)
PROCEDURE ПEЧTAБ(FIRLIN,MAXLIN:LINE);
VAR INTERVAL:ARRAY 1..10 OF RECORD UP,LOW:COLUMN;SIZ:INT);
    LASTINT:INT;C:COLUMN;L:LINE;I,J:INTEGER;



(* SECTION ? .DIV *)
(*PAЗБИEHИE TAБЛИЦЫ*)
PROCEDURE DIVIDE(FIRCOL,LASCOL:COLUMN);
VAR N:INT;C:COLUMN;
BEGIN
N:=1;C:=FIRCOL;
(W) WHILE C<LASCOL DO(
  WITH INTERVAL[N] DO(
    UP:=C;SIZ:=1;
    FOR C:=C TO LASCOL DO SIZ:=SIZ+FORCOL[C].S+1;
    C:=LASCOL;
    WHILE SIZ>SCREEN DO(
      SIZ:=SIZ-FORCOL[C].S-1;C:=PRED(C));
    LOW:=C;
    IF C=LASCOL THEN EXIT W);
  N:=N+1;C:=SUCC(C));
LASTINT:=N;
END;



(* SECTION ? .WCELL *)
(*ПEЧATЬ ЯЧEЙKИ TAБЛИЦЫ*)
PROCEDURE WRITECELL(C:CELL);
BEGIN
(*WRITE(OUT,C.FRM,' ',C.CON!.TYP,'=');*)
WITH C.CON! DO CASE TYP OF
  CEL:WRITE(OUT,Ц!.ЗH:0);
  DAT:WДAT(OUT,Ц!.ЗH);
  MES:WMEC(OUT,Ц!.ЗH);
  KVA:WKBA(OUT,Ц!.ЗH);
  DEY:WREAL(Д!.ЗH,2);
  ALF:WRITE(OUT,A!.ЗH);
  STR:WCTP(OUT,C!.ЗH,0);
  LOG:IF Л!.ЗH THEN WRITE(OUT,'ДA') ELSE WRITE(OUT,'HET'));
END;



(* SECTION ? .ПT *)
BEGIN
DIVIDE(FIRCOL,VCБC);
FOR I TO LASTINT DO WITH INTERVAL[I] DO(
  FOR L:=FIRLIN TO MAXLIN DO(
    J:=1;
    FOR C:=UP TO LOW DO(
      TABLE[J].S:=FORCOL[C].S;
      TABLE[J].F:=T[C,L].FRM;
      WRITECELL(T[C,L]);WRITE(OUT,'!');
      J:=J+1);
    TABLE[J].S:=BCE;
    TPUT(FORLIN[L]+[EXPORT]));
  IF EXPORT=ЭKP THEN PUTT);
END;



(* SECTION ? .П *)
(*OTЧET ПO ПOCЛEДHEMY MECЯЦY*)
PROCEDURE ПOCЛEД;
VAR L,NT:LINE;
BEGIN
DMLCALL(338);IF ПYCTO THEN EXIT;DMLCALL(339);BЫЧKOЭФ;
ЗAПШAП;
SUM(LASLIN,0,TRUE);
(**)
DMLCALL(340)
(R)REPEAT
  (W)WHILE TRUE DO(
    IF ПYCTO THEN EXIT R;DMLCALL(341);
    WHILE MOЖHO DO(
      DMLCALL(342);IF NOT ПYCTO THEN EXIT W;
      DMLCALL(343));
    DMLCALL(344));(*W*)
  (**)
  ЗAПTEM;BЫЧTEM;
  IF PRINTCALC THEN ПEЧTAБ(FIRLIN,MAXLIN)
               ELSE ПEЧTAБ(MINLIN,MAXLIN);
  PRINTCALC:=FALSE;
  TOTAL[1]:=MAXLIN;SUM(LASLIN,1,FALSE);
  CLEAN(MINLIN,MAXLIN);
  CURLIN:=MINLIN-1;
  DMLCALL(345)
UNTIL FALSE;
(**)
ПEЧTAБ(LASLIN,LASLIN);WLF(3);
CLEAN(FIRLIN,MINLIN-1);CLEAN(LASLIN,LASLIN);
END;



(* SECTION ? .TЗB *)
BEGIN
INITTAB;SCREEN:=126;EXPORT:=ПEЧ;ПOCЛEД;ДИP:='BЫX';
(*INITTAB;
WRITE(OUT,'      ...BЫ B БЛOKE OTЧETA ПO ЗATPATAM...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПEЧ - BЫДAЧA OTЧETA HA ПEЧATЬ/',
          'ЭKP - BЫДAЧA OTЧETA HA ЭKPAH/');
MENU;
SELECT
  'ПEЧ'=ДИP:(SCREEN:=124;EXPORT:=ПEЧ;ПOCЛEД);
  'ЭKP'=ДИP:(SCREEN:=77;EXPORT:=ЭKP;ПOCЛEД);
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:EXIT);
);*)
END;



(* SECTION ? .B *)
BEGIN
TAБЛЗAT;
END.
