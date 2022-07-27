#!/bin/bash

set -e

mkdir -p testruns

LOGFILE=testruns/testlog.txt

> $LOGFILE
for srcfile in $(find t/tests/ -type f -name "*.c"); do
    echo $srcfile
    name=$(basename $srcfile)
    dir=$(dirname $srcfile)
    expectfile=$dir/$name.e
    output=testruns/$name.output
    rm -f $output
    (
        echo
        echo ==== BEGIN TEST $name ====
        set -x
        PRINT_SHORT_OPERANDS=2 bin/sdcc $srcfile > $output
    ) >> $LOGFILE 2>&1 || true
    diff -U1 $expectfile $output || true
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
