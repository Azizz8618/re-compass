(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOOTC(output,BUF,BDVECT,BDERRN); (*AM:OTЧET *)
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
    189: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    190: begin
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
    191: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Ш';BUF.M[20]:='И';
      BUF.M[21]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    192: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    193: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    194: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='Ш';BUF.M[23]:='И';BUF.M[24]:='-';
      BUF.M[25]:='П';BUF.M[26]:='P';BUF.M[27]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    195: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    196: begin
      BUF.LEN:=108;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='И';BUF.M[10]:='Б';BUF.M[11]:='O';BUF.M[12]:='P';
      BUF.M[13]:=';';BUF.M[14]:=' ';BUF.M[15]:=' ';BUF.M[16]:=' ';
      BUF.M[17]:=' ';BUF.M[18]:=' ';BUF.M[19]:=' ';BUF.M[20]:=' ';
      BUF.M[21]:='H';BUF.M[22]:='A';BUF.M[23]:='Й';BUF.M[24]:='T';
      BUF.M[25]:='И';BUF.M[26]:=' ';BUF.M[27]:='П';BUF.M[28]:='E';
      BUF.M[29]:='P';BUF.M[30]:='B';BUF.M[31]:='Y';BUF.M[32]:='Ю';
      BUF.M[33]:=' ';BUF.M[34]:='B';BUF.M[35]:=' ';BUF.M[36]:='И';
      BUF.M[37]:='H';BUF.M[38]:='-';BUF.M[39]:='C';BUF.M[40]:='T';
      BUF.M[41]:='O';BUF.M[42]:=';';BUF.M[43]:='B';BUF.M[44]:='З';
      BUF.M[45]:='Я';BUF.M[46]:='T';BUF.M[47]:='Ь';BUF.M[48]:=' ';
      BUF.M[49]:='C';BUF.M[50]:='T';BUF.M[51]:='O';BUF.M[52]:='И';
      BUF.M[53]:='T';BUF.M[54]:='.';BUF.M[55]:='П';BUF.M[56]:='P';
      BUF.M[57]:='И';BUF.M[58]:='H';BUF.M[59]:='Я';BUF.M[60]:='Л';
      BUF.M[61]:=';';BUF.M[62]:=' ';BUF.M[63]:=' ';BUF.M[64]:=' ';
      BUF.M[65]:=' ';BUF.M[66]:=' ';BUF.M[67]:=' ';BUF.M[68]:=' ';
      BUF.M[69]:='H';BUF.M[70]:='A';BUF.M[71]:='Й';BUF.M[72]:='T';
      BUF.M[73]:='И';BUF.M[74]:=' ';BUF.M[75]:='П';BUF.M[76]:='O';
      BUF.M[77]:='C';BUF.M[78]:='Л';BUF.M[79]:='E';BUF.M[80]:='Д';
      BUF.M[81]:=' ';BUF.M[82]:='B';BUF.M[83]:=' ';BUF.M[84]:='И';
      BUF.M[85]:='H';BUF.M[86]:='-';BUF.M[87]:='C';BUF.M[88]:='T';
      BUF.M[89]:='O';BUF.M[90]:=';';BUF.M[91]:='B';BUF.M[92]:='З';
      BUF.M[93]:='Я';BUF.M[94]:='T';BUF.M[95]:='Ь';BUF.M[96]:=' ';
      BUF.M[97]:='C';BUF.M[98]:='T';BUF.M[99]:='O';BUF.M[100]:='И';
      BUF.M[101]:='T';BUF.M[102]:='.';BUF.M[103]:='C';BUF.M[104]:='П';
      BUF.M[105]:='И';BUF.M[106]:='C';BUF.M[107]:='A';BUF.M[108]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    197: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    198: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Ш';
      BUF.M[17]:='И';BUF.M[18]:='-';BUF.M[19]:='П';BUF.M[20]:='P';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    199: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Ш';BUF.M[20]:='И';
      BUF.M[21]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    200: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Г';BUF.M[20]:='P';
      BUF.M[21]:='Y';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    201: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    202: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Г';BUF.M[20]:='P';
      BUF.M[21]:='Y';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    203: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    204: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='П';BUF.M[20]:='P';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    205: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    206: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    207: begin
      BUF.LEN:=45;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='Д';BUF.M[32]:='E';
      BUF.M[33]:='Л';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='З';BUF.M[38]:='B';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:=' ';BUF.M[43]:='O';BUF.M[44]:='T';
      BUF.M[45]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    208: begin
      BUF.LEN:=24;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='T';
      BUF.M[9]:='O';BUF.M[10]:='И';BUF.M[11]:='T';BUF.M[12]:=';';
      BUF.M[13]:='B';BUF.M[14]:='З';BUF.M[15]:='Я';BUF.M[16]:='T';
      BUF.M[17]:='Ь';BUF.M[18]:=' ';BUF.M[19]:='П';BUF.M[20]:='P';
      BUF.M[21]:='И';BUF.M[22]:='Б';BUF.M[23]:='O';BUF.M[24]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    209: begin
      BUF.LEN:=37;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='H';
      BUF.M[9]:='B';BUF.M[10]:=';';BUF.M[11]:='H';BUF.M[12]:='A';
      BUF.M[13]:='Й';BUF.M[14]:='T';BUF.M[15]:='И';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:='Л';BUF.M[19]:='A';BUF.M[20]:='Д';
      BUF.M[21]:='E';BUF.M[22]:='Л';BUF.M[23]:=' ';BUF.M[24]:='B';
      BUF.M[25]:=' ';BUF.M[26]:='Ш';BUF.M[27]:='И';BUF.M[28]:='-';
      BUF.M[29]:='П';BUF.M[30]:='P';BUF.M[31]:='И';BUF.M[32]:=';';
      BUF.M[33]:='B';BUF.M[34]:='З';BUF.M[35]:='Я';BUF.M[36]:='T';
      BUF.M[37]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    210: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    211: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    212: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='П';BUF.M[20]:='P';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    213: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    214: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='И';BUF.M[23]:='H';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='T';BUF.M[27]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    215: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    216: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    217: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='Б';BUF.M[8]:='Д';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='O';BUF.M[15]:='T';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:=' ';BUF.M[23]:='K';BUF.M[24]:='E';
      BUF.M[25]:='Y';BUF.M[26]:='B';BUF.M[27]:='D';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    218: begin
      BUF.LEN:=53;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='Б';
      BUF.M[9]:='Д';BUF.M[10]:='-';BUF.M[11]:='K';BUF.M[12]:='Л';
      BUF.M[13]:='Ю';BUF.M[14]:=' ';BUF.M[15]:='O';BUF.M[16]:='T';
      BUF.M[17]:='Д';BUF.M[18]:='E';BUF.M[19]:='Л';BUF.M[20]:=' ';
      BUF.M[21]:='H';BUF.M[22]:='A';BUF.M[23]:=' ';BUF.M[24]:='K';
      BUF.M[25]:='E';BUF.M[26]:='Y';BUF.M[27]:='B';BUF.M[28]:='D';
      BUF.M[29]:=';';BUF.M[30]:=' ';BUF.M[31]:=' ';BUF.M[32]:=' ';
      BUF.M[33]:='H';BUF.M[34]:='A';BUF.M[35]:='Й';BUF.M[36]:='T';
      BUF.M[37]:='И';BUF.M[38]:=' ';BUF.M[39]:='C';BUF.M[40]:='Л';
      BUF.M[41]:='E';BUF.M[42]:='Д';BUF.M[43]:='Y';BUF.M[44]:='Ю';
      BUF.M[45]:=' ';BUF.M[46]:='B';BUF.M[47]:=' ';BUF.M[48]:='S';
      BUF.M[49]:='Y';BUF.M[50]:='-';BUF.M[51]:='O';BUF.M[52]:='T';
      BUF.M[53]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    219: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    220: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    221: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    222: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    223: begin
      BUF.LEN:=32;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='O';BUF.M[15]:='T';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:='.';BUF.M[20]:='H';
      BUF.M[21]:='A';BUF.M[22]:='З';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='S';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='O';BUF.M[31]:='T';BUF.M[32]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    224: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    225: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='E';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    226: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='O';BUF.M[27]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    227: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    228: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='E';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* L0 DMLCALL(189)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:FWRITE*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:ЧИCДAT*)
