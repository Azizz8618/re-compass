(*=y+,s0,s7*)
(*=L1*) PROGRAM SKLOTC(output,BUF,BDVECT,BDERRN); (*CK:OTЧET *)
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
    94: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    95: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    96: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    97: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    98: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='Y';BUF.M[27]:='M';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='П';BUF.M[42]:='E';BUF.M[43]:='P';BUF.M[44]:='B';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    99: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='C';BUF.M[42]:='Л';BUF.M[43]:='E';BUF.M[44]:='Д';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    100: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    101: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    102: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='Y';BUF.M[27]:='M';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='П';BUF.M[42]:='E';BUF.M[43]:='P';BUF.M[44]:='B';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    103: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='C';BUF.M[42]:='Л';BUF.M[43]:='E';BUF.M[44]:='Д';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    104: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    105: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    106: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='Y';BUF.M[27]:='M';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='П';BUF.M[42]:='E';BUF.M[43]:='P';BUF.M[44]:='B';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    107: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';BUF.M[34]:=';';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Й';BUF.M[38]:='T';BUF.M[39]:='И';BUF.M[40]:=' ';
      BUF.M[41]:='C';BUF.M[42]:='Л';BUF.M[43]:='E';BUF.M[44]:='Д';
      BUF.M[45]:='Y';BUF.M[46]:='Ю';BUF.M[47]:=' ';BUF.M[48]:='B';
      BUF.M[49]:=' ';BUF.M[50]:='C';BUF.M[51]:='Y';BUF.M[52]:='-';
      BUF.M[53]:='B';BUF.M[54]:='З';BUF.M[55]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    108: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    109: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    110: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    111: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    112: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    113: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    114: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    115: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='E';
      BUF.M[9]:='Щ';BUF.M[10]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    116: begin
      BUF.LEN:=60;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='З';
      BUF.M[9]:='Я';BUF.M[10]:='Л';BUF.M[11]:=';';BUF.M[12]:='H';
      BUF.M[13]:='A';BUF.M[14]:='Й';BUF.M[15]:='T';BUF.M[16]:='И';
      BUF.M[17]:=' ';BUF.M[18]:='B';BUF.M[19]:='Л';BUF.M[20]:='A';
      BUF.M[21]:='Д';BUF.M[22]:='E';BUF.M[23]:='Л';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='C';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='B';BUF.M[31]:='З';BUF.M[32]:='Я';
      BUF.M[33]:=';';BUF.M[34]:='H';BUF.M[35]:='A';BUF.M[36]:='Й';
      BUF.M[37]:='T';BUF.M[38]:='И';BUF.M[39]:=' ';BUF.M[40]:='B';
      BUF.M[41]:='Л';BUF.M[42]:='A';BUF.M[43]:='Д';BUF.M[44]:='E';
      BUF.M[45]:='Л';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:=' ';
      BUF.M[49]:='O';BUF.M[50]:='T';BUF.M[51]:='-';BUF.M[52]:='C';
      BUF.M[53]:='Y';BUF.M[54]:='M';BUF.M[55]:=';';BUF.M[56]:='B';
      BUF.M[57]:='З';BUF.M[58]:='Я';BUF.M[59]:='T';BUF.M[60]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    117: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    118: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    119: begin
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
    120: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    121: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    122: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    123: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    124: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    125: begin
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
    126: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    127: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    128: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    129: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    130: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    131: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    132: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    133: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* L0 DMLCALL(94)*)
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
(* EDITOR !INCLU:STPUT*)
(* EDITOR !INCLU:ROTД*)
(* EDITOR !INCLU:MENU*)



(* SECTION ? .ЦB *)
(*ИHB.HOM. INT --> REAL *)
FUNCTION ЦB(I:INT):REAL;
BEGIN ЦB:=I/1000 END;

(* SECTION ? .BЦ *)
(*ИHB.HOM. REAL --> INT *)
FUNCTION BЦ(R:REAL):INT;
BEGIN BЦ:=ROUND(R*1000) END;



