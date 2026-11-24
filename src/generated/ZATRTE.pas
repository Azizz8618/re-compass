(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATRTE(output,BUF,BDVECT,BDERRN); (*ЗT:PEГИC.TEM (YCEЧEHHAЯ)*)
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
    299: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    300: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    301: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='T';
      BUF.M[9]:='E';BUF.M[10]:='M';BUF.M[11]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    302: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    303: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='Э';
      BUF.M[9]:='T';BUF.M[10]:='A';BUF.M[11]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    304: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    305: begin
      BUF.LEN:=38;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    306: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    307: begin
      BUF.LEN:=54;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';BUF.M[39]:=';';BUF.M[40]:='B';
      BUF.M[41]:='K';BUF.M[42]:='Л';BUF.M[43]:='Ю';BUF.M[44]:='Ч';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:=' ';
      BUF.M[49]:='И';BUF.M[50]:='C';BUF.M[51]:='-';BUF.M[52]:='И';
      BUF.M[53]:='C';BUF.M[54]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    308: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    309: begin
      BUF.LEN:=54;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';BUF.M[39]:=';';BUF.M[40]:='B';
      BUF.M[41]:='K';BUF.M[42]:='Л';BUF.M[43]:='Ю';BUF.M[44]:='Ч';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:=' ';
      BUF.M[49]:='И';BUF.M[50]:='C';BUF.M[51]:='-';BUF.M[52]:='И';
      BUF.M[53]:='C';BUF.M[54]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    310: begin
      BUF.LEN:=70;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='Д';BUF.M[32]:='E';
      BUF.M[33]:='Л';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='З';BUF.M[38]:='B';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:=' ';BUF.M[43]:='C';BUF.M[44]:='!';
      BUF.M[45]:='.';BUF.M[46]:='A';BUF.M[47]:='!';BUF.M[48]:=';';
      BUF.M[49]:=' ';BUF.M[50]:='H';BUF.M[51]:='A';BUF.M[52]:='Й';
      BUF.M[53]:='T';BUF.M[54]:='И';BUF.M[55]:=' ';BUF.M[56]:='П';
      BUF.M[57]:='E';BUF.M[58]:='P';BUF.M[59]:='B';BUF.M[60]:='Y';
      BUF.M[61]:='Ю';BUF.M[62]:=' ';BUF.M[63]:='B';BUF.M[64]:=' ';
      BUF.M[65]:='И';BUF.M[66]:='C';BUF.M[67]:='-';BUF.M[68]:='И';
      BUF.M[69]:='C';BUF.M[70]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    311: begin
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
    312: begin
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
    313: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    314: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    315: begin
      BUF.LEN:=38;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='Э';BUF.M[8]:='T';
      BUF.M[9]:='A';BUF.M[10]:='П';BUF.M[11]:='.';BUF.M[12]:='H';
      BUF.M[13]:='O';BUF.M[14]:='M';BUF.M[15]:='E';BUF.M[16]:='P';
      BUF.M[17]:=' ';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:=' ';
      BUF.M[21]:='C';BUF.M[22]:='!';BUF.M[23]:='.';BUF.M[24]:='Ц';
      BUF.M[25]:='!';BUF.M[26]:=';';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Й';BUF.M[30]:='T';BUF.M[31]:='И';BUF.M[32]:=' ';
      BUF.M[33]:='C';BUF.M[34]:='Л';BUF.M[35]:='E';BUF.M[36]:='Д';
      BUF.M[37]:='Y';BUF.M[38]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    316: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    317: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    318: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    319: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    320: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    321: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    322: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    323: begin
      BUF.LEN:=37;
      BUF.M[1]:='И';BUF.M[2]:='C';BUF.M[3]:='K';BUF.M[4]:='Л';
      BUF.M[5]:='Ю';BUF.M[6]:='Ч';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='И';BUF.M[11]:='C';BUF.M[12]:='-';
      BUF.M[13]:='И';BUF.M[14]:='C';BUF.M[15]:='П';BUF.M[16]:=';';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:='Й';BUF.M[20]:='T';
      BUF.M[21]:='И';BUF.M[22]:=' ';BUF.M[23]:='C';BUF.M[24]:='Л';
      BUF.M[25]:='E';BUF.M[26]:='Д';BUF.M[27]:='Y';BUF.M[28]:='Ю';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='T';
      BUF.M[33]:='E';BUF.M[34]:='-';BUF.M[35]:='И';BUF.M[36]:='C';
      BUF.M[37]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    324: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='T';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='Э';
      BUF.M[9]:='T';BUF.M[10]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    325: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='T';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='И';
      BUF.M[9]:='C';BUF.M[10]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    326: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='T';
      BUF.M[9]:='E';BUF.M[10]:='M';BUF.M[11]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  QMADX(0)
end;
(* L0 DMLCALL(299)*)
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



(* SECTION ? .ПOC *)
(*ПOCTABИTЬ KAPTY*)
PROCEDURE ПOCTAB;
VAR TEKИCП,TEKCOИ:INT;
BEGIN
RESETCON;WITH ИCПOЛH DO(HOMEP:=-1;YPOB:=-1);
REPEAT WITH CUL!.CUC! DO SELECT
BOS!.NAM='THOMK ':(TEMA.HOMEP:=Ц!;
  DMLCALL(300);IF ПYCTO THEN(DMLCALL(301)));
BOS!.NAM='TЭTAП ':(ЭTAП.HOMEP:=Ц!;
  DMLCALL(302);IF ПYCTO THEN(DMLCALL(303)));
BOS!.NAM='TИCП  ':(WITH ИCПOЛH DO(HOMEP:=HOMEP+1;TEKИCП:=HOMEP);
  DMLCALL(304);IF ПYCTO THEN(
    DMLCALL(305)));
BOS!.NAM='TCOИ  ':(WITH ИCПOЛH DO(HOMEP:=HOMEP+1;TEKCOИ:=HOMEP);
  ЦEЛ.ЗH:=TEKИCП;
  DMLCALL(306);IF ПYCTO THEN(
    DMLCALL(307)));
BOS!.NAM='TПOД  ':(WITH ИCПOЛH DO HOMEP:=HOMEP+1;
  ЦEЛ.ЗH:=TEKCOИ;
  DMLCALL(308);IF ПYCTO THEN(
    DMLCALL(309))));
