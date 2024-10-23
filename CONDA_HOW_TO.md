# Making conda environments is partly described in the JUPYTER_HOW_TO_Make_a_Jupyter_Notebook_on_ACCRE.md

# Rules of Thumb
- Try to only use "conda install" for packages
- Remove "defaults" from your channel list - details in main READ_ME for this GitHub
- Keep your projects/methods/analyses separate!
  - Instead of trying to install new packages (I'm talking about specialized packages more than standard, well documented packages) into an existing conda environment you like, I would highly recommend creating a new environment
  - Note: Before you do make a new one, ask someone if they have an existing environmen to save time! 
  - The warning here is that sometimes, new packages may have conflicts of dependencies with existing packages, and it could "break" your environment, which can be a major headache
    - "conda install" is slow at "solving specifications", and is a known issue, so the less you have to do this, the less time you feel like you're wasting
  
# How to share environments
- Yes, you can make a .yml if you don't mix *pip* with *conda install* in your environment
```bash
# enter an environment
conda env export > environment.yml
```
Other user:
```bash
conda env create -f environment.yml
```

- Or, you can also just share between hodges_lab users by making your environment public
  - Unless you have changed this, your environments should probably be in ~/.conda/envs/
Then, someone can load that environment using the same method as always:
```bash
source activate /someones/path/to/an/environment
``` 