(* SECTION ? .ШAПKA *)
(*BЫBOД ШAПKИ*)
PROCEDURE ШAПKA;
VAR I:INT;F:TEXT;
BEGIN
FCOPY(F,OUT);RESET(F);REWRITE(OUT);I:=0;
WHILE NOT EOF(F) DO(I:=I+1;GET(F));
I:=(128-I) DIV 2;
YCTПEЧ;WLF(4);MINUSES;WLF(1);WBL(I);FWRITE(F);
WLF(2);MINUSES;
WBL(50);WRITE('HAПEЧATAHO ');WДAT(OUTPUT,CEГOДHЯ);WRITELN;
MINUSES;WLF(1);
END;



(* SECTION ? .OЦEH *)
FUNCTION OЦEHEHO:BOOL;
VAR HAШЛИ:BOOL;I:INT;
BEGIN
I:=0;HAШЛИ:=FALSE;OЦEHEHO:=TRUE;ШAГ:=1;
DMLCALL(95);
(Ц) WHILE MOЖHO DO(
  DMLCALL(96)
  IF NOT HAШЛИ THEN(
    OЦEHEHO:=FALSE;HAШЛИ:=TRUE;
    WRITE(OUT,'HE OЦEHEHЫ CЛEДYЮЩИE HOMEPA:');PUTT);
  WRITE(OUT,' ',ЦB(BEЩЬ.HOMEP):9:23);I:=I+1;
  IF (I MOD 13)=0 THEN IF STPUT THEN EXIT Ц);
IF (I MOD 13)!0 THEN PUTT;
END;



(* SECTION ? .ПKO *)
(*ПEЧATЬ KAPTЫ ДЛЯ OTДEЛA*)
PROCEDURE ПEЧKAPOT;
BEGIN
WITH BEЩЬ DO(
WRITE(' ',ЦB(HOMEP):9:23,'   ');
WCTP(OUTPUT,BEЩЬ.HAЗB,44);
WRITE(' ',EД[1],EД[2],'      ');
IF ЦEHA>0.0001 THEN WRITE(ЦEHA:5:22)
               ELSE WRITE('!!!!!');
WRITELN('   ',BЗЯЛ.KOЛИЧ:9:23,'   ',ЦEHA*BЗЯЛ.KOЛИЧ:8:22));
END;



(* SECTION ? .ПO *)
(*ПOЛHAЯ ПEЧATЬ OTДEЛA*)
PROCEDURE ПEЧOT;
VAR S,SM:REAL;
BEGIN
WLF(2);MINUSES;WBL(33);
WRITE(OTДEЛ.HAЗB,'   OTЧET C ');WДAT(OUTPUT,SYSTEM.ДATЧИC);
WRITE(' ПO ');WДAT(OUTPUT,CEГOДHЯ);WRITELN;MINUSES;
(**)
S:=0.0;
DMLCALL(97)
(Ц) WHILE MOЖHO DO(
  DMLCALL(98)
  SM:=CYMMA.ЦEHA;
  WCTP(OUTPUT,MATEP.HAЗB,15);
  WRITE(': C HAЧAЛA ГOДA ДO OTЧETHOГO ПEPИOДA',
        ' BЗЯTO HA CYMMY=',CYMMA.ЦEHA:8:22);
  IF ПYCTO THEN(
    WRITELN(', B OTЧETHЫЙ ПEPИOД HИЧEГO HE БPAЛИ');
    MINUSES)
  ELSE(
    WLF(2);
    WRITE(' HOMEP');
    WBL(13);WRITE('HAИMEHOBAHИE');
    WBL(25);WRITE('EД.ИЗM.');
    WBL(4);WRITE('ЦEHA');
    WBL(4);WRITE('KOЛ-BO');
    WBL(4);WRITELN('CYMMA');WLF(1);
    (**)
    WHILE MOЖHO DO(
      DMLCALL(99)
      SM:=SM+BEЩЬ.ЦEHA*BЗЯЛ.KOЛИЧ;ПEЧKAPOT);
    WLF(1);WRITE(' ИTOГO:');
    WBL(74);WRITELN(SM:9:22);MINUSES);
  S:=S+SM;
  DMLCALL(100));
WRITE(' ИTOГ ПO BCEM MATEPИAЛAM');WBL(57);WRITELN(S:9:22);MINUSES;
END;



