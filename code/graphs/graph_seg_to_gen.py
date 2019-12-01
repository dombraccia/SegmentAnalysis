import matplotlib.pyplot as plt
import numpy as np
import matplotlib.mlab as mlab
import json

with open('/cbcbhomes/dfirer/dicts/dict_gen_to_seg.txt') as json_file:
    data = json.load(json_file)
count= []
for seg in data.values():
    count.append(len(seg))

num_bins= 50
n, bins, patches = plt.hist(count, num_bins, facecolor='blue', alpha=0.5)
plt.xlabel('# of Segments Per Genome')
plt.ylabel('Count of Genomes')
plt.title(r'Histogram of Counts of Genomes with x Segments')
print(bins)

plt.savefig("/cbcbhomes/dfirer/gen_to_seg.png")