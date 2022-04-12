#!/bin/bash

cd ../serial-borg-moea/C
mpicc -shared -march=native -fPIC -O3 -o libborg.so borg.c mt19937ar.c -lm
mpicc -shared -march=native -fPIC -O3 -o libborgms.so borgms.c mt19937ar.c -lm
cp libbor*.so ../../WPB-checkpointing_borg_python/
cp ../Python_wrapper/borg.py ../../WPB-checkpointing_borg_python/
