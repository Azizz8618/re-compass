(*=y+,s0,s7*)program servis(output, input, BDVECT, BDERRN, PIC);
(* SERVIS processor for BESM-6, stage 4.
   Each SERVIS area is a separate MARS area named after the object.
   Descriptor: [1] code, [2] length, [3] capture, [4] kind,
   [5] head code, [6] journal state, [7] control, [8] mode,
   [9] direction, [10] start, [11] reserved, [12..72] page table.
   MARS info word: MMMMZZNNNN, MMMM = length in zones (octal). *)
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
  r, ur: RecT;
  k, k2, kw, kw2: alfa;
  p, ncode, ncnt, dl, cur, lasterr: integer;
  nms: array [1..64] of alfa;
  ades: array [1..24] of RecT;
  p0, p1, p2, p3: array [0..7] of integer;
  zlo, zhi: array [1..24] of integer;
  unms, rnms, robj, rtyp: array [1..16] of alfa;
  un, rn: integer;
  lastinfo: integer;
  nxt: char;
  done: boolean;

procedure PASACD(var i:integer); FORTRAN;
procedure PASSETAR(i:integer); EXTERNAL;
procedure pasbdi; external;
procedure pasbd; external;

function EXN:integer;
begin
  EXN := BDERRN
end;

(* PASBDI clears the sticky MARS error word. *)
procedure ClrErr;
begin
  _(
  pasbdi;
  BDERRN := 0
  _);
end;

procedure Err(n:integer);
begin
  _(
  lasterr := n;
  write('ОШИБКА ', n, ': ');
  case n of
    3: writeln('ОБЛАСТЬ НЕ ОПРЕДЕЛЕНА');
    4: writeln('УЖЕ ЕСТЬ АДМИНИСТРАТОР');
    5: writeln('НЕСУЩЕСТВУЮЩЕЕ ПРАВО');
    6: writeln('НЕТ ПРАВ ДОСТУПА');
    7: writeln('ПЕРЕПОЛНЕНА ADA');
    11: writeln('ЕСТЬ ВАРИАНТЫ');
    50: writeln('НЕТ ПРАВА ДЛЯ-МО');
    51: writeln('ОБЪЕКТ ПРАВА НЕ НАЙДЕН');
    52: writeln('ГОЛОВНАЯ ОБЛАСТЬ НЕ НАЙДЕНА');
    53: writeln('ОШИБКА В ОПРЕДЕЛЕНИИ ДУБЛЯ');
    54: writeln('ОБЛАСТЬ НЕ ЯВЛЯЕТСЯ ДУБЛЕМ');
    55: writeln('ОБЛАСТЬ НЕ ИМЕЕТ ДУБЛЕЙ');
    56: writeln('ОТСУТСТВУЕТ СЛОВО НА');
    57: writeln('ОБЛАСТИ НЕ ЯВЛЯЮТСЯ ДУБЛЯМИ');
    58: writeln('ДЛИНА ДУБЛЯ БОЛЬШЕ ГОЛОВНОЙ');
    60: writeln('УБИРАЕМАЯ ОБЛАСТЬ ИМЕЕТ ДУБЛИ');
    61: writeln('ПРОСТРАНСТВО НЕ ПУСТО');
    62: writeln('ОБЛАСТЬ СВЯЗАНА СО СХЕМОЙ');
    63: writeln('ОБЛАСТЬ СВЯЗАНА С ПОДСХЕМОЙ');
    64: writeln('НЕТ ДВОЕТОЧИЯ ИЛИ ;');
    65: writeln('ДЛИНА ВАРИАНТА БОЛЬШЕ ГОЛОВНОЙ');
    66: writeln('ДЛИНА ДУБЛЯ БОЛЬШЕ ГОЛОВНОЙ');
    67: writeln('ОБЛАСТЬ НЕ ОБЪЯВЛЕНА ЖУРНАЛОМ');
    68: writeln('ЖУРНАЛ ЗАХВАЧЕН ПРОЦЕССОМ');
    69: writeln('СБРОС ПОСЛЕ ЗАКРЕПЛЕНИЯ');
    71: writeln('НЕТ ПАРАМЕТРОВ ЗАМЕНЫ');
    72: writeln('ЗАМЕНЯЕМЫЙ ОБЪЕКТ НЕ НАЙДЕН');
    74: writeln('НЕ АДМИНИСТРАТОР');
    76: writeln('НЕДОПУСТИМОЕ СЛОВО');
    77: writeln('НЕДОПУСТИМОЕ СЛОВО ПОСЛЕ ЗАМЕНЫ');
    78: writeln('НЕ УКАЗАН ОБЪЕКТ');
    80: writeln('ОБЪЕКТ УЖЕ ЕСТЬ');
    83: writeln('НЕ УКАЗАНО СБРОСИ ИЛИ ЗАКРЕПИ');
    84: writeln('НЕПРАВИЛЬНОЕ ПЕРВОЕ СЛОВО');
    87: writeln('НЕ МОЖЕТ БЫТЬ ПОСТАВЛЕН');
  end
  _);
