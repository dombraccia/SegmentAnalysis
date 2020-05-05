import sqlite3
import pandas as pd
import query_db as qdb

data_location = "/fs/cbcb-scratch/jkanche/segments/top100/"
db_file_name = "segments_top100_4.db"

## filter genes by type
print("query db for riboswitch", flush=True)
conn = sqlite3.connect(data_location + db_file_name, uri=True)
ribo_genes = pd.read_sql("select genome_id, start, end, product, gene_names from genes where type = 'riboswitch'", conn)

print("write genes to db", flush=True)
ribo_genes.to_csv("ribo_genes.csv", sep="\t")

# TODO: use joblib to parallelize
print("map ribo genes to segments", flush=True)
ribo_segments =  ribo_genes.apply(lambda x: qdb.find_segments_overlap(x["start"], x["end"], x["genome_id"]), axis=1)

ribo_segments = pd.concat([ribo_segments])
print("write segments to db", flush=True)
ribo_segments.to_csv("ribo_segments.csv", sep="\t")
