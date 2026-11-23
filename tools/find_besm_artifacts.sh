#!/usr/bin/env bash
# Поиск маркеров КОМПАС/МАРС в образах дисков БЭСМ-6.
set -euo pipefail

PATTERNS=(КОБЛА БАНДИТ МАРС ФИЛ КОМПАС Компас)

IMAGES=("$@")
if [ "${#IMAGES[@]}" -eq 0 ]; then
    IMAGES=(
        /usr/local/share/besm6/2048
        /usr/local/share/besm6/2053
        /usr/local/share/besm6/2113
        /usr/local/share/besm6/2248
        /usr/local/share/besm6/2348
    )
fi

for image in "${IMAGES[@]}"; do
    if [ ! -f "$image" ]; then
        printf 'пропущен, файл не найден: %s\n' "$image"
        continue
    fi
    for pattern in "${PATTERNS[@]}"; do
        for encoding in UTF-8 CP866; do
            needle=$(printf '%s' "$pattern" | iconv -f UTF-8 -t "$encoding" 2>/dev/null) || continue
            [ -n "$needle" ] || continue
            if grep -a -F -q -- "$needle" "$image"; then
                printf '%s\t%s\t%s\n' "$image" "$pattern" "$encoding"
            fi
        done
    done
done
