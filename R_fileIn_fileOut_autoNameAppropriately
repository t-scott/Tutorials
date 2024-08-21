# 
### One way to load files in, perform a process, and save outputs with appropriate filenames
#

### Get a list of filenames to iterate over
setwd("/data/hodges_lab/Tim/data/directory/")
lof <- list.files()
# The goal here is to be able to iterate over all names with a function
#    Alternatively, you could load all files into a list using 
#        list.files() --> map(read_tsv, lof) --> rename list with names from list.files()
#        but this can also be annoying to work with

### Write a function
#       It needs to load in a file based on the filename
do_something <- function(fname, dir_in, dir_out){
    # You could also just initialize a dir as a variable
    # file_dir <- "/data/path/to/files/"
    
    ## Clean file name (fname)
    fname_c <- gsub(".txt$", "", fname) # pattern here is gsub("pattern_to_replace", "replacement", string)
    #    Ideally, if your filename is like "SampleA.txt", fname_c is "SampleA", a nice easy ID
    
    ## Do stuff
    p <- ggplot(things, x = this, y = that) +
            geom_graphs()
    
    ## Save your stuff appropriately!
    #      -Strategy here is to combine the dir_out and the fname_c
    out_file=paste0(dir_out, fname_c, ".pdf")
    # out_file is now something like "/path/to/out/dir/SampleA.pdf"
    
    # save
    ggsave(p, out_file, dpi = 150)
}

### Map the function across the list of files!
map(lof, do_something, "/path/to/files/", "/path/to/output/")
