#!/bin/bash

results=$1
seed=$2
nfe_init=$3
nfe_final=$4

mkdir $results/objs
awk 'BEGIN {FS=" "}; /^#/ {print $0}; /^[^#/]/ {printf("%s %s %s %s\n",$7,$8,$9,$10)}' $results/runtime/seed${seed}.runtime > $results/objs/seed${seed}_nfe${nfe_final}.obj
