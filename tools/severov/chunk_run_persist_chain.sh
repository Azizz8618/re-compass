#!/usr/bin/env bash
# Persistent 3-writer -> reader chain on disk pack LU 41 (-wr).
set -u
S="$(cd "$(dirname "$0")" && pwd)"
cd "$S"
DISKS="2048 2053 2099 2148 2196 2348"

restore() { for d in $DISKS; do cp -f "backups/$d.pristine" "$d"; done; }
run() {
  local deck="$1" tag="$2"
  timeout 600 dispak --path=. -p "decks/$deck.b6" > "logs/${tag}.run" 2> "logs/${tag}.err"
  echo "$tag exit=$? errbytes=$(wc -c < logs/${tag}.err) disk2348=$(md5sum 2348 | cut -d' ' -f1)"
}

restore
echo "pristine disk2348=$(md5sum 2348 | cut -d' ' -f1)"
for c in 1 2 3; do run "pchain_w$c" "pchain_w$c"; done
run "pchain_reader" "pchain_reader"

echo "--- program output per task ---"
for tag in pchain_w1 pchain_w2 pchain_w3 pchain_reader; do
  echo "[$tag]"
  sed -n '/\*ЕХЕСUТЕ/,/КОНЕЦ ЗАДАЧИ/p' "logs/${tag}.run" | grep -aE '^[A-Z] |TAR|OPEN|LEN|OFF|D[0-9]|LOGICAL|CHECKSUM|FINAL|KOB|DONE|DATА ВАSЕ' | head -40
done
