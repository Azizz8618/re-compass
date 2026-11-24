(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATMON(output,BUF,BDVECT,BDERRN); (*ЗT:MOHИTOP*)
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
    237: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    238: begin
      BUF.LEN:=74;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='Ф';BUF.M[16]:='Л';
      BUF.M[17]:='A';BUF.M[18]:='Г';BUF.M[19]:='И';BUF.M[20]:=''';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';BUF.M[52]:=';';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Ф';BUF.M[71]:='Л';BUF.M[72]:='A';
      BUF.M[73]:='Г';BUF.M[74]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    239: begin
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
      BUF.M[41]:='A';BUF.M[42]:='-';BUF.M[43]:='Ц';BUF.M[44]:='E';
      BUF.M[45]:='Л';BUF.M[46]:=';';BUF.M[47]:='З';BUF.M[48]:='A';
      BUF.M[49]:='M';BUF.M[50]:='E';BUF.M[51]:='H';BUF.M[52]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    240: begin
      BUF.LEN:=152;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='Д';BUF.M[16]:='A';
      BUF.M[17]:='T';BUF.M[18]:='З';BUF.M[19]:='П';BUF.M[20]:=''';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:=' ';BUF.M[24]:='S';
      BUF.M[25]:='Y';BUF.M[26]:='-';BUF.M[27]:='П';BUF.M[28]:='A';
      BUF.M[29]:='P';BUF.M[30]:=';';BUF.M[31]:='H';BUF.M[32]:='A';
      BUF.M[33]:='Й';BUF.M[34]:='T';BUF.M[35]:='И';BUF.M[36]:=' ';
      BUF.M[37]:='П';BUF.M[38]:='E';BUF.M[39]:='P';BUF.M[40]:='B';
      BUF.M[41]:='Y';BUF.M[42]:='Ю';BUF.M[43]:=' ';BUF.M[44]:='B';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='A';BUF.M[48]:='-';
      BUF.M[49]:='Ц';BUF.M[50]:='E';BUF.M[51]:='Л';BUF.M[52]:=';';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='Ц';
      BUF.M[61]:='E';BUF.M[62]:='Л';BUF.M[63]:='.';BUF.M[64]:='З';
      BUF.M[65]:='H';BUF.M[66]:=' ';BUF.M[67]:='H';BUF.M[68]:='A';
      BUF.M[69]:=' ';BUF.M[70]:='Д';BUF.M[71]:='A';BUF.M[72]:='T';
      BUF.M[73]:='З';BUF.M[74]:='П';BUF.M[75]:=';';BUF.M[76]:=' ';
      BUF.M[77]:='H';BUF.M[78]:='A';BUF.M[79]:='Й';BUF.M[80]:='T';
      BUF.M[81]:='И';BUF.M[82]:=' ';BUF.M[83]:='П';BUF.M[84]:='O';
      BUF.M[85]:='-';BUF.M[86]:='K';BUF.M[87]:='Л';BUF.M[88]:='Ю';
      BUF.M[89]:=' ';BUF.M[90]:=''';BUF.M[91]:='П';BUF.M[92]:='A';
      BUF.M[93]:='P';BUF.M[94]:='O';BUF.M[95]:='Л';BUF.M[96]:='Ь';
      BUF.M[97]:=''';BUF.M[98]:=' ';BUF.M[99]:='B';BUF.M[100]:=' ';
      BUF.M[101]:='S';BUF.M[102]:='Y';BUF.M[103]:='-';BUF.M[104]:='П';
      BUF.M[105]:='A';BUF.M[106]:='P';BUF.M[107]:=';';BUF.M[108]:='H';
      BUF.M[109]:='A';BUF.M[110]:='Й';BUF.M[111]:='T';BUF.M[112]:='И';
      BUF.M[113]:=' ';BUF.M[114]:='П';BUF.M[115]:='E';BUF.M[116]:='P';
      BUF.M[117]:='B';BUF.M[118]:='Y';BUF.M[119]:='Ю';BUF.M[120]:=' ';
      BUF.M[121]:='B';BUF.M[122]:=' ';BUF.M[123]:='П';BUF.M[124]:='A';
      BUF.M[125]:='-';BUF.M[126]:='A';BUF.M[127]:='Л';BUF.M[128]:='Ф';
      BUF.M[129]:=';';BUF.M[130]:=' ';BUF.M[131]:='B';BUF.M[132]:='З';
      BUF.M[133]:='Я';BUF.M[134]:='T';BUF.M[135]:='Ь';BUF.M[136]:=' ';
      BUF.M[137]:='A';BUF.M[138]:='Л';BUF.M[139]:='Ф';BUF.M[140]:='.';
      BUF.M[141]:='З';BUF.M[142]:='H';BUF.M[143]:=' ';BUF.M[144]:='H';
      BUF.M[145]:='A';BUF.M[146]:=' ';BUF.M[147]:='П';BUF.M[148]:='A';
      BUF.M[149]:='P';BUF.M[150]:='O';BUF.M[151]:='Л';BUF.M[152]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    241: begin
      BUF.LEN:=59;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='П';BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='O';BUF.M[19]:='Л';BUF.M[20]:='Ь';
      BUF.M[21]:=''';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';BUF.M[52]:='Ф';
      BUF.M[53]:=';';BUF.M[54]:='З';BUF.M[55]:='A';BUF.M[56]:='M';
      BUF.M[57]:='E';BUF.M[58]:='H';BUF.M[59]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    242: begin
      BUF.LEN:=58;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:=''';BUF.M[15]:='П';BUF.M[16]:='A';
      BUF.M[17]:='P';BUF.M[18]:='C';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:=''';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='П';
      BUF.M[29]:='A';BUF.M[30]:='P';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='E';BUF.M[40]:='P';
      BUF.M[41]:='B';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='П';BUF.M[48]:='A';
      BUF.M[49]:='-';BUF.M[50]:='A';BUF.M[51]:='Л';BUF.M[52]:='Ф';
      BUF.M[53]:=';';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
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
(* L0 DMLCALL(237)*)
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
DMLCALL(238)
END;



(* SECTION ? .PЦEЛ *)
(*ЗAMEHИTЬ ПEPBOE ЗHAЧEHИE ЦEЛOГO ПAPAMETPA*)
PROCEDURE PЦEЛ(A:ALFA;I:INT);
BEGIN;DMLCALL(239)
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
DMLCALL(240)
PUTT;YCTФЛAГ;
WRITE(OUT,'         ДAHHЫE OT ');WДAT(OUT,ДATЗП);
IF OTЛAД IN ФЛAГИ THEN(
  ФЛAГИ:=ФЛAГИ+[AДMИH];CEГOДHЯ:=ДATЗП+1)
ELSE(
PUTT;PUTT;
WRITE(OUT,'       ...ЗДPABCTBYЙTE...');PUTT;
WRITE(OUT,'BЫ - AДMИHИCTPATOP!');
IF ДA THEN(
  WRITE(OUT,'ПOДTBEPДИTE ПAPOЛЬ:');GETHAЧ;
  READ(INP,PAROL);
  IF ПAPOЛЬ=PAROL THEN(
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
CEГOДHЯ:=RДAT(ДATЗП,ДATЧИC(31,12,99)));
END;



(* SECTION ? .ПAPOЛЬ *)
(*ИЗMEHEHИE ПAPOЛЯ*)
PROCEDURE ПAPOЛЬ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN EXIT;
WRITE(OUT,'COOБЩИTE HOBЫЙ ПAPOЛЬ:');GETHAЧ;
IF HAЧ THEN EXIT;
READ(INP,AЛФ.ЗH);
DMLCALL(241)
YCTMOД;ECTЬ;
END;



(* SECTION ? .БPEГ *)
(*PEГИCTPAЦИOHHЫЙ БЛOK-MEHЮ*)
PROCEDURE БЛOKPEГ;
BEGIN
IF HEЛЬЗЯ OR ЗAKPЫTO THEN(KYДA:='HAPYЖY';EXIT);
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B PEГИCTPAЦИOHHOM БЛOKE...  ');PUTT;
WRITE(OUT,'KOФ - BXOД B БЛOK PEГИCTPAЦИИ KOЭФФИЦИEHTOB/',
          'OTД - BXOД B БЛOK PEГИCTPAЦИИ OTДEЛOB/',
          'TEM - BXOД B БЛOK PEГИCTPAЦИИ TEM/',
          'ФAK - BXOД B БЛOK PEГИCTPAЦИИ ФAKTИЧ.ЗATPAT/',
          'OБЩ - BXOД B БЛOK PEГИCTPAЦИИ OБЩИX ЗATPAT/');
MENU;
SELECT
  'KOФ'=ДИP:(KYДA:='ZATCOF';EXIT);
  'OTД'=ДИP:(KYДA:='ZATOTD';EXIT);
  'TEM'=ДИP:(KYДA:='ZATRTE';EXIT);
  'ФAK'=ДИP:(KYДA:='ZATZAT';EXIT);
  'OБЩ'=ДИP:(KYДA:='ZATNAK';EXIT);
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:(KYДA:='HAPYЖY';EXIT)));
END;



(* SECTION ? .БOTЧ *)
(*БЛOK-MEHЮ BЫДAЧИ OTЧETOB*)
PROCEDURE БЛOKOTЧ;
BEGIN
IF ЗAKPЫTO THEN(KYДA:='HAPYЖY';EXIT);
IF KYДA='ZATTAB' THEN ECTЬ;
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B БЛOKE BЫДAЧИ OTЧETOB...  ');PUTT;
WRITE(OUT,'ПOC - BЫДAЧA OTЧETA ПO ПOCЛEДHEMY MECЯЦY/');
MENU;
SELECT
  'ПOC'=ДИP:(YCTПEЧ;YCTMOД;KYДA:='ZATTAB';EXIT);
  'KOH'=ДИP:(KYДA:='HAPYЖY';EXIT);
  'BЫX'=ДИP:(KYДA:='HAPYЖY';EXIT)));
END;



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



(* SECTION ? .БCИC *)
(*CИCTEMHЫЙ БЛOK*)
PROCEDURE БЛOKCИC;
VAR ПAPCИC:ALFA;
BEGIN
KYДA:='HAPYЖY';
WRITE(OUT,'ПAPOЛЬ:');GETT;
READ(INP,ПAPCИC);
DMLCALL(242)
PUTT;YCTФЛAГ;
IF AЛФ.ЗH ! ПAPCИC THEN(
  WRITE(OUT,'HE ЛEЗЬ, KYДA HE HYЖHO???');PUTT;EXIT);
PUTT;
WHILE TRUE DO(
WRITE(OUT,'      ...BЫ B CИCTEMHOM БЛOKE...  ');PUTT;
WRITE(OUT,'ФЛA - ИHBEPTИPOBAHИE ФЛAГOB/');
MENU;
SELECT
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT;
  'ФЛA'=ДИP:SETFLAG);
)
END;



(* SECTION ? .B *)
BEGIN CASE KYДA OF
'HAЧAЛO':(
WRITELN(OUT);PUTT;
RGEXPORT:=[46];
PUTT;WRITELN;
WRITE(OUT,'           **************');PUTPT;
WRITE(OUT,'           ИПC ЗATPATЫ-89');PUTPT;
WRITE(OUT,'           **************');PUTPT;
WRITELN;
IF ПYCTO THEN(
    WRITE(OUT,'CИCTEMA TPEБYET BOCCTAHOBЛEHИЯ');PUTT;
    WRITE(OUT,'COOБЩИTE AДMИHИCTPATOPY');PUTT;
    WRITE(OUT,'      ...ДO CBИДAHИЯ...');PUTT;
    DMLCALL(243);KYДA:='ЭTOBCE';EXIT);
  ПPABA);
(**)
  'ZATTAB':БЛOKOTЧ;
  'ZATZAT','ZATNAK','ZATRTE','ZATCOF','ZATOTD':БЛOKPEГ);
(**)
IF (KYДA!'HAPYЖY') AND (KYДA!'HAЧAЛO') THEN EXIT;
(**)
WHILE TRUE DO(
IF ДИP!'KOH' THEN(
WRITE(OUT,'      ...BЫ B OБЩEM БЛOKE...  ');PUTT;
(* SECTION ? .Д *)
WRITE(OUT,'PEГ - BXOД B PEГИCTPAЦИOHHЫЙ БЛOK/',
          'OTЧ - BXOД B БЛOK BЫДAЧИ OTЧETOB/',
          'ПAP - ИЗMEHEHИE ПAPOЛЯ AДMИHИCTPATOPA/',
          'ЗAK - ЗAKPEПИTЬ ИЗMEHEHИЯ/',
          'CБP - CБPOCИTЬ ИЗMEHEHИЯ/',
          'CИC - BXOД B CИCTEMHЫЙ БЛOK/');
MENU);
SELECT
  'PEГ'=ДИP:(БЛOKPEГ;IF KYДA!'HAPYЖY' THEN EXIT);
  'OTЧ'=ДИP:(БЛOKOTЧ;IF KYДA!'HAPYЖY' THEN EXIT);
  'CИC'=ДИP:(БЛOKCИC;IF KYДA!'HAPYЖY' THEN EXIT);
  'ЗAK'=ДИP:ЖYPHAЛ('ЗAK',ПPEДЗAK);
  'CБP'=ДИP:ЖYPHAЛ('CБP',ПPEДЗAK);
  'ПAP'=ДИP:ПAPOЛЬ;
  'KOH'=ДИP:(KOHEЦ(ПPEДЗAK);IF NOT HAЧ THEN(ДИP:='KOH';EXIT));
  'BЫX'=ДИP:(WRITE(OUT,
             'ECЛИ XOTИTE ЗABEPШИTЬ PAБOTY HAБEPИTE "KOH"');
             PUTT)));
END.
