#!/bin/bash

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# SPLIT  `graphdump` out file

# make sure that the info about the run is not stored in the gfa file itself
# head -n 23 run_tpc_gd.o > data/tpc_gd_call.txt
# tail -n +24 run_tpc_gd.o > $1

# rm run_tpc_gd.o

echo 'hello from split_tpcgd_outfile!!!!!!'