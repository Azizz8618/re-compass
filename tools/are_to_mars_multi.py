#!/usr/bin/env python3
"""Генератор деки Паскаль-Монитора для импорта многстраничной области .ARE в МАРС.

Расширение tools/are_to_mars.py: все страницы area, уникальные 6-символьные
ключи ADpnnn (p - код страницы, nnn - номер валидного дескриптора на странице),
значение записи - один integer: номер дескриптора из JSON. Invalid-дескрипторы
отбрасываются. NEWD получает info word с длиной, равной числу страниц области
(десятичное число страниц переводится в восьмеричное поле MMMM info word).

Из-за ограничения компилятора 15.1 на число команд в блоке PUTD и проверки
разнесены по процедурам с чанком CHUNK ключей на процедуру.
"""

import argparse
import json
from pathlib import Path

MAX_LINE = 72
CHUNK = 8
PAGE_CODES = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"


def lines_check(lines):
    for n, line in enumerate(lines, 1):
        if len(line) > MAX_LINE:
            raise ValueError(f"строка {n} длиной {len(line)} > {MAX_LINE}: {line!r}")


def page_code(page):
    if not 0 <= page < len(PAGE_CODES):
        raise ValueError(f"нет кода для страницы {page}")
    return PAGE_CODES[page]


def load_descriptors(json_path, prefix, max_keys):
    doc = json.loads(Path(json_path).read_text(encoding="utf-8"))
    if not isinstance(doc, list) or not doc:
        raise ValueError("ожидался непустой список файлов в JSON")
    area = doc[0]
    pages = area.get("page_data", [])
    if not pages:
        raise ValueError("в JSON нет страниц")
    page_count = len(pages)

    by_page = []
    total_valid = 0
    for page in pages:
        records = []
        ordinal = 0
        for d in page["descriptors"]:
            if d.get("invalid"):
                continue
            fields = [d.get("number"), d.get("knot"), d.get("length"), d.get("address")]
            if any(not isinstance(v, int) for v in fields):
                continue
            number, knot, length, addr = fields
            if length <= 0 or addr <= 0 or addr + length > 2048:
                continue
            ordinal += 1
            key = f"{prefix}{page_code(page['page'])}{ordinal:03d}"
            if len(key) != 6 or not key.isalnum():
                raise ValueError(f"плохой ключ {key!r}")
            records.append({
                "key": key,
                "page": page["page"],
                "ordinal": ordinal,
                "number": number,
                "knot": knot,
                "length": length,
                "address": addr,
            })
        total_valid += len(records)
        by_page.append(records)

    selected = []
    if max_keys > 0:
        max_round = max((len(r) for r in by_page), default=0)
        for round_no in range(max_round):
            for records in by_page:
                if round_no < len(records):
                    selected.append(records[round_no])
                    if len(selected) >= max_keys:
                        break
            if len(selected) >= max_keys:
                break

    keys = [r["key"] for r in selected]
    if len(keys) != len(set(keys)):
        raise ValueError("ключи не уникальны")
    return area, page_count, total_valid, selected


def build_deck(area_name, records, page_count):
    length_oct = format(page_count, "o")
    info_word = f"{length_oct}270001c"
    chunks = [records[i:i + CHUNK] for i in range(0, len(records), CHUNK)]
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
    a("  m:array[1..1] of integer; k:alfa; i,j:integer;")
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

    for n, chunk in enumerate(chunks, 1):
        a(f"procedure p{n:02d};")
        a("begin")
        for r in chunk:
            a(f"  m[1]:={r['number']};")
            a(f"  putd('{r['key']}', m);")
        a("end;")
        a(f"procedure c{n:02d};")
        a("begin")
        for r in chunk:
            key = r["key"]
            a(f"  k := find('{key}');")
            a(f"  getd('{key}', m);")
            a("  j := 0;")
            a(f"  if k <> '{key}' then j := 1;")
            a(f"  if m[1] <> {r['number']} then j := 1;")
            a(f"  if j = 0 then writeln('{key} OK')")
            a(f"  else writeln('{key} MISMATCH');")
            a("  writeln('  ITLEN=',ITLEN,' EXN=',EXN);")
            a(f"  if j <> 0 then writeln('  GOT ',m[1],' EXPECTED ',{r['number']});")
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
    # Длина области в зонах = числу страниц .ARE (десятичное -> восьмеричное
    # поле MMMM info word);LU 27 и зона 1 взяты из рабочего одностраничного
    # варианта (1270001c).
    a(f"  i := {info_word};")
    a(f"  newd('{area_name}', i);")
    a(f"  opend('{area_name}');")
    a("  writeln('OPEN EX=',EXN);")
    for n in range(1, len(chunks) + 1):
        a(f"  p{n:02d};")
    a("  writeln('PUTD EX=',EXN);")
    for n in range(1, len(chunks) + 1):
        a(f"  c{n:02d};")
    a("  writeln('FINAL EXN=',EXN);")
    a("END.")
    a("*no load list")
    a("*execute")
    a("*end file")
    a("``````")
    a("еконец")
    lines_check(l)
    return "\n".join(l) + "\n", info_word


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--json", required=True, type=Path)
    p.add_argument("--out", required=True, type=Path)
    p.add_argument("--keys-out", required=True, type=Path)
    p.add_argument("--area", default="ADA   ")
    p.add_argument("--prefix", default="AD")
    p.add_argument("--max-keys", type=int, default=40)
    args = p.parse_args()
    if len(args.area) != 6:
        raise ValueError("имя области должно быть ровно 6 символов")
    if len(args.prefix) != 2:
        raise ValueError("префикс ключа должен быть ровно 2 символа")
    area, page_count, total_valid, selected = load_descriptors(
        args.json, args.prefix, args.max_keys
    )
    if page_count > len(PAGE_CODES):
        raise ValueError(f"слишком много страниц для кодирования: {page_count}")
    deck, info_word = build_deck(args.area, selected, page_count)
    args.out.write_text(deck, encoding="utf-8")
    payload = {
        "file": area.get("file"),
        "area_id": area.get("area_id"),
        "pages": page_count,
        "valid_descriptors_total": total_valid,
        "max_keys": args.max_keys,
        "selected": len(selected),
        "chunk_size": CHUNK,
        "newd_info_word": info_word,
        "newd_length_zones_decimal": page_count,
        "newd_length_field_octal": format(page_count, "o"),
        "records": selected,
    }
    args.keys_out.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    if area.get("area_id") is not None:
        print(f"area_id={area['area_id']}")
    print(f"pages={page_count} valid_descriptors_total={total_valid}")
    print(f"selected={len(selected)} newd_info={info_word}")
    print("keys=" + " ".join(r["key"] for r in selected))
    print(f"записано {args.out} и {args.keys_out}")


if __name__ == "__main__":
    main()
