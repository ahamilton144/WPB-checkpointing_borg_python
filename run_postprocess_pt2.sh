#!/bin/bash

seeds=(1 2 3 4 5)

#### round 1
#round=1
#nfes_init=(0 0 0 0 0)
#nfes_final=(6100 6100 6100 6100 6100)

### round 2
round=2
nfes_init=(6101 6101 6101 6101 6101)
nfes_final=(12101 12101 12101 12101 12101)

### run postprocessing for this round
num_results=${#seeds[@]}

### get overall reference set (only need to do this once in 1st round, since all rounds' ref sets have been copied there in run_postprocess_pt1.sh)
if [ $round -eq 1 ]; then
	python ../pareto.py results_overall/*.reference -o 0-3 -e 0.01 0.01 0.0001 0.0001 --output results_overall/overall.reference --delimiter=" " --comment="#"
fi

### find runtime metrics
for (( i=0; i<$num_results; i++ )); do
	seed=${seeds[$i]}
	nfe_init=${nfes_init[$i]}
	nfe_final=${nfes_final[$i]}
	subdir=results_round${round}

	### find runtime metrics
	sh find_runtime_metrics.sh $subdir $seed $nfe_init $nfe_final
	### find operator dynamcs
	sh find_operators.sh $subdir $seed $nfe_init $nfe_final
done
