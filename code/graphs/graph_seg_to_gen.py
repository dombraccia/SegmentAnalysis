import matplotlib.pyplot as plt
import numpy as np
import matplotlib.mlab as mlab
import json

with open('/cbcbhomes/dfirer/dicts/dict_seg_to_gen.txt') as json_file:
    data = json.load(json_file)
count= []
for seg in data.values():
    count.append(len(seg))

num_bins= 300
n, bins, patches = plt.hist(count, num_bins, facecolor='blue', alpha=0.5)
plt.xlabel('# of Genomes Per Segment')
plt.ylabel('Count of Segments')
plt.title(r'Histogram of Counts of Segments with x Genomes')
print(bins) #will print the bin edges
plt.ylabel('Count of Segments')
plt.xlabel('# of Genomes Per Segment')
plt.title(r'Histogram of Counts of Segments with x Genomes')

plt.savefig("/cbcbhomes/dfirer/seg_to_gen.png")