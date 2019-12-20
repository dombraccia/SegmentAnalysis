import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import time

'''
A script for graphing histograms from genome_info.json dictionaries
'''

# open up files from pickle
print('-- loading dataframe of genInfo ')
t = time.time()
genInfoDF = pickle.load(open("../results/genInfoDF.pickle", "rb"))
# testInfo = genInfoDF[:100]
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ======================= BASIC HISTOGRAM PLOTS ============================= #
 
print('-- histogram of num_of_segments using matplotlib.pyplot')
t = time.time()
print('column name(s):', genInfoDF.columns)
x = genInfoDF.num_of_segments #TODO: how many of these segments are uniqe? what are their lengths?
n, bins, patches = plt.hist(x, bins = 200) # TODO: calculate number of bins more ... better

plt.title('Genome Segmentation (# of segments per genome)')
plt.xlabel('number of segments')
plt.ylabel('number of genomes')
#plt.yscale('log', nonposy = 'clip')
plt.savefig('../results/scg_genome_segmentation.png')
plt.close()
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# ===================== NUMBER OF UNIQUE SEGS PLOTS ========================= #

print('-- histogram of num_uniq_segs using matplotlib.pyplot')
t = time.time()
x = genInfoDF.num_uniq_segs
n, bins, patches = plt.hist(x, bins = 350)

plt.title('Genome Uniqeness (# of unique segments per genome)')
plt.xlabel('number of unique segments')
plt.ylabel('number of genomes')
plt.yscale('log', nonposy = 'clip')
plt.savefig('../results/scg_genome_uniqness.png')
plt.close()
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")
