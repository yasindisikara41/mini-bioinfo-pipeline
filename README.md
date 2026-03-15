# Mini Bioinformatics Pipeline

This is a QC pipeline I built for long-read sequencing data. It takes a raw FASTQ file, calculates per-read statistics, and generates distribution plots.

## What it does

The pipeline has two main steps:
- `qc_analysis.R` reads the FASTQ file in chunks (to avoid memory issues), calculates GC content, read length, and mean quality score for each read, and saves everything to a CSV file.
- `visualize.R` takes that CSV and generates three distribution plots plus summary statistics.

Snakemake is used to connect the two steps together.

## Requirements

- R >= 4.4 with Biostrings, ShortRead, tidyverse
- Python >= 3.10
- Snakemake

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
| Mean Quality Score | 17.9 | 17.3 |

## Email to Professor Kilic

**To:** Prof. Dr. Kilic  
**Subject:** QC Results – barcode77 Sequencing Data

Dear Professor Kilic,

I've finished the quality control analysis on the barcode77 dataset. Here's a quick summary of what I found.

I processed all 81,011 reads and looked at three things: how long the reads are, their GC content, and their quality scores.

The read lengths are pretty spread out — the median is around 547 bp but there are some reads going up to 686,000 bp, which is normal for Oxford Nanopore data. The GC content sits at about 53%, which looks fine biologically. The average quality score came out at Q17.9, which is a bit below the Q20 cutoff but honestly pretty typical for ONT runs using the HAC basecalling model.

Based on this, I think the data is good enough to move forward with alignment. I'd suggest using Minimap2. If you want to be more conservative, we could filter out reads below Q20 first, but I don't think it's strictly necessary here.

Let me know if you'd like me to look at anything else or if you have questions about the plots.

Best,  
Yasin Dişikara