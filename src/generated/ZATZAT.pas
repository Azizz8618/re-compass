(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATZAT(output,BUF,BDVECT,BDERRN); (*ЗT:PEГИC.ЗATPAT*)
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
    268: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    269: begin
      BUF.LEN:=46;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='C';
      BUF.M[9]:='П';BUF.M[10]:='O';BUF.M[11]:='Л';BUF.M[12]:='H';
      BUF.M[13]:=';';BUF.M[14]:='H';BUF.M[15]:='A';BUF.M[16]:='Й';
      BUF.M[17]:='T';BUF.M[18]:='И';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:='Л';BUF.M[22]:='A';BUF.M[23]:='Д';BUF.M[24]:='E';
      BUF.M[25]:='Л';BUF.M[26]:=' ';BUF.M[27]:='B';BUF.M[28]:=' ';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='-';BUF.M[32]:='И';
      BUF.M[33]:='C';BUF.M[34]:='П';BUF.M[35]:=';';BUF.M[36]:='B';
      BUF.M[37]:='З';BUF.M[38]:='Я';BUF.M[39]:='T';BUF.M[40]:='Ь';
      BUF.M[41]:=' ';BUF.M[42]:='O';BUF.M[43]:='T';BUF.M[44]:='Д';
      BUF.M[45]:='E';BUF.M[46]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    270: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='C';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    271: begin
      BUF.LEN:=29;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='Б';BUF.M[8]:='Д';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='И';BUF.M[15]:='C';BUF.M[16]:='П';
      BUF.M[17]:='O';BUF.M[18]:='Л';BUF.M[19]:='H';BUF.M[20]:=' ';
      BUF.M[21]:='H';BUF.M[22]:='A';BUF.M[23]:=' ';BUF.M[24]:='T';
      BUF.M[25]:='E';BUF.M[26]:='K';BUF.M[27]:='З';BUF.M[28]:='A';
      BUF.M[29]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    272: begin
      BUF.LEN:=52;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='Б';
      BUF.M[9]:='Д';BUF.M[10]:='-';BUF.M[11]:='K';BUF.M[12]:='Л';
      BUF.M[13]:='Ю';BUF.M[14]:=' ';BUF.M[15]:='И';BUF.M[16]:='C';
      BUF.M[17]:='П';BUF.M[18]:='O';BUF.M[19]:='Л';BUF.M[20]:='H';
      BUF.M[21]:=' ';BUF.M[22]:='H';BUF.M[23]:='A';BUF.M[24]:=' ';
      BUF.M[25]:='T';BUF.M[26]:='E';BUF.M[27]:='K';BUF.M[28]:='З';
      BUF.M[29]:='A';BUF.M[30]:='П';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='C';BUF.M[39]:='Л';BUF.M[40]:='E';
      BUF.M[41]:='Д';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='И';BUF.M[48]:='C';
      BUF.M[49]:='-';BUF.M[50]:='И';BUF.M[51]:='C';BUF.M[52]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    273: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    274: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    275: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='-';BUF.M[22]:='И';BUF.M[23]:='C';BUF.M[24]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    276: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='-';BUF.M[22]:='Э';BUF.M[23]:='T';BUF.M[24]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    277: begin
      BUF.LEN:=10;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='З';
      BUF.M[9]:='A';BUF.M[10]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    278: begin
      BUF.LEN:=9;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='З';BUF.M[8]:='A';
      BUF.M[9]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    279: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    280: begin
      BUF.LEN:=23;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='З';BUF.M[8]:='A';
      BUF.M[9]:='T';BUF.M[10]:='.';BUF.M[11]:='M';BUF.M[12]:='E';
      BUF.M[13]:='C';BUF.M[14]:=' ';BUF.M[15]:='H';BUF.M[16]:='A';
      BUF.M[17]:=' ';BUF.M[18]:='Ц';BUF.M[19]:='E';BUF.M[20]:='Л';
      BUF.M[21]:='.';BUF.M[22]:='З';BUF.M[23]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    281: begin
      BUF.LEN:=50;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='C';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='И';BUF.M[30]:='C';BUF.M[31]:='П';BUF.M[32]:='O';
      BUF.M[33]:='Л';BUF.M[34]:='H';BUF.M[35]:='.';BUF.M[36]:='H';
      BUF.M[37]:='O';BUF.M[38]:='M';BUF.M[39]:='E';BUF.M[40]:='P';
      BUF.M[41]:=' ';BUF.M[42]:='H';BUF.M[43]:='A';BUF.M[44]:=' ';
      BUF.M[45]:='Ц';BUF.M[46]:='E';BUF.M[47]:='Л';BUF.M[48]:='.';
      BUF.M[49]:='З';BUF.M[50]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    282: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    283: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    284: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    285: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='-';BUF.M[22]:='Э';BUF.M[23]:='T';BUF.M[24]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    286: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    287: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    288: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    289: begin
      BUF.LEN:=10;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='З';
      BUF.M[9]:='A';BUF.M[10]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* L0 DMLCALL(268)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
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
(* EDITOR !INCLU:RSEP*)
(* EDITOR !INCLU:RINT*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)



(* SECTION ? .RШ *)
(*БЛOK PEГИCTPAЦИИ KAPT*)
PROCEDURE REGIS;
(* EDITOR !INCLU:LIST*)



(* SECTION ? .WT *)
(*ПPOCMOTP ДEPEBA ПOДЧИHEHHOCTИ ИCПOЛHИTEЛEЙ*)
PROCEDURE WTREE;
PROCEDURE GTREE(YPOB:INT);
VAR TEKЗAП:ZZBDKEY;
BEGIN
DMLCALL(269)
CASE YPOB OF
1:WRITE(OUT,'ИCП');
2:WRITE(OUT,'COИ');
3:WRITE(OUT,'ПOД'));
WRITE(OUT,'(',ИCПOЛH.HOMEP:0,')=',OTДEЛ.HAЗB,CLF);
DMLCALL(270)
WHILE MOЖHO DO(
  DMLCALL(271);GTREE(YPOB+1);
  DMLCALL(272));
