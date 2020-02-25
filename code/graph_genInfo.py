import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time
import sys

'''
A script for graphing histograms from genome_info.json dictionaries
'''

# ===================== LOADING IN STANDARD INPUT =========================== #
path2genInfoDF = sys.argv[1]
path2genSegmentationFig = sys.argv[2]
path2genUniqnessFig = sys.argv[3]

# ==================== OPENING UP FILES FROM PICKLE ========================= #
print('-- loading dataframe of genInfo ')
t = time.time()
genInfoDF = pickle.load(open(path2genInfoDF, "rb"))
# testInfo = genInfoDF[:100]
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ======================= BASIC HISTOGRAM PLOTS ============================= #
 
print('-- histogram of num_of_segments using matplotlib.pyplot')
t = time.time()
x = genInfoDF.num_of_segments #TODO: how many of these segments are uniqe? what are their lengths?
n, bins, patches = plt.hist(x, bins = 200) # TODO: calculate number of bins more ... better

plt.title('Genome Segmentation (# of segments per genome)')
plt.xlabel('number of segments')
plt.ylabel('number of genomes')
#plt.yscale('log', nonposy = 'clip')
plt.savefig(path2genSegmentationFig)
plt.close()
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ===================== NUMBER OF UNIQUE SEGS PLOTS ========================= #

print('-- histogram of num_uniq_segs using matplotlib.pyplot')
t = time.time()
x = genInfoDF[genInfoDF.num_uniq_segs < 1000]
n, bins, patches = plt.hist(x, bins = 1000)

plt.title('Genome Uniqeness (# of unique segments per genome)')
plt.xlabel('number of unique segments')
plt.ylabel('number of genomes')
plt.yscale('log', nonposy = 'clip')
plt.savefig(path2genUniqnessFig)
plt.close()
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")