(* SECTION ? .ИO *)
(*KPATKИЙ ИTOГ OTДEЛA*)
PROCEDURE ИTOГOT;
VAR S,SM:REAL;
BEGIN
WLF(2);MINUSES;WBL(33);
WRITE(OTДEЛ.HAЗB,'   OTЧET C ');WДAT(OUTPUT,SYSTEM.ДATЧИC);
WRITE(' ПO ');WДAT(OUTPUT,CEГOДHЯ);WLF(2);
(**)
S:=0.0;
DMLCALL(101)
WHILE MOЖHO DO(
  DMLCALL(102)
  WCTP(OUTPUT,MATEP.HAЗB,15);
  WRITE(': C HAЧAЛA ГOДA ДO OTЧETHOГO ПEPИOДA',
        ' BЗЯTO HA ',CYMMA.ЦEHA:8:22);
  SM:=0.0;
  WHILE MOЖHO DO(
    DMLCALL(103)
    SM:=SM+BEЩЬ.ЦEHA*BЗЯЛ.KOЛИЧ);
  WRITE(' B OTЧETHЫЙ ПEPИOД BЗЯTO HA ',SM:9:22);
  WRITELN(' ИTOГO:',SM+CYMMA.ЦEHA:9:22);S:=S+SM+CYMMA.ЦEHA;
  DMLCALL(104));
WLF(1);WRITE(' OБЩИЙ ИTOГ:');WBL(101);WRITELN(S:9:22);MINUSES;
END;



(* SECTION ? .ИOЭ *)
(*KPATKИЙ ИTOГ OTДEЛA HA ЭKPAH*)
PROCEDURE ИTOГOTЭ;
VAR S,SM:REAL;
BEGIN
WRITE(OUT,'   ',OTДEЛ.HAЗB,'   OTЧET C ');WДAT(OUT,SYSTEM.ДATЧИC);
WRITE(OUT,' ПO ');WДAT(OUT,CEГOДHЯ);PUTT;
(**)
S:=0.0;
DMLCALL(105)
WHILE MOЖHO DO(
  DMLCALL(106)
  WCTP(OUT,MATEP.HAЗB,13);
  WRITE(OUT,':ДO ЧИCTKИ=',CYMMA.ЦEHA:8:22);
  SM:=0.0;
  WHILE MOЖHO DO(
    DMLCALL(107)
    SM:=SM+BEЩЬ.ЦEHA*BЗЯЛ.KOЛИЧ);
  WRITE(OUT,'   ПOCЛE ЧИCTKИ=',SM:8:22);
  WRITELN(OUT,'   ИTOГO=',SM+CYMMA.ЦEHA:9:22);PUTT;S:=S+SM+CYMMA.ЦEHA;
  DMLCALL(108));
WRITE(OUT,'   OБЩИЙ ИTOГ:                                ',
          '                    ',S:8:22);PUTT;
END;



(* SECTION ? .ПBC *)
(*BЫДAЧA ПOЛHOГO OTЧETA ПO BCEM OTДEЛAM*)
PROCEDURE ПBC;
BEGIN
WRITE(OUT,'ПOЛHAЯ TAБЛИЦA MATEPИAЛOB ПO OTДEЛAM');ШAПKA;
DMLCALL(109)
WHILE MOЖHO DO(
  DMLCALL(110);ПEЧOT;
  DMLCALL(111));
ФЛAГИ:=ФЛAГИ+[OTЧOTД];YCTMOД;ECTЬ;
END;



(* SECTION ? .ПOT *)
(*BЫДAЧA ПOЛHOГO OTЧETA ПO OTДEЛЬHЫM OTДEЛAM*)
PROCEDURE ПOT;
BEGIN
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
YCTПEЧ;
ПEЧOT;ECTЬ;
END;



(* SECTION ? .KBC *)
(*BЫДAЧA KPATKOГO OTЧETA ПO BCEM OTДEЛAM*)
PROCEDURE KBC;
BEGIN
YCTПEЧ;
WRITE(OUT,'KPATKAЯ TAБЛИЦA MATEPИAЛOB ПO OTДEЛAM');ШAПKA;
DMLCALL(112)
WHILE MOЖHO DO(
  DMLCALL(113);ИTOГOT;
  DMLCALL(114));
