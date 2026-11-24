program genmadrun(output, BDVECT, BDERRN);
(* GENZAG + MAD port, extended: decks 3/8/9 full command set. *)
(* W5b: compiled as PERSO at 3370. MADX executes MAD text
   placed by the caller in the common BUF.M string. *)
type word = record case integer of
       0:(i:integer); 1:(a:alfa); 2:(c:char) end;
     TYPEM = packed array[1..256] of char;
     ZZBUFT = record LEN,H,D,I:integer; M,MV:TYPEM end;
     valt = array[1..4] of integer;
     v8t = array[1..8] of integer;
     lint = packed array[1..72] of char;
     txtt = packed array[1..24] of char;
var BDVECT: array[0..167] of word; BDERRN:integer;
    BUF: ZZBUFT;
    ln:lint; tok,t1:alfa; sep:char; p:integer;
    fn:array[1..8] of alfa; rc:array[1..8] of integer;
    nf,cf,cnt,tl,mode,i,j,kk:integer; dc:char;
    txt:txtt; v:valt; w:word; key:alfa;
    op:array[1..32] of integer; pre:alfa;
    nc,cur,mx:integer; loaded:boolean;
    o2:array[1..16] of integer;
    x1,x2,l2:array[1..16] of alfa;
    nm,ns,ss,coc,pc:integer;
    sn:array[1..8] of alfa; sp:array[1..8] of alfa;
    sc:array[1..8] of integer; sm:array[1..8] of integer;
    bf:array[1..8] of alfa;
    ck:alfa; bv:array[1..8] of alfa;
    v8:v8t; curbuf:integer;
    bufMode:boolean; bm:array[1..257] of char;
    bp,blen:integer;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbd; external;
function EXN:integer;
begin EXN:=BDERRN end;
procedure ClrErr;
begin BDERRN:=0 end;
procedure Next;
var i:integer; c:char; stop:boolean;
begin
  while (p<=72) and (ln[p]=' ') do p:=p+1;
  while (p<=72) and ((ln[p]=':') or (ln[p]=';') or
        (ln[p]=',') or (ln[p]='.')) do p:=p+1;
  for i:=1 to 6 do tok[i]:=' ';
  sep:=' ';
  if p>72 then exit;
  c:=ln[p];
  if (c='*') or (c=']') or (c='[') or (c=chr(38)) or
     (c='"') or (c='_') then begin sep:=c; p:=p+1; exit end;
  i:=0; stop:=false;
  while (p<=72) and (i<6) and not stop do begin
    c:=ln[p];
    if (c=' ') or (c='_') or (c='*') or (c=']') or
       (c='[') or (c=chr(38)) or (c='"') or (c=':') or
       (c=';') or (c=',') or (c='.') then stop:=true
    else begin i:=i+1; tok[i]:=c; p:=p+1 end
  end
end;
function FindFmt(t:alfa):integer;
var i:integer;
begin
  FindFmt:=0;
  for i:=1 to nf do if fn[i]=t then FindFmt:=i
end;
procedure MakeKey(var k:alfa; q:integer);
var a,b:integer;
begin
  k[1]:=dc;
  if cf<10 then k[2]:=chr(48+cf) else k[2]:=chr(55+cf);
  a:=q div 1000; b:=q-a*1000;
  k[3]:=chr(48+a); a:=b div 100; b:=b-a*100;
  k[4]:=chr(48+a); a:=b div 10; b:=b-a*10;
  k[5]:=chr(48+a); k[6]:=chr(48+b)
end;
procedure MKey(q:integer);
var a,b:integer;
begin
  key[1]:=pre[1]; key[2]:=pre[2];
  a:=q div 1000; b:=q-a*1000;
  key[3]:=chr(48+a); a:=b div 100; b:=b-a*100;
  key[4]:=chr(48+a); a:=b div 10; b:=b-a*10;
  key[5]:=chr(48+a); key[6]:=chr(48+b)
end;
procedure Add;
var i:integer; done:boolean;
begin
  done:=false;
  if (tl>0) and (tl<24) then begin tl:=tl+1; txt[tl]:='_' end;
  i:=1;
  while (i<=6) and (tl<24) and not done do begin
    if tok[i]=' ' then done:=true
    else begin tl:=tl+1; txt[tl]:=tok[i]; i:=i+1 end
  end
