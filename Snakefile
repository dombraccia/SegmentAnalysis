# ============================ INITIALIZE LISTS ============================= #
# Would be useful to list out all different subsets of genomes I would like to
# run this analysis on like list = ["subset_complete_genome", "subset_Strep", ...]

#subsets = ["subset_complete_genome", "subset_Streptococcus"] # do this later

# =========================== SEGMENT GENERATION ============================ #

# also downloads genome annotations from same loc
rule download_refseq_genomes: 
    output:
        "data/all_complete_refseq_bac.fasta"
    shell:
        "time bash code/download_refseq_genomes.sh" 

rule multiline2oneline_refseq:
    input:
        "data/all_complete_refseq_bac.fasta",
    output:
        "data/all_complete_refseq_bac_oneline.fasta",
    shell:
        "bash code/multiline2oneline.sh {input} {output}"

# import os
# gff_filenames = os.listdir("data/test_gffs")
rule concatenate_gff_files: # FOR NOW: cat_gff_files.sh is hard coded to work
                            # on the data/refseq_genome_annotations/ dir
    # input:
    #     expand("data/test_gffs/{anno}", anno = gff_filenames)
    #     # "data/test_gffs/*.gff"
    output:
        "data/scg_annotations.gff"
    shell: 
        "bash code/cat_gff_files.sh {output}"

rule clean_gff_files:
    input:
        "data/scg_annotations.gff"
    output:
        "data/scg_annotations_clean.gff"
    shell: "code/clean_gff.sh {input} {output}"

# not creating TxDb object for now (19 Mar 2020)
#rule gff_to_txdb:
#    input: 
#        "data/scg_annotations_clean.gff"
#    output:
#
#    shell:

rule gff2GRList:
    input:
        "data/scg_annotations.gff"
    output:
        "results/scg_GRList.Rds"
    shell: 
        "source ~/.bash_profile; module load R/3.6.1; Rscript code/gff2GRList.R {input} {output}"

rule multiline2oneline_16S:
    input:
        "data/sequence.fasta" # download from NCBI
    output:
        "data/all_ncbi_16S_oneline.fasta"
    shell:
        "bash code/multiline2oneline.sh {input} {output}"

rule subset_selected_seqs:
    input:
        "data/all_complete_refseq_bac_oneline.fasta"
    output:
        "data/subset_complete_genome.fasta"
    shell:
        "time bash code/subset_selected_seqs.sh"

# may want to split into two rules, so that the graph can be dumped as either gfa1 or gfa2
rule tpc_gd_scg:
    input:
        scg = "data/subset_complete_genome.fasta",
    output:
        scg = "data/subset_complete_genome.gfa2"
    shell:
        "bash code/tpc_gd.sh 40 scg_de_Bruijn.bin gfa2 99 {input.scg} {output.scg}"

rule tpc_gd_scg_gfa1:
    input:
	"data/subset_complete_genome.fasta"
    output:
       "data/subset_complete_genome.gfa1"
    shell:
        "bash code/tpc_gd.sh 40 scg_de_Bruijn.bin gfa1 99 {input} {output}"

rule tpc_gd_16S:
    input:
        all_16S = "data/all_ncbi_16S_oneline.fasta"
    output:
        all_16S = "data/all_ncbi_16S.gfa1"
    shell:
        "bash code/tpc_gd.sh 36 all_16S_de_Bruijn.bin 25 {input.all_16S} {output.all_16S}"

rule get_scg_plines:
    input:
        "data/subset_complete_genome.gfa1"
    output:
        "data/scg_plines.txt"
    shell:
        "grep '^P' {input} >> {output}"

rule get_16S_plines:
    input:
        "data/all_ncbi_16S.gfa1"
    output:
        "data/all_ncbi_16S_plines.txt"
    shell:
        "grep '^P' {input} >> {output}"

rule get_scg_segments_from_gfa:
    input:
        "data/subset_complete_genome.gfa1"
    output:
        "data/scg_segments.fasta"
    shell:
        "code/split_gfa1.sh {input} {output}"

rule get_16S_segments_from_gfa:
    input:
        "data/all_ncbi_16S.gfa1"
    output:
        "data/all_ncbi_16S_segments.fasta"
    shell:
        "code/split_gfa1.sh {input} {output}"
        
# ==================== DATA PRE-PROCESSING FOR PLOTS ======================== #

rule generate_scg_segment_and_genome_dictionaries:
    input:
        "data/scg_plines.txt"
    output:
        gen_info = "data/scg_genome_info.json",
        genomes = "data/scg_genomes.json",
        seg_info = "data/scg_segment_info.json",
        segments = "data/scg_segments.json"
    shell:
        "python code/dict.py {input} {output.gen_info} {output.genomes} {output.seg_info} {output.segments}"

rule generate_16S_segment_and_gene_dictionaries:
    input:
        "data/all_ncbi_16S_plines.txt"
    output:
        gene_info = "data/all_ncbi_16S_gene_info.json",
        genes = "data/all_ncbi_16S_genes.json",
        seg_info = "data/all_ncbi_16S_segment_info.json",
        segments = "data/all_ncbi_16S_segments.json"
    shell:
        """
        python code/dict.py \
        {input} {output.gene_info} {output.genes} {output.seg_info} {output.segments}
        """

