# WPB-checkpointing_borg_python

This repository contains all code related to the post ["Checkpointing and restoring runs with the Borg MOEA,"](https://waterprogramming.wordpress.com/?p=19135) by Andrew Hamilton, on the Water Programming Blog.

All experiments were run on the Cube cluster at Cornell University, using 2 nodes per seed. I used Python 3.9.4, and the only non-standard modules needed are scipy, numpy, pandas, matplotlib, and Jupyter Notebooks. 

You will also need to download the [Borg MOEA](http://borgmoea.org/). The Borg directory and the WPB-checkpointing_borg_python directory should be placed inside the same base directory. *For those of you who already have a copy of Borg* - make sure you have the repository named "Serial Borg MOEA" (which has both serial and master-worker implementations) rather than the "Borg MOEA" repository (which has the multi-master implementation). Once you have the right repo, switch to the "alh-python-checkpointing" branch, on which I have made some minor changes to improve the compatability of the Python wrapper with checkpointing & restoring functionalities: ```git checkout alh-python-checkpointing```

Lastly, download the [MOEA Framework](http://moeaframework.org/) and [pareto.py](https://github.com/matthewjwoodruff/pareto.py), and place them in the WPB-checkpointing_borg_python directory. 

This repository builds off of code from a [previous blog post](https://wordpress.com/post/waterprogramming.wordpress.com/19006) on parallelization of the Borg MOEA in Python, which itself built off of [Andrew Dircks' blog post] on the Borg MOEA Python wrapper and the Lake Problem.

To repeat the analysis, run the following steps from within the WPB-checkpointing_borg_python directory:

1. Compile the master-worker version of the Borg MOEA: ```sh compile_borg.sh```
2. Create a new folder called "results/": ```mkdir results```
3. Run 5 seeds of "round 1", the first iteration of optimization: ```sh submit_msmp.sh```. This will submit 5 separate jobs to the SLURM scheduler, one for each seed. Each job will run for 5 minutes on 2 nodes.
4. Once the jobs finish, change the name of the results folder to save the first round: ```mv results/ results_round1/```
5. Create a new results folder, along with a checkpoints folder inside of that: ```mkdir results/; mkdir results/checkpoint```
6. Copy the round 1 checkpoint files with the largest NFE for each seed into the new results folder. For my runs, all 5 seeds reached 6100 as the largest NFE. ```cp results_round1/checkpoints/seed*_nfe6100.checkpoint results/checkpoints/```
7. In "submit_msmp.sh", comment out the "numFEPrevious" for round 1 and uncomment for round 2. Then change the values in this list to be consistent with the checkpoint files you just copied over (e.g. for my experiment, each NFE is set to 6100)
8. Run 5 seeds of round 2 with the same command from step #3
9. When round 2 is finished, copy the results folder to "results_round2"
10. Run the first postprocessing script for round 1, which calculates the reference sets and extracts objective values for each seed: ```sh run_postprocess_pt1.sh```
11. Comment out the three lines below "#### round 1" in "run_postprocess_pt1.sh", and uncomment the lines for round 2. Fill in the values of "nfes_init" and "nfes_final" based on the smallest and largest NFE values for each seed in the round 2 results. Then rerun the command for step #10.
12. Repeat the instructions for steps #10 and #11, but for the second postprocessing script, "run_postprocess_pt2.sh". This script calculates the overall reference set across all seeds, calculates runtime metrics (e.g., hypervolume) for each seed, and extracts the recombination operator probabilities for each seed.
13. Copy all results to a local computer, then open and run the Jupyter Notebook ```process_results.ipynb```, which will create all figures from the blog post.