end;
procedure UseTok;
begin
  cnt:=cnt+1;
  if mode=2 then Add
end;
procedure Emit;
var j,k:integer;
begin
  rc[cf]:=rc[cf]+1;
  MakeKey(key,rc[cf]);
  for j:=1 to 4 do begin
    for k:=1 to 6 do w.a[k]:=' ';
    for k:=1 to 6 do w.a[k]:=txt[(j-1)*6+k];
    v[j]:=w.i
  end;
  ClrErr;
  putd(key,v);
  write('PUTD ',key,' ');
  for j:=1 to 24 do write(txt[j]);
  writeln
end;
procedure WriteDir;
var i:integer;
begin
  for i:=1 to nf do if rc[i]>0 then begin
    cf:=i; MakeKey(key,0);
    v[1]:=rc[i]; v[2]:=i; v[3]:=0; v[4]:=0;
    ClrErr; putd(key,v);
    write('DIR ',key,' ',rc[i],' '); writeln(fn[i])
  end
end;
procedure Exec;
var i,j:integer;
begin
  MKey(0); ClrErr; getd(key,v);
  if BDERRN<>0 then begin
    writeln('DIR ERR ',BDERRN); mx:=0
  end else mx:=v[1];
  writeln('QUERY ',pre[1],pre[2],' N=',mx);
  i:=1;
  while i<=nc do begin
    if op[i]=1 then begin cur:=1; loaded:=false; i:=i+1 end
    else if op[i]=2 then begin
      MKey(cur); ClrErr; getd(key,v);
      if BDERRN<>0 then begin
        writeln('GET ERR ',BDERRN); loaded:=false
      end else loaded:=true;
      i:=i+1
    end else if op[i]=3 then begin
      if loaded then begin
        write(cur,' ',key,' ');
        for j:=1 to 4 do begin w.i:=v[j]; write(w.a) end;
        writeln
      end else writeln('ПУСТО');
      i:=i+1
    end else if op[i]=4 then begin
      if cur<mx then begin
        cur:=cur+1; loaded:=false;
        j:=1;
        while (j<=nc) and (op[j]<>2) do j:=j+1;
        i:=j
      end else begin writeln('KOHEЦ ПEPEБOPA'); i:=nc+1 end
    end else i:=nc+1
  end
end;
(* ---------------- extended full-MAD machine ---------------- *)
function FindSet(t:alfa):integer;
var z:integer;
begin
  FindSet:=0;
  for z:=1 to ns do if sn[z]=t then FindSet:=z
end;
function FindLab(t:alfa):integer;
var z:integer;
begin
  FindLab:=0;
  for z:=1 to nm do if l2[z]=t then FindLab:=z
end;
(* An absent MAD label ends the snippet. *)
procedure JumpTo(t:alfa);
var q:integer;
begin
  q:=FindLab(t);
  if (q>=1) and (q<=nm) then pc:=q-1 else pc:=nm+1
end;
procedure KeyAt(s,q:integer);
var a,b:integer;
begin
  ck[1]:=sp[s][1]; ck[2]:=sp[s][2];
  a:=q div 1000; b:=q-a*1000;
  ck[3]:=chr(48+a); a:=b div 100; b:=b-a*100;
  ck[4]:=chr(48+a); a:=b div 10; b:=b-a*10;
  ck[5]:=chr(48+a); ck[6]:=chr(48+b)
end;
procedure NumKey;
begin
  sc[ss]:=(ord(ck[3])-48)*1000+(ord(ck[4])-48)*100+
          (ord(ck[5])-48)*10+(ord(ck[6])-48)
end;
procedure LoadRec(bno:integer);
var k:integer;
begin
  ClrErr; getd(ck,v8);
  if BDERRN<>0 then coc:=1 else begin
    coc:=0;
    for k:=1 to 8 do begin w.i:=v8[k]; bf[(bno-1)*8+k]:=w.a end
  end
end;
procedure SaveRec(bno:integer);
var k:integer;
begin
  for k:=1 to 8 do begin w.a:=bf[(bno-1)*8+k]; v8[k]:=w.i end;
  ClrErr; modd(ck,v8)