ФЛAГИ:=ФЛAГИ+[OTЧOTД];YCTMOД;ECTЬ;
END;



(* SECTION ? .KOT *)
(*BЫДAЧA KPATKOГO OTЧETA ПO OTДEЛЬHЫM OTДEЛAM*)
PROCEDURE KOT;
BEGIN
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;
IF HAЧ THEN EXIT;
ИTOГOTЭ;
END;



(* SECTION ? .ПKД *)
(*ПEЧATЬ ДBИГABШИXCЯ KAPT*)
PROCEDURE ПEЧKAPДB;
BEGIN
WITH BEЩЬ DO(
WRITE(' ',ЦB(HOMEP):9:23,') ');WCTP(OUTPUT,HAЗB,32);
WRITE(' ',EД[1],EД[2],'  ');
IF ЦEHA>0.0001 THEN WRITE(ЦEHA:5:22)
               ELSE WRITE('!!!!!');
WRITE('   ',ПPИXOД:9:23,'/',ПPИXOД*ЦEHA:8:22,
      '   ',PACXOД:9:23,'/',PACXOД*ЦEHA:8:22,
      '   ',OCTAT :9:23,'/',OCTAT *ЦEHA:8:22,' ');
WCTP(OUTPUT,MATEP.HAЗB,5));WRITELN;
END;



(* SECTION ? .ПP *)
PROCEDURE ПEЧPACX;
VAR I:INT;
BEGIN
I:=0;
DMLCALL(115)
WRITE(' ',ЦB(BEЩЬ.HOMEP):9:23,') ');
WHILE MOЖHO DO(
  I:=I+1;IF (((I-1) MOD 5)=0) AND (I>1) THEN WBL(7);
  DMLCALL(116)
  WRITE('   ',OTДEЛ.HAЗB,'=',BЗЯЛ.KOЛИЧ:0:23,'/');
  IF BEЩЬ.ЦEHA<0.01 THEN WRITE('!!!!!')
          ELSE WRITE(BЗЯЛ.KOЛИЧ*BEЩЬ.ЦEHA:0:22);
  IF (I MOD 5)=0 THEN WRITELN;
  DMLCALL(117));
IF (I MOD 5)!0 THEN WRITELN;
END;



(* SECTION ? .ДBИ *)
PROCEDURE ДBИ;
BEGIN
WRITE(OUT,'TAБЛИЦA MATEPИAЛOB ПO CKЛAДY (ДBИЖEHИE)');ШAПKA;
DMLCALL(118)
IF ПYCTO THEN(WBL(55);WRITELN('HET KAPT');EXIT);
    WRITE(' HOMEP');
    WBL(13);WRITE('HAИMEHOBAHИE');
    WBL(11);WRITE('EД.ИЗM.');
    WBL(1);WRITE('ЦEHA');
    WBL(7);WRITE('ПPИXOД');
    WBL(14);WRITE('PACXOД');
    WBL(15);WRITE('OCTATOK');
    WBL(11);WRITELN('BИД');MINUSES;
REPEAT
  DMLCALL(119);ПEЧKAPДB;
  DMLCALL(120)
UNTIL ПYCTO;
(**)
WLF(3);MINUSES;WBL(43);
WRITELN('TAБЛИЦA "ЧTO БPAЛИ OTДEЛЫ"');
MINUSES;WLF(1);
DMLCALL(121)
REPEAT
  DMLCALL(122)
  IF MOЖHO THEN ПEЧPACX;
  DMLCALL(123)
UNTIL ПYCTO;
ФЛAГИ:=ФЛAГИ+[OTЧCKЛ];YCTMOД;ECTЬ;
END;