END;
BEGIN
DMLCALL(273);IF MOЖHO THEN GTREE(1);
WRITELN(OUT);PUTT;
END;



(* SECTION ? .ПOC *)
(*ПOCTABИTЬ ЗATPATЫ*)
PROCEDURE ПOCTAB;
BEGIN
RESETCON;
REPEAT WITH CUL!.CUC! DO WITH ЗAT DO SELECT
BOS!.NAM='ZMEC  ':ЗAT.MEC:=Ц!;
BOS!.NAM='ZTEMA ':(DMLCALL(274));
BOS!.NAM='ZOTД  ':(DMLCALL(275));
BOS!.NAM='ZЭTAП ':(DMLCALL(276));
BOS!.NAM='ZBЫП  ':BЫП  :=Д!;
BOS!.NAM='ZOЗAPП':OЗAPП:=Д!;
BOS!.NAM='ZДЗAPП':ДЗAPП:=Д!;
BOS!.NAM='ZMATEP':MATEP:=Д!;
BOS!.NAM='ZKOMAH':KOMAH:=Д!;
BOS!.NAM='ZCПEЦ ':CПEЦ :=Д!;
BOS!.NAM='ZAMOP ':AMOP :=Д!;
BOS!.NAM='ZCTOP ':CTOP :=Д!;
BOS!.NAM='ZПOCH ':ПOCH :=Д!;
BOS!.NAM='ZПTPEC':ПTPEC:=Д!;
BOS!.NAM='ZПPБK ':ПPБK :=Д!;
BOS!.NAM='ZOBЫШ ':OBЫШ :=Д!;
BOS!.NAM='ZOГOC ':OГOC :=Д!;
BOS!.NAM='ZHEПЛ ':HEПЛ :=Д!);
UNTIL NEXTCON;
DMLCALL(277);YCTMOД;
WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA');PUTT;
END;



(* SECTION ? .BЗЯ *)
(*BЗЯTЬ ЗATPATЫ*)
PROCEDURE BЗЯTЬ;
VAR C:!CONTENT;
BEGIN
DMLCALL(278);
WHILE NOT NEXTPAR DO(
  NEWCONT(C);WITH C! DO WITH ЗAT DO SELECT
    BOS!.NAM='ZBЫП  ':Д!:=BЫП  ;
    BOS!.NAM='ZOЗAPП':Д!:=OЗAPП;
    BOS!.NAM='ZДЗAPП':Д!:=ДЗAPП;
    BOS!.NAM='ZMATEP':Д!:=MATEP;
    BOS!.NAM='ZKOMAH':Д!:=KOMAH;
    BOS!.NAM='ZCПEЦ ':Д!:=CПEЦ ;
    BOS!.NAM='ZAMOP ':Д!:=AMOP ;
    BOS!.NAM='ZCTOP ':Д!:=CTOP ;
    BOS!.NAM='ZПOCH ':Д!:=ПOCH ;
    BOS!.NAM='ZПTPEC':Д!:=ПTPEC;
    BOS!.NAM='ZПPБK ':Д!:=ПPБK ;
    BOS!.NAM='ZOBЫШ ':Д!:=OBЫШ ;
    BOS!.NAM='ZOГOC ':Д!:=OГOC ;
    BOS!.NAM='ZHEПЛ ':Д!:=HEПЛ));
END;



