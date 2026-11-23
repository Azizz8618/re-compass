#!/bin/bash
# Syntax-only acceptance check for the 18 generated Severov application decks.
# Usage: tools/severov/check_decks.sh <working-disks-dir> <report-file>
# The working disks directory must contain writable copies of 2048,2053,2099,2148,2348,2196.
set -u
REPO=$(cd "$(dirname "$0")/../.." && pwd)
DISKS=${1:?нужен каталог с рабочими копиями дисков}
REPORT=${2:-"$REPO/docs/severov-apps/DECK-CHECK.syntax.txt"}
LOGDIR=$(mktemp -d /tmp/.private/azizz/deckcheck.XXXXXX)
: > "$REPORT"
for d in "$REPO"/tests/severov-apps/*.b6; do
  n=$(basename "$d" .b6)
  timeout 120 dispak --path="$DISKS" -p "$d" \
      < /dev/null > "$LOGDIR/$n.run" 2> "$LOGDIR/$n.err"
  rc=$?
  banner=$(grep -c '15\.1 (28\.10\.26)' "$LOGDIR/$n.run" || true)
  endtask=$(grep -c 'КОНЕЦ ЗАДАЧИ' "$LOGDIR/$n.run" || true)
  diag=$(grep -c '\*\*\*\*\*\*' "$LOGDIR/$n.run" || true)
  absent=$(grep -c 'ОТСУТСТВУЕТ' "$LOGDIR/$n.run" || true)
  printf '%-8s rc=%3d banner=%s end=%s diag=%3s absent=%s stderr="%s"\n' \
    "$n" "$rc" "$banner" "$endtask" "$diag" "$absent" "$(tr '\n' ' ' < "$LOGDIR/$n.err")" >> "$REPORT"
done
echo "логи проверки: $LOGDIR" >> "$REPORT"
