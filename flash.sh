#!/usr/bin/env bash

set -eu

device="$1"
binary="$2"

esptool.py -p "$device" write_flash 0x00 "$binary" 
esptool.py -p "$device" write_flash 0xfb000 zeros.bin