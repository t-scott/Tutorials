#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

#-----------------------------------------------------------------
#                             Set up
#-----------------------------------------------------------------

print("*Loading libraries and checking arguments.")
### Libraries
suppressPackageStartupMessages({
    library(ggplot2)
    library(tidyverse)
    library(RColorBrewer)
    library(ggrepel)
    library(data.table)
    library(reshape2)
    library(optparse)
})

#### Variables - through library: optparse
option_list = list(
    make_option(c("-f", "--filepath"), type="character", default = "FPATH", help="input file path"),
    make_option(c("-p", "--outpath"), type="character", default="/data/hodges_lab/", help="dir path for output files"),
    make_option(c("-o", "--outname"), type="character", default="knownResults.pdf", help="name for output plot"),
    make_option(c("-t", "--title"), type="character", default="HOMER Results", help="title for plot"),
    make_option(c("-n", "--nrow"), type="integer", default=10, help="the amount of hits to show"),
    make_option(c("-l", "--labelsize"), type="integer", default=12, help="size for label text"),
    make_option(c("-a", "--axislabelsize"), type="integer", default=10, help="size for axis label text"),
    make_option(c("-w", "--figurewidth"), type="integer", default=8, help="figure width"),
    make_option(c("-e", "--figureheight"), type="integer", default=8, help="figure height"),
    make_option(c("-c", "--colorpalette"), type="character", default="Blues", help="RColorBrewer palette name. Options for sequential: Blues, BuGn, BuPu, GnBu, Greens, Greys, Oranges, OrRd, PuBu, PuBuGn, PuRd, Purples, RdPu, Reds, YlGn, YlGnBu, YlOrBr, YlOrRd")
)
opt <- parse_args(OptionParser(add_help_option=TRUE, option_list = option_list))

# Quick input check
if (opt$filepath=="FPATH"){
    stop("File path not supplied.")
} else if (opt$outpath=="/data/hodges_lab/"){
    stop("Output directory not supplied.")
} 



#-----------------------------------------------------------------
#                       Things happen here
#-----------------------------------------------------------------
### Read in file
colnames_list <- c("motif_name","consensus","p_value","log_p_value","q_value_Benjamimi", "target_seq_with_motif", "perc_target_seq_with_motif", "bkgrd_seq_with_motif", "perc_bkgrd_seq_with_motif")

df <- read_tsv(paste0(opt$filepath, "knownResults.txt"), col_names=colnames_list, skip = 1, col_types = cols()) 




#-----------------------------------------------------------------
#                       Clean up below
#-----------------------------------------------------------------

### HOMER ggplot function
plot_dot <- function(df, nrow, title_name, file_save_name, figw=10, figh=10){
    df_sub <- df[1:nrow,]
    # plot
    p <- df_sub %>%
    mutate(motif_short = gsub("\\(.*","",motif_name)) %>%
    mutate(motif_ordered = fct_reorder(motif_short, log_p_value)) %>%
    mutate(fold_change = target_seq_with_motif/bkgrd_seq_with_motif) %>%
    ggplot(aes(x = -log_p_value, y = motif_ordered)) +
        geom_point(aes(size = -log_p_value, color = fold_change)) +
        theme_minimal() + 
        ggtitle(title_name) +
        theme(
            aspect.ratio=1,
            plot.title = element_text(hjust = 0.5), # centered
            axis.title.x = element_text(size = opt$axislabelsize), # axis title size
            axis.title.y = element_text(size = opt$axislabelsize), # axis title size
            axis.text.y = element_text(size = opt$labelsize), # axis text label size 
            axis.text.x = element_text(size = opt$labelsize) # axis text label size (angle = 90, vjust = 0.5, hjust=1,) for vertical
        ) +
        scale_y_discrete(limits=rev) +
        ylab("Motifs") +
        xlab("-log(p-value)") +
        labs(color = "FoldChange") +
        scale_size(range = c(2,5)) +
        scale_colour_distiller(palette = opt$colorpalette)
    ggsave(paste0(opt$outpath, file_save_name), p, width = opt$figurewidth, height = opt$figureheight, dpi = 150)
}

### Apply function
plot_dot(df, opt$nrow, opt$title, opt$outname)





#-----------------------------------------------------------------
#                       Test code snippets
#-----------------------------------------------------------------
# module restore conda31
# source activate jupyter_py3.10.9_r4.4.1
# or
# module load GCC/11.3.0  OpenMPI/4.1.4
# module load R/4.2.1
#
#
# help option
# Rscript /data/hodges_lab/tools/plot_homer_single.R --help
#
# simple options (input, output):
# Rscript /data/hodges_lab/tools/plot_homer_single.R -f "/data/hodges_lab/Tim/github_tutorials/homer/" -p /data/hodges_lab/Tim/github_tutorials/homer/ 
#
# + option for file_outname + option for nrow + title
# Rscript /data/hodges_lab/tools/plot_homer_single.R -f /data/hodges_lab/Tim/github_tutorials/homer/ -p /data/hodges_lab/Tim/github_tutorials/homer/ -o knownResults.top20.pdf -n 20 -t "Top 20"
#
# + option for file_outname + option for nrow + title
# Rscript /data/hodges_lab/tools/plot_homer_single.R -f /data/hodges_lab/Tim/github_tutorials/homer/ -p /data/hodges_lab/Tim/github_tutorials/homer/ -o knownResults.top20.resize.pdf -n 20 -t "Top 20" -e 8 -w 6
#
# + option for file_outname + option for nrow + title + size
# Rscript /data/hodges_lab/tools/plot_homer_single.R -f /data/hodges_lab/Tim/github_tutorials/homer/ -p /data/hodges_lab/Tim/github_tutorials/homer/ -o knownResults.top20.resize.PuBuGn.pdf -n 20 -t "Top 20" -e 8 -w 6 -c PuBuGn
#
# + option for file_outname + option for nrow + title + size + label sizes
# Rscript /data/hodges_lab/tools/plot_homer_single.R -f /data/hodges_lab/Tim/github_tutorials/homer/ -p /data/hodges_lab/Tim/github_tutorials/homer/ -o knownResults.top20.resize.PuBuGn.label_sizes.pdf -n 20 -t "Top 20" -e 8 -w 6 -c PuBuGn -l 8 -a 12
