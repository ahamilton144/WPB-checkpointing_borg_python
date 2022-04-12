#!/bin/bash

results=$1
seed=$2
nfe_init=$3
nfe_final=$4

runtimefile=$results/runtime/seed${seed}.runtime

mkdir $results/operators

for operator in SBX DE PCX SPX UNDX UM NFE
do
	operatorfile=$results/operators/seed${seed}_nfe${nfe_final}.${operator}
	grep $operator $runtimefile | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | tee $operatorfile >/dev/null
done
