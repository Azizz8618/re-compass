#!/usr/bin/env bash
# Распаковка архива Ильина во временный каталог без изменения исходника.
set -euo pipefail

ARCHIVE="${1:-$HOME/Рабочий стол/БЭСМ-6/Ильин_дискеты_февраль_2022.zip}"
OUT="${2:-${TMPDIR:-/tmp}/re-compass-ilyin}"

if [ ! -f "$ARCHIVE" ]; then
    printf 'архив не найден: %s\n' "$ARCHIVE" >&2
    exit 1
fi

mkdir -p "$OUT"
unzip -o -q "$ARCHIVE" -d "$OUT"
printf '%s\n' "$OUT"
