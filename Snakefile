rule all:
    input:
        "results/qc/nanostat_report.txt",
        "results/qc/read_stats.csv",
        "results/plots/read_length_distribution.png",
        "results/plots/gc_content_distribution.png",
        "results/plots/quality_distribution.png"

rule nanostat:
    input:
        fastq = "data/barcode77.fastq"
    output:
        report = "results/qc/nanostat_report.txt"
    log:
        "logs/nanostat.log"
    shell:
        "NanoStat --fastq {input.fastq} > {output.report} 2> {log}"

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
