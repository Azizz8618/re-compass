#!/usr/bin/env bash
# Воспроизведение минимального порта TPREDT/ЯМД на Паскаль-Мониторе 15.1.
# Работает только с рабочими копиями дисков, оригиналы не изменяются.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUN="${1:-/home/azizz/.cache/re-compass-predtgen}"
SOURCE="${BESM6_IMAGES:-$HOME/.besm6}"
EXTRA_2196="${DISPAK_2196:-$HOME/Yandex.Disk/dispak/tests/disks/2196}"

mkdir -p "$RUN"
for image in 2048 2053 2099 2148 2348; do
    cp "$SOURCE/$image" "$RUN/$image"
done
cp "$EXTRA_2196" "$RUN/2196"
cp "$ROOT/tests/comtup_final_build.b6" "$ROOT/tests/predtgen.b6" "$RUN/"
(
    cd "$RUN"
    dispak --path=. -p comtup_final_build.b6 > build.run 2> build.err
    dispak --path=. -p predtgen.b6 > out.run 2> out.err
)

normalize() {
    sed -E 's/[0-9]{2}\.[0-9]{2}\.26/DD.MM.26/g' "$1"
}

if diff -u <(normalize "$ROOT/tests/predtgen.expected.txt") <(normalize "$RUN/out.run"); then
    printf 'predtgen: PASS (EXN=0 на всех шагах)\n'
else
    printf 'predtgen: FAIL, вывод отличается от эталона\n'
    exit 1
fi
