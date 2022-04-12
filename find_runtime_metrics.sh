#!/bin/bash

results=$1
seed=$2
nfe_init=$3
nfe_final=$4

JAVA_ARGS="-cp ../MOEAFramework-2.12-Demo.jar"

name=seed${seed}_nfe${nfe_final}
mkdir $results/metrics

slurmscript="\
#!/bin/bash\n\
#SBATCH -J ${name}\n\
#SBATCH -N 1\n\
#SBATCH -n 1\n\
#SBATCH -p normal\n\
#SBATCH -t 1:00:00\n\
#SBATCH -o $results/metrics/$name.metricsout\n\
#SBATCH -e $results/metrics/$name.metricserr\n\
java ${JAVA_ARGS} org.moeaframework.analysis.sensitivity.ResultFileEvaluator \
	-d 4 -i $results/objs/seed${seed}_nfe${nfe_final}.obj -r results_overall/overall.reference \
	-o $results/metrics/${name}.metrics"
echo -e $slurmscript | sbatch

