import sqlite3
import pandas as pd
import query_db as qdb #this is jays query_db.py file should be in the same directory to import it
import json
import sys
import os
import re
import time
import numpy as np
import matplotlib.pyplot as plt


# from pandarallel import pandarallel
# pandarallel.initialize()
#new_df= pd.DataFrame(columns=['start', 'end', 'source', 'type', 'strand', 'product', 'gene_names', 'attributes','segment_index']) #'inner_index',
'''
def edited_find_genes(whole):
    out= qdb.find_genes_overlap(whole["start"], whole["end"], whole["genome_id"])
    print('NEXT '+str(whole.name))
    #print(type(out))
    #print(whole)
    #print(whole.name)
    #print(type(whole.name))
    #print('type:')
    #print(type(whole))
    #print("this is the obj")
    #print(out)
    #print(out.dtypes)
    if out.empty:
        #print("EMP") start
        #d= {'start': ['emp'], 'end': ['emp'], 'source': ['emp'], 'type': ['emp'], 'strand': ['emp'], 'product': ['emp'], 'gene_names': ['emp'], 'attributes': ['emp']}
        df_emp = pd.DataFrame(data={'start': [whole.start], 'end': [whole.end], 'source': ['emp'], 'type': ['emp'], 'strand': [whole.strand], 'product': ['emp'], 'gene_names': ['emp'], 'attributes': ['emp'], 'segment_index': [whole.name]})
        #print(df_emp)
        new_df= new_df.append(df_emp, ignore_index = False)
        print(new_df)
        return df_emp
    else:
        
        #print(out.start.to_string(index=False))
        #print(out.end.to_string(index=False))
        #print(out.source.to_string(index=False))
        #start, end, source, type, strand, product, gene_names, attributes
        #'inner_index', ,'segment_index'
        out['segment_index']= whole.name
        #print(out)
        new_df= new_df.append(out, ignore_index = False)
        print(new_df)
        return out    
'''
## filter genes for segment
with open('/cbcbhomes/dfirer/SegmentAnalysis/code/analyze_shared/topsegs.txt', 'r') as input1: #the list of all the seg ids (unique) was created previously
    top100=json.load(input1)
seg_id= top100[int(sys.argv[1])][0] 
print(seg_id)   
print("query db for segment "+seg_id, flush=True)
conn = sqlite3.connect('/fs/cbcb-scratch/jkanche/segments/top100/segments_top100_4.db', uri=True)
#trial part
#all_segs = pd.read_sql("with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+") select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join genes b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end)", conn) #make limit 5 in virtual table to make small tests

all_segs= pd.read_sql("with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where not (start = 1 or type = 'sequence_uncertainty')), final as (select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id) select seg_row_id, gene_row_id, genome_id, start, end, type, attributes from final group by seg_row_id, genome_id, start, end", conn)
#get count of segments not mapped to a gene in the genes table -- doesnt work yet prob not nec
#nomap= pd.read_sql("with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where not (start = 1 or type = 'sequence_uncertainty')), final as (select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id) select count(attributes) from final group by attributes", conn)
#nomap.to_csv("nomapinfo"+seg_id+".csv", sep="\t") 
#with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where not (start = 1 or type = 'sequence_uncertainty')), final as (select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id) select seg_row_id, gene_row_id, genome_id, start, end, type, attributes from final group by seg_row_id, genome_id, start, end", conn)
#with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where not (start = 1 or type = 'sequence_uncertainty')), final as (select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id) select seg_row_id, gene_row_id, genome_id, start, end, type, CASE type WHEN 'exon' THEN 'e' WHEN 'rRNA' THEN 'r' WHEN 'gene' THEN 'g' ELSE 'o' END find, product, gene_names from final group by seg_row_id, genome_id, start, end", conn)
#with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where not (start = 1 or type = 'sequence_uncertainty')), final as (select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id) select seg_row_id, count(*) from final where type not null group by seg_row_id", conn)
#with find_seg as (select row_id, segment_id, genome_id, start, end, strand from segments where segment_id = "+seg_id+"), find_gene as (select * from genes where start <> 1) select a.row_id as seg_row_id, b.row_id as gene_row_id, a.segment_id, a.genome_id, b.start, b.end, b.source, b.type, b.strand, b.product, b.gene_names, b.attributes from find_seg a left join find_gene b on (a.genome_id = b.genome_id and a.start >= b.start and a.end <= b.end) order by seg_row_id", conn)
#print(type(all_segs))
#print(len(all_segs.index))
all_segs.to_csv("geneinfo2"+seg_id+".csv", sep="\t") #withSTATEorderedfullno1_seg_genes
count={}
att= all_segs.loc[: , "attributes"]
for index, whole in att.items():
    #print(index)
    #print(type(whole))
    
    #pattern = r"gene_biotype=([^;]+)|Note=([^;]+)|product=([^;]+)" #gene_biotype=([^;]+)$   gbkey=([^;]+)
    if whole is np.nan:
        #print("HERRREE")
        result= 'empty'
    elif all_segs.loc[index, "type"] == 'region' or all_segs.loc[index, "type"] == 'operon' or all_segs.loc[index, "type"] == 'repeat_region' \
            or all_segs.loc[index, "type"] == 'rRNA':
        #print("HERRREE1")
        pattern = r"gbkey=([^;]+)"
        preresult = re.search(pattern, whole)
        result= preresult[1]
    else: # deal with all other cases. normally want to get genebiotype but if it doesnt exist then get product, if no prod then note
        #print("HERRREE2")
        pattern = r"gene_biotype=([^;]+)"
        preresult = re.search(pattern, whole)
        if preresult:
            result= preresult[1]
        elif re.search(r"product=([^;]+)", whole):
            preresult= re.search(r"product=([^;]+)", whole)
            result= preresult[1]
        else:
            preresult= re.search(r"Note=([^;]+)", whole)
            result= preresult[1]   
    #print(result)
    #if index == 15:
        #break
    #print(type(result))
    '''
    if result is None: #or result== 'protein_coding' or result== 'other' or result== 'Rsite':
        print(index)
        print(whole)
    '''
    if result[:18] == 'rRNA operon region':
        result= 'rRNA operon'
    elif re.search(r"rRNA|ribosomal RNA", result):
        result= 'rRNA'
    elif re.search(r"Genomic Island", result):
        result= 'genomic island'    
    if result in count:
        count[result]+= 1
    else:
        count[result]=1    
print(count)


fig, ax = plt.subplots()
ax.set_title('Counts of Gene Regions')
ax.set_ylabel('Count (log scale)')
ax.set_xlabel('Region Types')
plt.bar(range(len(count)), list(count.values()), align='center')
plt.xticks(range(len(count)), list(count.keys()), fontsize= 6)
ax.set_yscale('log') #its log scale bc otherwise couldnt see all of the counts
plt.savefig('sample.png') #should prob change the name to what you are looking at