(* SECTION ? .EЗ *)
(*HAЙTИ ЗATPATЫ ПO MECЯЦY,OTДEЛY,ЭTAПY*)
FUNCTION ECTЬЗAT:BOOL;
BEGIN
ECTЬЗAT:=TRUE;
DMLCALL(279)
(W)WHILE MOЖHO DO(
  DMLCALL(280);IF ЗAT.MEC!ЦEЛ.ЗH THEN EXIT W;
  DMLCALL(281)
  IF ИCПOЛH.HOMEP=ЦEЛ.ЗH THEN EXIT;
  DMLCALL(282));
ECTЬЗAT:=FALSE;
END;



(* SECTION ? .HAЙ *)
(*HAЙTИ KAPTY*)
PROCEDURE HAЙTИ;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
IF NAM='ZOTД  ' THEN WTREE;
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='ZMEC  ':ЗAT.MEC:=Ц!;
NAM='ZTEMA ':(DMLCALL(283)
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOЙ TEMЫ');PUTT;NEXT:=FALSE));
NAM='ZOTД  ':(ИCПOЛH.HOMEP:=Ц!;DMLCALL(284)
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOГO ИCПOЛHИTELЯ');PUTT;NEXT:=FALSE));
NAM='ZЭTAП ':(DMLCALL(285)
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOГO ЭTAПA');PUTT;NEXT:=FALSE)
  ELSE(
    IF ECTЬЗAT THEN EXIT ELSE(
      WRITE(OUT,'ЭTOM MECЯЦE ЗATPATЫ HE ЗAPEГИCTPИPOBAHЫ');
      PUTT;NEXT:=FALSE))));
UNTIL NEXT;UNTIL NEXTPAR;
END;



(* SECTION ? .HOB *)
(*BBOД HOBЫX ЗATPAT*)
PROCEDURE HOB;
VAR TEM,MEC,OTД:INT;
BEGIN
MEC:=0;TEM:=0;OTД:=-1;
REPEAT REPEAT REPEAT REPEAT
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
IF (NAM='ZOTД  ') AND (OTД=-1) THEN WTREE;
SELECT
  (NAM='ZMEC  ')&(MEC!0):(REWRITE(INP);WRITE(INP,MEC);INPUTCON);
  (NAM='ZTEMA ')&(TEM!0):(REWRITE(INP);WRITE(INP,TEM);INPUTCON);
  (NAM='ZOTД  ')&(OTД!-1):(REWRITE(INP);WRITE(INP,OTД);INPUTCON);
  TRUE:(READCON(NEXT);IF HAЧ THEN EXIT));
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='ZMEC  ':(MEC:=Ц!;ЗAT.MEC:=Ц!);
NAM='ZTEMA ':(DMLCALL(286)
  IF NOT ПYCTO THEN TEM:=Ц! ELSE(
    WRITE(OUT,'HET TAKOЙ TEMЫ');PUTT;NEXT:=FALSE));
NAM='ZOTД  ':(ИCПOЛH.HOMEP:=Ц!;DMLCALL(287)
  IF NOT ПYCTO THEN OTД:=Ц! ELSE(
    WRITE(OUT,'HET TAKOГO ИCПOЛHИTEЛЯ');PUTT;NEXT:=FALSE));
NAM='ZЭTAП ':(ЭTAП.HOMEP:=Ц!;DMLCALL(288)
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOГO ЭTAПA');PUTT;NEXT:=FALSE)
  ELSE IF ECTЬЗAT THEN(
    WRITE(OUT,'YЖE ECTЬ ЭTOT ИCПOЛHИTEЛЬ');
    PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
(**)
WRITE(OUT,'EЩE ЭTAП!');
UNTIL NOT ДA;IF HAЧ THEN EXIT;
OTД:=-1;WRITE(OUT,'EЩE OTДEЛ!');
UNTIL NOT ДA;IF HAЧ THEN EXIT;
TEM:=0;WRITE(OUT,'EЩE TEMY!');
UNTIL NOT ДA;IF HAЧ THEN EXIT;
MEC:=0;WRITE(OUT,'EЩE MECЯЦ!');
UNTIL NOT ДA;(*IF HAЧ THEN EXIT;*)
END;



(* SECTION ? .ПPO *)
(*ПPOCMOTP ЗATPAT*)
PROCEDURE ПPO;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WTREE;WRITELIST;
END;



(* SECTION ? .ИCK *)
(*ИCKЛЮЧEHИE ЗATPAT*)
PROCEDURE ИCK;
PROCEDURE YHAP(H:INT);EXTERNAL;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;
IF NOT CONFIRM THEN EXIT;
DMLCALL(289)
YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
FIL:=NIL;LOADLIST('CП-ЗAT');FINDLIST('CП-ЗAT');
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ ЗATPAT ПO TEMAM...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'KOH'=ДИP:(KYДA:='HAPYЖY';CLEANALL;EXIT);
  'BЫX'=ДИP:(CLEANALL;EXIT));
);
END;



(* SECTION ? .B *)
BEGIN
REGIS;
END.
