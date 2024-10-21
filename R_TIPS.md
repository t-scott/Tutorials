# How to wrap text on ggplot axes
TL;DR: Use the library *stringr*
```R
scale_x_discrete(labels = function(x) str_wrap(x, width = 20))
scale_y_discrete(labels = function(x) str_wrap(x, width = 20))
```

Sometimes, you might want to wrap the text of labels on an axis because the string is excessively long, which can cause "squishing" of the plot you want to see. This is common when trying to plot ontologies and phenotypes. 
Example data is stored on ACCRE at: /data/hodges_lab/Tim/github_tutorials/long_string_example_files


Here's an example of code for a plot that might have too long of labels on the y-axis. You could imagine these being ontology strings for a dotplot of top GO hits. 
```R
# Load libraries
library(ggplot2)
library(tidyverse)
library(data.table)
library(stringr) # This is the one to help wrap text

# Load file
setwd("/data/hodges_lab/Tim/github_tutorials/long_string_example_files/")
df <- read_tsv("long_string_example.txt", col_names = TRUE, show_col_types = FALSE)
df
```
| fake_ID | some_value |
|-----:|---------------|
|this is a long long very long string of words|              5|
|it might be a gene ontology string that is ridiculously long|              4|
|a very long string of some sort of collection of words|              3|




And here's an example of the code and resultant plot by using:
**scale_y_discrete(labels = function(x) str_wrap(x, width = 20))**

