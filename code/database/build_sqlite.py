import pandas as pd
import numpy as np

data_location = "/fs/cbcb-lab/hcorrada/SGVFinder/SegmentAnalysis/data/"
db_file_name = "segments_top100_4.db"

print("reading segments", flush=True)
segments = pd.read_csv(data_location + "scg_flines_top100_shared.tsv", sep="\t", names=["type", "segment_id", "genome_id", "score", "seg_length", "start", "end", "overlap"])
segments["row_id"] = segments.index.values
# segments.head()
segments["strand"] = segments["genome_id"].str[-1:]
segments["genome_id"] = segments["genome_id"].str[:-1]
segments["overlap"] = segments["overlap"].str.replace("M", "")
segments["seg_length"] = segments["seg_length"].str.replace("$", "")
# segments.head()

print("reading genomes", flush=True)
genes = pd.read_csv(data_location + "scg_annotations.gff", sep="\t", names=["genome_id", "source", "type", "start", "end", "score", "strand", "phase", "attributes"], comment='#', nrows=100000)
genes["row_id"] = genes.index.values
# genes.head()

def parse_attribute_product(item):
    key="product"
    if key in item:
        tstr = item.split(key, 1)
        tstrval = tstr[1].split(";", 1)
        return tstrval[0][1:]
    else:
        return None

def parse_attribute_gnames(item):
    key="Name"
    if key in item:
        tstr = item.split(key, 1)
        tstrval = tstr[1].split(";", 1)
        return tstrval[0][1:]
    else:
        return None

print("mapping products to genomes", flush=True)
genes["product"] = genes["attributes"].apply(parse_attribute_product)

print("mapping gene_names to genomes", flush=True)
genes["gene_names"] = genes["attributes"].apply(parse_attribute_gnames)

# seg_gen_matches = pd.DataFrame()

# print("finding matches with genomes", flush=True)
# for index, row in segments.iterrows():
#     matches = genes[(genes["genome_id"] == row["genome_id"]) & (genes["start"] <= row["end"]) & (genes["end"] >= row["start"])]
#     matches["seg_row_id"] = row["row_id"]
#     seg_gen_matches = pd.concat([seg_gen_matches, matches])
#     if index % 1000 == 0:
#         print("\t finding match done", index)

import sqlite3
conn = sqlite3.connect(db_file_name)

print("db: write segments", flush=True)
segments.to_sql(name='segments', con=conn)
conn.commit()

print("db: write segments", flush=True)
genes.to_sql(name='genes', con=conn)
conn.commit()

# print("db: write segments to genome matches", flush=True)
# seg_gen_matches.to_sql(name='segments_genes_matches', con=conn)
# conn.commit()

print("db: generate indexes", flush=True)
c.execute("CREATE INDEX segments_seg_idx ON segments (segment_id)")
c.execute("CREATE INDEX segments_gen_idx ON segments (genome_id)")
c.execute("CREATE INDEX genes_genome_idx ON genes (genome_id)")
c.execute("CREATE INDEX genes_type_idx ON genes (type)")
conn.commit()
c.execute("CREATE INDEX segments_genes_genome_idx ON genes (genome_id)")
c.execute("CREATE INDEX segments_genes_genes_idx ON genes (gene_names)")
c.execute("CREATE INDEX segments_genes_type_idx ON genes (type)")
c.execute("CREATE INDEX segments_genes_prd_idx ON genes (type)")

conn.close()

print("generate segment index", flush=True)
# segments_idx =  NCLS(segments["start"].values, segments["end"].values, segments.index.values)
np.savez("segments_idx", starts = segments["start"].values, ends = segments["end"].values, indexes = segments.index.values)

print("generate genes index", flush=True)
# genes_idx =  NCLS(genes["start"].values, genes["end"].values, genes.index.values)
np.savez("genes_idx", starts = genes["start"].values, ends = genes["end"].values, indexes = genes.index.values)