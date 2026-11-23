#!/usr/bin/env bash
# Проверка зон МАРС на диске 2348 только на чтение.
set -euo pipefail

DISK="${DISK:-2348}"
EXPECTED="1e0371b054f29adc7804d982bd8b3de6"
DUMP="build/zone0657.bin"

mkdir -p build
besmtool dump "$DISK" --start=0657 --length=18 --to-file="$DUMP" > /dev/null

actual=$(md5sum "$DUMP" | cut -d' ' -f1)
if [ "$actual" = "$EXPECTED" ]; then
    printf 'БАНДИТ зона 0657: PASS (%s)\n' "$actual"
else
    printf 'БАНДИТ зона 0657: FAIL, получено %s, ожидалось %s\n' "$actual" "$EXPECTED"
    exit 1
fi

printf 'Маркер БАНДИТ:\n'
besmtool search "$DISK" БАНДИТ 2>/dev/null | head -3
printf 'Интерфейс PASBDI:\n'
besmtool search "$DISK" PASBDI 2>/dev/null | head -5
