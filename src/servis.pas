(*=y+,s0,s7*)program servis(output, input, BDVECT, BDERRN, PIC);
(* SERVIS - minimal processor of SERVIS statements on BESM-6.
   Ported from PC module TSERVIS.PAS (TURK.ARJ~, 30708 bytes).
   Area storage is MARS via PASACD/PASSETAR/NEWD/OPEND/PUTD/GETD.
   The catalog area 'SERVIS' holds one 72-word record per area:
   [1] code, [2] length, [3] capture flag, [4] kind,
   [5..8] reserved, [9..72] free-page table (SSPUS = 2040).
   PIC is kept as a COMMON placeholder for compatibility with the
   original PROGRAM header; it is not used by this minimal port. *)
type
  word = record case integer of
    0:(i:integer);
    1:(a:alfa)
  end;
  RecT = array [1..72] of integer;
  LinT = packed array [1..72] of char;
var
  BDVECT: array [0..167] of word;
  BDERRN: integer;
  PIC: integer;
  ln: LinT;
  r: RecT;
  k, kw: alfa;
  p, ncode, ncnt, len: integer;
  nms: array [1..64] of alfa;

procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;

function EXN:integer;
begin
  EXN := BDERRN
end;

(* PASBDI resets the sticky MARS error word. *)
procedure ClrErr;
begin
  _(
  pasbdi;
  BDERRN := 0
  _);
end;

procedure Init;
var i,j:integer;
begin
  _(
  (* PASCOMPL 15.1 miscompiles a plain '= 0' test here. *)
  if BDVECT[36].i + 0 = 0 then begin
    for j := 0 to 167 do BDVECT[j].i := 0;
    i := 1270000c;
    PASACD(i);
    PASSETAR(270000c)
  end;
  pasbdi;
  BDERRN := 0;
  i := 1270001c;
  newd('SERVIS', i);
  ClrErr
  _);
end;

(* SETFL/CLFL of TSERVIS replaced by MARS catalog operations. *)
procedure SETFL(a:integer);
begin
  _(
  if a = 0 then opend('SERVIS');
  if a = 2 then opend('SERVIS')
  _);
end;

procedure CLFL(a:integer);
begin
end;

(* Catalog of areas created in this run; avoids noisy MARS misses. *)
function Kfind(name:alfa):boolean;
var i:integer;
begin
  _(
  Kfind := false;
  for i := 1 to ncnt do
    if nms[i] = name then Kfind := true
  _);
end;

procedure Err84;
begin
  writeln('ОШИБКА 84: НЕПРАВИЛЬНОЕ ПЕРВОЕ СЛОВО')
end;

procedure Err78;
begin
  writeln('ОШИБКА 78: НЕ УКАЗАН ОБЪЕКТ')
end;

procedure Err64;
begin
  writeln('ОШИБКА 64: НЕТ ДВОЕТОЧИЯ ИЛИ ;')
end;

procedure Err76;
begin
  writeln('ОШИБКА 76: НЕДОПУСТИМОЕ СЛОВО')
end;

procedure Err3;
begin
  writeln('ОШИБКА 3: ОБЛАСТЬ НЕ ОПРЕДЕЛЕНА')
end;

procedure Err80;
begin
  writeln('ОШИБКА 80: ОБЪЕКТ УЖЕ ЕСТЬ')
end;

procedure Skip;
begin
  _(
  while (p < 72) and (ln[p] = ' ') do p := p + 1
  _);
end;

(* First six significant characters of the current token. *)
function Tok:alfa;
var t:alfa; j:integer;
begin
  _(
  for j := 1 to 6 do t[j] := ' ';
  Skip;
  j := 1;
  while (p <= 72) and (ln[p] <> ' ') and (j <= 6) do begin
    t[j] := ln[p];
    p := p + 1;
    j := j + 1
  end;
  while (p <= 72) and (ln[p] <> ' ') do p := p + 1;
  Tok := t
  _);
end;

procedure GetName(var t:alfa);
var j:integer;
begin
  _(
  for j := 1 to 6 do t[j] := ' ';
  Skip;
  j := 1;
  while (p <= 72) and (j <= 6) and (ln[p] <> ' ') and
        (ln[p] <> ':') and (ln[p] <> ';') and (ln[p] <> ',') do begin
    t[j] := ln[p];
    j := j + 1;
    p := p + 1
  end;
  while (p <= 72) and (ln[p] <> ' ') and (ln[p] <> ':') and
        (ln[p] <> ';') and (ln[p] <> ',') do p := p + 1
  _);
end;

