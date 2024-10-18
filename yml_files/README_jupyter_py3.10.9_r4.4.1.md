## NOTE: CHANGE BEFORE INSTALLING CONDA ENV
The name in the first line of the yml file will determine the name of the conda environment. Edit before creating your environment. ("Name: env_name")

# To install a conda environment from a yml
## Loading Conda ##
- To start, you need to be in a conda environment
  - On ACCRE, you can load in a conda environment through LMod, by using:
      > module load Anaconda3/2023.03-1
      - This one is the most stable, up to date version currently as of Oct 2024, so subject to change
### [!!!] Alternatively, if you don't want to remember that whole sequence of numbers, you can make an Lmod "environment"/collection that saves this similar to a conda env, and you can then load it with an easy to remember name
      # Load in the module as above
      > module load Anaconda3/2023.03-1
      # Now that it's loaded, you can save this as an Lmod collection
      > module save [NAME_OF_MODULE] # I named mine: module save conda31
      # You can now load this in using:
      > module restore [NAME_OF_MODULE] # e.g. module restore conda31

## Creating your conda environment from the yml file ##
- This is the 

