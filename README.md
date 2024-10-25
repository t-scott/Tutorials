# Tutorials

A collection of tutorials, code, scripts, and ymls to hopefully make your bioinformatic life a little simpler. 

<br>

# Table of Contents (in progress)
## Bash
- BASH_HOW_TO_use_variables_in_awk.md
    - If you want to use bash variables in your awk command (e.g. putting the filename or another variable in as a column)
- BASH_TIPS.md
    - Consider creating lmod collections    
    - How to clean up bash variables
    - Making shortcuts in ~/.bash_profile
    - Screens
    - Consider using Oh-My-Zsh

<br>
<br>

## Jupyter
- JUPYTER_HOW_TO_Make_a_Jupyter_Notebook_on_ACCRE.md
    - Install a default env with Jupyter Notebook on ACCRE via .yml
      - Allows for Jupyter Notebooks with Python/R/bash kernels
      - Comes with Rv4.4.1: tidyverse, ggplot2, ggrepel, RColorBrewer, reshape2, scales
      - Comes with Pythonv3.10.9
      - Designed to be a good starting point/general environment for most needs
    - How to create a new conda environment with packages from just conda-forge and bioconductor
- JUPYTER_TIPS.md
    - How to resize plot outputs in your Notebook
 
<br>
<br>

## R
- R_HOW_TO_Graph_a_list_of_files.md
    - How to load files in from a filename pattern, ggplot them with appropriately named titles, and save them with appropriate outfile names            
- R_HOW_TO_Load_in_a_list_of_files_and_do_processes_with_them.md
    - More generalized version of loading in a list of files from a filename pattern and applying a function to each file 
- R_HOW_TO_Load_list_of_files_in_and_write_files_out_automatically.md
    - More generalized version of iterating a process of a list of dataframes with options for input directory and output directory 
- R_HOW_TO_Wrap_ggplot_text_labels.md
    - How to wrap text if your axis labels are **too wide** 
- R_TIPS.md
    - My basic starting ggplot *theme()* section
    - Checking your R random number generator method (re: *set.seed()*)
    - *mutate()* + *case_when()* to add new columns to a dataframe based on other columns

<br>
<br>

## Conda
- CONDA_HOW_TO.md
    - The main how to conda is summarized in the lower part of this READ_ME, or in the JUPYTER_HOW_TO_Make_a_Jupyter_Notebook_on_ACCRE.md page
    - This includes some Rules of Thumb
    - And how to share an environment in the lab


<br> 
<br>

## Other    
- GENERAL_HOW_TO.md
    - Organizing your directories 
- HOW_TO_convert_gene_IDs.md
    - A quick look at how to convert geneIDs in R and another potential method 
- Hodges_Lab_Software_Recs.md
    - Some ideas for a text editor and terminal     
- GREAT_and_the_not_so_great.md
    - Some warnings about GREAT usage 
- PheWAS_HOW_TO.md
- LabWAS_HOW_TO.md
- LDSC_HOW_TO.md
- USEFUL_LINKS.md
    - RColorBrewer cheatsheet
    - UCSC FTP links (hg19/hg38)
    - KentUtils links for downloading binaries
- plot_HOMER_single.R
    - a script I wrote to quickly plot HOMER output (knownResults.txt)
    - Options:
        - -f FILEPATH, --filepath=FILEPATH - input file path
        - -p OUTPATH, --outpath=OUTPATH - dir path for output files
        - -o OUTNAME, --outname=OUTNAME - name for output plot
        - -t TITLE, --title=TITLE - title for plot
        - -n NROW, --nrow=NROW - the amount of hits to show
        - -l LABELSIZE, --labelsize=LABELSIZE - size for label text
        - -a AXISLABELSIZE, --axislabelsize=AXISLABELSIZE - size for axis label text
        - -w FIGUREWIDTH, --figurewidth=FIGUREWIDTH - figure width
        - -e FIGUREHEIGHT, --figureheight=FIGUREHEIGHT - figure height
        - -c COLORPALETTE, --colorpalette=COLORPALETTE - RColorBrewer palette name.
- plot_qPCR.R_script_with_options.R
    - a script I wrote for J.Day with options:
               - --filepath, --outpath, --name, --remove, --housekeepinggene, --labelsize, --axislabelsize, --figurewidth, --figureheight


<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

# Quick notes on use of conda on ACCRE:
Update on post-conda commercialization: 

TL;DR:
- Remove defaults from your conda config file channel list using "conda config --remove channels defaults"
- Check your favorite environments for packages from sources outside of conda-forge or bioconda:

```bash
conda list -n my_env_name
```

  If it's clear, you're good to go

Main issue:
- Anaconda, miniconda, etc. remain free to use
- Repositories: conda-forge and bioconda remain free to use
- Repository: defaults is no longer free to use (and does have a lot of regular, popular packages)

Solution:
- Only use the user-generated conda-forge and bioconda repositories (users maintain common, popular packages over on these repos, too)
- Don't use defaults
     - You can check what channels/repos your conda is set to look through when installing software, using
```bash
conda config --show channels
```
- Remove defaults from this list using 
```bash
conda config --remove channels defaults
```
- For stubborn environments, you can also manually edit this .condarc file like a .bashrc (probably at the location: ~/.condarc) and remove it that way


Practical solution for current environments:
- Check if your current favorite environments even violate the updated Anaconda Terms of Service. Check if your environment has any packages not from conda-forge or bioconda by using:
```bash
conda list -n my_env_name
```
- It should show the "channel" from which packages are sourced in the fourth column. If all your channels are from conda-forge or bioconda, then you're good to go. 
- If not:
     - Delete packages if not needed
     - Reinstall from a free channel source instead
     - Start a new notebook/conda environment, updated instructions here: 
          - [https://github.com/t-scott/Tutorials/blob/main/jupyter_notebook_ACCRE](https://github.com/t-scott/Tutorials/blob/main/JUPYTER_HOW_TO_Make_a_jupyter_notebook_on_ACCRE.md)
     - Start a new notebook/conda environment from a yml. I have a basic one for python3.10.9 (with your basic do-all python libraries) with R4.4.1 (has tidyverse, ggplot2, data.table, etc.):
           - https://github.com/t-scott/Tutorials/blob/main/yml_files/jupyter_py3.10.9_r4.4.1.yml
           - conda create -f name_of_yml_file.yml # (change the .yml file name to the name you want to name your conda env)