(* EDITOR !INCLU:ДATЧИC*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:APИФM*)
(* EDITOR !INCLU:WINT*)
(* EDITOR !INCLU:WДAT*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MINUSES*)
(* EDITOR !INCLU:WLF*)
(* EDITOR !INCLU:WBL*)
(* EDITOR !INCLU:BIGLIN*)
(* EDITOR !INCLU:YCTПEЧ*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ROTД*)
(* EDITOR !INCLU:RЦEЛBEЩ*)
(* EDITOR !INCLU:MENU*)



(* SECTION ? .BB *)
(*BЗЯTЬ ПPИБOP И BЛAДEЛ B SY-OTД И SY-ШИФ*)
PROCEDURE BЗЯTЬBCE;
BEGIN
DMLCALL(190)
END;



(* SECTION ? .OT *)
(*BЫДAЧA OTЧETOB*)
PROCEDURE OTЧET;
VAR MEC,MK,MП:INT;BMEC,KMEC,Z:REAL;



(* SECTION ? .MECЯЦ *)
(*BBOД OTЧETHOГO MECЯЦA*)
FUNCTION MECЯЦ:INT;
VAR I:INT;
BEGIN
WRITE(OUT,'HOMEP OTЧETHOГO MECЯЦA:');
MECЯЦ:=RЦEЛ(1,12);
END;



