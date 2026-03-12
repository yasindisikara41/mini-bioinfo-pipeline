library(tidyverse)

# Veriyi oku
df <- read_csv("results/qc/read_stats.csv")

# ── Summary Statistics ──────────────────────────────────────
cat("=== SUMMARY STATISTICS ===\n\n")

cat("Read Length:\n")
cat("  Mean:  ", round(mean(df$read_length), 2), "\n")
cat("  Median:", median(df$read_length), "\n")
cat("  Min:   ", min(df$read_length), "\n")
cat("  Max:   ", max(df$read_length), "\n\n")

cat("GC Content (%):\n")
cat("  Mean:  ", round(mean(df$gc_content), 2), "\n")
cat("  Median:", median(df$gc_content), "\n\n")

cat("Mean Quality Score:\n")
cat("  Mean:  ", round(mean(df$mean_quality), 2), "\n")
cat("  Median:", median(df$mean_quality), "\n\n")

# ── Plot 1: Read Length Distribution ────────────────────────
p1 <- ggplot(df, aes(x = read_length)) +
  geom_histogram(bins = 80, fill = "#2196F3", color = "white", alpha = 0.85) +
  scale_x_log10(labels = scales::comma) +
  labs(
    title = "Read Length Distribution",
    subtitle = paste("n =", nrow(df), "reads"),
    x = "Read Length (bp, log scale)",
    y = "Count"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/read_length_distribution.png", p1, width = 8, height = 5, dpi = 150)
cat("Saved: read_length_distribution.png\n")

# ── Plot 2: GC Content Distribution ─────────────────────────
p2 <- ggplot(df, aes(x = gc_content)) +
  geom_histogram(bins = 60, fill = "#4CAF50", color = "white", alpha = 0.85) +
  geom_vline(xintercept = mean(df$gc_content), color = "red", linetype = "dashed", linewidth = 0.8) +
  labs(
    title = "GC Content Distribution",
    subtitle = paste("Mean GC =", round(mean(df$gc_content), 1), "%"),
    x = "GC Content (%)",
    y = "Count"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/gc_content_distribution.png", p2, width = 8, height = 5, dpi = 150)
cat("Saved: gc_content_distribution.png\n")

# ── Plot 3: Mean Quality Score Distribution ──────────────────
p3 <- ggplot(df, aes(x = mean_quality)) +
  geom_histogram(bins = 60, fill = "#FF9800", color = "white", alpha = 0.85) +
  geom_vline(xintercept = 20, color = "red", linetype = "dashed", linewidth = 0.8) +
  annotate("text", x = 21, y = Inf, label = "Q20", vjust = 2, color = "red", size = 4) +
  labs(
    title = "Mean Read Quality Score Distribution",
    subtitle = paste("Mean Q =", round(mean(df$mean_quality), 1)),
    x = "Mean Phred Quality Score",
    y = "Count"
  ) +
  theme_minimal(base_size = 13)

ggsave("results/plots/quality_distribution.png", p3, width = 8, height = 5, dpi = 150)
cat("Saved: quality_distribution.png\n")

cat("\nAll plots saved to results/plots/\n")