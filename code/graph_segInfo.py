import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time

'''
A script for graphing histograms from segment_info.json dictionaries
'''

# ====================== LOADING IN PICKLED DATA ============================ #

# open up files from pickle
print('-- loading dataframe of seginfo ')
t = time.time()
segInfoDF = pickle.load(open("../results/segInfoDF.pickle", "rb"))
# segInfoDF = pickle.load(open("../results/testInfoDF.pickle", "rb"))
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ======================= BASIC HISTOGRAM PLOTS ============================= #
 
print('-- histogram of num_of_genomes using matplotlib.pyplot')
t = time.time()
x = segInfoDF.num_of_genomes
n, bins, patches = plt.hist(x, bins = 400) #TODO: calculate number of bins more ... better
plt.title('Segment Ubiquity')
plt.xlabel('number of genomes')
plt.ylabel('log(number of segments)')
plt.yscale('log', nonposy='clip')
plt.savefig('../results/scg_segment_ubiquity.png')
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

print('-- histogram of length_(bp) using matplotlib.pyplot')
t = time.time()
x = segInfoDF.length_bp
n, bins, patches = plt.hist(x, bins = 400, color = "b") #TODO: calculate number of bins more ... better
plt.title('Segment Lengths')
plt.xlabel('segment length (bp)')
plt.ylabel('number of segments')
#plt.yscale('log', nonposy='clip')
plt.savefig('../results/scg_segment_length.png')
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# =========================================================================== #