(* SECTION ? .ЭM *)
(*ПPИHAДЛEЖHOCTЬ MECЯЦA ПPOMEЖYTKY*)
FUNCTION ЭTOTMEC:BOOL;
BEGIN
WITH ПPИБOP DO(
IF CTOИT.ПPИHЯЛ=0 THEN MK:=1
                  ELSE MK:=CTOИT.ПPИHЯЛ;
IF CTOИT.CПИCAЛ=0 THEN MП:=12
                  ELSE MП:=CTOИT.CПИCAЛ;
IF MП>MEC THEN MП:=MEC;
BMEC:=ЦEHA/100*BOC/12;
KMEC:=ЦEHA/100*KAП/12);
ЭTOTMEC:=(MEC>=MK)AND(MEC<=MП);
END;



(* SECTION ? .ШИФ *)
(*BЫДAЧA TAБЛИЦЫ ПO ГPYППAM ШИФPOB*)
PROCEDURE ШИФ;



(* SECTION ? .ШO *)
(*BЫДAЧA CTPOKИ TAБЛИЦЫ ПO ГPYППE ШИФPOB*)
PROCEDURE ШИФOTД;
VAR SЦEHA,SBMEC,SKMEC,SBTEK,SKTEK:REAL;
BEGIN
SЦEHA:=0;SBMEC:=0;SKMEC:=0;SBTEK:=0;SKTEK:=0;
DMLCALL(191)
(Ц1)WHILE MOЖHO DO(
  DMLCALL(192);IF ШИФP.HOMEP>=ГPYППA.HAЧ THEN EXIT Ц1;
  DMLCALL(193));
(**)
WHILE MOЖHO AND(ШИФP.HOMEP<=ГPYППA.KOH) DO(
  DMLCALL(194)
  WHILE MOЖHO DO WITH ПPИБOP DO(
    DMLCALL(195)
    WHILE MOЖHO DO(
      DMLCALL(196)
      IF ЭTOTMEC THEN(
        SЦEHA:=SЦEHA+ЦEHA;
        SBMEC:=SBMEC+BMEC;
        SKMEC:=SKMEC+KMEC);
      SBTEK:=SBTEK+BMEC*(MП-MK+1);
      SKTEK:=SKTEK+KMEC*(MП-MK+1);
      DMLCALL(197));
    DMLCALL(198));
  DMLCALL(199));
(**)
WRITE(' ',ГPYППA.HAЧ:6,' - ',
          ГPYППA.KOH:6,' ');
WCTP(OUTPUT,ГPYППA.HAЗB,48);
WRITELN(' ',SЦEHA:10:22,' ',
        SBMEC:9:22,' ',SKMEC:9:22,'  ',
        SBTEK:9:22,' ',SKTEK:9:22);
MINUSES;END;



(* SECTION ? .ШИФB *)
BEGIN
MEC:=MECЯЦ;IF HAЧ THEN EXIT;
YCTПEЧ;
WLF(4);MINUSES;WLF(1);WBL(20);
WRITE('TAБЛИЦA AMOPTИЗAЦИИ ПO ГPYППAM ШИФPOB');
WRITE('    ЗA ',MEC:0,' MECЯЦ      (HAПEЧATAHO ');
WДAT(OUTPUT,CEГOДHЯ);WRITELN(')');
WLF(1);MINUSES;WLF(1);
WBL(10);WRITE('Г P Y П П A   Ш И Ф P O B');
WBL(36);WRITE('ЦEHA');
WBL(7);WRITELN('AMOPT.ЗA MECЯЦ     AMOPT.C HAЧAЛA ГOДA');
WBL(80);WRITELN('HA BOCCT  HA KAП.P   HA BOCCT  HA KAП.P');
MINUSES;
DMLCALL(200)
WHILE MOЖHO DO(
  DMLCALL(201);ШИФOTД;
  DMLCALL(202));
ECTЬ;
END;



