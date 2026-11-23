#!/usr/bin/env python3
"""Декларативное чтение областей БД КОМПАС из файлов .ARE.

Формат страницы (2048 байт, 1024 16-разрядных слова little-endian):
  w[0] - идентификатор области;
  w[1] - номер страницы;
  w[2] - конец таблицы дескрипторов в словах;
  w[3] - адрес первой записи в зоне данных.
Дескриптор занимает 4 слова: локальный номер, тип knot, длина, адрес.
Зона данных растёт с конца страницы назад.
"""

import argparse
import json
import struct
from pathlib import Path

PAGE_WORDS = 1024
PAGE_BYTES = PAGE_WORDS * 2


def words_from_page(raw: bytes):
    if len(raw) != PAGE_BYTES:
        raise ValueError(f"размер страницы {len(raw)}, ожидалось {PAGE_BYTES}")
    return struct.unpack(f"<{PAGE_WORDS}H", raw)


def decode_text(data: bytes) -> str:
    """Символы CP866 лежат по два в 16-разрядном слове."""
    text = data.decode("cp866", errors="replace")
    return "".join(ch for ch in text if ch.isprintable())


def parse_page(raw_page: bytes, words, page_no: int):
    area_id, recorded_page, table_end, first_record = words[:4]
    if recorded_page != page_no:
        raise ValueError(f"страница {page_no}: в заголовке {recorded_page}")
    if not (4 <= table_end <= PAGE_WORDS):
        raise ValueError(f"страница {page_no}: неверный конец таблицы {table_end}")

    descriptors = []
    for off in range(4, table_end, 4):
        number, knot, length, addr = words[off : off + 4]
        if length == 0 or addr == 0:
            continue
        if addr + length > PAGE_BYTES:
            descriptors.append(
                {
                    "page": page_no,
                    "number": number,
                    "knot": knot,
                    "length": length,
                    "address": addr,
                    "invalid": True,
                }
            )
            continue
        data = raw_page[addr : addr + length]
        descriptors.append(
            {
                "page": page_no,
                "number": number,
                "knot": knot,
                "length": length,
                "address": addr,
                "text": decode_text(data),
                "raw_hex": data[:64].hex(),
            }
        )
    return {
        "page": page_no,
        "area_id": area_id,
        "table_end": table_end,
        "first_record": first_record,
        "descriptors": descriptors,
    }


def parse_file(path: Path):
    data = path.read_bytes()
    if len(data) % PAGE_BYTES:
        raise ValueError(f"{path}: размер не кратен {PAGE_BYTES}")
    pages = []
    for index in range(len(data) // PAGE_BYTES):
        raw_page = data[index * PAGE_BYTES : (index + 1) * PAGE_BYTES]
        words = words_from_page(raw_page)
        pages.append(parse_page(raw_page, words, index))
    return {
        "file": path.name,
        "size": len(data),
        "pages": len(pages),
        "area_id": pages[0]["area_id"] if pages else None,
        "page_data": pages,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("files", nargs="+", type=Path, help="файлы .ARE")
    parser.add_argument("--out", type=Path, help="записать JSON в файл")
    parser.add_argument("--limit", type=int, default=5, help="страниц в выводе")
    args = parser.parse_args()

    result = []
    for path in args.files:
        parsed = parse_file(path)
        parsed["page_data"] = parsed["page_data"][: args.limit]
        result.append(parsed)

    text = json.dumps(result, ensure_ascii=False, indent=2)
    if args.out:
        args.out.write_text(text + "\n", encoding="utf-8")
        print(f"записано {args.out}")
    else:
        print(text)


if __name__ == "__main__":
    main()
