# ============================ INITIALIZE LISTS ============================= #
# Would be useful to list out all different subsets of genomes I would like to
# run this analysis on like list = ["subset_complete_genome", "subset_Strep", ...]

#subsets = ["subset_complete_genome", "subset_Streptococcus"] # do this later

# =========================== SEGMENT GENERATION ============================ #

rule download_refseq_genomes:
    output:
        "data/all_complete_refseq_bac.fasta"
    shell:
        "time bash code/download_refseq_genomes.sh" 

rule multiline2oneline_refseq:
    input:
        refseq = "data/all_complete_refseq_bac.fasta",
    output:
        refseq = "data/all_complete_refseq_bac_oneline.fasta",
    shell:
        "bash code/multiline2oneline.sh {input.refseq} {output.refseq}"

rule multiline2oneline_16S:
    input:
        all_16S = "data/all_ncbi_16S.fasta"
    output:
        all_16S = "data/all_ncbi_16S_oneline.fasta"
    shell:
        "bash code/multiline2oneline.sh {input.all_16S} {output.all_16S}"

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
        "bash code/tpc_gd.sh scg_de_Bruijn.bin 99 {input.scg} {output.scg}"

rule tpc_gd_16S:
    input:
        all_16S = "data/all_ncbi_16S_oneline.fasta"
    output:
        all_16S = "data/all_ncbi_16S.gfa1"
    shell:
        "bash code/tpc_gd.sh all_16S_de_Bruijn.bin 25 {input.all_16S} {output.all_16S}"

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
    script:
        "code/dict.py {input} {output.gen_info} {output.genomes} {output.seg_info} {output.segments}"

rule generate_16S_segment_and_gene_dictionaries:
    input:
        "data/all_ncbi_16S_plines.txt"
    output:
        gene_info = "data/all_ncbi_16S_gene_info.json",
        genes = "data/all_ncbi_16S_genes.json",
        seg_info = "data/all_ncbi_16S_segment_info.json",
        segments = "data/all_ncbi_16S_segments.json"
    script:
        "code/dict.py {input} {output.gene_info} {output.genes} {output.seg_info} {output.segments}"

rule modify_scg_info_dicts:
    input: 
        seg_info = "data/scg_segment_info.json",
        gen_info = "data/scg_genome_info.json",
        segments = "data/scg_segments.fasta"
    output:
        "data/scg_segment_info.json"
    script:
        "code/segment_lengths.py {input.seg_info} {input.gen_info} {input.segments}"

rule modify_16S_info_dicts:
    input: 
        seg_info = "data/all_ncbi_16S_segment_info.json",
        gene_info = "data/all_ncbi_16S_gene_info.json",
        segments = "data/all_ncbi_16S_segments.fasta"
    output:
        "data/all_ncbi_16S_segment_info.json"
    script:
        "code/segment_lengths.py {input.seg_info} {input.gene_info} {input.segments}"

# ============================== EDA PLOTS ================================== #

