#!/usr/bin/env bash
# Cross-task chain: restore pristine disks, run 3 writers sequentially, then reader.
# Disks are NOT restored between writers or before the reader: the whole point is
# that MARS/KOBLA state persists on the shared disk across separate dispak tasks.
set -u
S="$(cd "$(dirname "$0")" && pwd)"
cd "$S"
DISKS="2048 2053 2099 2148 2196 2348"

restore() {
  for d in $DISKS; do cp -f "backups/$d.pristine" "$d"; done
}

snap() {
  local tag="$1"
  md5sum 2348 > "results/disk2348_after_${tag}.md5"
}

run() {
  local deck="$1" tag="$2"
  timeout 600 dispak --path=. -p "decks/$deck.b6" > "logs/${tag}.run" 2> "logs/${tag}.err"
  echo "$tag exit=$? errbytes=$(wc -c < logs/${tag}.err)"
}

restore
snap pristine
for c in 1 2 3; do
  run "writer_$c" "writer_$c"
  snap "writer_$c"
done
run "reader_123" "reader_123"
snap reader_123

echo "--- summary by task ---"
for tag in writer_1 writer_2 writer_3 reader_123; do
  echo "[$tag]"
  grep -aE '^[A-Z] |TAR|OPEN|LEN|OFF|D[0-9]|TOTAL|CHECKSUM|FINAL|DONE|INIT|PUTD|DATА ВАSЕ|КОНЕЦ ЗАДАЧИ' \
    "logs/${tag}.run" | tail -25
  echo "stderr: $(cat logs/${tag}.err | head -c 200)"
done