(* SECTION ? .BCE *)
PROCEDURE BCEBCE;
BEGIN
WRITE(OUT,'ПOЛHAЯ TAБЛИЦA MATEPИAЛOB ПO CKЛAДY');ШAПKA;
DMLCALL(124)
IF ПYCTO THEN(WBL(55);WRITELN('HET KAPT');EXIT);
    WRITE(' HOMEP');
    WBL(13);WRITE('HAИMEHOBAHИE');
    WBL(11);WRITE('EД.ИЗM.');
    WBL(1);WRITE('ЦEHA');
    WBL(7);WRITE('ПPИXOД');
    WBL(14);WRITE('PACXOД');
    WBL(15);WRITE('OCTATOK');
    WBL(11);WRITELN('BИД');MINUSES;
REPEAT
  DMLCALL(125);ПEЧKAPДB;
  DMLCALL(126)
UNTIL ПYCTO;
(**)
WLF(3);MINUSES;WBL(43);
WRITELN('TAБЛИЦA "ЧTO БPAЛИ OTДEЛЫ"');
MINUSES;WLF(1);
DMLCALL(127)
REPEAT
  DMLCALL(128)
  IF MOЖHO THEN ПEЧPACX;
  DMLCALL(129)
UNTIL ПYCTO;
ФЛAГИ:=ФЛAГИ+[OTЧCKЛ];YCTMOД;ECTЬ;
END;



(* SECTION ? .ИTO *)
(*KPATKИЙ ИTOГ ПO CKЛAДY HA ЭKPAH*)
PROCEDURE ИTO;
 VAR SП,SP,SO,SПM,SPM,SOM:REAL;
BEGIN
WRITE(OUT,'И T O Г    П O    C K Л A Д Y');ШAПKA;
SП:=0.0;SP:=0.0;SO:=0.0;
DMLCALL(130)
WHILE MOЖHO DO(
SПM:=0.0;SPM:=0.0;SOM:=0.0;
  DMLCALL(131)
  WCTP(OUT,MATEP.HAЗB,13);WRITE(OUT,':');
  WHILE MOЖHO DO(
    DMLCALL(132)
    SПM:=SПM+BEЩЬ.ЦEHA*BEЩЬ.ПPИXOД;
    SPM:=SPM+BEЩЬ.ЦEHA*BEЩЬ.PACXOД;
    SOM:=SOM+BEЩЬ.ЦEHA*BEЩЬ.OCTAT);
  WRITE(OUT,'  ПPИXOД=',SПM:9:22,
            '  PACXOД=',SPM:9:22,
            '  OCTATOK=',SOM:9:22);
  FWRITE(OUT);MINUSES;PUTT;
  SП:=SП+SПM;
  SP:=SP+SPM;
  SO:=SO+SOM;
  DMLCALL(133));
WRITE(OUT,'   OБЩИЙ ИTOГ:',
          '  ПPИXOД=',SП:9:22,
          '  PACXOД=',SP:9:22,
          '  OCTATOK=',SO:9:22);
FWRITE(OUT);MINUSES;PUTT;
END;



(* SECTION ? .B *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE BЫДAЧИ OTЧETOB...');PUTT;
KYДA:='HAPYЖY';
IF NOT OЦEHEHO THEN(
  WRITE(OUT,'OTЧETЫ БYДYT HE BEPHЫ ???');
  PUTT;PUTT;);
WHILE TRUE DO(
WRITE(OUT,'ДBИ - OTЧET ПO ДBИЖEHИЮ HA CKЛAДE/',
          'BCE - ПOЛHЫЙ OTЧET ПO CKЛAДY/',
          'ИTO - TEKYЩИЙ ИTOГ ПO CKЛAДY/',
          'ПBC - ПOЛHЫЙ OTЧET ПO BCEM OTДEЛAM/',
          'ПOT - ПOЛHЫЙ OTЧET ПO OTДEЛЬHЫM OTДEЛAM/',
          'KBC - KPATKИЙ OTЧET ПO BCEM OTДEЛAM/',
          'KOT - KPATKИЙ OTЧET ПO OTДEЛЬHЫM OTДEЛAM/');
MENU;
SELECT
  'ИTO'=ДИP:ИTO;
  'BCE'=ДИP:BCEBCE;
  'ДBИ'=ДИP:ДBИ;
  'ПBC'=ДИP:ПBC;
  'ПOT'=ДИP:ПOT;
  'KBC'=ДИP:KBC;
  'KOT'=ДИP:KOT;
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT);
);
END.
