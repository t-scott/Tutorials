# Basic idea:
This (hopefully) describes how to iterate over a list of files and ggplot them, assuming you want to apply the same ggplot function to each file

**Rule of thumb:**
- **If you find yourself copying/pasting or rewriting code 3 or more times, loop it.** There's also a good chance you might have to rerun the code, and you don't want to have to edit each individual line if something changes (filename, file location, etc.). 

## Example usage:  
- I have a directory of 1000 PheWAS output results that I'd like to plot. And, their rsIDs are part of the output file names: rs12345.output.txt, rs23456.output.txt, rs34567.output.txt, ..., so therefore, I'd also like the outputs to include these names: rs12345, rs23456, rs34567 in the filename of the saved plot.

## Why this is a separate HOW_TO:
- This is similar to the other How-to's regarding how to load in a list of files with similar filenames and iterate a process (column alteration, renaming, calculating new columns, various formatting, etc.) over them. There is also a how-to for how to iterate a process and have the code detect files with a common name (rs123.output.txt, rs234.output.txt, rs345.output.txt, ...) and save them with an appropriate naming convention (rs123.plot.png, rs234.plot.png, rs345.plot.png) automatically.
- The big thing here is being able to use the identifier (here, for example, "rs123, rs234, rs456" or "rep1, rep2, rep3" or "ENSG001, ENSG002, ENSG003"--whatever is unique to each file) as a ggplot title so that when they save, not only is the filename unique to that individual file, but also the title. This is also convenient for running a series of plots in Jupyter Notebooks while retaining the identifying information so you know which plot represents what file while scrolling through tens or even hundreds of plots.
  - The major difference is using map2 (instead of just normal *map*), so we can feed in not only a list of dataframes, but also the list of file names (cleaned) so that it can use two inputs, one for the the ggplot as usual, and the list of names for ggtitles

# R stuff
The files I use for examples are stored on ACCRE: /data/hodges_lab/Tim/github_tutorials/rep_example_files/

## Create a list of filenames to load
```R
> setwd("/some/output/directory/full/of/neat/files")
> # lofn = list of file names
> # Here, like the other how-to, I'm assuming our pattern of files is: REP1.output.txt, REP2.output.txt, REP3.output.txt, ...
> lofn <- list.files(pattern=".*.output.file.txt")

> lofn
> 'REP1.output.txt''REP2.output.txt''REP3.output.txt'

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
> lofn_cleaned
> 'REP1'
  'REP2'
  'REP3'

```

## Load the list in
Here, we are going to use *map()* to read in the list of files, based on the list of filenames
- Importantly, map can also take in additional arguments and pass them to the function! This is useful for various functions with more options than just the object, like read_tsv where you might want to use *skip* or *colnames*
```R
    # I'm abbreviating "list of files" to "lof"
    > lof <- map(lofn, read_tsv)
    # If you have column names, you can also do: 
    > lof <- map(read_tsv, lofn, colnames=TRUE)
    # Here's an example of mine where I'm sending in a few more options
    > lof <- map(lofn, read_tsv, col_names=c("phecode","snp","adjustment","beta","SE","OR","pvalue","type","n_total","n_cases","n_controls","HWE_p","allele_freq","n_no_snp","note","bonferroni","fdr"), skip = 1)
```
Now you have a list of dataframes! With read_tsv, you really have tibbles. But, the point is they're the same as if you had loaded them in individually, but just stored in a list structure. The one-liner is much faster than writing each and every file out: 
```R
# Slow way
rep1_df <- read_tsv("/data/hodges_lab/Tim/github_tutorials/rep_example_files/REP1.output.txt", colnames=TRUE)
rep2_df <- read_tsv("/data/hodges_lab/Tim/github_tutorials/rep_example_files/REP2.output.txt", colnames=TRUE)
rep3_df <- read_tsv("/data/hodges_lab/Tim/github_tutorials/rep_example_files/REP3.output.txt", colnames=TRUE)
...
...
...
```

## Name the items appropriately with our cleaned list of filenames
```R
    > names(lof) <- lofn_cleaned
    # Easy peasy
```
It should look something like this: 
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_named_list_of_dataframes.png)


## Do stuff to each file
The idea here is that now you can use map2 and iterate ggplot over each file efficiently, as in a for loop. Importantly, here, we're also sending in the cleaned list of filenames (*lofn_cleaned*) from above, so the ggplot function knows both what dataframe we're plotting as well as the name of the dataframe (i.e. "REP1", "REP2", "REP3", etc.)
```R
> # Define a function for ggplotting
> # Note that this expect TWO inputs! The dataframe as usual, and a title, which we'll provide as a string
> some_ggplot_function <- function(input_df, title) {
    plot_to_save <- input_df %>%
    # mutate(...) # you can also mutate in new columns or calculations or group assignments here (case_when is great)
    ggplot(aes(x=fake_x_col, y=fake_y_col)) +
      geom_point() +
      ggtitle(title) +
      theme_minimal() + 
      theme(
            plot.title = element_text(hjust = 0.5, size = 14), # centers the title
            axis.title.x = element_text(color = "grey20", size = 14),
            axis.title.y = element_text(color = "grey20", size = 14),
            axis.text.x = element_text(color = "grey20", size = 14, angle = 90, hjust = 1), # adjusts x-axis to vertical
            axis.text.y = element_text(color = "grey20", size = 14),
            panel.grid.minor = element_blank(),
            panel.grid.major.y = element_blank()
      )
    plot_to_save
    ggsave(paste0("/some/directory/path/for/plots/", title, ".output_plot.pdf"), plot_to_save, width = 8, height = 8, dpi = 150)
}
```
A couple notes here:
- Note that the *title* being requested is being used twice in the function: once in the *ggtitle()* and again in the *ggsave()* call--this is where the map2 is useful in being able to take in that list of filenames, so now we can just save the plots automatically with informed identifiers ("REP1", "REP2", "REP3", etc. --> "REP1.output_plot.pdf", "REP2.output_plot.pdf", "REP3.output_plot.pdf") without ever having to copy/paste or, worse, explicitly writing them out! This gets increasingly useful with increasing amounts of files; this also helps in cases where you have many many files with similar names (e.g. rsIDs, ENSG gene names, etc.) where a copy/paste error could be problematic and hard to track down. 
  - *paste0()* (as opposed to *paste(..., ..., sep="\t")* combines strings with the assumption that you don't want a separator, so it's good for combining paths and filenames


Now we can iterate this function over our list of dataframes and list of cleaned names:
```R
> # Iterate over files
> map2(lof, lofn_cleaned, ~some_ggplot_function(input_df = .x, title = .y))
```

Here's an example of me running the code above. 
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_plotting_function.R_HOW_TO_Graph_a_list_of_files.png)

Note how the plots now have their appropriate title label! And how Jupyter Notebook will still print the list names, but it won't necessarily put them in order with the plots, so with many more files, it would otherwise be difficult to immediately tell which plot represented what identifier ("REP1", "REP2", "REP3", etc.). 
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_plots.R_HOW_TO_Graph_a_list_of_files.png)









