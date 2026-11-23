#!/usr/bin/env bash
# Воспроизведение дымового теста МАРС из Pascal без изменения эталонных образов.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RUN="${1:-/tmp/.private/azizz/re-compass-run}"
SOURCE="${BESM6_IMAGES:-$HOME/.besm6}"

mkdir -p "$RUN"
for image in 2048 2053 2099 2148 2348; do
    cp "$SOURCE/$image" "$RUN/$image"
done
cp "$ROOT/tests/mars_smoke.b6" "$RUN/"

(
    cd "$RUN"
    dispak --path=. -p mars_smoke.b6 > output.run 2> output.err
)

if diff -u "$ROOT/tests/mars_smoke.expected.txt" "$RUN/output.run"; then
    printf 'smoke: PASS\n'
else
    printf ' smoke: FAIL, вывод отличается от эталона\n'
    exit 1
fi
