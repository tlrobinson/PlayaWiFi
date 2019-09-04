#!/usr/bin/env bash

set -eu

logs="logs"
mkdir -p "$logs"

device_prefix="$1"
binary="$2"
once="$3"

flash-device() {
  device="$1"
  binary="$2"
  echo "flashing: $device"
  if ./flash.sh "$device" "$binary" > "$logs/$(basename $device).out"  2> "$logs/$(basename $device).err"; then
    echo "done: $device"
  else
    echo "error: $device"
  fi
}

list-serial-devices() {
  ls $device_prefix* 2>/dev/null | cat
}

prev="$logs/.prev.txt"
next="$logs/.next.txt"

echo > "$prev"

pids=()
while true; do
  list-serial-devices > "$next"
  for device in $(comm -23 <(sort -n "$next") <(sort -n "$prev")); do
    echo "connected: $device"
    flash-device "$device" "$binary" &
    pids+=($!)
  done
  if [ "$once" ]; then
    break;
  fi
  sleep 1
  mv "$next" "$prev"
done

wait ${pids[*]}