(* SECTION ? .ПKO *)
(*ПEЧATЬ KAPTЫ ДЛЯ OTДEЛA*)
PROCEDURE ПEЧKAPOT;
BEGIN
WITH ПPИБOP DO(
WRITE(' ',ИHB.HOMEP:5,' ');
WCTP(OUTPUT,HAЗB,48);
WRITELN(' ',ШИФP.HOMEP:6,'     ',ЦEHA:9:22,'      ',
  BOC:5:22,'!(',BMEC:8:22,')      ',
  KAП:5:22,'!(',KMEC:8:22,')'));
END;



(* SECTION ? .ПO *)
(*ПOЛHAЯ ПEЧATЬ OTДEЛA*)
PROCEDURE ПEЧOT;
VAR SЦEHA,SBOC,SKAП:REAL;OTД:ALFA;
BEGIN
SЦEHA:=0;SBOC:=0;SKAП:=0;
(**)
WLF(2);MINUSES;WBL(33);
WRITE(OTДEЛ.HAЗB,'  ЗA ',MEC:0,' MECЯЦ    (HAПEЧATAHO ');
WДAT(OUTPUT,CEГOДHЯ);WRITELN(')');
MINUSES;
DMLCALL(203)
IF ПYCTO THEN(WBL(40);
  WRITELN('HИЧEГO HE ЗAPEГИCTPИPOBAHO');
  MINUSES;EXIT);
WRITE(' ИHB.N');
WBL(10);WRITE('HAИMEHOBAHИE');
WBL(29);WRITE('ШИФP');
WBL(9);WRITE('ЦEHA');
WBL(10);WRITE('OTЧ.HA BOCCT');
WBL(12);WRITELN('OTЧ.HA KAП.P');MINUSES;
(**)
DMLCALL(204)
WHILE MOЖHO DO(
  DMLCALL(205)
  WHILE MOЖHO DO(
    DMLCALL(206)
    WHILE MOЖHO DO(
      DMLCALL(207)
      IF OTДEЛ.HAЗB=OTД THEN(
        DMLCALL(208)
        IF ЭTOTMEC THEN(
          DMLCALL(209);ПEЧKAPOT;
          SЦEHA:=SЦEHA+ПPИБOP.ЦEHA;
          SBOC:=SBOC+BMEC;
          SKAП:=SKAП+KMEC));
      DMLCALL(210));
    DMLCALL(211));
  DMLCALL(212));
(**)
WRITE('ИTOГO:');
WBL(61);WRITE(SЦEHA:9:22);
WBL(13);WRITE(SBOC:8:22);
WBL(14);WRITELN(SKAП:8:22);
MINUSES;
END;



(* SECTION ? .ИO *)
(*KPATKИЙ ИTOГ OTДEЛA*)
PROCEDURE ИTOГOT(ЭKPAH:BOOL);
VAR SЦEHA,SBOC,SKAП:REAL;
BEGIN
SЦEHA:=0;SBOC:=0;SKAП:=0;
WRITE(OUT,' ',OTДEЛ.HAЗB);
IF NOT ЭKPAH THEN(
  WRITE(OUT,' ЗA ',MEC:0,' MECЯЦ     (HAПEЧATAHO ');
  WДAT(OUT,CEГOДHЯ);WRITE(OUT,')'));
DMLCALL(213)
IF ПYCTO THEN(WLF(1);
  WRITELN(OUT,' - HИЧEГO HE ЗAPEГИCTPИPOBAHO');
  FWRITE(OUT);REWRITE(OUT);MINUSES;EXIT);
WHILE MOЖHO DO(
  DMLCALL(214)
  BЗЯTЬBCE;DMLCALL(215)
  IF ЭTOTMEC THEN(
    SЦEHA:=SЦEHA+ПPИБOP.ЦEHA;
    SBOC:=SBOC+BMEC;
    SKAП:=SKAП+KMEC));
(**)
WRITELN(OUT,
  '  OБЩ.CTOИM=',SЦEHA:0:22,
  '  OTЧ.HA BOCCT=',SBOC:0:22,
  '  OTЧ.HA KAП.P=',SKAП:0:22);
IF ЭKPAH THEN PUTT ELSE(
  WLF(1);FWRITE(OUT);REWRITE(OUT);MINUSES);
END;



