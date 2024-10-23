# The difference to how we run it:
The major difference here is being able to input a BED file (no, not the .bed/.bim/.fam bed file--the real one). We are able to run a "region-based" PheWAS!

These scripts and code have been developed and worked on by many people including the Davis Lab, Verda Agan, Anna Lorenz, and myself. 

# Step 1: Get a BED file
This BED file could be of HMRs, individual 1bp regions relating to SNP locations, or any other set of regions. 

**NOTE**: PLINK wants a fourth column. It doesn't *really* matter what it is, but it just wants it. 

For example, here's a BED file I used for running PheWAS across a clustered region around rs7976678: 

```bash
# /data/hodges_lab/Tim/jday/phewas/SNP_bed/SNPs_in_HMRs.near_rs7976678_chr12_6422679_6434399_hg38.txt
chr12	6423772	6423773	rs75339490
chr12	6427213	6427214	rs75639654
chr12	6426745	6426746	rs114686923
chr12	6428377	6428378	rs7976678
chr12	6433857	6433858	rs59065325
chr12	6433783	6433784	rs57380213
chr12	6433000	6433001	rs74056926
chr12	6433028	6433029	rs74056928
chr12	6433427	6433428	rs77025001
```

<br>
<br>
<br>



# Step 2: Filter the MEGA BED file for SNPs
This script is supposed to simplify several steps and relies on a couple other scripts and files. The idea here is to
1. format the input BED file into a PLINK-friendly bed file (chromosome IDs from "chr1" --> "1"; this is a script)
  - Also, chromosomes X and Y become 23 and 24. We also filter out unmapped contigs by searching for an underscore, "_". 
3. Use PLINK to filter out the super-large .bed/.bim/.fam MEGA files processed by the Davis Lab to just the SNPs we need so we can input those into the PheWAS script. The original MEGA files are huge, so you don't want to require that much memory to perform PheWAS on a subset. 

I moved the Davis Lab files into: /nobackup/hodges_lab/tim/phewas/. They are extremely large, nearing 500GB. 

```bash
mkdir /data/hodges_lab/Tim/jday/phewas/SNP_plink/ ### CHANGE ###

# Script in: /data/davis_lab/tim/schema_labwas/scripts/

# TAKES 3 positional variables:
#     1) Input file
#     2) Input directory - where to find input file
#     3) Working/Output directory - where intermediate and output files will be written

IN_DIR=/data/hodges_lab/Tim/jday/phewas/SNP_bed/ ### CHANGE ###
OUT_DIR=/data/hodges_lab/Tim/jday/phewas/SNP_plink/ ### CHANGE ###
SCRIPT_DIR=/data/hodges_lab/Tim/github_tutorials/scripts/ # originally in: /data/davis_lab/tim/schema_labwas/scripts/

# Run script
${SCRIPT_DIR}get_MEGA_filtered_plink_files.from_BED_file.sh SNPs_in_HMRs.near_rs7976678_chr12_6422679_6434399_hg38.bed ${IN_DIR} ${OUT_DIR}

echo "neat."
```

