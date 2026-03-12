rule all:
    input:
        "results/qc/read_stats.csv",
        "results/plots/read_length_distribution.png",
        "results/plots/gc_content_distribution.png",
        "results/plots/quality_distribution.png"

rule qc_analysis:
    input:
        fastq = "data/barcode77.fastq"
    output:
        csv = "results/qc/read_stats.csv"
    log:
        "logs/qc_analysis.log"
    shell:
        "Rscript scripts/qc_analysis.R > {log} 2>&1"

rule visualize:
    input:
        csv = "results/qc/read_stats.csv"
    output:
        p1 = "results/plots/read_length_distribution.png",
        p2 = "results/plots/gc_content_distribution.png",
        p3 = "results/plots/quality_distribution.png"
    log:
        "logs/visualize.log"
    shell:
        "Rscript scripts/visualize.R > {log} 2>&1"
