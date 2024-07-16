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
    make_option(c("-o", "--outpath"), type="character", default="/data/hodges_lab/", help="dir path for output files"),
    make_option(c("-n", "--name"), type="character", default="qPCR_plot.pdf", help="name for plot and df"),
    make_option(c("-r", "--remove"), type="character", default="default_match_string", help="target name to remove (singular)"),
    make_option(c("-l", "--labelsize"), type="integer", default=12, help="size for label text"),
    make_option(c("-a", "--axislabelsize"), type="integer", default=10, help="size for axis label text"),
    make_option(c("-w", "--figurewidth"), type="integer", default=10, help="figure width"),
    make_option(c("-h", "--figureheight"), type="integer", default=10, help="figure height")
)
opt <- parse_args(OptionParser(add_help_option=FALSE, option_list = option_list))

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
df <- read_tsv(opt$file, col_names=T, skip = 24, col_types = cols()) 

### Calculate dCT and ddCT
print(paste0("*Calculating ddCT from input file: ", opt$filepath))
ddCT <- df %>% 
    rename_all(~(sub(" ", "", names(df)))) %>% # Fix janked up column names, remove spaces
    filter(Cq!="Undetermined") %>% # Remove undetermined rows
    select(Sample, Target, CqMean) %>% # Simplify table, we only really need these and can collapse reps
    unique() %>% # reduce, since there's three copies of the Cq mean
    group_by(Sample) %>% # Per sample group...
    mutate(dCT = CqMean-CqMean[Target=="GAPDH"]) %>% # calc dCT
    ungroup() %>% group_by(Target) %>% # sets it up to calculate ddCT across targets
    mutate(ddCT = dCT-dCT[Sample=="GM12878"]) %>% # calc ddCT
    mutate(foldchange = 2^-(ddCT)) # calc fold change

# Save the ddCT dataframe under same name
write_delim(ddCT, paste0(opt$out, opt$name, ".ddCT_table.txt"), delim="\t", col_names=TRUE, quote="none")
print(paste0("-----ddCT table output saved at: ", opt$out, opt$name, ".ddCT_table.txt"))


### Plotting

p <- ddCT %>%
    filter(Target!=opt$remove) %>% # Check to see if 
    ggplot(aes(x = Target, y = foldchange)) +
    geom_bar(aes(fill = Sample), stat = "identity", position = position_dodge2()) +
    theme_minimal() + 
    theme(
        aspect.ratio = 1,
        plot.title = element_text(hjust = 0.5, size = 20),
        axis.title.x = element_text(size = opt$axislabelsize), # axis title size
        axis.title.y = element_text(size = opt$axislabelsize), # axis title size
        axis.text.y = element_text(size = opt$labelsize), # axis text label size 
        axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size = opt$labelsize), # axis text label size 
        panel.grid.minor = element_blank() # I just don't like'em; get'em outta here
    )

# Save the plot
ggsave(filename = paste0(opt$out, opt$name, ".ddCT_plot.pdf"), p, width = opt$figurewidth, height = opt$figureheight, dpi = 150)
print(paste0("-----ddCT plot output saved at: ", opt$out, opt$name, ".ddCT_plot.pdf"))

# TS
# plot_qpcr.R
# Ex: Rscript plot_qpcr.R -f ZNF384_CRISPR_analysis_Results_20240715_163740.txt -o /data/hodges_lab/Tim/jday/ -n test_ZNF