For those interested, the first script looks like: 
```bash
# Bash script to filter SNPs

##########################################################
#                     get_MEGA_filtered_plink_files.from_BED_file.sh                        #
##########################################################
# TAKES 3 positional variables:
#     1) Input file
#     2) Input directory - where to find input file
#     3) Working/Output directory - where intermediate and output files will be written

# RETURNS A list of rsIDs that have gone through the process:
# starting SNPs --> MEGA-ex [was extended to be: --> ENCODE TFBS --> CpG sites --> LD Pruning]

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##### Initialize variables
start=`date +%s`

# define input variables
SNPS_DIR=/data/hodges_lab/Tim/labwas/SNPs/ChronsGWAS_MEGAex
#MEGA_EU=/data/davis_lab/shared/genotype_data/biovu/processed/imputed/best_guess/MEGA/MEGA_recalled/20200518_biallelic_mega_recalled.chr1-22.grid.EU.filt1.r2corrected
# Now MEGA_EU is in:
MEGA_EU=/nobackup/hodges_lab/tim/phewas/MEGA_recalled/20200518_biallelic_mega_recalled.chr1-22.grid.EU.filt1.r2corrected
GRIDS_TO_KEEP=/data/hodges_lab/aganve/human_variants/biovu_mega/EU_megaEX_passed_relatedness_fid_iids_only.txt
TFBS_FILE=/data/hodges_lab/Tim/PLINK_testing/wgEncodeRegTfbsClusteredWithCellsV3.sorted.bed
CPG_FILE=/data/davis_lab/tim/methylationHeatmap/snplists/SNPPrioritization_brain_km11seed100/Human_H1ESC.CpG_sites.bed


##### User variables: Input & Output directories
INPUT_FILE=$1
INPUT_FILE_ROOT="${INPUT_FILE%%.*}"
INPUT_DIR=$2
OUTPUT_DIR=$3
mkdir -p ${OUTPUT_DIR}
echo "Running input file: "${INPUT_FILE}
echo "Hope it's located in: "${INPUT_DIR}
echo "Gonna start dumping files in: "${OUTPUT_DIR}




cd ${OUTPUT_DIR}
module load PLINK/1.9b_5.2

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##### Convert input file to a BED format for PLINK
echo -e "\n\n\n\nStarting conversion of input file into PLINK-ready BED file."
sh /data/hodges_lab/Tim/methylationHeatmap_SNPPrioritization/convert_BED_to_PLINKBED.sh ${INPUT_DIR}${INPUT_FILE} > ${INPUT_FILE_ROOT}.plinkReadyBED.txt
echo -e "Done with conversion of input file into PLINK-ready BED file.\n\n\n\n"



#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
##### Intersect with MEGA-ex SNPs
echo -e "\n\n\n\nComparing against MEGA-ex SNPs."
plink --bfile ${MEGA_EU} --extract range ${INPUT_FILE_ROOT}.plinkReadyBED.txt --keep ${GRIDS_TO_KEEP} --recodeA --make-bed --out ${INPUT_FILE_ROOT}_MEGA
echo -e "Done with MEGA-ex SNPs.\n\n\n\n"


echo -e "\n\n\n\n\nScript complete. Hope the output looks right."
end=`date +%s`
runtime=$((end-start))
echo "Total seconds for full run: "$runtime



# Home dir: /data/hodges_lab/Tim/github_tutorials/scripts
# Script name: get_MEGA_filtered_plink_files.from_BED_file.sh
```

The script this uses: convert_BED_to_PLINKBED.sh, looks like this:

```bash
####### CONVERT BED TO BED READY FOR PLINK ########
#@@@@@ RULES:
#		- No chr identifier with an underscore (e.g. chr3_un_23429)
#		- chrX becomes chr23
#		- chrY becomes chr24
IN_BED=$1

awk 'BEGIN{OFS=FS="\t"}{
	if ($1!~/\_/ && $1~/chr/ && NF==3){
		if ($1=="chrX"){
			print "23",$2,$3
		} else if ($1=="chrY"){
			print "24",$2,$3
		} else {
			gsub(/chr/, "", $1); print $1,$2,$3
		}
	} else if ($1!~/\_/ && $1~/chr/ && NF==4) {
		if ($1=="chrX"){
			print "23",$2,$3,$4
		} else if ($1=="chrY"){
			print "24",$2,$3,$4
		} else {
			gsub(/chr/, "", $1); print $1,$2,$3,$4
		}
	}
}' ${IN_BED}


###### TEST BED:
# chr1	100	200
# chr2	300	400
# chr3	500	600
# chr1_un_123	1000	1500
# chr4_delete	4000	5000
# chrX	1000	1500
# chrY	5000	6000
```

<br>
<br>
<br>

# Step 3: Make an rsID_header.txt file to tell the PheWAS script which SNPs to run
This file is a little redundant, but the PheWAS/LabWAS scripts are designed to use these. It's literally just a one-column text file of rsIDs with a header. 

This can be made using a quick bit of bash and leveraging the .raw file made from above, as the .raw file will include all the rsIDs you've filtered out as column headers. You probably want this to exist in the same directory as the .bed/.bim/.fam

