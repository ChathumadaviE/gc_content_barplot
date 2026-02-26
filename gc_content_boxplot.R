# gc_content_boxplot.R
# Compare GC content across genomic locations using boxplots
# and pairwise Wilcoxon tests.

library(ggplot2)

#-----------------------------
# User-configurable parameters
#-----------------------------

gc_box_file <- "gc_content_locations.tsv"

plot_title <- "Ectocarpus GC content by genomic location"
x_label    <- "Genomic location"
y_label    <- "GC content (%)"

#-----------------------------
# Load data
#-----------------------------

# Expected columns:
#   location  (factor/character; e.g., "exon", "intron", "intergenic")
#   pct_gc    (numeric; GC percentage per region)
GC2 <- read.table(gc_box_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

if (!all(c("location", "pct_gc") %in% colnames(GC2))) {
  stop("Input file must contain columns 'location' and 'pct_gc'.")
}

GC2$location <- factor(GC2$location)

#-----------------------------
# Boxplot
#-----------------------------

p <- ggplot(GC2, aes(x = location, y = pct_gc, fill = location)) +
  geom_boxplot() +
  theme_bw() +
  ggtitle(plot_title) +
  xlab(x_label) +
  ylab(y_label) +
  theme(
    axis.text.x  = element_text(size = 12, angle = 45, hjust = 1),
    axis.text.y  = element_text(size = 12),
    axis.title   = element_text(size = 14, face = "bold"),
    legend.position = "none"
  )

print(p)

#-----------------------------
# Pairwise Wilcoxon tests
#-----------------------------

wilcox_res <- pairwise.wilcox.test(
  GC2$pct_gc,
  GC2$location,
  p.adjust.method = "BH"
)

print(wilcox_res)
