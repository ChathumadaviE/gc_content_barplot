# gc_content_barplot.R
# Visualize GC content per chromosome as a bar plot with a color scale.

library(ggplot2)
library(scales)

#-----------------------------
# User-configurable parameters
#-----------------------------

# GC content file (tab-delimited)
# Expected columns:
#   V1 = chromosome
#   V2 = window start (bp)
#   V3 = window end (bp)
#   V4 = %AT
#   V5 = %GC
#   V6–V11 = counts of A, C, G, T, N, other
#   V12 = sequence length
gc_file <- "gc_content.tsv"

# Chromosome order
chromosome_levels <- c(
  "C0001", "C0002", "C0003", "C0004",
  "C0005", "C0006", "C0007", "C0008",
  "C0009", "C0010", "C0011", "C0012"
)

plot_title <- "Eulimnadia texana GC content"
x_label    <- "Chromosomes"
y_label    <- "Size (Mbp)"

#-----------------------------
# Load data
#-----------------------------

GC <- read.table(gc_file, header = FALSE, stringsAsFactors = FALSE)

colnames(GC) <- c(
  "chr_window", "pos_start", "pos_end",
  "pct_at", "pct_gc",
  "num_A", "num_C", "num_G", "num_T",
  "num_N", "num_oth", "seq_len",
  "chrorder"
)

# Use chromosome IDs from first column
GC$chrorder <- factor(GC$chr_window, levels = chromosome_levels)

# Aggregate by chromosome: total length and mean GC%
GC_summary <- GC |>
  dplyr::group_by(chrorder) |>
  dplyr::summarise(
    size_Mbp = sum(seq_len) / 1e6,
    mean_gc  = weighted.mean(pct_gc, seq_len)
  ) |>
  dplyr::ungroup()

# Drop chromosomes not present (if any)
GC_summary <- GC_summary[!is.na(GC_summary$chrorder), ]

#-----------------------------
# Color scale
#-----------------------------

gc_colors <- colorRampPalette(c(
  "#a50026", "#d73027", "#f46d43", "#fdae61", "#fee08b",
  "#ffffbf", "#d9ef8b", "#a6d96a", "#66bd63", "#1a9850", "#006837"
))(100)

#-----------------------------
# Plot
#-----------------------------

p <- ggplot(GC_summary, aes(x = chrorder, y = size_Mbp, fill = mean_gc)) +
  geom_bar(stat = "identity") +
  scale_fill_gradientn(
    colours = gc_colors,
    values = rescale(seq(0, 100, by = 10)),
    guide  = guide_colourbar(
      title          = "GC content (%)",
      barwidth       = 10,
      title.position = "top"
    )
  ) +
  xlab(x_label) +
  ylab(y_label) +
  ggtitle(plot_title) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line        = element_line(colour = "black"),
    legend.position  = "top",
    axis.text.x      = element_text(size = 12, angle = 50, hjust = 1),
    axis.text.y      = element_text(size = 12),
    axis.title       = element_text(size = 14, face = "bold")
  )

print(p)
