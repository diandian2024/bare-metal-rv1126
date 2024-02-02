#!/bin/zsh

qemu-system-arm -M virt -m 128M -cpu cortex-a7 -pflash build/rv1126-baremetal.img -nographic -serial /dev/null -S -s
