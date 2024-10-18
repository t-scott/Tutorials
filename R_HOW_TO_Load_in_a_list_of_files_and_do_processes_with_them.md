# (1) Tell R what files we want to load in: 
For this part, we're going to use the function *list.files()*
- The goal here is to get an object that is a list of strings of filenames we'd like to load in.
- Here, I find it easier to *cd* into the directory of interest first, and then use list.files, or all the file names will include the directory path, and it's just more cumbersome to view as well as clean
  - On a similar note, it's easier if the files you want are the only files in the directory, as *list.files()* will match using regex, and writing complex regex expressions to isolate your files of interest is avoidable by having a clean directory of interest
- And, here, ideally the files have some sort of pattern to them, where their ID is part of the name
    - rsID1.txt, rsID2.txt, rsID3.txt, ... 
    - REP1.output.file.txt, REP2.output.file.txt, REP3.output.file.txt, ...


```R
# Go to the directory of interest
cd("/some/output/directory/")

# Load in the filenames based on pattern (this uses regex, so the cleaner your directory, the easier)




