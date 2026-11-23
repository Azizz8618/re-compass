#!/usr/bin/env bash
# Воспроизведение интеграционного теста уровня СУБД (kompas_suite).
# Работает только с рабочими копиями дисков; оригиналы не изменяются.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN="${1:-/home/azizz/.cache/re-compass-kompas-suite}"
SOURCE="${BESM6_IMAGES:-$HOME/.besm6}"
EXTRA_2196="${DISPAK_2196:-$HOME/Yandex.Disk/dispak/tests/disks/2196}"

mkdir -p "$RUN"
for image in 2048 2053 2099 2148 2348; do
    cp "$SOURCE/$image" "$RUN/$image"
done
cp "$RUN/2348" "$RUN/2348.before"

# Тест требует PERSO-библиотеку COMTUP в зоне 2570 на рабочей копии 2348.
if [ -f "$EXTRA_2196" ]; then
    cp "$EXTRA_2196" "$RUN/2196"
fi
(
    cd "$RUN"
    dispak --path=. -p "$ROOT/tests/comtup_final_build.b6" > build.run 2> build.err
)

cp "$ROOT/tests/kompas_suite.b6" "$RUN/"
(
    cd "$RUN"
    dispak --path=. -p kompas_suite.b6 > out.run 2> out.err
)

normalize() {
    sed -E 's/[0-9]{2}\.[0-9]{2}\.26/DD.MM.26/g' "$1"
}

if diff -u <(normalize "$ROOT/tests/kompas_suite.expected.txt") <(normalize "$RUN/out.run"); then
    printf 'kompas_suite: PASS\n'
else
    printf 'kompas_suite: FAIL, вывод отличается от эталона\n'
    exit 1
fi