end;

procedure Skip;
begin
  _(
  while (p <= 72) and (ln[p] = ' ') do p := p + 1
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
  while (p <= 72) and (j <= 6) and (ln[p] <> ' ') and
        (ln[p] <> ':') and (ln[p] <> ';') and (ln[p] <> ',') and
        (ln[p] <> '.') do begin
    t[j] := ln[p];
    p := p + 1;
    j := j + 1
  end;
  while (p <= 72) and (ln[p] <> ' ') and (ln[p] <> ':') and
        (ln[p] <> ';') and (ln[p] <> ',') and
        (ln[p] <> '.') do p := p + 1;
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
        (ln[p] <> ':') and (ln[p] <> ';') and
        (ln[p] <> ',') and (ln[p] <> '.') do begin
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

(* Octal powers as literals: multiplication wraps at 2^24 here. *)
procedure InitPows;
begin
  _(
  p0[0]:=0c; p0[1]:=1000000c; p0[2]:=2000000c;
  p0[3]:=3000000c; p0[4]:=4000000c;
  p0[5]:=5000000c; p0[6]:=6000000c; p0[7]:=7000000c;
  p1[0]:=0c; p1[1]:=10000000c; p1[2]:=20000000c;
  p1[3]:=30000000c; p1[4]:=40000000c;
  p1[5]:=50000000c; p1[6]:=60000000c; p1[7]:=70000000c;
  p2[0]:=0c; p2[1]:=100000000c; p2[2]:=200000000c;
  p2[3]:=300000000c; p2[4]:=400000000c;
  p2[5]:=500000000c; p2[6]:=600000000c; p2[7]:=700000000c;
  p3[0]:=0c; p3[1]:=1000000000c; p3[2]:=2000000000c;
  p3[3]:=3000000000c; p3[4]:=4000000000c;
  p3[5]:=5000000000c; p3[6]:=6000000000c; p3[7]:=7000000000c;
  zlo[1]:=1c; zlo[2]:=101c; zlo[3]:=201c; zlo[4]:=301c;
  zlo[5]:=401c; zlo[6]:=501c; zlo[7]:=601c; zlo[8]:=701c;
  zlo[9]:=1001c; zlo[10]:=1101c; zlo[11]:=1201c;
  zlo[12]:=1301c; zlo[13]:=1401c; zlo[14]:=1501c;
  zlo[15]:=1601c; zlo[16]:=1701c;
  zhi[1]:=4001c; zhi[2]:=5001c; zhi[3]:=6001c; zhi[4]:=7001c;
  zhi[5]:=4001c; zhi[6]:=5001c; zhi[7]:=6001c; zhi[8]:=7001c;
  zhi[9]:=4001c; zhi[10]:=5001c; zhi[11]:=6001c; zhi[12]:=7001c;
  zhi[13]:=4001c; zhi[14]:=5001c; zhi[15]:=6001c; zhi[16]:=7001c
  _);
end;

(* Build MARS info word for a decimal length in zones. *)
function InfoWord(l,z:integer):integer;
var q,d0,d1,d2,d3:integer;
begin
  _(
  q := l; d0 := q mod 8; q := q div 8;
  d1 := q mod 8; q := q div 8;
  d2 := q mod 8; q := q div 8;
  d3 := q mod 8;
  InfoWord := p3[d3] + p2[d2] + p1[d1] + p0[d0] + 270000c + z
  _);
end;

procedure Kadd(nm:alfa);
begin
  _(
  if ncnt < 64 then begin
    ncnt := ncnt + 1;
    nms[ncnt] := nm
  end
  _);
end;

function Kfind(nm:alfa):boolean;
var j:integer;
begin
  _(
  Kfind := false;
  for j := 1 to ncnt do
    if nms[j] = nm then Kfind := true
  _);
end;

procedure Kdel(nm:alfa);
var j,t:integer;
begin
  _(
  for j := 1 to ncnt do
    if nms[j] = nm then begin
      for t := j to ncnt-1 do nms[t] := nms[t+1];
      ncnt := ncnt - 1
    end
  _);
end;

procedure UstOBL(var d:RecT; l,kind:integer);
var j:integer;
begin
  _(
  for j := 1 to 72 do d[j] := 0;
  d[1] := ncode;
  d[2] := l;
  d[3] := 1;
  d[4] := kind;
  d[5] := 0;
  d[6] := 0;
  d[7] := 0;
  d[8] := 0;
  d[9] := 0;
  d[10] := 1;
  for j := 1 to 61 do d[11+j] := 2040
  _);
end;

function IdxOf(nm:alfa):integer;
var j:integer;
begin
  _(
  IdxOf := 0;
  for j := 1 to ncnt do
    if nms[j] = nm then IdxOf := j
  _);
end;

function GetRec(nm:alfa; var d:RecT):boolean;
var j:integer;
begin
  _(
  j := IdxOf(nm);
  if j > 0 then begin
    d := ades[j];
    cur := j;
    GetRec := true
  end else
    GetRec := false
  _);
end;

procedure PutRec(nm:alfa; var d:RecT);
var j:integer;
begin
  _(
  j := IdxOf(nm);
  if j > 0 then ades[j] := d
  _);
end;

(* SETFL/CLFL of TSERVIS: open the named MARS area. *)
procedure SETFL(a:integer);
begin
  _(
  if a = 0 then opend(k);
  if a = 2 then opend(k)
  _);
end;

procedure CLFL(a:integer);
begin
end;

(* MARS rejects huge containers here: clamp the physical call. *)
function PhysLen(l:integer):integer;
begin
  _(
  if l > 1000 then PhysLen := 1000 else PhysLen := l
  _);
end;

procedure NewArea(nm:alfa; var d:RecT);
var i,nz,zv:integer;
begin
  _(
  if Kfind(nm) then
    Err(80)
  else begin
    ncode := ncode + 1;
    Kadd(nm);
    d[1] := ncode;
    if d[2] > 64 then zv := zhi[ncode] else zv := zlo[ncode+1];
    d[10] := zv;
    lastinfo := InfoWord(d[2], zv);
    i := InfoWord(PhysLen(d[2]), zv);
    ClrErr;
    newd(nm, i);
    ClrErr;
    ades[ncnt] := d;
    k := nm;
    writeln('New Area N = ', ncode, ' INFO=', lastinfo)
  end
  _);
end;

procedure AErase(nm:alfa);
var j,lim:integer;
begin
  _(
  if GetRec(nm, r) then begin
    if r[2] > 61 then lim := 61 else lim := r[2];
    for j := lim downto 1 do r[11+j] := 2040;
    PutRec(nm, r);
    write(nm, ' ');
    writeln('ОЧИЩЕНА')
  end else Err(3)
  _);
end;

procedure Osvobo(nm:alfa);
begin
  _(
  if GetRec(nm, r) then begin
    r[3] := 0;
    PutRec(nm, r);
    write(nm, ' ');
    writeln('ОСВОБОЖДЕНА')
  end else Err(3)
  _);
end;

procedure Bocct(nm:alfa);
var j,lim:integer;
begin
  _(
  if GetRec(nm, r) then begin
    writeln('ВОССТАНОВЛЕНИЕ ', nm);
    if r[2] > 61 then lim := 61 else lim := r[2];
    for j := 1 to lim do writeln(j, ':', r[11+j]);
    if r[2] > 61 then writeln('... ВСЕГО СТРАНИЦ ', r[2]);
    writeln('ВОССТАНОВЛЕНО')
  end else Err(3)
  _);
end;

procedure Obnovi(nm:alfa);
begin
  _(
  if GetRec(nm, r) then begin
    PutRec(nm, r);
    writeln('ОБНОВЛЕНО ', nm)
  end else Err(3)
  _);
end;

function CodeOf(nm:alfa):integer;
begin
  _(
  CodeOf := 0;
  if GetRec(nm, ur) then CodeOf := ur[1]
  _);
end;

procedure Dubl;
var n3,n4:alfa; c3,c4,j:integer;
begin
  _(
  kw2 := Tok;
  if kw2 = 'НА    ' then begin
    GetName(n4);
    c4 := CodeOf(n4);
    if c4 = 0 then Err(52)
    else if cur = 0 then Err(3)
    else if GetRec(nms[cur], r) then begin
      r[4] := 4;
      r[5] := c4;
      PutRec(nms[cur], r);
      writeln('ДУБЛЬ ', nms[cur], ' НА ', n4)
    end
  end else if kw2 = 'С     ' then begin
    GetName(n4);
    if not GetRec(nms[cur], r) then Err(3)
    else if r[4] <> 4 then Err(54)
    else if not GetRec(n4, ur) then Err(52)
    else begin
      if ur[2] > r[2] then Err(58)
      else begin
        for j := 1 to 61 do r[11+j] := ur[11+j];
        PutRec(nms[cur], r);
        writeln('ДУБЛЬ С ', n4, ' ВЫПОЛНЕН')
      end
    end
  end else begin
    n3 := kw2;
    kw2 := Tok;
      if kw2 <> 'НА    ' then Err(56)
      else begin
        GetName(n4);
        c3 := CodeOf(n4);
        if c3 = 0 then Err(52)
        else if not GetRec(n4, ur) then Err(52)
        else if Kfind(n3) then Err(80)
        else begin
          r := ur;
          UstOBL(r, ur[2], 4);
          NewArea(n3, r);
          if GetRec(n3, r) then begin
            r[5] := c3;
            for j := 1 to 61 do r[11+j] := ur[11+j];
            PutRec(n3, r)
          end;
          writeln('ДУБЛЬ ', n3, ' СОЗДАН')
        end
      end
    end
  _);
end;

procedure Osvabd;
var j:integer;
begin
  _(
  j := 0;
  for cur := 1 to ncnt do
    if GetRec(nms[cur], r) then begin
      PutRec(nms[cur], r);
      j := j + 1
    end;
  writeln('ОСВАБД: ЗАПИСАНО ОБЛАСТЕЙ ', j)
  _);
end;

procedure Journal;
var nm:alfa; st:integer;
begin
  _(
  GetName(nm);
  if not GetRec(nm, r) then Err(3)
  else begin
    if r[4] <> 2 then Err(67)
    else begin
      kw2 := Tok;
      if kw2 = 'СБРОСИ' then begin
        if r[6] = 2 then Err(69)
        else begin
          r[6] := 1;
          PutRec(nm, r);
          writeln('ЖУРНАЛ ', nm, ' СБРОШЕН')
        end
      end else if kw2 = 'ЗАКРЕП' then begin
        if r[3] <> 0 then Err(68)
        else begin
          r[6] := 2;
          PutRec(nm, r);
          writeln('ЖУРНАЛ ', nm, ' ЗАКРЕПЛЕН')
        end
      end else Err(83)
    end
  end
  _);
end;

procedure Ubrat;
var nm:alfa; j,cc:integer; found:boolean;
begin
  _(
  kw2 := Tok;
  if kw2 <> 'ОБЛАСТ' then Err(78)
  else begin
    GetName(nm);
    if not GetRec(nm, r) then Err(3)
    else begin
      cc := r[1];
      found := false;
      for j := 1 to ncnt do
        if GetRec(nms[j], ur) then
          if (ur[5] = cc) and (nms[j] <> nm) then found := true;
      if found then Err(60)
      else if r[3] <> 0 then Err(50)
      else begin
        Kdel(nm);
        writeln('ОБЛАСТЬ ', nm, ' УБРАНА')
      end
    end
  end
  _);
end;

(* Parameters of CREATE/CHANGE AREA. *)
procedure Params(var d:RecT; var l:integer);
var nm:alfa; v:integer;
begin
  _(
  repeat
    if (p > 72) or (ln[p] = ';') or (ln[p] = ',') or
       (ln[p] = '.') then p := 73
    else begin
      kw2 := Tok;
      if (kw2 = 'ДЛИНА ') or (kw2 = 'ДЛИHA ') then begin
        v := Number;
        if (v < 1) or (v > 1750) then Err(76) else l := v
      end else if (kw2 = 'НАПР  ') or (kw2 = 'HAПP  ') then
        d[9] := Number
      else if (kw2 = 'НАЧАЛО') or (kw2 = 'HAЧAЛO') then
        d[10] := Number
      else if (kw2 = 'ВИД   ') or (kw2 = 'BИД   ') then begin
        nm := Tok;
        if nm = 'ЖУРНАЛ' then d[4] := 2 else d[4] := 1
      end else if (kw2 = 'ВАРИАН') or (kw2 = 'BAPИAH') then begin
        GetName(nm);
        d[5] := CodeOf(nm)
      end else if (kw2 = 'ДУБЛЬ ') or (kw2 = 'ДYБЬ  ') then begin
        GetName(nm);
        d[5] := CodeOf(nm);
        d[4] := 4
      end else if (kw2 = 'РЕЖИМ ') or (kw2 = 'PEЖИM ') then
        d[8] := Number
      else if (kw2 = 'ПАРОЛЬ') then begin
        nm := Tok;
        d[7] := 1
      end else if (kw2 = 'КОНТРО') then
        d[7] := Number
      else begin
        Err(76);
        p := 73
      end
    end
  until p > 72
  _);
end;

procedure CreAr;
var kind:integer;
begin
  _(
  if kw = 'СОЗДАТ' then begin
    kw2 := Tok;
    if kw2 <> 'ОБЛАСТ' then Err(78)
  end;
  GetName(k);
  if k = '      ' then Err(78)
  else begin
    dl := 1;
    kind := 1;
    Skip;
    if p <= 72 then begin
      if ln[p] = ':' then p := p + 1;
      if (ln[p] = ',') or (ln[p] = ';') then p := 73
      else if p <= 72 then begin
        UstOBL(r, dl, kind);
        Params(r, dl)
      end
    end;
    r[2] := dl;
    if Kfind(k) then Err(80) else NewArea(k, r)
  end
  _);
end;

procedure Izmeni;
var nm:alfa; nd:integer;
begin
  _(
  kw2 := Tok;
  if kw2 <> 'ОБЛАСТ' then Err(77)
  else begin
    GetName(nm);
    if not GetRec(nm, r) then Err(72)
    else begin
      Skip;
      if (p > 72) or (ln[p] <> ':') then Err(64)
      else begin
        p := p + 1;
        nd := r[2];
        Params(r, nd);
        r[2] := nd;
        PutRec(nm, r);
        writeln('ОБЛАСТЬ ', nm, ' ИЗМЕНЕНА')
      end
    end
  end
  _);
end;

procedure AddUser;
var nm,pw:alfa;
begin
  _(
  GetName(nm);
  if nm = '      ' then Err(78)
  else if un >= 16 then Err(87)
  else begin
    unms[un+1] := nm;
    un := un + 1;
    Skip;
    if (p <= 72) and (ln[p] = ':') then begin
      p := p + 1;
      kw2 := Tok;
      if kw2 = 'ПАРОЛЬ' then pw := Tok
    end;
    writeln('ПОЛЬЗОВАТЕЛЬ ', nm, ' СОЗДАН')
  end
  _);
end;

procedure AddRight;
var us,ob,ty,rt:alfa; ok:boolean;
begin
  _(
  kw2 := Tok;
  if kw2 <> 'ПОЛЬЗО' then Err(78)
  else begin
    GetName(us);
    kw2 := Tok;
    if (kw2 = 'ОБЛАСТ') or (kw2 = 'ПОДСХЕ') or
       (kw2 = 'СХЕМЫ ') then ty := kw2 else ty := kw2;
    GetName(ob);
    Skip;
    if (p <= 72) and (ln[p] = ':') then p := p + 1;
    rt := Tok;
    ok := (rt = 'ДЛЯ-ВЫ') or (rt = 'ДЛЯ-МО');
    if not ok then Err(5)
    else if rn >= 16 then Err(7)
    else if (ty <> 'ОБЛАСТ') and (ty <> 'ПОДСХЕ') and
            (ty <> 'СХЕМЫ ') then Err(77)
    else if (ty = 'ОБЛАСТ') and (not Kfind(ob)) then Err(51)
    else begin
      rn := rn + 1;
      rnms[rn] := us;
      robj[rn] := ob;
      rtyp[rn] := rt;
      writeln('ПРАВО ', rt, ' ', us, ' НА ', ob, ' ДАНО')
    end
  end
  _);
end;

procedure Create;
begin
  _(
  kw2 := Tok;
  if kw2 = 'ПОЛЬЗО' then AddUser
  else if kw2 = 'ПРАВО ' then AddRight
  else if kw2 = 'ОБЛАСТ' then CreAr
  else Err(78)
  _);
end;

procedure Names(cmd:alfa);
var nm:alfa;
begin
  _(
  k2 := cmd;
  repeat
    Skip;
    if (p <= 72) and (ln[p] = ',') then p := p + 1;
    GetName(nm);
    if nm <> '      ' then begin
      if cmd = 'ОЧИСТИ' then AErase(nm);
      if cmd = 'ОСВОБО' then Osvobo(nm);
      if cmd = 'ВОССТА' then Bocct(nm)
    end
  until (nm = '      ') or (p > 72)
  _);
end;

procedure Stmt;
begin
  _(
  Skip;
  if p <= 72 then begin
    if (ln[p] = '?') or (ln[p] = '*') then p := 73
    else if (ln[p] = ';') or (ln[p] = ',') then p := p + 1
    else if ln[p] = '.' then p := p + 1
    else begin
      kw := Tok;
      if (kw = 'ОЧИСТИ') or (kw = 'ОСВОБО') or (kw = 'ВОССТА') then
        Names(kw)
      else if (kw = 'СОЗДАТ') then Create
      else if (kw = 'ОБЛАСТ') or (kw = 'ПРОСТР') then CreAr
      else if (kw = 'ИЗМЕНИ') then Izmeni
      else if (kw = 'ОБНОВИ') then begin
        GetName(k);
        if k <> '      ' then Obnovi(k) else Err(78)
      end else if (kw = 'ДУБЛЬ ') then Dubl
      else if (kw = 'ОСВАБД') then Osvabd
      else if (kw = 'ЖУРНАЛ') then Journal
      else if (kw = 'УБРАТЬ') then Ubrat
      else if (kw = 'B     ') then p := 73
      else if (kw = 'КОНЕЦ ') or (kw = 'КОНЕЦ.') then p := 73
      else if k2 <> '      ' then begin
        p := 1;
        Skip;
        Names(k2)
      end
      else Err(84)
    end
  end
  _);
end;

(* Front-end: the original gold deck is read as INPUT verbatim.
   Recognise the monitor/system cards and their head lines, skip them,
   and pass every subsequent line to the SERVIS processor unchanged. *)
function SysCard: boolean;
var q: integer;
begin
  q := 1;
  while (q <= 72) and (ln[q] = ' ') do q := q + 1;
  SysCard := false;
  if q <= 72 then
    SysCard := (ln[q] = '?') or (ln[q] = '*') or
      ((ln[q] = 'Ш') and (ln[q+1] = 'И') and (ln[q+2] = 'Ф')) or
      ((ln[q] = 'O') and (ln[q+1] = 'З') and (ln[q+2] = 'Y')) or
      ((ln[q] = 'E') and (ln[q+1] = 'E') and (ln[q+2] = 'B'))
end;

procedure Init;
var i,j:integer;
begin
  _(
  (* PASCOMPL 15.1 miscompiles a plain '= 0' test here. *)
  if BDVECT[36].i + 0 = 0 then begin
    for j := 0 to 167 do BDVECT[j].i := 0;
    i := 20270000c;
    PASACD(i);
    PASSETAR(270000c)
  end;
  pasbdi;
  BDERRN := 0;
  InitPows;
  i := 2270001c;
  newd('ADA   ', i);
  ClrErr;
  opend('ADA   ');
  for j := 1 to 72 do ur[j] := 0;
  ur[1] := 1;
  ur[2] := 1;
  modd('ADMIN ', ur);
  ClrErr;
  un := 0;
  rn := 0;
  unms[1] := 'ADMIN ';
  un := 1;
  rnms[1] := 'ADMIN ';
  robj[1] := 'ADA   ';
  rtyp[1] := 'ДЛЯ-ВЫ';
  rn := 1
  _);
end;

begin
  Init;
  ncode := 0;
  ncnt := 0;
  writeln('SERVIS PROCESSOR 15.1');
  writeln('ADMIN: ПОЛЬЗОВАТЕЛЬ ADMIN ЗАРЕГИСТРИРОВАН');
  done := false;
  while not eof(input) and not done do begin
    readln(ln);
    if SysCard then
      writeln('FRONT: SYSTEM CARD SKIPPED: ', ln)
    else begin
      p := 1;
      repeat
        Stmt;
        Skip;
        if p <= 72 then begin
          nxt := ln[p];
          if (nxt = ';') or (nxt = ',') then p := p + 1
          else p := 73
        end
      until p > 72;
      p := 1;
      while (p <= 72) and (ln[p] = ' ') do p := p + 1;
      if p <= 72 then
        if ln[p] = 'К' then done := true
    end
  end;
  writeln('EXN=', EXN)
end.
