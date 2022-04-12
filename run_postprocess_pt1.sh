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

mkdir results_overall

### find objectives & ref sets for each seed
for (( i=0; i<$num_results; i++ )); do
	seed=${seeds[$i]}
	nfe_init=${nfes_init[$i]}
	nfe_final=${nfes_final[$i]}
	subdir=results_round${round}

	### find reference set for this seed
	sh find_refset.sh $subdir $seed $nfe_init $nfe_final
	### get objective values at each runtime write
	sh find_objs.sh $subdir $seed $nfe_init $nfe_final
	### copy to overall ref set directory
	cp $subdir/*.reference results_overall
done

