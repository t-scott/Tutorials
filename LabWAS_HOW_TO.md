# NOTE: All the initial steps (1, 2, & 3) are identical to the steps for PheWAS
You can refer to these in the "PheWAS_HOW_TO.md" page. These are:
1. Get a BED file
2. Filter the MEGA BED file for SNPs
3. Make an rsID_header.txt file

If you have ran those for PheWAS, you can just start here at just running the LabWAS script!

# Step 4: The LabWAS script



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
Rscript --verbose --no-save /data/hodges_lab/anna/pipeline/labwas.R \
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








