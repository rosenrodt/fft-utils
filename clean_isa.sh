#!/bin/bash
# first: yank from start to \ts_nop 0.*\_s\ts_nop 0

sed -i 's/\/\/ .*//g' $1     # delete hex machine codes
sed -i 's/\s\+$//g' $1       # delete trailing white space
sed -i '/^; \/.*/d' $1       # delete reference line number
sed -i 's/^[0-9]\w*\s//g' $1 # delete code block address