rule modify_scg_info_dicts:
    input: 
        seg_info = "data/scg_segment_info.json",
        gen_info = "data/scg_genome_info.json",
        segments = "data/scg_segments.fasta"
    output:
        "data/scg_segment_info_complete.json"
    shell:
        """
        python code/segment_lengths.py {input.seg_info} {input.gen_info} {input.segments} {output}
        """

rule dict_to_dataframe_scg:
    input:
        seg_info = "data/scg_segment_info_complete.json",
        gen_info = "data/scg_genome_info.json"
    output:
        segInfoCSV = "results/segInfoDF.csv",
        segInfoDF = "results/segInfoDF.pickle",
        genInfoDF = "results/genInfoDF_tmp.pickle",
        uniqSegInfoDF = "results/uniqSegInfoDF.pickle"
    shell:
        """
        python code/dict_to_dataframe.py \
        {input.seg_info} {input.gen_info} {output.segInfoCSV} {output.segInfoDF} {output.genInfoDF} {output.uniqSegInfoDF}
        """


rule modify_16S_info_dicts:
    input: 
        seg_info = "data/all_ncbi_16S_segment_info.json",
        gene_info = "data/all_ncbi_16S_gene_info.json",
        segments = "data/all_ncbi_16S_segments.fasta"
    output:
        "data/all_ncbi_16S_segment_info_complete.json"
    shell:
        """
        python code/segment_lengths.py \
        {input.seg_info} {input.gene_info} {input.segments} {output}
        """

rule dict_to_dataframe_16S:
    input:
        seg_info = "data/all_ncbi_16S_segment_info_complete.json",
        gene_info = "data/all_ncbi_16S_gene_info.json"
    output:
        segInfoDF = "results/all_ncbi_16S_segInfoDF.pickle",
        geneInfoDF = "results/all_ncbi_16S_geneInfoDF.pickle"
    shell:
        """
        python code/dict_to_dataframe.py \
        {input.seg_info} {input.gene_info} {output.segInfoDF} {output.geneInfoDF}
        """

# ========================= PREP FOR GRanges OBJ ============================ #

rule get_scg_clines:
    input:
        "data/subset_complete_genome.gfa1"
    output:
        "data/scg_clines.txt"
    shell:
        "grep '^C' {input} > {output}" 

rule get_scg_flines:
    input: 
        "data/subset_complete_genome.gfa2"
    output: 
        "data/scg_flines.txt"
    shell: 
        "grep '^F' {input} > {output}" 

# exporting F-lines for top100 most shared segments
rule subset_flines_by_top100_shared_segs:
    input:
        top100shared_segs = "results/scg_top100_shared_segs.txt", # this was created manually ... 
                                                                  # TODO: automate creation of this list
        flines = "data/scg_flines.txt"
    output:
        "data/scg_flines_top100_shared.tsv"
    run:
        shell("awk 'NR==FNR{{pat[$0]; next}} $2 in pat' {input.top100shared_segs} {input.flines} > {output}")

rule find_overlaps_top100:
    input:
        gffGRList = "results/scg_GRList.Rds",
        top100shared_flines = "data/scg_flines_top100_shared.tsv"
    output:
        "results/top100_gff_overlaps.Rds"
    shell: 
        "Rscript code/find_overlaps.R {input.gffGRList} {input.top100shared_flines} {output}"

rule clines_to_bed:
    input:
        scg_clines = "data/scg_clines.txt",
        segInfoDF = "results/segInfoDF.pickle"
    output:
        "results/scg_segments.bed"
    shell:
        "python code/gfa2bed.py {input.scg_clines} {input.segInfoDF} {output}" 

# dont actually need to do this.. can directly take the scg_flines.txt (tsv)
# output and load it directly to R and make a GRanges object out of it
# rule flines_to_bed:
#     input:
#         "data/scg_flines_top100_shared.txt"
#     output:
#         "results/scg_top100_shared_segs_tmp.bed"
#     shell:
#         "python code/flines2bed.py {input} {output}"

# also not necessary since we can go directly from flines -> GRanges
# rule bed2GRanges:
#     input:
#         "data/scg_segments.bed" # ready to run once this completes
#     output:
#         "results/scg_segment_GRanges.tsv"
#     shell:
#         "Rscript code/bed2GRanges.R {input} {output}"

# ============================== EDA PLOTS ================================== #

rule make_uniqSegsInfoDF:
    input: 
        genomes = "data/genomes.json",
        genInfoDF_tmp = "results/genInfoDF_tmp.pickle",
        uniqSegInfoDF = "results/uniqSegInfoDF.pickle"
    output: 
        genInfoDF = "results/genInfoDF.pickle"
    shell: 
        """
        python code/uniq_segs.py {input.genomes} {input.genInfoDF_tmp} {input.uniqSegInfoDF} {output.genInfoDF}
        """

rule generate_histograms:
    input:
        segInfoDF = "results/segInfoDF.pickle",
        genInfoDF = "results/genInfoDF.pickle"
    output:
        segUbiquityFig = "results/scg_segment_ubiquity.png",
        segLengthFig = "results/scg_segment_length.png",
        genSegmentationFig = "results/scg_genome_segmentation.png",
        genUniqnessFig = "results/scg_genome_uniqueness.png"
    run:
        shell("python code/graph_segInfo.py {input.segInfoDF} {output.segUbiquityFig} {output.segLengthFig}")
        shell("python code/graph_genInfo.py {input.genInfoDF} {output.genSegmentationFig} {output.genUniqnessFig}")
