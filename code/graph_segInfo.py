import json
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import vaex
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
n, bins, patches = plt.hist(x, bins = 400)
print('n =', n)
print('bins =', bins)
print('patches =', patches)

plt.title('Segment Ubiquity')
plt.xlabel('number of genomes')
plt.ylabel('log(number of segments)')
plt.yscale('log', nonposy='clip')
plt.savefig('../results/test_hist.png')
# aplot = testInfoDF.num_of_genomes.hist()
# aplot.savefig('../results/test_hist.png')
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# =========================================================================== #

'''
# ======================= PLOTTING USING SEABORN ============================ #
grid.set(yticks = ticks, yticklabels = labels)
print('-- plotting segment length and ubiquity hex plot')
t = time.time()

# subsetting out unique segment
segInfoShared = segInfoDF[segInfoDF["num_of_genomes"] > 1]
print("--- size of original df:   ", segInfoDF.shape)
print("--- size of shared segs df:", segInfoShared.shape)

# setting plot attributes
f, ax = plt.subplots(figsize=(7, 7))
ax.set(xscale="log", yscale="log")
#cmap = sns.cubehelix_palette(as_cmap=True, reverse=True)

jointplot = sns.jointplot(x = np.log(segInfoShared["length_(bp)"]), 
              y = np.log(segInfoShared["num_of_genomes"]), 
              kind = "hex",
              cmap = cmap)
#ax.set(xlabel='log(segment length) in bp', 
#       ylabel='log(num of genomes)')
jointplot.savefig("../results/log(len_vs_numGenomes)_shared.png")

#genomes_hist = sns.distplot(segInfoDF["num_of_genomes"], kde=False, rug=True, bins=50)
#genomes_hist.savefig("../results/num_of_genomes_hist.png") # can't save plot?
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")

# =========================================================================== #
'''


'''
t = time.time()
jointplot = sns.jointplot(x = segInfoDF["length_(bp)"], 
              y = segInfoDF["num_of_genomes"], 
              kind = "hex")
jointplot.savefig("../results/length_vs_numOfGenomes.png")

#genomes_hist = sns.distplot(segInfoDF["num_of_genomes"], kde=False, rug=True, bins=50)
#genomes_hist.savefig("../results/num_of_genomes_hist.png") # can't save plot?
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed/60, 2), "min")
'''
'''
print('-- plotting length histogram')
t = time.time()
length_hist = sns.distplot(segInfoDF["length_(bp)"], kde=False, rug=True, bins=50)
length_hist.savefig("../results/seg_lengths_hist.png")
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed), "sec")

print('-- plotting GC content histogram')
t = time.time()
gc_hist = sns.distplot(segInfoDF["GC_content_(%)"], kde=False, rug=True, bins=50)
gc_hist.savefig("gc_content_hist.png")
elapsed = time.time() - t
print("--- time elapsed: ", round(elapsed), "sec")

#print('-- plotting seg ubiquity vs seg length scatter')
'''


# add axis titles
'''
n, bins, patches = plt.hist(segInfoDF["num_of_genomes"], bins='auto')
plt.xlabel('number of genomes appeared in')
plt.ylabel('number of segments')
plt.title('Number of segments shared across genomes in RefSeq')
plt.savefig('../results/segs_across_genomes.png')
plt.close()

print('-- plotting segment length histogram')
n, bins, patches = plt.hist(segInfoDF["length_(bp)"], bins='auto')
plt.xlabel('length of sequence (bp)')
plt.ylabel('number of segments')
plt.title('Length of all segments histogram')
plt.savefig('../results/seg_lengths.png')
plt.close()

print('-- plotting scatter of segment length and ubiquity across genomes')
plt.scatter(x = segInfoDF["length_(bp)"], y = segInfoDF["num_of_genomes"])
plt.xlabel('length of segment (bp)')
plt.ylabel('numer of genomes segment appears in')
plt.title('Relationship between segment length and ubiquity across reference genomes')
plt.savefig('../results/ubiquity_vs_segLength.png')
plt.close()
'''

'''
# test dictionary plotting
d = {"68562730": [2, 104, 50], "218553201": [377, 102, 58], "148856740": [1, 199, 36], "224152203": [31, 100, 53], "207775387": [1, 160, 50], "75563229": [665, 100, 56], "65547318": [205, 101, 50], "233519523": [1, 105, 58], "277752437": [1, 105, 52], "277752433": [1, 158, 46]}
dDF = pd.DataFrame.from_dict(d, orient = "index")
dDF.columns = ["num_of_genomes", "length_(bp)", "GC_content_(%)"]
print(dDF)

# test plotting 
n, bins, patches = plt.hist(dDF["num_of_genomes"])
plt.savefig('test_hist.png')
'''
