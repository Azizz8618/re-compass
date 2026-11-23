program genmad(output, input, BDVECT, BDERRN);
label 9,10;
(* GENZAG + MAD port; one process, MARS state lives in memory. *)
type word = record case integer of
       0:(i:integer); 1:(a:alfa) end;
     valt = array[1..4] of integer;
     lint = packed array[1..72] of char;
     txtt = packed array[1..24] of char;
var BDVECT: array[0..167] of word; BDERRN:integer;
    ln:lint; tok,t1:alfa; sep:char; p:integer;
    fn:array[1..16] of alfa; rc:array[1..16] of integer;
    nf,cf,cnt,tl,mode,i,j,kk:integer; dc:char;
    txt:txtt; v:valt; w:word; key:alfa;
    op:array[1..32] of integer; pre:alfa;
    nc,cur,mx:integer; loaded:boolean;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;
function EXN:integer;
begin EXN:=BDERRN end;
procedure ClrErr;
begin pasbdi; BDERRN:=0 end;
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
procedure ReadOps;
label 2;
begin
  nc:=0;
  while not eof(input) do begin
    readln(ln); p:=1; Next;
    if tok='KOHEЦ ' then begin nc:=nc+1; op[nc]:=5; goto 2 end;
    if tok='HAЙTИ ' then begin
      Next; nc:=nc+1;
      if tok='ПEPBYЮ' then op[nc]:=1 else op[nc]:=4
    end else if tok='BЗЯTЬ ' then begin
      nc:=nc+1; op[nc]:=2
    end else if tok='BЫДATЬ' then begin
      nc:=nc+1; op[nc]:=3
    end;
  end;
2:
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
procedure MadRun;
begin
  mx:=0; cur:=0; loaded:=false;
  while not eof(input) do begin
    readln(ln); p:=1; Next;
    if tok='P     ' then begin
      Next; pre:=tok;
      ReadOps; Exec
    end
  end
end;
begin
  if BDVECT[36].i + 0 = 0 then begin
    for j:=0 to 167 do BDVECT[j].i:=0;
    i:=20270000c; PASACD(i); PASSETAR(270000c)
  end;
  i:=20270001c;
  newd('ZGEN  ',i);
  ClrErr;
  opend('ZGEN  ');
  ClrErr;
  writeln('INIT EX=',EXN);
  nf:=0; mode:=0; dc:='6';
  for i:=1 to 16 do rc[i]:=0;
  while not eof(input) do begin
    readln(ln);
    if ln[1]='#' then goto 10;
    if ln[1]='@' then begin
      WriteDir;
      dc:=ln[7]; nf:=0; mode:=0;
      for i:=1 to 16 do rc[i]:=0;
      writeln('DECK ',dc);
      goto 9
    end;
    p:=1; cnt:=0; tl:=0;
    Next;
    if sep=chr(38) then goto 9;
    if tok='ФOPMAT' then begin
      Next; nf:=nf+1; fn[nf]:=tok; cf:=nf; mode:=1;
      writeln('FMT ',tok);
      goto 9
    end;
    if tok='KOHEЦ ' then begin mode:=0; goto 9 end;
    if tok='ПACKAЛ' then goto 9;
    if tok<>'      ' then begin
      t1:=tok; Next;
      if sep='[' then begin
        cf:=FindFmt(t1);
        if cf=0 then cf:=nf;
        mode:=2;
        writeln('BLK ',t1)
      end else begin
        tok:=t1; UseTok
      end
    end;
    while p<=72 do begin
      Next;
      if sep=chr(38) then goto 9;
      if (sep='*') or (sep=']') then begin
        if (mode=2) and (tl>0) then Emit;
        tl:=0;
        if sep=']' then mode:=0
      end else if tok<>'      ' then UseTok
    end;
    if (mode=1) and (cnt>0) then writeln('FLD ',cnt);
9:
  end;
  WriteDir;
  writeln('GEN EX=',EXN);
10:
  WriteDir;
  writeln('GEN EX=',EXN);
  MadRun;
  writeln('MAD EX=',EXN)
end.