end;
procedure PrintLit(s:alfa);
var z,z1,z2:integer;
begin
  z1:=1; z2:=6;
  while (z1<=6) and (s[z1]=' ') do z1:=z1+1;
  if z1>6 then begin for z:=1 to 6 do write(' '); exit end;
  while (z2>=1) and (s[z2]=' ') do z2:=z2-1;
  for z:=z1 to z2 do write(s[z])
end;
procedure LoadData;
var k,z:integer; q:integer;
begin
  q:=(ord(ln[2])-48)*1000+(ord(ln[3])-48)*100+
     (ord(ln[4])-48)*10+(ord(ln[5])-48);
  key[1]:=sp[ss][1]; key[2]:=sp[ss][2];
  key[3]:=ln[2]; key[4]:=ln[3]; key[5]:=ln[4]; key[6]:=ln[5];
  for k:=1 to 8 do begin
    for z:=1 to 6 do w.a[z]:=ln[6*k+z-1];
    v8[k]:=w.i
  end;
  ClrErr; putd(key,v8);
  if q>sm[ss] then sm[ss]:=q
end;
(* The application string is split on ';' into ordinary MAD cards.  The
   original ReadMad2 parser is then reused unchanged for every card. *)
procedure NextBufLine(var ok:boolean);
var i:integer;
begin
  ok:=false;
  if bp>blen then exit;
  i:=1;
  while (bp<=blen) and (bm[bp]<>';') and (i<=72) do begin
    ln[i]:=bm[bp]; bp:=bp+1; i:=i+1
  end;
  if (bp<=blen) and (bm[bp]=';') then bp:=bp+1;
  while i<=72 do begin ln[i]:=' '; i:=i+1 end;
  ok:=true
end;
procedure ReadMad2;
label 2,3;
var z:integer; s:alfa; ok:boolean;
begin
  nm:=0;
  while bp<=blen do begin
    NextBufLine(ok);
    if not ok then goto 2;
    if ln[1]='#' then goto 2;
    if ln[1]='?' then goto 3;
    p:=1; Next;
    if tok[1]='S' then begin
      Next; s:=tok; Next;
      ns:=ns+1; sn[ns]:=s; sp[ns]:=tok; sc[ns]:=0; sm[ns]:=0; ss:=ns;
      writeln('SET ',sn[ns],' ',sp[ns]);
      goto 3
    end;
    if tok[1]='L' then begin
      Next; nm:=nm+1; o2[nm]:=0; l2[nm]:=tok; goto 3
    end;
    nm:=nm+1; l2[nm]:='      '; x2[nm]:='      ';
    if tok='HAЙTИ ' then begin
      Next;
      if tok='ПEPBYЮ' then o2[nm]:=1
      else if tok='CЛEДYЮ' then o2[nm]:=2
      else if tok='ПPEДЫД' then o2[nm]:=3
      else if tok='ПOCЛEД' then o2[nm]:=4
      else if tok='BЛAДEЛ' then o2[nm]:=5
      else o2[nm]:=6;
      Next;
      if tok='B     ' then Next;  (* B = 'in' before a set name. *)
      x1[nm]:=tok
    end else if tok='BЗЯTЬ ' then begin
      Next;
      if tok[1]='Б' then begin o2[nm]:=8; Next; x1[nm]:=tok end
      else begin o2[nm]:=7; x1[nm]:=tok end
    end else if tok='ЗAMEHИ' then begin
      Next; Next; o2[nm]:=9; x1[nm]:=tok
    end else if (tok='BЫДATЬ') or (tok='BB    ') then begin
      o2[nm]:=10
    end else if tok='ECЛИ  ' then begin
      Next; s:=tok;
      if s[4]='<' then begin o2[nm]:=14; Next; Next; x1[nm]:=tok end
      else begin o2[nm]:=13; Next; Next; x1[nm]:=tok end
    end else if tok[1]='K' then begin
      Next; s:=tok;
      if s<>'      ' then begin o2[nm]:=23; x1[nm]:=s end
      else o2[nm]:=17
    end else if tok='KOHEЦ ' then begin o2[nm]:=18
    end else if (tok='CБPOCИ') or (tok='ЗABEPШ') or
                (tok='PEЖИM ') or (tok='ЖYPHAЛ') or
                (tok='ПOДCXE') or (tok='ДЛЯ-BЫ') then begin
      o2[nm]:=19
    end else if tok[1]='П' then begin
      if tok[2]='Л' then begin
        o2[nm]:=20;
        for z:=1 to 6 do x1[nm][z]:=ln[z+2]
      end else if tok[2]='П' then begin
        o2[nm]:=21; x1[nm][1]:=ln[3]; x2[nm][1]:=ln[4]
      end else o2[nm]:=22
    end else o2[nm]:=19;