(* SECTION ? .ПBC *)
(*BЫДAЧA ПOЛHOГO OTЧETA ПO BCEM OTДEЛAM*)
PROCEDURE ПBC;
VAR KEYBD:ZZBDKEY;
BEGIN
MEC:=MECЯЦ;IF HAЧ THEN EXIT;
WLF(4);MINUSES;WLF(1);WBL(40);
WRITELN('ПOЛHAЯ TAБЛИЦA AMOPTИЗAЦИИ ПO OTДEЛAM');
WLF(1);MINUSES;WLF(1);
YCTПEЧ;
DMLCALL(216)
WHILE MOЖHO DO(
  DMLCALL(217);ПEЧOT;
  DMLCALL(218));
ECTЬ;
END;



(* SECTION ? .ПOT *)
(*BЫДAЧA ПOЛHOГO OTЧETA ПO OTДEЛЬHЫM OTДEЛAM*)
PROCEDURE ПOT;
BEGIN
MEC:=MECЯЦ;IF HAЧ THEN EXIT;
YCTПEЧ;
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
DMLCALL(219)
IF ПYCTO THEN(
  WRITE(OUT,'Y ЭTOГO OTДEЛA HИЧEГO HE ЗAPEГИCTPИPOBAHO');PUTT;EXIT);
ПEЧOT;
ECTЬ;
END;



(* SECTION ? .KBC *)
(*BЫДAЧA KPATKOГO OTЧETA ПO BCEM OTДEЛAM*)
PROCEDURE KBC;
BEGIN
MEC:=MECЯЦ;IF HAЧ THEN EXIT;
YCTПEЧ;
WLF(4);MINUSES;WLF(1);WBL(40);
WRITELN('KPATKAЯ TAБЛИЦA AMOPTИЗAЦИИ ПO OTДEЛAM');
WLF(1);MINUSES;WLF(1);
YCTПEЧ;
DMLCALL(220)
WHILE MOЖHO DO(
  DMLCALL(221);ИTOГOT(FALSE);
  DMLCALL(222));
ECTЬ;
END;



(* SECTION ? .KOT *)
(*BЫДAЧA KPATKOГO OTЧETA ПO OTДEЛЬHЫM OTДEЛAM*)
PROCEDURE KOT;
BEGIN
MEC:=MECЯЦ;IF HAЧ THEN EXIT;
WRITE(OUT,'HAЗBAHИE OTДEЛA:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,OTДEЛ.HAЗB);
DMLCALL(223);
IF ПYCTO THEN(
  WRITE(OUT,'TAKOЙ OTДEЛ HE ЗAPEГИCTPИPOBAH');PUTT;EXIT);
DMLCALL(224)
IF ПYCTO THEN(
  WRITE(OUT,'Y ЭTOГO OTДEЛA HИЧEГO HE ЗAPEГИCTPИPOBAHO');PUTT;EXIT);
ИTOГOT(TRUE);
END;



(* SECTION ? .ДPA *)
(*BЫДAЧA OTЧETA ПO ДPAГ.METAЛЛAM *)
PROCEDURE ДPA;
VAR S:REAL;
BEGIN
WRITE(OUT,'COДEPЖAHИE ДPAГ.METAЛOB B OCH.CPEДCTBAX');PUTT;
DMLCALL(225)
WHILE MOЖHO DO(
  S:=0.0;
  DMLCALL(226)
  WHILE MOЖHO DO(
    DMLCALL(227)
    S:=S+COДEPЖ.KOЛИЧ);
  WCTP(OUT,METAЛ.HAЗB,15);WRITE(OUT,':',S:0:26);PUTT;
  DMLCALL(228));
END;



(* SECTION ? .B *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE BЫДAЧИ OTЧETOB...');PUTT;
KYДA:='HAPYЖY';
WHILE TRUE DO(
WRITE(OUT,'ШИФ - OTЧET ПO ГPYППAM ШИФPOB/',
          'ПBC - ПOЛHЫЙ OTЧET ПO BCEM OTДEЛAM/',
          'ПOT - ПOЛHЫЙ OTЧET ПO OTДEЛЬHЫM OTДEЛAM/',
          'KBC - KPATKИЙ OTЧET ПO BCEM OTДEЛAM/',
          'KOT - KPATKИЙ OTЧET ПO OTДEЛЬHЫM OTДEЛAM/',
          'ДPA - OTЧET ПO ДPAГOЦEHHЫM METAЛЛAM/');
MENU;
SELECT
  'ДPA'=ДИP:ДPA;
  'ШИФ'=ДИP:ШИФ;
  'ПBC'=ДИP:ПBC;
  'ПOT'=ДИP:ПOT;
  'KBC'=ДИP:KBC;
  'KOT'=ДИP:KOT;
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT);
);
END;



(* SECTION ? .BEGIN *)
BEGIN OTЧET END.
