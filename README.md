# Mini Bioinformatics Pipeline

This is a QC pipeline I built for long-read sequencing data. It takes a raw FASTQ file, calculates per-read statistics, and generates distribution plots.

## What it does

The pipeline has three main steps:
- `nanostat` runs NanoStat, a QC tool specifically designed for long-read sequencing data.
- `qc_analysis.R` reads the FASTQ file in chunks (to avoid memory issues), calculates GC content, read length, and mean quality score for each read, and saves everything to a CSV file.
- `visualize.R` takes that CSV and generates three distribution plots plus summary statistics.

Snakemake is used to connect the steps together.

## Requirements

- R >= 4.4 with Biostrings, ShortRead, tidyverse
- Python >= 3.10
- Snakemake
- NanoStat

You can set up the environment with:

    conda env create -f environment.yml
    conda activate mini-bioinfo-pipeline

## How to run

Put your FASTQ file in the `data/` folder and run:

    snakemake --cores 1

## Results (barcode77)

| Metric | Mean | Median |
|---|---|---|
| Read Length (bp) | 1038 | 547 |
| GC Content (%) | 53.0 | 53.5 |
| Mean Quality Score (per-read) | 17.9 | 17.3 |
| Mean Quality Score (NanoStat) | 8.4 | 9.9 |

Note: The difference in mean quality scores between our script (Q17.9) and NanoStat (Q8.4) is expected. NanoStat averages Phred scores on a linear scale, while our script averages the raw Phred values directly. Both are valid approaches but give different numbers.

## Email to Professor Kilic

**To:** Prof. Dr. Kilic
**Subject:** QC Results - barcode77 Sequencing Data

Dear Professor Kilic,

I've finished the quality control analysis on the barcode77 dataset. Here's a quick summary of what I found.

I processed all 81,011 reads using both NanoStat and a custom R script, and looked at three things: how long the reads are, their GC content, and their quality scores.

The read lengths are pretty spread out — the median is around 547 bp but there are some reads going up to 686,000 bp, which is normal for Oxford Nanopore data. The GC content sits at about 53%, which looks fine biologically.

For quality, NanoStat reports a mean of Q8.4 and our per-read calculation gives Q17.9 — the difference comes from how each method averages Phred scores, which is a known issue. Either way, only 0.1% of reads exceed Q20, so the data is on the lower end quality-wise.

Based on this, the data is still usable for alignment. I'd suggest using Minimap2. If you want cleaner results, we could filter out reads below Q10 first — that would keep about 48.6% of reads (around 39,000 reads, 44.8 Mb).

Let me know if you'd like me to look at anything else or if you have questions about the plots.

Best,
Yasin Disikara