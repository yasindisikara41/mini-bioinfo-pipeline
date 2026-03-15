library(Biostrings)
library(ShortRead)
library(tidyverse)

fastq_file <- "data/barcode77.fastq"
output_file <- "results/qc/read_stats.csv"
chunk_size  <- 5000

cat("Reading FASTQ file in chunks...\n")

stream  <- FastqStreamer(fastq_file, n = chunk_size)
results <- list()
chunk_i <- 1

repeat {
  fq <- yield(stream)
  if (length(fq) == 0) break
  cat("Processing chunk", chunk_i, "...\n")
  seqs <- sread(fq)
  gc <- rowSums(alphabetFrequency(seqs, baseOnly = TRUE)[, c("G","C")]) / width(seqs) * 100
  rl  <- width(seqs)
  mq <- sapply(seq_len(length(fq)), function(i) {
    q_str <- as.character(quality(fq[i])[[1]])
    mean(utf8ToInt(q_str) - 33L)
  })
  results[[chunk_i]] <- tibble(
    read_id      = sub(" .*", "", as.character(id(fq))),
    read_length  = rl,
    gc_content   = round(gc, 2),
    mean_quality = round(mq, 2)
  )
  chunk_i <- chunk_i + 1
}

close(stream)
final <- bind_rows(results)
write_csv(final, output_file)
cat("Done! Total reads:", nrow(final), "\n")
cat("Results saved to:", output_file, "\n")