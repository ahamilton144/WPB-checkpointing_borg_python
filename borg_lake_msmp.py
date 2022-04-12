# Master-worker Borg run with Python wrapper
# ensure libborgms.so or libborgms.so is compiled and in this directory
from borg import *
from lake_mp import *
import sys

maxEvals = int(sys.argv[1])
maxEvalsPrevious = int(sys.argv[2])
seed = int(sys.argv[3])
runtimeFreq = int(sys.argv[4])

# need to start up MPI first
Configuration.startMPI()
    
# create an instance of Borg with the Lake problem
borg = Borg(nvars, nobjs, nconstrs, LakeProblemDPS)
Configuration.seed(seed)

runtimeFile = 'results/runtime/seed' + str(seed) + '.runtime'
setFile = 'results/sets/seed' + str(seed) + '.set'
evaluationFile = 'results/evaluations/seed' + str(seed) + '.evaluations'
newCheckpointFileBase = 'results/checkpoints/seed' + str(seed) # this is just base, will have "_nfe{}.checkpoint" appended, each time we write to runtime file
if maxEvalsPrevious > 0:
    oldCheckpointFile = 'results/checkpoints/seed' + str(seed) + '_nfe' + str(maxEvalsPrevious) + '.checkpoint'

# set bounds and epsilons for the Lake problem
borg.setBounds(*[[-2, 2], [0, 2], [0, 1]] * int((nvars / 3)))
borg.setEpsilons(0.01, 0.01, 0.0001, 0.0001)

# perform the optimization
if maxEvalsPrevious <= 0:
    result = borg.solveMPI(maxEvaluations=maxEvals, runtime=runtimeFile, frequency=runtimeFreq, newCheckpointFileBase=newCheckpointFileBase, evaluationFile=evaluationFile)
else:
    result = borg.solveMPI(maxEvaluations=maxEvals, runtime=runtimeFile, frequency=runtimeFreq, newCheckpointFileBase=newCheckpointFileBase, oldCheckpointFile=oldCheckpointFile, evaluationFile=evaluationFile)
# print the objectives to output
if result:
    result.display()
    f = open(setFile, 'w')
    for solution in result:
        line = ''
        for v in solution.getVariables():
            line += str(v) + ' '
        for o in solution.getObjectives():
            line += str(o) + ' '
        for c in solution.getConstraints():
            line += str(c) + ' '
        f.write(line[:-1] + '\n')
    f.write('#')
    f.close()

# shut down MPI
Configuration.stopMPI()

