#!/bin/bash 
#SBATCH -J tpc_gd # Job name 
#SBATCH -o run_tpc_gd.o # Name of output file
#SBATCH -e run_tpc_gd.e # Name of error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=21-00:00:00 
#SBATCH --qos=xlarge
#SBATCH --mem=500gb

##### TODO: MODIFY TO WORK IN SEGMENTANALYSIS PIPELINE

# THIS SCRIPT: combining the twopaco and graph dump scripts into one

# $1 output file name for de Bruijn graph
# $2 kvalue 99
# $3 ../data/from-ncbi/subset_Streptococcus.fasta is an example of a \
# fasta file of genomes for input 

# EXAMPLE sbatch CALL: 
# sbatch run_TwoPaCo.sh subset_complete_genome.bin 99 ../data/from-ncbi/subset_complete_genome.fasta 

# job script for running TwoPaCo on all reference genomes
/usr/bin/time external/TwoPaCo/build/graphconstructor/twopaco \
    --threads 16 \
    -f 40 \
    -o $1 \
    --kvalue $2 \
    $3

## RUNNING `graphdump` TO EXTRACT GFA1 FILE FROM de Bruijn  GRAPH

# Standard input values:
# $1: dB graph to parse and dump 
#     example: ./de_Bruijn.bin
# $2: k value used in the segments generation step 
#     example: 99
# $3: location of the original fasta file containing genomes 
#     example: '../data/from-ncbi/subset_complete_genome.fasta'
/usr/bin/time time external/TwoPaCo/build/graphdump/graphdump \
    $1 \
    -f gfa1 \
    -k $2 \
    -s $3

# removing debruijn graph after creation
rm $1

# run shell script which splits the log and gfa file
# $4: name of output gfa file (example: subset_complete_genome.gfa1)
bash code/split_tpcgd_outfile.sh $4

# renaming the output file: DO THIS SEPERATELY FOR NOW
#mv run_tpc_gd_%j.o ../data/test/test_genomes/test_genomes.gfa1
