library(tidyverse)

# qc analizinden gelen CSV'yi okuyoruz
df <- read_csv("results/qc/read_stats.csv")

# ozet istatistikler
cat("=== OZET ISTATISTIKLER ===\n\n")

cat("Read Uzunlugu:\n")
cat("  Ortalama:", round(mean(df$read_length), 2), "\n")
cat("  Medyan:  ", median(df$read_length), "\n")
cat("  Min:     ", min(df$read_length), "\n")
cat("  Max:     ", max(df$read_length), "\n\n")

cat("GC Icerik (%):\n")
cat("  Ortalama:", round(mean(df$gc_content), 2), "\n")
cat("  Medyan:  ", median(df$gc_content), "\n\n")

cat("Kalite Skoru:\n")
cat("  Ortalama:", round(mean(df$mean_quality), 2), "\n")
cat("  Medyan:  ", median(df$mean_quality), "\n\n")

# read uzunlugu dagilimi - log scale kullandim cunku cok uzun readler var
p1 <- ggplot(df, aes(x = read_length)) +
  geom_histogram(bins = 80, fill = "#2196F3", color = "white", alpha = 0.85) +
  scale_x_log10(labels = scales::comma) +
  labs(
    title = "Read Uzunlugu Dagilimi",
    subtitle = paste("n =", nrow(df), "read"),
    x = "Read Uzunlugu (bp, log scale)",
    y = "Sayi"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/read_length_distribution.png", p1, width = 8, height = 5, dpi = 150)

# GC icerik dagilimi - kirmizi cizgi ortalama
p2 <- ggplot(df, aes(x = gc_content)) +
  geom_histogram(bins = 60, fill = "#4CAF50", color = "white", alpha = 0.85) +
  geom_vline(xintercept = mean(df$gc_content), color = "red", linetype = "dashed", linewidth = 0.8) +
  labs(
    title = "GC Icerik Dagilimi",
    subtitle = paste("Ortalama GC =", round(mean(df$gc_content), 1), "%"),
    x = "GC Icerik (%)",
    y = "Sayi"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/gc_content_distribution.png", p2, width = 8, height = 5, dpi = 150)

# kalite skoru dagilimi - Q20 esigi isaretlendi
p3 <- ggplot(df, aes(x = mean_quality)) +
  geom_histogram(bins = 60, fill = "#FF9800", color = "white", alpha = 0.85) +
  geom_vline(xintercept = 20, color = "red", linetype = "dashed", linewidth = 0.8) +
  annotate("text", x = 21, y = Inf, label = "Q20", vjust = 2, color = "red", size = 4) +
  labs(
    title = "Ortalama Kalite Skoru Dagilimi",
    subtitle = paste("Ortalama Q =", round(mean(df$mean_quality), 1)),
    x = "Ortalama Phred Kalite Skoru",
    y = "Sayi"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/quality_distribution.png", p3, width = 8, height = 5, dpi = 150)

cat("Grafikler kaydedildi: results/plots/\n")