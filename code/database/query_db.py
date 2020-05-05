import numpy as np
import pandas as pd
from ncls import NCLS
import sqlite3

data_location = "/fs/cbcb-scratch/jkanche/segments/top100/"
db_file_name = "segments_top100_4.db"

def build_index(starts, ends, indexes):
    idx =  NCLS(starts, ends, indexes)
    return idx

def get_index(type=None):
    if type == "segments":
        data = np.load("segments_idx.npz")
    elif type == "genes":        
        data = np.load("genes_idx.npz")

    return build_index(data["starts"], data["ends"], data["indexes"])

segments_idx = get_index("segments")
genes_idx = get_index("genes")

def find_genes_overlap(start, end, genome_id):
    matches = genes_idx.find_overlap(start, end)
    tids = []
    for m in matches:
        tids.append(str(m[2]))

    ids_string = ",".join(tids)

    conn = sqlite3.connect(data_location + db_file_name, uri=True)
    result = pd.read_sql('select start, end, source, type, strand, product, gene_names from genes where `index` IN (' + ids_string + ') and genome_id = "' + genome_id + '"', conn)
    return result

def find_segments_overlap(start, end, genome_id):
    matches = segments_idx.find_overlap(start, end)
    tids = []
    for m in matches:
        tids.append(str(m[2]))
    ids_string = ",".join(tids)
    
    # print('QUERY = select segment_id, start, end where index IN (' + ids_string + ') and genome_id = "' + genome_id + '"') 
    conn = sqlite3.connect(data_location + db_file_name, uri=True)
    result = pd.read_sql('select segment_id, start, end from segments where `index` IN (' + ids_string + ') and genome_id = "' + genome_id + '"', conn)
    return result
