# Mini Bioinformatics Pipeline

A reproducible QC pipeline for long-read sequencing data using R and Snakemake.

## Requirements

- R (>= 4.4)
- Python (>= 3.10)
- Snakemake (`pip install snakemake`)
- R packages: `Biostrings`, `ShortRead`, `tidyverse`

## Installation
```bash
git clone https://github.com/yasindisikara41/mini-bioinfo-pipeline.git
cd mini-bioinfo-pipeline
```

Install R packages:
```r
install.packages("BiocManager")
BiocManager::install(c("Biostrings", "ShortRead"))
install.packages("tidyverse")
```

## Usage

Place your FASTQ file in the `data/` folder, then run:
```bash
snakemake --cores 1
```

## Pipeline Steps

1. **qc_analysis.R** — Reads the FASTQ file in chunks, calculates GC content, read length, and mean quality score for each read. Saves results to `results/qc/read_stats.csv`.
2. **visualize.R** — Generates distribution plots for all three metrics. Saves plots to `results/plots/`.

## Results Summary (barcode77)

| Metric | Mean | Median |
|---|---|---|
| Read Length (bp) | 1038 | 547 |
| GC Content (%) | 53.0 | 53.5 |
| Mean Quality Score | 17.9 | 17.3 |

## Email to Professor Kılıç

**To:** Prof. Dr. Kılıç  
**Subject:** Long-Read Sequencing QC Report – barcode77

Dear Professor Kılıç,

I have completed the quality control analysis of the raw sequencing data you provided (barcode77). Here is a plain-language summary of what I did and what the results show.

**What I did:**  
I wrote an automated pipeline that reads the raw sequencing file and calculates three key metrics for each of the 81,011 reads: read length, GC content, and quality score. I then generated distribution plots for each metric.

**What the results show:**

- **Read Length:** The average read length is ~1,038 base pairs, with a median of 547 bp. This is typical for Oxford Nanopore long-read data. There are some very long reads (up to ~686,000 bp), which is a known characteristic of this technology.

- **GC Content:** The average GC content is 53%, which is within the normal biological range (40–60%). This suggests no major contamination or bias in the sequencing run.

- **Quality Score:** The average Phred quality score is Q17.9, which means roughly 1 error per 63 bases. While this is slightly below the Q20 threshold (1 error per 100 bases) commonly used as a cutoff, it is acceptable for Oxford Nanopore data sequenced with the HAC basecalling model.

**Recommendation:**  
The data quality is sufficient to proceed to alignment. I recommend using Minimap2 for alignment against the reference genome, followed by variant calling. If higher accuracy is required, the reads could be filtered to retain only those with Q≥20 before alignment.

Please let me know if you have any questions.

Best regards,  
Yasin Dişikara