#!/bin/bash

set -e

pattern=$1

mkdir -p testruns

LOGFILE=testruns/testlog.txt

rm -f testruns/*.asm testruns/failed testruns/failed_expect

> $LOGFILE
for srcfile in $(find t/tests/ -type f -name "*.c" | sort); do
    if [[ $pattern ]]; then
        if [[ ! $srcfile =~ $pattern ]]; then
            echo "skip $srcfile"
            continue
        fi
    fi
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
    diff_output=$(mktemp)
    # grep -v $'[\t ]*;.*$' < $expectfile > $expectfile_clean
    # grep -v $'[\t ]*;.*$' < $output > $output_clean
    diff --label $expectfile --label $output -B -w -U4 $expectfile $output > $diff_output || true
    RET=$?
    if [[ 0 == $RET ]]; then
        true
    else
        cat $diff_output | colordiff
        echo "$output" > testruns/failed
        echo "$expectfile" > testruns/failed_expect
        break
    fi
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
