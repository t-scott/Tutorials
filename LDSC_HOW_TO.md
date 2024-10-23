# Notes
This program was not very fun to work with at the start. It came from a paper and technically had documentation, but it was sparce. It's hosted on this GitHub: https://github.com/bulik/ldsc

It comes with tutorials, but they are only several steps and make it seem easy. Some files/default sumstats were also hosted on a separate lab FTP that is no longer available. 

I tried to simplify the process by refactoring the code so you only have to change a few variables at the top and then let it rip. 

From the GitHub, starting from scratch, it provides a conda environment environment.yml, but I have had trouble implementing this. I have a conda environment on ACCRE, and hopefully, you can just use that one. 
```bash
conda activate /home/scottt7/.conda/envs/ldsc
# Tested by Jessica, it *should* work
```


# The .slrm script
The main input for this is just a BED file. 

This .slrm script is designed to take in a positional argument ("$1"), so that one can use a separate chunk of code to submit a series of BED files. Hopefully this is clear below. 

Variables to change are typically marked with "##### CHANGE ######'
1. DIR_LDSC
This one hosts the reference files and python scripts needed:
- tim_ldsc.yml - an attempt to share my conda environment 
- make_annot.py - part of the first step to create annotation of the genome with your input BED file
- ldsc.py - the main guy
- 1000G_EUR_Phase3_plink files
- 1000G_Phase3_baselineLD_v2.2_scores - you can find this hopefully on their GitHub, but it's already downloaded - may be updated in the future
- 1000G_frq files
- hapmap3_snps files
- weights_hm3_no_hla files
- Alkes_sumstats - downloaded from the Alkes lab FTP that's no longer available - provided as default sumstat files
- original_sumstats - a directory of sumstat files I added that the script will loop over
  - Note: Put any new sumstats files you'd like to run in here and add the filename to the for loop in the script!
2. COMP_NAME_PRE - added to the front of COMP_NAME - this can be editted out for simplicity
- This was used to add a prefix to denote we were running clusters from a heatmap, so the output would be "Heatmap_info_" + ["cluster1", "cluster2", etc.] as we had multiple heatmaps. This added clarity to the outputs
3. COMP_NAME - This is used for naming intermediate and output files
4. FILE_COLHEADER - This is used as the header in the .annot file, the first file produced
- **BIG NOTE**: This has to be different from COMP_NAME, or an error will appear.
  - I do not recall why, but somewhere deep deep in hundreds of lines of code, it becomes ambiguous
5. DIR_LDSChost - This is where your input files are coming from
- It's currently set up to assume you have a subdirectory in this one called "/inputFiles/", but you can adjust the code
6. DIR_INTER - Where intermediate files go
- This process creates a lot of stuff in between the start and the output, so it's nice to quarden them off
- If this directory doesn't already exist, it'll make it for you
7. DIR_OUT -  Where output files go
- This is self explanatory
- If this directory doesn't already exist, it'll make it for you

Other note about running: It currently assumes your filenames are something like "relevantID1.input.words.txt", "relevantID2.input.words.txt", "relevantID3.input.words.txt", etc.. You can see at the very start, it imports the positional variable and then truncates it before the first **period**. Then, it's using that name (e.g. "relevantID1", "relevantID2", "relevantID3", etc.) for automatically naming the first .annot file that then gets appended to the big default .annot file that includes ~98 other annotations by default provided by the authors (the combination of these is what's used for the analysis). This naming process can be adjusted as needed. 


## The main script

