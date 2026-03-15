library(Biostrings)
library(ShortRead)
library(tidyverse)

# her read icin GC icerik, uzunluk ve kalite skoru hesaplar
# sonuclari CSV olarak kaydeder
fastq_file <- "data/barcode77.fastq"
output_file <- "results/qc/read_stats.csv"
chunk_size <- 5000  # 81k read var, bellek icin chunk'a aldim

cat("Dosya okunuyor...\n")

stream <- FastqStreamer(fastq_file, n = chunk_size)
tum_sonuclar <- list()
i <- 1

repeat {
  fq <- yield(stream)
  if (length(fq) == 0) break
  
  cat("Chunk isleniyor:", i, "\n")
  
  sequences <- sread(fq)
  
  # G ve C bazlarini say, toplam uzunluga bol
  gc <- rowSums(alphabetFrequency(sequences, baseOnly = TRUE)[, c("G","C")]) /
    width(sequences) * 100
  
  # read uzunlugu
  uzunluk <- width(sequences)
  
  # Phred kalite skoru: ASCII degerinden 33 cikariyoruz (Phred+33 encoding)
  kalite <- sapply(seq_len(length(fq)), function(j) {
    q <- as.character(quality(fq[j])[[1]])
    mean(utf8ToInt(q) - 33L)
  })
  
  tum_sonuclar[[i]] <- tibble(
    read_id      = sub(" .*", "", as.character(id(fq))),  # sadece UUID kismi
    read_length  = uzunluk,
    gc_content   = round(gc, 2),
    mean_quality = round(kalite, 2)
  )
  i <- i + 1
}

close(stream)

sonuc <- bind_rows(tum_sonuclar)
write_csv(sonuc, output_file)

cat("Tamamlandi! Toplam read:", nrow(sonuc), "\n")
cat("Kaydedildi:", output_file, "\n")