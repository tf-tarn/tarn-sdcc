#!/bin/bash

set -e

mkdir -p testruns

LOGFILE=testruns/testlog.txt

rm testruns/*.asm

> $LOGFILE
for srcfile in $(find t/tests/ -type f -name "*.c" | sort); do
    echo $srcfile
    name=$(basename $srcfile)
    dir=$(dirname $srcfile)
    expectfile=$dir/$name.asm
    if [ ! -f $expectfile ]; then
        continue
    fi
    output=testruns/$name.asm
    rm -f $output
    (
        echo
        echo ==== BEGIN TEST $name ====
        set -x
        PRINT_SHORT_OPERANDS=2 sdcc -S $srcfile -o $output || true
    ) >> $LOGFILE 2>&1 || true
    expectfile_clean=$(mktemp)
    output_clean=$(mktemp)
    # sed -r 's/^[\t ]*;.*$//' < $expectfile > $expectfile_clean
    # sed -r 's/^[\t ]*;.*$//' < $output > $output_clean
    diff --label $expectfile --label $output -B -w -U4 $expectfile $output || true
done
echo log written to $LOGFILE

function generate {
    for srcfile in $(find t/tests/ -type f -name "*.c"); do
        name=$(basename $srcfile)
        dir=$(dirname $srcfile)
        expectfile=$dir/$name.e
        PRINT_SHORT_OPERANDS=2 bin/sdcc $srcfile 2>&1 > $expectfile
    done
}
