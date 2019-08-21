#!/usr/bin/env bash

set -eu

echo "String $1 ="
sed -e 's/"/\\"/g' -e 's/$/"/g' -e 's/^/"/g'
echo ";"