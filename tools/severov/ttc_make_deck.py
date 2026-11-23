#!/usr/bin/env python3
"""Build a DISPAC deck embedding ttc15.pas and deck-2 YOD operators."""
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
gold = Path("/home/azizz/Yandex.Disk/re-compass/gold/"
            "BESM-6 (Pavel Severov, NIS GIDROPROEKT) KOMPAS-based systems 1988-1989.txt")
src = (root / "src/ttc15.pas").read_text(encoding="utf-8").rstrip("\n").split("\n")
lines = gold.read_text(encoding="utf-8").splitlines()
ops = [l.rstrip("\r") for l in lines[49:166]]
ops = [l for l in ops if not l.startswith("*")]

head = [
    "шифр 419900зс5^",
    "лен 40(2048-630)^",
    "лен 41(2348)^",
    "ОЗУ 32^",
    "ее в1а3",
    "*name ",
    "*call ficmemory",
    "*perso:412570",
    "*stand",
    "*call *pascal",
]
tail = ["*no load list", "*end file", "``````", "еконец"]

out = head + src + ["*execute"] + ops + tail
for i, l in enumerate(out, 1):
    if len(l) > 72:
        print(f"LONG {i} {len(l)}: {l}", file=sys.stderr)
        sys.exit(1)
path = root / "decks/ttc15_run.b6"
path.write_text("\n".join(out) + "\n", encoding="utf-8")
print(f"{path} lines={len(out)} ops={len(ops)}")
