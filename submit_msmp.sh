#!/bin/bash

nodes=2
ntasks_per_node=4
t=00:05:00
partition=normal

numFE=1000000
runtimeFrequency=100

seeds=(1 2 3 4 5)

### round 1
numsFEPrevious=(0 0 0 0 0)

### round 2
#numsFEPrevious=(6100 6100 6100 6100 6100)

mkdir results/runtime
mkdir results/sets
mkdir results/checkpoints
mkdir results/evaluations
sed -i "s:nTasksPerNode = .*:nTasksPerNode = ${ntasks_per_node}:g" lake_mp.py 

### loop over seeds, getting info from arrays above
num_seeds=${#seeds[@]}
for (( i=0; i<$num_seeds; i++ )); do
    seed=${seeds[$i]}
    numFEPrevious=${numsFEPrevious[$i]}
    SLURM="#!/bin/bash\n\
#SBATCH -J s${seed} \n\
#SBATCH -o results/seed${seed}.out \n\
#SBATCH -e results/seed${seed}.err \n\
#SBATCH -t ${t} \n\
#SBATCH --nodes ${nodes} \n\
#SBATCH --ntasks-per-node ${ntasks_per_node} \n\
\n\
time mpirun python3 borg_lake_msmp.py $numFE $numFEPrevious $seed $runtimeFrequency \n\
\n\ "
    echo -e $SLURM | sbatch
    sleep 0.5
done
