# GC content visualization in R

This repository contains an R script to visualize GC content per
chromosome for a genome assembly. It reads a GC content file (e.g.,
from a sliding-window GC calculation), summarizes total chromosome
size and mean GC percentage, and plots a bar chart where:

- x-axis: chromosomes
- y-axis: total size (Mbp)
- fill color: mean GC content (%)

The example is configured for *Eulimnadia texana* scaffolds `C0001`–`C0012`
but can be adapted to any genome by editing the chromosome list and labels.

## Files

- `gc_content_barplot.R`  
  Main script that:
  - Loads window-level GC content data.
  - Aggregates per chromosome (total length and mean GC%).
  - Plots a bar chart with a continuous GC color scale.

- (optional) `gc_content.tsv`  
  Example GC content file with the expected format.

## Input format

The script expects a tab-delimited file (`gc_content.tsv`) with at least
12 columns:

1. `V1` – chromosome ID (e.g., `C0001`, `C0002`, …)  
2. `V2` – window start position (bp)  
3. `V3` – window end position (bp)  
4. `V4` – percent AT (`pct_at`)  
5. `V5` – percent GC (`pct_gc`)  
6. `V6` – count of A (`num_A`)  
7. `V7` – count of C (`num_C`)  
8. `V8` – count of G (`num_G`)  
9. `V9` – count of T (`num_T`)  
10. `V10` – count of N (`num_N`)  
11. `V11` – count of other bases (`num_oth`)  
12. `V12` – sequence length of the window (`seq_len`)  

The script renames these to:

- `chr_window`, `pos_start`, `pos_end`, `pct_at`, `pct_gc`,
  `num_A`, `num_C`, `num_G`, `num_T`, `num_N`, `num_oth`, `seq_len`,
  `chrorder`

and then collapses to one row per chromosome with:

- `size_Mbp` – sum of `seq_len` per chromosome divided by 1e6.  
- `mean_gc` – length-weighted mean of `pct_gc` per chromosome.

## Requirements

- R (version 3.0+)
- Packages:
  - `ggplot2`
  - `scales`
  - `dplyr` (from `tidyverse`)

Install in R if needed:

```r
install.packages("ggplot2")
install.packages("scales")
install.packages("dplyr")
```

Usage
Place your GC content file and script in the same directory.

Edit the top of gc_content_barplot.R if needed:
```
r
gc_file <- "gc_content.tsv"

chromosome_levels <- c(
  "C0001", "C0002", "C0003", "C0004",
  "C0005", "C0006", "C0007", "C0008",
  "C0009", "C0010", "C0011", "C0012"
)

plot_title <- "Eulimnadia texana GC content"
x_label    <- "Chromosomes"
y_label    <- "Size (Mbp)"
```
Run in R or RStudio:

```
r
setwd("path/to/this/repository")
source("gc_content_barplot.R")
```
This will produce a bar plot where each chromosome is a bar whose
height reflects its total length and whose color reflects mean GC
content.

## Example 2: GC content by genomic location (boxplot)

The script `gc_content_boxplot.R` compares GC content distributions
across genomic locations (e.g., exons, introns, intergenic regions)
and visualizes them as boxplots.

### Input format

`gc_content_locations.tsv` should be a tab-delimited file with at least:

- `location` – category label (e.g., `exon`, `intron`, `intergenic`,
  `SDR`, `PAR`).  
- `pct_gc` – GC percentage for each region/window.

Example:

```text
location    pct_gc
exon        47.3
exon        49.1
intron      38.5
intergenic  36.2
...