UNTIL NEXTCON;
YCTMOД;
WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA');PUTT;
END;



(* SECTION ? .GT *)
(*ПPOCMOTP ДEPEBA ПOДЧИHEHHOCTИ ИCПOЛHИTEЛEЙ*)
PROCEDURE GTREE(YPOB:INT);
VAR TEKЗAП:ZZBDKEY;C:!CONTENT;
BEGIN
CASE YPOB OF
1:FINDPAR('TИCП  ');
2:FINDPAR('TCOИ  ');
3:FINDPAR('TПOД  '));
NEWCONT(C);
DMLCALL(310)
WHILE MOЖHO DO(
  DMLCALL(311);GTREE(YPOB+1);
  DMLCALL(312));
END;



(* SECTION ? .BЗЯ *)
(*BЗЯTЬ KAPTY*)
PROCEDURE BЗЯTЬ;
VAR C:!CONTENT;
BEGIN
RESETCON;
(S)REPEAT WITH CUL!.CUC! DO SELECT
BOS!.NAM='THOMK ':EXIT S);
UNTIL NEXTCON;
(**)
DMLCALL(313);IF MOЖHO THEN GTREE(1);
(**)
DMLCALL(314)
WHILE MOЖHO DO(
  FINDPAR('TЭTAП ');NEWCONT(C);
  DMLCALL(315));
END;



(* SECTION ? .HAЙ *)
(*HAЙTИ KAPTY*)
PROCEDURE HAЙTИ;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='THOMK ':(DMLCALL(316)
  IF MOЖHO THEN EXIT ELSE(
    WRITE(OUT,'HET TAKOЙ TEMЫ');PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
END;



(* SECTION ? .HOB *)
(*BBOД HOBOЙ KAPTЫ*)
PROCEDURE HOB;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='THOMK ':(
  DMLCALL(317);
  IF NOT ПYCTO THEN(
    WRITE(OUT,'YЖE ECTЬ ЭTA TEMA');
    PUTT;NEXT:=FALSE));
(NAM='TИCП  ')OR(NAM='TCOИ  ')OR(NAM='TПOД  '):(
  DMLCALL(318);
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOГO OTДEЛA');
    PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
END;



(* SECTION ? .ЭTA *)
(*BBOД HOBЫX ЭTAПOB*)
PROCEDURE ЭTA;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WRITELIST;
REPEAT
NEXT:=TRUE;
READCON(NEXT);IF HAЧ THEN EXIT;
UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
END;



(* SECTION ? .ПPO *)
(*ПPOCMOTP KAPTЫ*)
PROCEDURE ПPO;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WRITELIST;
END;



(* SECTION ? .ИCK *)
(*ИCKЛЮЧEHИE KAPTЫ*)
PROCEDURE ИCK;
PROCEDURE YHAP(H:INT);EXTERNAL;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;
DMLCALL(319)
WHILE MOЖHO DO(
  DMLCALL(320)
  IF NOT ПYCTO THEN(WRITE(OUT,
    'CHAЧAЛA HAДO ИCKЛЮЧИTЬ BCE ЗATPATЫ ПO TEME');PUTT;EXIT);
  DMLCALL(321));
IF NOT CONFIRM THEN EXIT;
DMLCALL(322)
WHILE MOЖHO DO(DMLCALL(323));
YHAP(DMLCALL(324));YHAP(DMLCALL(325));DMLCALL(326)
YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
FIL:=NIL;LOADLIST('CП-TEM');FINDLIST('CП-TEM');
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ TEM...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ЭTA - ДOБABЛEHИE B TEMY HOBЫX ЭTAПOB/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
MENU;
SELECT
  'ЭTA'=ДИP:ЭTA;
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
