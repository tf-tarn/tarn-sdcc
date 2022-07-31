#!/bin/bash

set -e
for srcfile in $(find sdcc-dev/tests/ -type f -name "*.c"); do
    name=$(basename $srcfile)
    dir=$(dirname $srcfile)
    expectfile=$dir/$name.asm
    PRINT_SHORT_OPERANDS=2 sdcc $srcfile -o $expectfile || true
done
