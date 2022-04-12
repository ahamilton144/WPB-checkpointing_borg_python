#/bin/bash

results=$1

### for each directory, get ref sets from checkpoint file. Manually add correct checkpoint file for each directory.
seed=$2
nfe_init=$3
nfe_final=$4

setfile=$results/sets/seed${seed}_nfe${nfe_final}.set
checkptfile=$results/checkpoints/seed${seed}_nfe${nfe_final}.checkpoint
### get lines bracketing archive
line1=$(grep -n "Archive:" $checkptfile | tr ":" " ")
line1=($line1)
line1=${line1[0]}
let line1++
line2=$(grep -n "Number of Improvements:" $checkptfile | tr ":" " ")
line2=($line2)
line2=${line2[0]}
let line2--
### print archive to set file
sed -n ${line1},${line2}p $checkptfile > $setfile
sed "s/^[ \t]*//" -i $setfile

###get reference sets
python pareto.py $setfile -o 6-9 -e 0.01 0.01 0.0001 0.0001 --output $results/seed${seed}_nfe${nfe_final}.resultfile --delimiter=" " --comment="#"
cut -d ' ' -f 7-10 $results/seed${seed}_nfe${nfe_final}.resultfile > $results/seed${seed}_nfe${nfe_final}.reference

