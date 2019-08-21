#!/usr/bin/env bash

set -eu

logs="logs"
mkdir -p "$logs"

device_prefix="$1"
binary="$2"

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
while true; do
  list-serial-devices > "$next"
  comm -23 <(sort -n "$next") <(sort -n "$prev") | while read device; do
    echo "connected: $device"
    flash-device "$device" "$binary" &
  done
  sleep 1
  mv "$next" "$prev"
done
