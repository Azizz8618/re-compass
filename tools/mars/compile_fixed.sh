#!/usr/bin/env bash
# Control experiment: compile unmodified re-mars.asm with the BESM-6
# macro-BEMSH translator built into dispak. No original disk is written.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGES="$HERE/images"
WORK="$HERE/out"
mkdir -p "$IMAGES" "$WORK"
SHARE=/usr/local/share/besm6
for v in 2048 2053 2099 2248 2348; do
    if [ ! -f "$IMAGES/$v" ]; then cp "$SHARE/$v" "$IMAGES/$v"; fi
done

python3 - "$HERE/re-mars-fixed.asm" "$WORK/job.b6" <<'PY'
import sys
src, out = sys.argv[1], sys.argv[2]
job = ["шифр 419999^", "трак 64^", "лент 30(2048-6200)^", "лент 42(2099)^",
       "лент 43(2348-ЗП)^", "ацп 40^", "росп 0^", "врем 240^",
       "лист 0-37^", "вход 4000^", "е", "в 4000", "к 00 010 4003",
       "к 15 24 04000", "к 00 066 0001 00 000 0100", "с 3000 67",
       "в 14000", "а1", "ВВД$$$^"]
job += [l.rstrip("\n") + "^" for l in open(src, encoding="utf-8")]
job += ["КВЧ$$$^", "ТРН$$$^", "ЧТКОМП420070^", "0-0^", "ПЕЧМАК^",
        "КНЦ$$$^", "_$ЕКОНЕЦ"]
open(out, "w", encoding="utf-8").write("\n".join(job) + "\n")
PY

env BESM6_PATH="$IMAGES" dispak -l "$WORK/job.b6" > "$WORK/listing.out" 2>&1 || true
echo "=== errors ==="
grep -a -i -E 'ОШИБ|OШИБ|ОШИБОК' "$WORK/listing.out" | tail -10 || true
echo "=== header/tail ==="
head -20 "$WORK/listing.out"
tail -20 "$WORK/listing.out"
