# ============================ INITIALIZE LISTS ============================= #
# Would be useful to list out all different subsets of genomes I would like to
# run this analysis on like list = ["subset_complete_genome", "subset_Strep", ...]

#subsets = ["subset_complete_genome", "subset_Streptococcus"] # do this later

# =============================== MAKE RULES ================================ #

rule download_genomes:
    output:
        "data/all_complete_refseq_bac.fasta"
    shell:
        "time bash code/download_refseq_genomes.sh"

rule subset_selected_seqs:
    input:
        "data/all_complete_refseq_bac.fasta"
    output:
        "data/subset_complete_genome.fasta"
        # TODO: include subset_Strep as output
    shell:
        "time bash code/subset_selected_seqs.sh"

rule tpc_gd:
    input:
        "data/subset_complete_genome.fasta"
        # TODO: include Strep in tpc_gd rule
    output:
        "data/subset_complete_genome.gfa1"
        # TODO: include Strep in tpc_gd rule
    shell:
        "time bash code/tpc_gd.sh de_Bruijn.bin 99 {input} {output}"

rule get_plines:
    input:
        "data/subset_complete_genome.gfa1"
    output:
        "data/plines.txt"
    shell:
        "grep '^P' {input} >> {output}"

rule get_segments_from_gfa:
    input:
        "data/subset_complete_genome.gfa1"
    output:
        "data/segments_subset_complete_genome.fasta"
    shell:
        "code/split_gfa1.sh {input}"
        

rule generate_segment_and_genome_dictionaries:
    input:
        "data/plines.txt"
    output:
        "data/genome_info.json",
        "data/genomes.json",
        "data/segment_info.json",
        "data/segments.json"
    script:
        "code/dict.py"

rule modify_info_dicts:
    input: 
        "data/segment_info.json",
        "data/genome_info.json",
        "data/segments_subset_complete_genome.fasta"
    output:
        "data/segment_info_all.json"
    script:
        "code/segment_lengths.py"

# rule 
