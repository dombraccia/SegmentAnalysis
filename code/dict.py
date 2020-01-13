print('-- begin `dict.py`')
import json
import os
from collections import Counter, defaultdict
import time

print('-- initialize dictionaries')
genomes={}
genome_counts={}
segments=defaultdict(list) # eliminates the need for if/else statements
segment_counts=Counter()   # need to make a seperate dictionary to store counts

print('-- writing genome_counts and segment_counts dictionaries')
t = time.time()
with open('data/plines.txt') as plines:
    #r= plines.readline().split()
    for i, line in enumerate(plines):
        if i % 1000 == 0:
            print('--- on genome number: ', str(i)) # check at every 1000 iterations
        if line[0] == 'P':
            line= line.split()
            segs_stranded= line[2].split(',')
            segs = [s[:-1] for s in segs_stranded] # removing +/- from end of segmentID
            current_genome = line[1]

            #### -------------------------------- ####

            genomes[current_genome]= segs # keeping p-line information in dict
                                          # NOTE: Can be stranded or unstranded segments
            genome_counts[current_genome] = len(set(segs))
            for each_seg in set(segs):
                segments[each_seg].append(current_genome) # appending the genome to segment keys
                segment_counts[each_seg] += 1
elapsed = time.time() - t
print('--- time elapsed:', round(elapsed/60, 3), "min")

print('-- write dictionaries to file')
t = time.time()
with open('data/genome_info.json', 'w') as gen_counts_out:
    json.dump(genome_counts, gen_counts_out)
with open('data/genomes.json', 'w') as gen_out:
    json.dump(genomes, gen_out)
with open('data/segment_info.json', 'w') as seg_counts_out:
    json.dump(segment_counts, seg_counts_out)
with open('data/segments.json', 'w') as seg_out:
    json.dump(segments, seg_out)
elapsed = time.time() - t
print('--- time elapsed:', round(elapsed/60, 3), "min")
