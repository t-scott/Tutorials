# NOTE: All the initial steps (1, 2, & 3) are identical to the steps for PheWAS
You can refer to these in the "PheWAS_HOW_TO.md" page. These are:
1. Get a BED file
2. Filter the MEGA BED file for SNPs
3. Make an rsID_header.txt file

If you have ran those for PheWAS, you can just start here at just running the LabWAS script!

We have tried to pull everything needed over to /data/hodges_lab/ or /nobackup/hodges_lab/ from the Davis lab's side for accessibility. 

# Step 4: The LabWAS .slrm script
Edit your slrm variables at the top. Also, edit the nice variables that Verda and Anna helped to refactor, "SNPS_DIR" and 

I put the labwas.R script in: /data/hodges_lab/Tim/github_tutorials/labwas/, for easy finding. 

```bash
#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --account=hodges_lab
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mem=32G
#SBATCH --output=/data/hodges_lab/Tim/jday/labwas/scripts/labwas_v1.test_time.out
#SBATCH --error=/data/hodges_lab/anna/slurm_output/labwas_v1.test_time.error
#SBATCH --job-name=rs797_labwas_testtime


start=`date +%s`

# load modules 
module load GCC/8.2.0 OpenMPI/3.1.4 R/3.6.0

# define filepaths
LABS_DIR='/data/hodges_lab/anna/brain/labwas_table'
COVAR_DIR='/data/hodges_lab/aganve/human_variants/biovu_mega'
LABS_DIR2='/data/hodges_lab/aganve/human_variants/labwas'
SNPS_DIR='/data/hodges_lab/Tim/jday/labwas/plink'

# define cluster_num
cluster_num=$SLURM_ARRAY_TASK_ID

# create output directory for each cluster 
OUT_DIR=/data/hodges_lab/Tim/jday/labwas/output_rs7976678_time_test/
mkdir -p ${OUT_DIR}

# start R-Script
Rscript --verbose --no-save /data/hodges_lab/Tim/github_tutorials/labwas/labwas.R \
${SNPS_DIR}/rs7976678_MEGA \
${LABS_DIR}/20220115_Inverse_Normal_Medians_ageAdjusted_all_labs \
${LABS_DIR2}/shortnames-longnames-categories \
${COVAR_DIR}/EUs_ibd_check_passed_megaEX_labwas_ready_covs_gender_pcs \
${SNPS_DIR}/rs7976678_MEGA.rsID_header \
${OUT_DIR}

echo -e "\n\n\n\n\nScript complete."
end=`date +%s`
runtime=$((end-start))
echo "Total seconds for full run: "$runtime

# /data/hodges_lab/Tim/jday/labwas/scripts/run_rs7976678.time_test.slrm
```

# Plotting
This one is easier than PheWAS in my opinion. But, remember (!), all your SNPs are in one file per run. 

Thus, if you want to group some, you can pull them out with a system something like: 
```R
HMR1_SNPs <- c("rs56017594", "rs75339490")
HMR3_SNPs <- c("rs2364491", "rs114686923", "rs2886089", "rs75639654", "rs138731227", "rs578158958")
HMR4_SNPs <- c("rs11835466", "rs7976678", "rs200259352")
HMR5_SNPs <- c("rs12319859", "rs73052493")
HMR6_SNPs <- c("rs59135444", "rs74056926", "rs74056928", "rs77025001", "rs1555121489", "rs112310421", "rs199509339", "rs1555121502", "rs553298540", "rs57380213", "rs59065325")

res_HMR1 <- res %>% filter(rsIDshort %in% HMR1_SNPs)
res_HMR3 <- res %>% filter(rsIDshort %in% HMR3_SNPs)
res_HMR4 <- res %>% filter(rsIDshort %in% HMR4_SNPs)
res_HMR5 <- res %>% filter(rsIDshort %in% HMR5_SNPs)
res_HMR6 <- res %>% filter(rsIDshort %in% HMR6_SNPs)
```

Anyways, 

## Load libraries

``` R
library(tidyverse)
library(ggplot2)
library(readr)
library(data.table)
library(ggrepel)
```

## Load results file
Note: The rsIDs come back as rsID######_[A/C/G/T], denoting the minor allele. 

I don't enjoy looking at them, so I immediately create another column called "rsIDshort" that truncates that using *gsub()*. 

```R
res_dirty <- read_tsv("/data/hodges_lab/Tim/jday/labwas/output_region_around_rs7976678_chr12_6531245_6544281_on_MEGA_imputed_MEGA/labwas_results.txt", col_names=T)

res <- res_dirty %>% mutate(rsIDshort = gsub("\\_.*","", rsID))

nrow(res)
head(res)
```

## Plotting function
This function also counts the number of lines to automatically calculate a bonferonni value for plotting the red line. However, since I had multiple sets running, I had to multiply # tests by also the # of sets, so I just put that as it's own variable up top "bonferonni_value". This matters in the line:

```R
    geom_hline(yintercept=(-log10(bonferroni)), color="red") +
```
I changed it back to "bonferonni" below, but just keep in mind that this is an option/consideration. 

```R
bonferroni_value=7.89066692e-7

#plot Manhattan
labwas_manhattan <- function(results=results) {
    #sign returns a vector with the signs of the corresponding elements of x (-1, 0, or 1)
    results$direction <- sign(results$effect_estimate)
    #subset rows with non-NA pvalue
    results2=results[!is.na(results$pvalue),]
    #take the -log10 of pvalue
    results2$graph_pvalue <- -log10(results2$pvalue)
    bonferroni <- .05/nrow(results2)
    ggplot(data=results2, aes(x=group, y=graph_pvalue)) +
    #color: assign colors to outline points in a ggplot2 plot based on the categorical variable, group
    #fill: defines colors within which points are filled based on the categorical variable, group 
    #shape: changes point shapes based on a grouping variable...in this case our grouping varaible is the direction of the beta coefficient (1 or -1)
    geom_jitter(aes(size=.2,shape=factor(direction), color=factor(group), fill=factor(group))) +
#     geom_label_repel(data=results2, 
#                     aes(label=ifelse((results2$fdr_status == TRUE & results2$bonferroni_status == FALSE) |
#                                      (results2$fdr_status == TRUE & results2$bonferroni_status == TRUE), as.character(results2$lab),'')), size=3,
#                    max.overlaps=Inf) +
    scale_shape_manual(values=c(25,24)) +
    geom_text_repel(data=subset(results2, pvalue<0.05), aes(label=lab)) +
    geom_hline(yintercept=(-log10(bonferroni)), color="red") +
    geom_hline(yintercept=(-log10(.05)), color="blue") +
    guides(fill="none") +
    guides(size="none") +
    guides(shape="none", colour="none") + 
    theme_classic() +
    theme(axis.text.x=element_text(angle=45, hjust=1)) +
    ylab("-log10(pvalue)") + 
    scale_y_continuous(breaks=seq(0,50,by=1))
    }
# labwas_manhattan
# class(labwas_manhattan)
```