```bash
# Create rsID file based on raw files 
OUT_DIR=/data/hodges_lab/Tim/jday/labwas/SNP_bed/
cd $OUT_DIR

# This should take out the first 7 column headers we don't want
#     then, tr is taking that string and changing the spaces to new lines to create a "column"
head -1 region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed_MEGA.raw | cut -d' ' -f7- | tr ' ' '\n' > temp.txt

# Echo the header we need into a new .rsID_header.txt file
echo "rsID" > region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed_MEGA.rsID_header.txt

# Write the column we made above 
cat temp.txt >> region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed_MEGA.rsID_header.txt

# Clean up
rm temp.txt

echo "neat."
```

## Note, if you already have a subset of the MEGA list but decided you want to just run a subset of that
You can actually just edit this .rsID_header.txt file to a subset and run the .bed/.bim/.fam you have. Since the .rsID_header.txt tells the program which SNPs to run, you just need to edit this.


<br>
<br>
<br>


# Step 4: Run the PheWAS script
This is a .slrm job. I found you can run ~100 SNPs in ~7-8 hours. But, if ACCRE is being weird, sometimes, you might need more time. Additionally, you can run this as a job array, if you have multiple sets to run (AKA, multiple .rsID_header.txt's). This is simpler if the multiple sets are also labeled in some way that they are 1-# (e.g. "cluster1", "cluster2", "cluster3", etc.). This is because the slrm array will label each job with a jobarray number in a sequence, so you can hijack that variable for easier coding. 

You can also write a for loop for multiple files instead of an array if it's not too long: 
```bash
for SET in set1 set2 set3
do
	Rscript --verbose --no-save /data/hodges_lab/Tim/github_tutorials/phewas/phewas.R \
	${SNPS_DIR}/${SET}_MEGA 
	.....
done
```

```bash
#!/bin/bash
#SBATCH --account=hodges_lab
#SBATCH --nodes=2
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --output=/data/hodges_lab/Tim/jday/phewas/scripts/phewas.out
#SBATCH --error=/data/hodges_lab/Tim/jday/phewas/scripts/phewas.error
#SBATCH --job-name=jd_phewas

# define filepaths
PHE_DIR='/data/hodges_lab/anna/brain/phewas_table'
COVAR_DIR='/data/hodges_lab/aganve/human_variants/biovu_mega'
# CHECK
SNPS_DIR='/data/hodges_lab/Tim/jday/labwas/SNP_bed'
# SNPS_DIR2='/data/hodges_lab/Tim/jday/phewas/rsID_header' # I reused the labwas rsID_header here 

# create output directory for each cluster 
OUT_DIR=/data/hodges_lab/Tim/jday/phewas/region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed/
mkdir -p ${OUT_DIR}

# activate environment
source /home/lorenzas/miniforge3/bin/activate hodges_lab

# start R-Script
Rscript --verbose --no-save /data/hodges_lab/Tim/github_tutorials/phewas/phewas.R \
${SNPS_DIR}/region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed_MEGA \
${PHE_DIR}/medical_home_phecode_table_20230607_pull_2_distinct_dates_yes_exclusions_121023 \
${COVAR_DIR}/EUs_ibd_check_passed_megaEX_labwas_ready_covs_gender_pcs \
${SNPS_DIR}/region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed_MEGA.subset.rsID_header \
${OUT_DIR}

# /data/hodges_lab/Tim/jday/phewas/scripts/run_phe.slrm
```

<br>
<br>
<br>


# Step 5: Plotting
There are some quirks in this one that are not experienced in LabWAS. 

## Load libraries
```R
library(tidyverse)
library(ggplot2)
library(readr)
library(data.table)
library(ggrepel)
```

## Load Phecode map (v1.2) for linking readable phenotype definitions to the ICD codes 
This is one of those quirks. The PheWAS library in R does provide functions to do this for you. However, I had trouble being able to install the PheWAS library in a conda environment that allowed me to do all this in a Jupyter Notebook. So, instead, I just perform this operation myself. 

```R
phemap <- read_csv("/data/hodges_lab/Tim/github_tutorials/phewas/phecode_definitions1.2.csv")

head(phemap)
```

## Read in output files
Unlike LabWAS, which will combine all the SNPs ran into one output file, PheWAS dumps your files into a directory, one file per SNP. Great.

In this example, I'm running 9 SNPs. 

```R
setwd("/data/hodges_lab/Tim/jday/phewas/region_around_rs7976678_chr12_6422679_6434399_on_MEGA_imputed/")

lofn <- list.files(pattern="phewas_result_rs*")
lofn
# 'phewas_result_rs114686923_C.txt''phewas_result_rs57380213_A.txt''phewas_result_rs59065325_T.txt''phewas_result_rs74056926_G.txt''phewas_result_rs74056928_G.txt''phewas_result_rs75339490_G.txt''phewas_result_rs75639654_A.txt''phewas_result_rs77025001_T.txt''phewas_result_rs7976678_A.txt'

lofn_cleaned_temp <- map(lofn, ~gsub("phewas_result_", "", .))
lofn_cleaned <- map(lofn_cleaned_temp, ~gsub("_.*.txt", "", .))
lofn_cleaned
# 'rs114686923'
# 'rs57380213'
# 'rs59065325'
# 'rs74056926'
# 'rs74056928'
# 'rs75339490'
# 'rs75639654'
# 'rs77025001'
# 'rs7976678'

lof <- map(lofn, read_tsv, col_names=c("phecode","snp","adjustment","beta","SE","OR","pvalue","type","n_total","n_cases","n_controls","HWE_p","allele_freq","n_no_snp","note","bonferroni","fdr"), skip = 1)
names(lof) <- lofn_cleaned
```

## Merge PheWAS results with Phecode map 

```R
lof_mrg <- map(lof, ~merge(., phemap, by="phecode"))
```

## Plotting function: 

```R
#plot Manhattan
phewas_manhattan <- function(results=results, title) {
    #sign returns a vector with the signs of the corresponding elements of x (-1, 0, or 1)
    results$direction <- sign(results$beta)
    #subset rows with non-NA pvalue
    results2=results[!is.na(results$pvalue),]
    #take the -log10 of pvalue
    results2$graph_pvalue <- -log10(results2$pvalue)
    bonferroni <- .05/nrow(results2)
    p <- ggplot(data=results2, aes(x=category, y=graph_pvalue)) +
    #color: assign colors to outline points in a ggplot2 plot based on the categorical variable, group
    #fill: defines colors within which points are filled based on the categorical variable, group 
    #shape: changes point shapes based on a grouping variable...in this case our grouping varaible is the direction of the beta coefficient (1 or -1)
        geom_jitter(aes(size=.2,shape=factor(direction), color=factor(category), fill=factor(category))) +
    #     geom_label_repel(data=results2, 
    #                     aes(label=ifelse((results2$fdr_status == TRUE & results2$bonferroni_status == FALSE) |
    #                                      (results2$fdr_status == TRUE & results2$bonferroni_status == TRUE), as.character(results2$lab),'')), size=3,
    #                    max.overlaps=Inf) +
        scale_shape_manual(values=c(25,24)) +
        geom_text_repel(data=subset(results2, pvalue<0.05), aes(label=phenotype)) +
        geom_hline(yintercept=(-log10(bonferroni)), color="red") +
        geom_hline(yintercept=(-log10(.05)), color="blue") +
        guides(fill="none") +
        guides(size="none") +
        guides(shape="none", colour="none") + 
        theme_classic() +
        theme(axis.text.x=element_text(angle=45, hjust=1)) +
        ylab("-log10(pvalue)") + 
        scale_y_continuous(breaks=seq(0,50,by=1)) +
        ggtitle(title)
    ggsave(paste0("/data/hodges_lab/Tim/jday/phewas/",title,".phewas.pdf"), p, height = 8, width = 8, dpi = 150) ### CHANGE ###
    p
}
```

## Use map2 to plot each SNP's manhattan plot with sensible titles and output names

```R
map2(lof_mrg, lofn_cleaned, ~ phewas_manhattan(results = .x, title = .y))
```






