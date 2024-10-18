# (1) Tell R what files we want to load in: 
For this part, we're going to use the function *list.files()*
- The goal here is to get an object that is a list of strings of filenames we'd like to load in.
- Here, I find it easier to *cd* into the directory of interest first, and then use *list.files()*, or all the file names will include the directory path, and it's just more cumbersome to view as well as clean
  - On a similar note, it's easier if the files you want are the only files in the directory, as *list.files()* will match using regex, and writing complex regex expressions to isolate your files of interest is avoidable by having a clean directory of interest
- And, here, ideally the files have some sort of pattern to them, where their ID is part of the name
    - rsID1.txt, rsID2.txt, rsID3.txt, ... 
    - REP1.output.file.txt, REP2.output.file.txt, REP3.output.file.txt, ...


# Steps for loading a list of files and having the list labeled in a readable manner
## Go to the directory of interest
```R
    > cd("/some/output/directory/")
```
## Load in the filenames based on pattern (this uses regex, so the cleaner your directory, the easier)
```R
    > # I shorthand "list of filenames" to lofn
    > # Here, I'm using the above example and assuming our pattern of files is: REP1.output.file.txt, REP2.output.file.txt, REP3.output.file.txt, ...
    > lofn <- list.files(pattern=".*.output.file.txt")
```
## Clean the filenames
Now you should have a list like: c("REP1.output.file.txt", "REP2.output.file.txt", "REP3.output.file.txt", ...)
But! Obviously, if we want to name the items of our list of dataframes in the next step, we'd like a cleaner list more like: c("REP1", "REP2", "REP3", ...)
- For this, we're going to use *gsub()*
  - The syntax for *gsub()* is gsub("pattern", "replacement", string)
  - We're also going to use *map()* to iterate over our list of filenames

- *map()* is faster than using a traditional *for loop* and is also, in my opinion, more readable 
    - The basic syntax here is map(list, function)
    - Importantly, you can write custom lambda functions within map with the help of a tilda (~) 

Instead of writing a for loop something like: 
```R
  > for (i in 1:length(lofn)){
      lofn[[i]] <- gsub(".output.file.txt", "", lofn[[i]]
  }
```
we can instead write a one-liner with map!
```R
    > lofn_cleaned <- map(lofn, ~gsub(".output.file.txt", "", .))
```

## Load the list in and name the items appropriately
Here, we are going to use *map()* again to read in the list of files, based on the list of filenames
- Importantly, map can also take in additional arguments and pass them to the function!
```R
    # I'm abbreviating "list of files" to "lof"
    > lof <- map(lofn, read_tsv)
    # If you have column names, you can also do: 
    > lof <- map(read_tsv, lofn, colnames=TRUE)
    # Here's an example of mine where I'm sending in a few more options
    > lof <- map(lofn, read_tsv, col_names=c("phecode","snp","adjustment","beta","SE","OR","pvalue","type","n_total","n_cases","n_controls","HWE_p","allele_freq","n_no_snp","note","bonferroni","fdr"), skip = 1)
```





