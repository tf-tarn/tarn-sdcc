#!/bin/bash

set -e

prog=$1

sed -i 's/\.db.*$/.zero 1/' ${prog}.asm

tarn-elf32-as ${prog}.asm -o /tmp/${prog}.o

export TEXT=0x4000
envsubst < /home/tarn/projects/tarn_sdcc/sdcc-4.2.0/t/ram-boot.ld.txt > /tmp/ld.txt

tarn-elf32-ld -T /tmp/ld.txt /tmp/${prog}.o -o /tmp/${prog}.out
tarn-elf32-objcopy -Oihex /tmp/${prog}.out ~/projects/mygcc/sim/${prog}.ihex
tarn-elf32-nm /tmp/${prog}.out | sort -g
tarn-elf32-objdump -s /tmp/${prog}.out
