(*=y+,s0,s7*)program ttc15(output, input, BDVECT, BDERRN, PIC);
(* Minimal TTC translator for the CX-CK0 schema.
   Reads YOD operators from INPUT, builds type/record/set descriptors,
   writes descriptors into MARS areas CXHD/CXFL/CXAT. *)
type
  word = record case integer of 0:(i:integer); 1:(a:alfa) end;
  Lint = packed array [1..72] of char;
  Dta  = packed array [1..36] of char;
  Num8 = packed array [1..8] of char;
var
  BDVECT: array [0..167] of word;
  BDERRN: integer;
  PIC: integer;
  ln: Lint;
  p, i, j, k: integer;
  kw, a, b, c, q, w, pol: alfa;
  num: Num8;
  cur, nerr: integer;
  tn, tb, ts: array [1..20] of alfa;
  tcnt: integer;
  rn: array [1..20] of alfa;
  rf, rt, rs, rm: array [1..240] of alfa;
  rcnt: array [1..20] of integer;
  rnum: integer;
  sn, sm, so: array [1..20] of alfa;
  sa, sv: array [1..240] of alfa;
  scnt: array [1..20] of integer;
  snum: integer;
  done, ign: boolean;
  d: Dta;
procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
function IsBlank(s:alfa):boolean;
var j:integer; t:boolean;
begin _(
  t := true;
  for j:=1 to 6 do if s[j] <> ' ' then t := false;
  IsBlank := t
_); end;
procedure Clr(var s:alfa);
var j:integer;
begin _( for j:=1 to 6 do s[j]:=' ' _); end;
procedure Skip;
begin _( while (p <= 72) and (ln[p]=' ') do p := p+1 _); end;
procedure Tok(var t:alfa);
var j:integer;
begin _(
  Clr(t); Skip; j := 1;
  while (p <= 72) and (j <= 6) and (ln[p]<>' ') and (ln[p]<>':') and
        (ln[p]<>';') and (ln[p]<>',') and (ln[p]<>'.') and
        (ln[p]<>'?') and (ln[p]<>'*') do begin
    t[j] := ln[p]; p := p+1; j := j+1
  end;
  while (p <= 72) and (ln[p]<>' ') and (ln[p]<>':') and
        (ln[p]<>';') and (ln[p]<>',') and (ln[p]<>'.') and
        (ln[p]<>'?') and (ln[p]<>'*') do p := p+1
_); end;
procedure GetNum(var z:Num8);
var j:integer;
begin _(
  for j:=1 to 8 do z[j]:=' ';
  Skip; j := 1;
  while (p <= 72) and (ln[p] >= '0') and (ln[p] <= '9') and
        (j <= 8) do begin
    z[j] := ln[p]; p := p+1; j := j+1
  end
_); end;
procedure Copy6(src:Num8; var dst:alfa);
var j:integer;
begin _( for j:=1 to 6 do dst[j] := src[j] _); end;
procedure Put6(var x:Dta; o:integer; s:alfa);
var j:integer;
begin _( for j:=1 to 6 do x[o+j-1] := s[j] _); end;
procedure ClearD;
var j:integer;
begin _( for j:=1 to 36 do d[j]:=' ' _); end;
procedure Key2(base:alfa; idx:integer; var key:alfa);
var j:integer;
begin _(
  for j:=1 to 6 do key[j] := base[j];
  key[5] := chr(ord('0') + (idx div 10));
  key[6] := chr(ord('0') + (idx mod 10))
_); end;
procedure InitMars;
var iw:integer;
begin _(
  iw := 20270000c; PASACD(iw); PASSETAR(270000c);
  pasbdi; BDERRN := 0;
  iw := 2270000c + 1c; newd('CXHD  ', iw);
pasbdi; BDERRN := 0;
  iw := 2270000c + 2c; newd('CXFL  ', iw);
pasbdi; BDERRN := 0;
  iw := 2270000c + 3c; newd('CXAT  ', iw);
pasbdi; BDERRN := 0
_); end;
procedure PutHere(key:alfa);
begin _(
  putd(key, d);
  if BDERRN <> 0 then begin
    nerr := nerr+1;
    writeln('MARS ERR ', BDERRN, ' KEY=', key)
  end;
  pasbdi; BDERRN := 0
_); end;
procedure AddType;
begin _(
  if tcnt < 20 then begin
    tcnt := tcnt+1;
    Tok(q); tn[tcnt] := q;
    Tok(q); tb[tcnt] := q;
    Clr(w); ts[tcnt] := w;
    Tok(q);
    if q = 'PAЗMEP' then begin
      GetNum(num); Copy6(num, w); ts[tcnt] := w
    end
  end
_); end;
procedure AddRec;
begin _(
  if rnum < 20 then begin
    rnum := rnum+1;
    Tok(q); rn[rnum] := q; rcnt[rnum] := 0; cur := 2
  end
_); end;
procedure AddSet;
begin _(
  if snum < 20 then begin
    snum := snum+1;
    Tok(q); sn[snum] := q;
    Clr(w); sm[snum] := w; so[snum] := w;
    scnt[snum] := 0; cur := 3
  end
_); end;
procedure AddFld;
begin _(
  if (cur = 2) and (rnum > 0) then
    if rcnt[rnum] < 12 then begin
      rcnt[rnum] := rcnt[rnum]+1;
      k := rcnt[rnum];
      Tok(q); rf[(rnum-1)*12+k] := q;
      Tok(q); rt[(rnum-1)*12+k] := q;
      Clr(w); rs[(rnum-1)*12+k] := w; rm[(rnum-1)*12+k] := w;
      Tok(q);
      if q = 'PAЗMEP' then begin
        GetNum(num); Copy6(num, w); rs[(rnum-1)*12+k] := w;
        Tok(q)
      end;
      if q = 'KOHCИM' then rm[(rnum-1)*12+k] := q
    end
_); end;
procedure AddAtt(x,y:alfa);
begin _(
  if (cur = 3) and (snum > 0) then
    if scnt[snum] < 12 then begin
      scnt[snum] := scnt[snum]+1;
      k := scnt[snum];
      sa[(snum-1)*12+k] := x; sv[(snum-1)*12+k] := y;
      if x = 'YПOPЯД' then sm[snum] := y;
      if x = 'BЛAДEЛ' then so[snum] := y;
      if x = 'ЧЛEH  ' then sm[snum] := y
    end
_); end;
procedure AttrLine;
var x,y:alfa; more:boolean;
begin _(
  more := true;
  while (p <= 72) and more do begin
    Tok(x);
    if IsBlank(x) then more := false else
    if x = 'YПOPЯД' then begin
      Tok(y); AddAtt(x,y);
      Tok(y); if not IsBlank(y) then AddAtt(pol, y)
    end else begin
      Tok(y);
      if IsBlank(y) then more := false else AddAtt(x,y)
    end
  end
_); end;
procedure StoreAll;
begin _(
  opend('CXHD  ');
  for i:=1 to tcnt do begin
    ClearD; Put6(d,1,'TYP   '); Put6(d,7,tn[i]);
    Put6(d,13,tb[i]); Put6(d,19,ts[i]);
    PutHere(tn[i])
  end;
  opend('CXHD  ');
  for i:=1 to rnum do begin
    ClearD; Put6(d,1,'REC   '); Put6(d,7,rn[i]);
    Clr(q);
    q[5] := chr(ord('0')+(rcnt[i] div 10));
    q[6] := chr(ord('0')+(rcnt[i] mod 10));
    Put6(d,13,q);
    PutHere(rn[i]);
    opend('CXFL  ');
    for j:=1 to rcnt[i] do begin
      ClearD; Put6(d,1,rf[(i-1)*12+j]); Put6(d,7,rt[(i-1)*12+j]);
      Put6(d,13,rs[(i-1)*12+j]); Put6(d,19,rm[(i-1)*12+j]);
      Key2(rn[i],j,q); PutHere(q)
    end
  end;
  opend('CXHD  ');
  for i:=1 to snum do begin
    ClearD; Put6(d,1,'SET   '); Put6(d,7,sn[i]);
    Put6(d,13,sm[i]); Put6(d,19,so[i]);
    PutHere(sn[i]);
    opend('CXAT  ');
    for j:=1 to scnt[i] do begin
      ClearD; Put6(d,1,sa[(i-1)*12+j]); Put6(d,7,sv[(i-1)*12+j]);
      Key2(sn[i],j,q); PutHere(q)
    end
  end
_); end;
procedure Verify;
begin _(
  ClearD; opend('CXHD  ');
getd(tn[1], d);
  writeln('RD HD1=', d);
  ClearD; getd(rn[1], d);
  writeln('RD HD2=', d);
  ClearD; opend('CXFL  '); getd('ВЕЩЬ01', d);
  writeln('RD FL1=', d);
  ClearD; opend('CXAT  '); getd('SY-B01', d);
  writeln('RD AT1=', d);
  pasbdi; BDERRN := 0
_); end;
procedure PrintAll;
begin _(
  writeln('=== TYPES ', tcnt, ' ===');
  for i:=1 to tcnt do
    writeln(' ', tn[i], ' BASE=', tb[i], ' SZ=', ts[i]);
  writeln('=== RECORDS ', rnum, ' ===');
  for i:=1 to rnum do begin
    writeln(' ', rn[i], ' FIELDS=', rcnt[i]);
    for j:=1 to rcnt[i] do
      writeln('   ', rf[(i-1)*12+j], ' ', rt[(i-1)*12+j],
              ' ', rs[(i-1)*12+j], ' ', rm[(i-1)*12+j])
  end;
  writeln('=== SETS ', snum, ' ===');
  for i:=1 to snum do begin
    writeln(' ', sn[i], ' MEMBER=', sm[i], ' OWNER=', so[i],
            ' ATT=', scnt[i]);
    for j:=1 to scnt[i] do
      writeln('   ', sa[(i-1)*12+j], ' ', sv[(i-1)*12+j])
  end
_); end;
begin
  InitMars;
  tcnt := 0; rnum := 0; snum := 0; cur := 0; nerr := 0;
  done := false; pol := 'ПОЛЕ  ';
  writeln('TTC15 CX-CK0');
  while not eof(input) and not done do begin
    for j:=1 to 72 do ln[j] := ' ';
    readln(ln);
    p := 1; Skip;
    ign := (p > 72) or (ln[p]='?') or (ln[p]='*');
    if not ign then begin
      Tok(kw);
      if (kw='KOHEЦ.') or (kw='KOHEЦ ') then done := true else
      if kw = 'TИП   ' then AddType else
      if kw = 'ЗAПИCЬ' then AddRec else
      if kw = 'HAБOP ' then AddSet else
      if kw = 'OБЛACT' then Tok(a) else
      if kw = 'ЭЛ    ' then AddFld else
      if (kw='ЧЛEH  ') or (kw='BЛAДEЛ') or (kw='ПPИBЯЗ') or
         (kw='YПOPЯД') or (kw='ИCKЛЮЧ') or (kw='BKЛЮЧE') or
         (kw='ДYБЛИK') or (kw='KOHCИM') or (kw='BPYЧHY') then begin
        p := 1; AttrLine
      end
    end
  end;
  StoreAll;
  Verify;
  PrintAll;
  writeln('SAVED=', tcnt+rnum+snum, ' MARSERR=', nerr);
  writeln('EXN=', BDERRN)
end.
