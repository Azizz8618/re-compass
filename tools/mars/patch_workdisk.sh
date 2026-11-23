#!/usr/bin/env bash
# Кандидат для tools/mars/patch_workdisk.sh.
# Накладывает in-place патч ядра МАРС на рабочую копию 2348.
# Использование: bash tools/mars/patch_workdisk.sh <workdir> [pristine-dump]
# <workdir> - каталог, содержащий рабочую копию 2348; оригиналы не трогаются,
# для besmtool явно выставляется BESM6_PATH=<workdir>.
set -euo pipefail

ROOT="${MARS_REPO:-$(cd "$(dirname "$0")/../.." && pwd)}"
WORK="$(cd "${1:?usage: patch_workdisk.sh <workdir> [pristine-dump]}" && pwd)"
[ -f "$WORK/2348" ] || { printf 'no working copy: %s/2348\n' "$WORK" >&2; exit 1; }
PRISTINE="${2:-$WORK/zone0657-pristine-L18.bin}"
OUT="$(cd "$(dirname "$PRISTINE")" && pwd)"
PATCHED="$OUT/zone0657-patched-L18.bin"
ZONE="$OUT/zone0657-patched-Z1.bin"
READBACK="$OUT/zone0657-readback-L18.bin"

EXPECTED_PRISTINE=1e0371b054f29adc7804d982bd8b3de6
EXPECTED_PATCHED=b0b34efe612a7bff0951b48ffa10e44f
EXPECTED_ZONE=6be325a8143c5256dc0e7a8888cff728

md5() { md5sum "$1" | cut -d' ' -f1; }
check() {
    local got
    got="$(md5 "$1")"
    if [ "$got" != "$2" ]; then
        printf 'PATCH FAIL: %s: expected %s, got %s\n' "$1" "$2" "$got" >&2
        exit 1
    fi
}

if [ ! -f "$PRISTINE" ]; then
    BESM6_PATH="$WORK" besmtool dump 2348 --start=0657 --length=18 \
        --to-file="$PRISTINE" >/dev/null
fi
check "$PRISTINE" "$EXPECTED_PRISTINE"

python3 "$ROOT/tools/mars/apply_inplace_patch.py" "$PRISTINE" "$PATCHED"
check "$PATCHED" "$EXPECTED_PATCHED"
dd if="$PATCHED" of="$ZONE" bs=6144 count=1 status=none
check "$ZONE" "$EXPECTED_ZONE"

BESM6_PATH="$WORK" besmtool write 2348 --start=0657 --length=18 \
    --from-file="$PATCHED" >/dev/null
BESM6_PATH="$WORK" besmtool dump 2348 --start=0657 --length=18 \
    --to-file="$READBACK" >/dev/null
check "$READBACK" "$EXPECTED_PATCHED"
dd if="$READBACK" of="$ZONE" bs=6144 count=1 status=none
check "$ZONE" "$EXPECTED_ZONE"

printf 'MARS patch: PASS (zone %s, dump %s)\n' "$EXPECTED_ZONE" "$EXPECTED_PATCHED"
