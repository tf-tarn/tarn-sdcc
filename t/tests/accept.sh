#!/bin/bash

set -e

if [ ! -f testruns/failed ]; then
    echo Nothing to accept.
else
    output=$(cat testruns/failed)
    expected=$(cat testruns/failed_expect)

    cp $output $expected
fi
