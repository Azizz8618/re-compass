#!/usr/bin/env python3
"""Apply the final in-place MARS length check to a pristine 18-zone dump.

Usage: apply_inplace_patch.py <pristine-dump> <output-dump>

The naive source-level insertion shifts every label by one word and breaks
the kernel at runtime (see REPORT.md). This patch keeps all original
addresses; it only replaces one halfword of command 10 and fills three free
words in the tail of zone 0657 (0o3720..0o3722, zero in the reference and
not present in the symbol table).
"""
import sys
from pathlib import Path

BASE = 0o2000
SCM5 = 0o400005          # УИ M5
SCH_E11 = 0o20101551     # СЧ E11  (03551, additive base M4)
VCH_DBLEN = 0o54050051   # ВЧ DBLEN (36051, data base M13)
PE_OVERFL = 0o22700570   # ПЕ OVERFL (02570)
PB_RETURN = 0o23001441   # ПБ 03441


def put(buf, addr, hi, lo):
    off = (addr - BASE) * 6
    buf[off:off+6] = ((hi << 24) | lo).to_bytes(6, "big")


def main():
    src, dst = sys.argv[1], sys.argv[2]
    buf = bytearray(Path(src).read_bytes())
    off = (0o3440 - BASE) * 6
    old = int.from_bytes(buf[off:off+6], "big")
    assert old & 0xffffff == SCM5, format(old & 0xffffff, "06o")
    for a in (0o3720, 0o3721, 0o3722):
        assert int.from_bytes(buf[(a-BASE)*6:(a-BASE)*6+6], "big") == 0, oct(a)
    put(buf, 0o3440, old >> 24, 0o23001720)   # ПБ 03720
    put(buf, 0o3720, SCM5, SCH_E11)
    put(buf, 0o3721, VCH_DBLEN, PE_OVERFL)
    put(buf, 0o3722, PB_RETURN, 0)
    Path(dst).write_bytes(buf)


if __name__ == "__main__":
    main()
