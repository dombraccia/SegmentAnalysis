#!/bin/bash
#SBATCH -J insert # Job name 
#SBATCH -o insert_genomes_%j.o # Name of output file
#SBATCH -e insert_genomes_%j.e # Name of error file
#SBATCH --mail-user=dbraccia@terpmail.umd.edu # Email for job info
#SBATCH --mail-type=fail,end # Get email for begin, end, and fail
#SBATCH --time=11-00:00:00                                                   
#SBATCH --qos=large
#SBATCH --mem=128gb

## TRYING TO INSERT THE GENOMES OF EACH BACTERIA INTO THEIR RESPECTIVE
## 'S' LINE IN THE GFA FILE

#initializing $filename
#filename=../data/B.tmp # testing
filename=../data/genome_s_lines.tmp

#find all S_lines with a '*' in the third field & subset to tmp file
#head -n 20000 ../data/scg_segments_k99.gfa1 | awk '$3 ~ /*/ {print}' >> ../data/genome_s_lines.tmp

#replace these fields with the matching genome
GENOME_S_LINES=`cat $filename` #works
#GENOME_S_LINES=`cat ../data/A.txt`

#initializing & setting '\n' to be only seperator in for looping
count=2
IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
#looping
for line in $GENOME_S_LINES;
do
    #checking step & line info
    echo $count
    echo $line

    #grabbing correct line in fasta file
    #current_genome=`awk "NR == \$count" ../data/A.fasta` #testing
    current_genome=`awk "NR == \$count" ../data/subset_complete_genome.fasta`

    #replacing the 3rd field with '*' with the actual genome for that bacteria
    #echo "${line/\*/$current_genome}" >> ../data/B_ref.tmp #testing
    echo "${line/\*/$current_genome}" >> ../data/genome_s_lines_complete.tmp

    #incrimenting
    count=`expr $count + 2`
done

#NOW: replace all leading S-lines in .gfa1 file with those from 
#     genome_s_lines_complete.tmp which contain whole genomes



# once completely replaced in the actual .gfa file, delete all temp files
