#!/usr/bin/env bash
# Compile re-mars.asm directly into a scratch zone of a copied 2348 image.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGES="$HERE/images"
WORK="$HERE/out_zone"
mkdir -p "$WORK"
python3 - "$HERE/re-mars.asm" "$WORK/job.b6" <<'PY'
import sys
src,out=sys.argv[1],sys.argv[2]
job=["шифр 419999^","трак 64^","лент 30(2048-6200)^","лент 42(2099)^",
     "лент 43(2348-ЗП)^","ацп 40^","росп 0^","врем 240^","лист 0-37^",
     "вход 4000^","е","в 4000","к 00 010 4003","к 15 24 04000",
     "к 00 066 0001 00 000 0100","с 3000 67","в 14000","а1","ВВД$$$^"]
job += [l.rstrip("\n")+"^" for l in open(src,encoding="utf-8")]
job += ["КВЧ$$$^","ТРН$$$^","ЧТКОМП420070^",
        "ЗОНГП 430100  0020^","КНЦ$$$^","_$ЕКОНЕЦ"]
open(out,"w",encoding="utf-8").write("\n".join(job)+"\n")
PY
env BESM6_PATH="$IMAGES" dispak "$WORK/job.b6" > "$WORK/listing.out" 2>&1 || true
grep -a 'ОШИБОК\|OШИБOK\|ЗОНГП\|ЗОНМОД\|СВ.ЗОНА' "$WORK/listing.out" | tail -12
