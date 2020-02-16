# ============================ INITIALIZE LISTS ============================= #
# Would be useful to list out all different subsets of genomes I would like to
# run this analysis on like list = ["subset_complete_genome", "subset_Strep", ...]

#subsets = ["subset_complete_genome", "subset_Streptococcus"] # do this later

# =========================== SEGMENT GENERATION ============================ #

rule download_refseq_genomes: # also downloads genome annotations from same loc
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

rule gff2TxDb:
    input:
        "data/scg_annotations.gff"
    output:
        "results/scg_txdb.sqlite"
    shell: 
        "source ~/.bash_profile; module load R/3.6.1; Rscript code/gff2TxDb.R {input} {output}"

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

rule tpc_gd_scg:
    input:
        scg = "data/subset_complete_genome.fasta",
    output:
        scg = "data/subset_complete_genome.gfa1",
    shell:
        "bash code/tpc_gd.sh 40 scg_de_Bruijn.bin 99 {input.scg} {output.scg}"

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
        segInfoDF = "results/segInfoDF.pickle",
        genInfoDF = "results/genInfoDF.pickle"
    shell:
        """
        python code/dict_to_dataframe.py \
        {input.seg_info} {input.gen_info} {output.segInfoDF} {output.genInfoDF}
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

rule gfa2bed:
    input:
        scg_clines = "data/scg_clines.txt",
        segInfoDF = "results/segInfoDF.pickle"
    output:
        "results/scg_segments.bed"
    shell:
        "python code/gfa2bed.py {input.scg_clines} {input.segInfoDF} {output}" 

rule bed2GRanges:
    input:
        "data/scg_segments.bed" # ready to run once this completes
    output:
        "results/scg_segment_GRanges.tsv"
    shell:
        "Rscript code/bed2GRanges.R {input} {output}"

# ============================== EDA PLOTS ================================== #

