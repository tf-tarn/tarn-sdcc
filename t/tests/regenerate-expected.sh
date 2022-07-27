#!/bin/bash

set -e
for srcfile in $(find t/tests/ -type f -name "*.c"); do
    name=$(basename $srcfile)
    dir=$(dirname $srcfile)
    expectfile=$dir/$name.e
    PRINT_SHORT_OPERANDS=2 bin/sdcc $srcfile 2>&1 > $expectfile || true
done
