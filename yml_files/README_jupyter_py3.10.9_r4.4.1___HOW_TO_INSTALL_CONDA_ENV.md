## NOTE: CHANGE BEFORE INSTALLING CONDA ENV
The name in the first line of the yml file will determine the name of the conda environment. Edit before creating your environment. ("Name: env_name")

# To install a conda environment from a yml
## Loading Conda 
- To start, you need to be in a conda environment
  - On ACCRE, you can load in a conda environment through LMod, by using:
      > module load Anaconda3/2023.03-1
      - This one is the most stable, up to date version currently as of Oct 2024, so subject to change
- [!!!] Alternatively, if you don't want to remember that whole sequence of numbers, you can make an Lmod "environment"/collection that saves this (i.e Anaconda3/2023.03-1) similar to a conda env, and you can then load it with an easy-to-remember name
###
    # Load in the module as above
    > module load Anaconda3/2023.03-1
    # Now that it's loaded, you can save this as an Lmod collection
    > module save [NAME_OF_MODULE] # I named mine: module save conda31
    # You can now load this in using:
    > module restore [NAME_OF_MODULE] # e.g. module restore conda31

## Creating your conda environment from the yml file 
- To do this part, you only need a simple command:
    > conda env create -f environment.yml
- Remember, the name of the .yml does not dictate the name of the conda environment you will use when loading it
- This portion will take a little time. We tested this with Jessica Day on a default ACCRE terminal and it took ~5-10 minutes.

## Using your conda environment for Jupyter Notebooks:
- Log into: https://portal.accre.vanderbilt.edu/
- Click "Interactive Apps" > "Jupyter Notebook" (first option)
- Set your hours, memory, and CPUs
- **[!!!] Click the box for "virtual environment"**
  - Here is where you should enter the conda environment name (e.g. "/data/hodges_lab/Tim/.conda/envs/jupyter_py3.10.9_r4.4.1")
- Click the box that says "Use Custom Module Collection" if you created an Lmod collection (e.g. "conda31)
  - Otherwise, select a "Python version" above (e.g. "Python 3.10.9 / Anaconda 2023.03")
    - Note: this should correlate with the conda version you used to make the conda environment (in my case "Python 3.10.9 / Anaconda 2023.03" matches back to "module load Anaconda3/2023.03-1)
- Click **"Launch"** at the bottom and wait for your job to start! This is like submitting a .slrm job, so it can take a minute or two (or three or more if ACCRE is having a bad day)

## Enabling nb_extensions (Table of Contents is elite)
- Once in a notebook (> new > bash/R/python), click "Edit" > "nbextensions_config"
- From this page, you can click the boxes to allow for "Table of Contents (2)"
- There are many other options here for your purusal 
