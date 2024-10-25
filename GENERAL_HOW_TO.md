# General How To
This page is for other tips/recommendations from the lab about best practices while doing the bioinformatics.

<br>
<br>
<br>

# Organizing your directories
This one is sometimes underappreciated--especially in the development stage of an analysis. You might not be sure how many files you may generate, or if the analysis will work. So you might just start with a single open directory like: /data/hodges_lab/person/some_analysis/.

However, as you download necessary files, perhaps necessary tools, and generate intermediate files, you will begin to fill the directory up. Then, if it doesn't work the first time, as many many computational analyses do, you might have multiple outputs (e.g. output.txt, output.fixed_naming.txt, output.fixed_naming2.txt, output.different_celltype.txt, etc.). You get the point. Also, you may realize you need to redo a process, and you have to search through a long list of files to remember where to pick up. 

## Recommended solution
Lindsey has a good system to start with, and it's similar to how I like to organize directories. 

Within your /.../.../some_analysis/ directory, consider starting with a few "default" subdirectories:
- /raw_data/
  - This doesn't necessarily have to be named this (L.G. mentioned for sequencing, she might have one called "/GEO/"), but the idea is to capture and isolate the raw files/data you use for an analysis. That way, if you need to figure out the exact source of some comparative data or some public sequencing data, you will know exactly where to go.
  - It also doesn't hurt to quickly open nano and create a quick READ_ME.txt style file to copy/paste in the website/source the data comes from. This should also ideally be in your Jupyter Notebook or some other documentation, but this way, it's right there with the data, and you don't need to hunt down another place to figure out where it came from. 
- /data/
  - This one is fairly self explanatory. Keep your data here.
  - You will probably have various subdirectories in here to separate types of data. Or "steps" of data along some analysis process. 
  - Another useful thing that I sometimes like to do is to put in an /intermediate_files/ folder here. Some analyses and development of scripts can produce lots and lots of files that you may not want to clutter up your final results. Often, you probably only care about the final results, so quarden off the intermediates if you need to refer back.  
- /results/
  - This is a good one for storing your final results so they're easily accessible. 
- /scripts/
  - This is a good place to keep the code/scripts you use to run whatever analysis in your folder. This is not only good for organization, but also good for future you. If you need to figure out what you did for some previous analysis, you'll know where to look. Also, it's good for other people or lab members who would like to repeat your analysis. 
  - I also like to make a ./dot_outs/ and a ./dot_errors/ subdirectory to store all the *.out and *.error files that an ACCRE SLURM job produces, just to keep it a little tidier with multiple runs.  

