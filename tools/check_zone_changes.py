#!/usr/bin/env python3
"""Контроль зон записи диска 2348.

Сравнивает рабочую копию с эталоном и сообщает, какие физические зоны
изменились. Разрешённые диапазоны описаны в docs/ZONE-ALLOCATION.md.
Любое изменение вне разрешённых зон считается нарушением.

Использование:
    python3 tools/check_zone_changes.py <working-2348> [baseline-2348]
"""

import sys
from pathlib import Path

ZONE = 8256  # 8 служебных слов + 1024 слова данных по 8 байт

ALLOWED = [
    ("MARS patch dump", 0o0657, 0o0704),
    ("PERSO COMTUP/SERVIS", 0o2570, 0o2637),
    ("TSSDML/TSSPPR reserve", 0o3250, 0o3347),
    ("MADX interpreter", 0o3370, 0o3430),
    ("PERSO UCOMPAS", 0o3350, 0o3360),
    ("REGIST catalog", 0o4100, 0o4130),
    ("REGIST data", 0o4200, 0o4230),
    ("SCL2 catalog", 0o6000, 0o6030),
    ("SCL2 data", 0o6100, 0o7470),
]


def owner(zone):
    for name, first, last in ALLOWED:
        if first <= zone <= last:
            return name
    return None


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    work = Path(sys.argv[1]).read_bytes()
    base = Path(sys.argv[2] if len(sys.argv) > 2 else "/usr/local/share/besm6/2348").read_bytes()
    if len(work) != len(base):
        raise SystemExit(f"размеры отличаются: {len(work)} != {len(base)}")

    total = len(work) // ZONE
    changed = []
    for z in range(total):
        a = z * ZONE
        if work[a:a + ZONE] != base[a:a + ZONE]:
            changed.append(z)

    unexpected = []
    print(f"зон всего: {total}, изменено: {len(changed)}")
    for z in changed:
        who = owner(z)
        mark = "OK" if who else "UNEXPECTED"
        if not who:
            unexpected.append(z)
        print(f"  {z:06o}  {mark:10s}  {who or '-'}")

    if unexpected:
        print("НАРУШЕНИЕ: изменения вне разрешённых зон:",
              " ".join(format(z, "06o") for z in unexpected))
        return 1
    print("зонный контроль: PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