3:
  end;
2:
end;
procedure MadExec2;
var z,bno,wn:integer;
begin
  coc:=0; pc:=1; curbuf:=1;
  writeln('MAD FULL: instructions=',nm,' sets=',ns);
  while pc<=nm do begin
    z:=o2[pc];
    if (z>=2) and (z<=4) then begin
      if x1[pc]<>'      ' then begin
        kk:=FindSet(x1[pc]); if kk<>0 then ss:=kk
      end
    end;
    if z=1 then begin
      ss:=FindSet(x1[pc]); if ss=0 then ss:=1;
      sc[ss]:=1; KeyAt(ss,1); coc:=0;
      writeln('FIND FIRST ',sn[ss],' N=',sm[ss])
    end else if z=2 then begin
      sc[ss]:=sc[ss]+1;
      if sc[ss]<=sm[ss] then begin KeyAt(ss,sc[ss]); coc:=0 end
      else begin coc:=1; writeln('FIND NEXT END') end
    end else if z=3 then begin
      sc[ss]:=sc[ss]-1;
      if sc[ss]>=1 then begin KeyAt(ss,sc[ss]); coc:=0 end else coc:=1
    end else if z=4 then begin
      sc[ss]:=sm[ss];
      if sc[ss]>=1 then begin KeyAt(ss,sc[ss]); coc:=0 end else coc:=1
    end else if z=5 then begin
      ss:=FindSet(x1[pc]); if ss=0 then ss:=1;
      if bf[(curbuf-1)*8+8]<>'      ' then begin
        ck:=bf[(curbuf-1)*8+8]; NumKey; coc:=0
      end else coc:=1;
      writeln('FIND OWNER ',sn[ss],' KEY=',ck)
    end else if z=6 then begin
      ss:=FindSet(x1[pc]); if ss=0 then ss:=1;
      ck:=bf[(curbuf-1)*8+8]; NumKey; LoadRec(1)
    end else if z=7 then begin
      bno:=ord(x1[pc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      curbuf:=bno; LoadRec(bno)
    end else if z=8 then begin
      bno:=ord(x1[pc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      bv[bno]:=bf[(curbuf-1)*8+6]
    end else if z=9 then begin
      bno:=ord(x1[pc][1])-48; if (bno<1) or (bno>8) then bno:=1;
      bf[(curbuf-1)*8+6]:=bv[bno]; SaveRec(curbuf)
    end else if z=20 then PrintLit(x1[pc])
    else if z=21 then begin
      bno:=ord(x1[pc][1])-48; wn:=ord(x2[pc][1])-48;
      if (bno>=1) and (bno<=8) and (wn>=1) and (wn<=8) then
        write(bf[(bno-1)*8+wn])
    end else if z=22 then writeln
    else if z=13 then begin if coc=0 then JumpTo(x1[pc]) end
    else if z=14 then begin if coc<>0 then JumpTo(x1[pc]) end
    else if z=15 then begin
      if coc=0 then JumpTo(x1[pc]) else JumpTo(x2[pc])
    end else if z=16 then begin
      if coc<>0 then JumpTo(x1[pc]) else JumpTo(x2[pc])
    end else if z=18 then pc:=nm+1
    else if z=23 then JumpTo(x1[pc]);
    pc:=pc+1
  end;
  writeln('MAD FULL EX=',EXN)
end;

(* W5b external entry.  The caller places MAD text in common
   BUF.M with length in BUF.LEN; no second parser is added. *)
(*=e+*)procedure MADX;
var i:integer;
begin
  bufMode:=true;
  blen:=BUF.LEN;
  if blen<1 then blen:=1;
  if blen>256 then blen:=256;
  for i:=1 to blen do bm[i]:=BUF.M[i];
  bm[blen+1]:='#';
  bp:=1;
  ReadMad2;
  MadExec2;
  bufMode:=false
end;
begin
end.