```bash
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=14:00:00
#SBATCH --mem=32G
#SBATCH --output=methHeatmap.%J.out


# Store positional variable (input file, e.g. Input.1.bed)
USER_INPUT_FILE=$1
USER_INPUT_NAME="${USER_INPUT_FILE%%.*}" 

echo "Running the file:" $USER_INPUT_FILE

# Get conda environment up and running
module restore conda
# source activate ldsc
# or hopefully:
source activate /home/scottt7/.conda/envs/ldsc


####### Set variables
# LDSC Directory 
DIR_LDSC=/data/hodges_lab/Tim/github_tutorials/ldsc/ ##### Check - previously /data/davis_lab/tim/LDSC_Base/
# Go to LDSC folder where subdirectories for this project and .py programs are located 
cd $DIR_LDSC

# Comparison Name
COMP_NAME_PRE="MethHeatmap_k9s112_" ##### Change #####
COMP_NAME=${COMP_NAME_PRE}${USER_INPUT_NAME} ##### Change ##### | Will be used as a file header for intermediate/output files

# Column header
FILE_COLHEADER=${USER_INPUT_NAME} ##### Change ##### | Will be used in the annotation column of .annot files | THIS HAS TO BE DIFFERENT FROM COMP_NAME (IDKY)

# Directory List: INPUT DIR
DIR_LDSChost=/data/hodges_lab/tim/LDSC_brain/ #### Change #### This is where your input files are 
cd ${DIR_LDSChost}
IN_DIR=${DIR_LDSChost}inputFiles/ ##### Check ########## CHANGED THE ROOT DIR FOR THIS - Made my own input dir here 

# Directory List: INTERMEDIATE/OUTPUT DIR
DIR_INTER=${DIR_LDSChost}intermediateFiles_methHeatmapk9s112_${USER_INPUT_NAME}/ ##### Change #####
mkdir -p ${DIR_INTER}

DIR_OUT=${DIR_LDSChost}outputResults_methHeatmapk9s112_${USER_INPUT_NAME}/ ##### Change #####
mkdir -p ${DIR_OUT}

##########################################################
##  Everything past this should not need to be touched! ##
##########################################################

# Directory List: Dependent Reference Files
DIR_LDSCOREANNOT=${DIR_LDSC}1000G_Phase3_baselineLD_v2.2_ldscores/
DIR_PLINK=${DIR_LDSC}1000G_EUR_Phase3_plink/ 





echo -e "-----------------------------------------------------\n#\t\t\tRUNNING STEP 0 \n-----------------------------------------------------"

# Go to LDSC folder where subdirectories for this project and .py programs are located 
cd $DIR_LDSC

# Make annotation file [baseline + 4 custom annotations]
# Make a SNP-annotation column for each annotation, then paste these to the right side of the baseline.[CHR].annot file; rezip at the end 
# Per chromosome
for CHR_NUM in {1..22}
do
	# Cl
	python make_annot.py --bed-file ${IN_DIR}${USER_INPUT_FILE} --bimfile ${DIR_PLINK}1000G.EUR.QC.${CHR_NUM}.bim --annot-file ${DIR_INTER}${USER_INPUT_NAME}.${CHR_NUM}.annot.gz 
	gunzip -f ${DIR_INTER}${USER_INPUT_NAME}.${CHR_NUM}.annot.gz
	awk -v header1=${FILE_COLHEADER} 'BEGIN{print header1}{if (NR>1) print}' ${DIR_INTER}${USER_INPUT_NAME}.${CHR_NUM}.annot > ${DIR_INTER}temp9.txt
	mv ${DIR_INTER}temp9.txt ${DIR_INTER}${USER_INPUT_NAME}.${CHR_NUM}.annot

	# Combine
	# Uses Alkes reference file here 
	paste ${DIR_LDSCOREANNOT}baselineLD.${CHR_NUM}.annot ${DIR_INTER}${USER_INPUT_NAME}.${CHR_NUM}.annot > ${DIR_INTER}${COMP_NAME}.${CHR_NUM}.annot

	# Remove waste
	rm ${DIR_INTER}temp*.txt
done

# # Gzip the above file: The annotation matrix with our columns appended 
gzip -f ${DIR_INTER}${COMP_NAME}.*.annot

## for chr in {1..22}; do sbatch Test_step1_calculate_ldscore.sh $chr; done








 echo -e "-----------------------------------------------------\n#\t\t\tRUNNING STEP 1 \n-----------------------------------------------------"

##########################################################
##  Everything past this should not need to be touched! ##
##########################################################

# Directory List: Dependent Reference Files
DIR_PLINK=${DIR_LDSC}1000G_EUR_Phase3_plink/ ### non-existent
DIR_HAPMAPSNP=${DIR_LDSC}hapmap3_snps/



# Go to directory where ldsc.py is hosted, or call on it with the direct path 
cd ${DIR_LDSC}

# Run L2
for CHR_NUM in {1..22}
do
	python ldsc.py --l2 --bfile ${DIR_PLINK}1000G.EUR.QC.${CHR_NUM} --ld-wind-cm 1 --annot ${DIR_INTER}${COMP_NAME}.${CHR_NUM}.annot.gz --out ${DIR_INTER}${COMP_NAME}.${CHR_NUM} --print-snps ${DIR_HAPMAPSNP}hm.${CHR_NUM}.snp
done








 echo -e "-----------------------------------------------------\n#\t\t\tRUNNING STEP 2 \n-----------------------------------------------------"


##########################################################
##  Everything past this should not need to be touched! ##
##########################################################

# Directory List: Dependent Reference Files
# DIR_LDSC=/data/davis_lab/tim/LDSC_Base/ ##### Check
DIR_SUMSTATS=/data/hodges_lab/Tim/LDSC_LG/Alkes_sumstats/
DIR_SUBSTATS_PGC=/data/davis_lab/tim/sumstats/psychiatric/
DIR_WEIGHTS=${DIR_LDSC}weights_hm3_no_hla/
DIR_FREQ=${DIR_LDSC}1000G_Phase3_frq/

# Make list of traits on which to run LDSC -h (partitioned heritability)
# Code to do so, if you're in the directory w/ sumstats
# ls | tr "\n" " "
# a="^^^"
# for i in $a; do fileName="${i%%.sumstats}"; echo $fileName; done | tr "\n" " "

# cd $DIR_LDSC

for TRAIT_NAME in ADHD ALCH AN ANX ASD BIP CUD MDD OCD OUD PTSD SCZ TS
do
	python ldsc.py --h2 ${DIR_SUBSTATS_PGC}${TRAIT_NAME}.sumstats.gz --ref-ld-chr ${DIR_INTER}${COMP_NAME}. --w-ld-chr ${DIR_WEIGHTS}weights. --overlap-annot --print-coefficients --frqfile-chr ${DIR_FREQ}1000G.EUR.QC. --out ${DIR_OUT}${COMP_NAME}.${TRAIT_NAME}
done


for TRAIT_NAME in PASS_HDL PASS_Height1 PASS_Rheumatoid_Arthritis UKB_460K.blood_EOSINOPHIL_COUNT UKB_460K.body_WHRadjBMIz UKB_460K.other_MORNINGPERSON
do
	python ldsc.py --h2 ${DIR_SUMSTATS}${TRAIT_NAME}.sumstats --ref-ld-chr ${DIR_INTER}${COMP_NAME}. --w-ld-chr ${DIR_WEIGHTS}weights. --overlap-annot --print-coefficients --frqfile-chr ${DIR_FREQ}1000G.EUR.QC. --out ${DIR_OUT}${COMP_NAME}.${TRAIT_NAME}
done

## Filename: run_LDSC_on_heatmapClusters.slrm
```

## Submitting files to the .slrm script
If everything goes well, you can use this to loop through files and send them to the .slrm script, creating a slrm script for each one. This differs from a bash array as it won't intelligently monitor and limit the submissions of the files/slrm jobs. It'll just submit them all. So be careful not to submit an exorbitant amount. This is a fairly resource-heavy process, so that could be bad. And bad for everyone else in the lab. 

```bash
cd /data/davis_lab/tim/test_scripts/

# Looping through 9 clusters here
for CLUSNUM in $(seq 1 9)
do
    sbatch run_LDSC_on_heatmapClusters.slrm cluster${CLUSNUM}.methMatrix.km9_seed112.txt
done
```