function Number:integer;
var v:integer;
begin
  _(
  Skip;
  v := 0;
  while (p <= 72) and (ln[p] >= '0') and (ln[p] <= '9') do begin
    v := v * 10 + ord(ln[p]) - ord('0');
    p := p + 1
  end;
  Number := v
  _);
end;

(* ustOBL: default descriptor as in TSERVIS.PAS:1138. *)
procedure UstOBL(var d:RecT; dl:integer);
var j:integer;
begin
  _(
  for j := 1 to 72 do d[j] := 0;
  d[1] := ncode;
  d[2] := dl;
  d[3] := 1;
  d[4] := 1;
  for j := 1 to dl do d[8+j] := 2040
  _);
end;

(* GetRec / PutRec keep the catalog in the single MARS area. *)
function GetRec(name:alfa; var d:RecT):boolean;
begin
  _(
  if Kfind(name) then begin
    SETFL(0);
    ClrErr;
    getd(name, d);
    GetRec := BDERRN = 0;
    ClrErr
  end else
    GetRec := false
  _);
end;

procedure PutRec(name:alfa; var d:RecT);
begin
  _(
  SETFL(0);
  modd(name, d);
  ClrErr
  _);
end;

(* novOBL: create area and register it in ADMIN/ADA catalog. *)
procedure NovOBL(name:alfa; dl:integer);
begin
  _(
  if Kfind(name) then
    Err80
  else begin
    ncode := ncode + 1;
    ncnt := ncnt + 1;
    nms[ncnt] := name;
    UstOBL(r, dl);
    PutRec(name, r);
    writeln('New Area N = ', ncode)
  end
  _);
end;

(* aERASE: clear the free-page table, as in TSERVIS.PAS:988. *)
procedure AErase(name:alfa);
var j:integer;
begin
  _(
  if GetRec(name, r) then begin
    for j := 1 to r[2] do r[8+j] := 2040;
    PutRec(name, r);
    write(name, ' ');
    writeln('ОЧИЩЕНА')
  end else
    Err3
  _);
end;

(* OSWOBO: release the capture flag, TSERVIS.PAS:1485. *)
procedure Osvobo(name:alfa);
begin
  _(
  if GetRec(name, r) then begin
    r[3] := 0;
    PutRec(name, r);
    write(name, ' ');
    writeln('ОСВОБОЖДЕНА')
  end else
    Err3
  _);
end;

(* BOCCT: print restored page table, TSERVIS.PAS:1016. *)
procedure Bocct(name:alfa);
var j:integer;
begin
  _(
  if GetRec(name, r) then begin
    writeln('ВОССТАНОВЛЕНИЕ ', name);
    for j := 1 to r[2] do
      writeln(j, ':', r[8+j]);
    writeln('ВОССТАНОВЛЕНО')
  end else
    Err3
  _);
end;

procedure Run;
var kw2:alfa; dl:integer; prost:boolean;
begin
  _(
  p := 1;
  Skip;
  if p <= 72 then begin
  kw := Tok;
  if (kw = 'ОЧИСТИ') or (kw = 'ОСВОБО') or (kw = 'ВОССТА') then begin
    GetName(k);
    if kw = 'ОЧИСТИ' then AErase(k);
    if kw = 'ОСВОБО' then Osvobo(k);
    if kw = 'ВОССТА' then Bocct(k)
  end else if (kw = 'СОЗДАТ') or (kw = 'ОБЛАСТ') or
              (kw = 'ПРОСТР') then begin
    if kw = 'СОЗДАТ' then begin
      kw2 := Tok;
      if kw2 <> 'ОБЛАСТ' then Err78
    end;
    dl := 0;
    prost := kw = 'ПРОСТР';
    GetName(k);
    Skip;
    if p >= 72 then begin
      if prost then dl := 1 else Err64
    end
    else if ln[p] = ':' then begin
      p := p + 1;
      kw2 := Tok;
      if kw2 <> 'ДЛИНА ' then
        Err76
      else begin
        dl := Number;
        if (dl < 1) or (dl > 64) then Err76
      end
    end else
      dl := 1;
    if (dl >= 1) and (dl <= 64) then NovOBL(k, dl)
  end else if (kw <> 'КОНЕЦ ') and (kw <> 'КОНЕЦ.') and
            (ln[1] <> '?') and (ln[1] <> '*') then
    Err84
  end
  _);
end;

begin
  Init;
  ncode := 0;
  ncnt := 0;
  writeln('SERVIS PROCESSOR 15.1');
  while not eof(input) do begin
    readln(ln);
    Run
  end;
  writeln('EXN=', EXN)
end.
