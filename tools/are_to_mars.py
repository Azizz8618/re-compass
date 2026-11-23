#!/usr/bin/env python3
"""Генератор деки Паскаль-Монитора для импорта дескрипторов .ARE в МАРС.

Вход: JSON, полученный через tools/are_decode.py < area.ARE > --out area.json.
Выход: дека, которая идемпотентно инициализирует МАРС, создаёт и открывает
область, пишет PUTD для каждого валидного дескриптора и проверяет результат
через FIND + GETD (+ ITLEN, EXN).

Значение записи - 4-словный массив integer: номер, knot, длина, адрес
дескриптора из JSON. Ключ - 6-символьное имя ZPnnnn, где nnnn - номер.
"""

import argparse
import json
from pathlib import Path


MAX_LINE = 72


def lines_check(lines):
    for n, line in enumerate(lines, 1):
        if len(line) > MAX_LINE:
            raise ValueError(f"строка {n} длиной {len(line)} > {MAX_LINE}: {line!r}")


def load_descriptors(json_path, prefix, page_index):
    doc = json.loads(Path(json_path).read_text(encoding="utf-8"))
    if not isinstance(doc, list) or not doc:
        raise ValueError("ожидался непустой список файлов в JSON")
    area = doc[0]
    pages = area.get("page_data", [])
    if not pages:
        raise ValueError("в JSON нет страниц")
    page = pages[page_index]
    out = []
    for d in page["descriptors"]:
        if d.get("invalid"):
            continue
        fields = [d.get("number"), d.get("knot"), d.get("length"), d.get("address")]
        if any(not isinstance(v, int) for v in fields):
            continue
        number, knot, length, addr = fields
        if length <= 0 or addr <= 0 or addr + length > 2048:
            continue
        key = f"{prefix}{number:04d}"
        if len(key) != 6 or not key.isalnum():
            raise ValueError(f"плохой ключ {key!r}")
        out.append({"key": key, "value": [number, knot, length, addr]})
    keys = [r["key"] for r in out]
    if len(keys) != len(set(keys)):
        raise ValueError("ключи не уникальны")
    return area, page, out


def build_deck(area_name, records):
    l = []
    a = l.append
    a("шифр 419900зс5^")
    a("лен 40(2348-630)^")
    a("лен 41(2348)^")
    a("ОЗУ 32^")
    a("еев1а3")
    a("*name")
    a("*call ficmemory")
    a("*perso:412570")
    a("*stand")
    a("*call *pascal")
    a("(*=y+,s0,s7*)program aremars(output, BDVECT, BDERRN);")
    a("type word = record case integer of")
    a("  0:(i:integer); 1:(a:alfa); 2:(p:@integer); 3:(c:char) end;")
    a("  TBDVec = array [0..167] of word;")
    a("var BDVECT: TBDVec; BDERRN:integer;")
    a("  m:array[1..4] of integer; k:alfa; i,j:integer;")
    a("procedure PASACD(var i:integer); FORTRAN;")
    a("procedure PASSETAR(i:integer); EXTERNAL;")
    a("procedure pasbd; external;")
    a("function EXN:integer; external;")
    a("function ITLEN:integer; external;")
    a("function find(a:alfa):alfa;")
    a("begin")
    a("  BDVECT[8].a := a;")
    a("  BDVECT[3].i := 11c;")
    a("  pasbd;")
    a("  find := BDVECT[31].a")
    a("end;")
    a("begin")
    # Компилятор 15.1 неверно сравнивает поле variant-записи с константой
    # напрямую: условие BDVECT[36].i = 0 всегда было ложным. Арифметическая
    # форма с + 0 даёт корректную проверку info word.
    a("  if BDVECT[36].i + 0 = 0 then begin")
    a("    for j := 0 to 167 do BDVECT[j].i := 0;")
    a("    i := 1270000c; PASACD(i);")
    a("    PASSETAR(270000c)")
    a("  end;")
    a("  writeln('INIT EX=',EXN);")
    a("  i := 1270001c;")
    a(f"  newd('{area_name}', i);")
    a(f"  opend('{area_name}');")
    a("  writeln('OPEN EX=',EXN);")
    for r in records:
        v = r["value"]
        a("  " + " ".join(f"m[{n}]:={v[n-1]};" for n in range(1, 5)))
        a(f"  putd('{r['key']}', m);")
    a("  writeln('PUTD EX=',EXN);")
    for r in records:
        key = r["key"]
        v = r["value"]
        a(f"  k := find('{key}');")
        a(f"  getd('{key}', m);")
        a("  j := 0;")
        a(f"  if k <> '{key}' then j := 1;")
        for n in range(1, 5):
            a(f"  if m[{n}] <> {v[n-1]} then j := 1;")
        a(f"  if j = 0 then writeln('{key} OK')")
        a(f"  else writeln('{key} MISMATCH');")
        a("  writeln('  ITLEN=',ITLEN,' EXN=',EXN);")
        a("  if j <> 0 then writeln('  GOT ',m[1],m[2],m[3],m[4]);")
    a("  writeln('FINAL EXN=',EXN);")
    a("END.")
    a("*no load list")
    a("*execute")
    a("*end file")
    a("``````")
    a("еконец")
    lines_check(l)
    return "\n".join(l) + "\n"


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--json", required=True, type=Path)
    p.add_argument("--out", required=True, type=Path)
    p.add_argument("--area", default="ZPROC ")
    p.add_argument("--prefix", default="ZP")
    p.add_argument("--page", type=int, default=0)
    args = p.parse_args()
    if len(args.area) != 6:
        raise ValueError("имя области должно быть ровно 6 символов")
    area, page, records = load_descriptors(args.json, args.prefix, args.page)
    if area.get("area_id") is not None:
        print(f"area_id={area['area_id']} page={page['page']}")
    print(f"records={len(records)} keys={[r['key'] for r in records]}")
    args.out.write_text(build_deck(args.area, records), encoding="utf-8")
    print(f"записано {args.out}")


if __name__ == "__main__":
    main()
