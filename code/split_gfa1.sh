#!/bin/bash
#SBATCH -J split_gfa # Job name 
#SBATCH -o split_gfa1_%j.o # Name of output file
#SBATCH -e split_gfa1_%j.e # Name of error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00                                                   
#SBATCH --qos=large 
#SBATCH --mem=128gb

## TODO: get rid of header genomes lines from outputted fasta file ##

### FASTA FILE ###
# converting the GFA1 output from  `twopaco` / `graphdump` to fasta 
# format where each sequence in the .fasta is a contig from the colored 
# deBruijn graph.

# Input:
# $1: location of GFA1 file (eample: data/subset_Streptococcus.gfa1)

INPUT=`echo $1 | sed s/.gfa1/.fasta/`
FA_FILE_NAME="segment_${INPUT}"
#META_FILE_NAME=`echo $1 | sed s/.gfa1/.meta/`
echo $FA_FILE_NAME
#echo $META_FILE_NAME

HEADER_LINES=`grep 'UR:Z:' $1 | wc -l`
echo $HEADER_LINES

### FASTA FILE ###
# generating the fasta file from S lines in gfa output
awk '/^S/{print ">"$2"\n"$3}' $1 | \
    tail -n +$HEADER_LINES | \
    sed '/\./,+1 d' > $FA_FILE_NAME # should get rid of the genome ID lines

### METADATA FILE ###
# keeping a parsable metadata file to retrace where segments come from

# TASK: remove all lines of the .gfa1 file that contain S
#sed '/^S/ d' $1 > $META_FILE_NAME
