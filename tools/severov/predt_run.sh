#!/usr/bin/env bash
# Воспроизведение минимального порта TPREDT/ЯМД на Паскаль-Мониторе 15.1.
# Оригинальные образы и репозиторий не изменяются.
set -euo pipefail
S="$(cd "$(dirname "$0")" && pwd)"
RUN="$S/run-repro"
mkdir -p "$RUN"
cp "$S"/disks/{2048,2053,2099,2148,2348,2196} "$RUN/"
cp /home/azizz/Yandex.Disk/re-compass/tests/comtup_final_build.b6 "$RUN/"
cp "$S/work/predtgen.b6" "$RUN/"
(
  cd "$RUN"
  dispak --path=. -p comtup_final_build.b6 > build.run 2> build.err
  dispak --path=. -p predtgen.b6 > out.run 2> out.err
)
diff -u "$S/work/predtgen.expected.txt" "$RUN/out.run"
printf 'predtgen: PASS (EXN=0 на всех шагах)\n'
