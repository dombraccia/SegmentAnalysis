import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time
import sys

'''
A script for graphing histograms from segment_info.json dictionaries
'''

# ===================== LOADING IN STANDARD INPUT =========================== #

path2segInfoDF = sys.argv[1]
path2segUbiqityFig = sys.argv[2]
path2segLengthFig = sys.argv[3]

# ====================== LOADING IN PICKLED DATA ============================ #

# open up files from pickle
print('-- loading dataframe of seginfo ')
t = time.time()
segInfoDF = pickle.load(open(path2segInfoDF, "rb"))
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
plt.savefig(path2segUbiqityFig)
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
plt.savefig(path2segLengthFig)
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# =========================================================================== #
