# Tutorials

A collection of code, scripts, and ymls to hopefully make your bioinformatic life a little simpler. 



# Quick notes on use of conda on ACCRE:
Update on post-conda commercialization: 

TL;DR:
- Remove defaults from your conda config file channel list using "conda config --remove channels defaults"
- Check your favorite environments for packages from sources outside of conda-forge or bioconda:

           conda list -n my_env_name

  If it's clear, you're good to go

Main issue:
- Anaconda, miniconda, etc. remain free to use
- Repositories: conda-forge and bioconda remain free to use
- Repository: defaults is no longer free to use (and does have a lot of regular, popular packages)

Solution:
- Only use the user-generated conda-forge and bioconda repositories (users maintain common, popular packages over on these repos, too)
- Don't use defaults
     - You can check what channels/repos your conda is set to look through when installing software, using "conda config --show channels"
     - Remove defaults from this list using "conda config --remove channels defaults"
           - For stubborn environments, you can also manually edit this .condarc file like a .bashrc (probably at the location: ~/.condarc) and remove it that way


Practical solution for current environments:
- Check if your current favorite environments even violate the updated Anaconda Terms of Service. Check if your environment has any packages not from conda-forge or bioconda by using:
   conda list -n my_env_name
- It should show the "channel" from which packages are sourced in the fourth column. If all your channels are from conda-forge or bioconda, then you're good to go. 
- If not:
     - Delete packages if not needed
     - Reinstall from a free channel source instead
     - Start a new notebook/conda environment, updated instructions here: 
          - [https://github.com/t-scott/Tutorials/blob/main/jupyter_notebook_ACCRE](https://github.com/t-scott/Tutorials/blob/main/JUPYTER_HOW_TO_Make_a_jupyter_notebook_on_ACCRE.md)
     - Start a new notebook/conda environment from a yml. I have a basic one for python3.10.9 (with your basic do-all python libraries) with R4.4.1 (has tidyverse, ggplot2, data.table, etc.):
           - https://github.com/t-scott/Tutorials/blob/main/yml_files/jupyter_py3.10.9_r4.4.1.yml
           - conda create -f name_of_yml_file.yml # (change the .yml file name to the name you want to name your conda env)




