# How to wrap text on ggplot axes
TL;DR: Use the library *stringr*
```R
scale_x_discrete(labels = function(x) str_wrap(x, width = 20))
scale_y_discrete(labels = function(x) str_wrap(x, width = 20))
```

Sometimes, you might want to wrap the text of labels on an axis because the string is excessively long, which can cause "squishing" of the plot you want to see. This is common when trying to plot ontologies and phenotypes. 
Example data is stored on ACCRE at: /data/hodges_lab/Tim/github_tutorials/long_string_example_files


## Here's an example of code for a plot that might have too long of labels on the y-axis. You could imagine these being ontology strings for a dotplot of top GO hits. 
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

```R
# Plot without wrapping text
options(repr.plot.width = 8, repr.plot.height = 5) 

df %>%
    ggplot(aes(x=some_value, y=fake_ID)) +
        geom_point() +
        theme_minimal() +
        theme(
            plot.title = element_text(hjust = 0.5, size = 14), # centers the title
            axis.title.x = element_text(color = "grey20", size = 14),
            axis.title.y = element_text(color = "grey20", size = 14),
            axis.text.x = element_text(color = "grey20", size = 14, angle = 90, hjust = 1), # adjusts x-axis to vertical
            axis.text.y = element_text(color = "grey20", size = 14),
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank()
        )
```
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_plots_long_text_label.R_TIPS.png)



## And here's an example of the code and resultant plot by using:
**scale_y_discrete(labels = function(x) str_wrap(x, width = 20))**
```R
# Plot with text wrapping
options(repr.plot.width = 6, repr.plot.height = 5) # adjusting to be less wide since text is now wrapped

df %>%
    ggplot(aes(x=some_value, y=fake_ID)) +
        geom_point() +
        theme_minimal() +
        theme(
            plot.title = element_text(hjust = 0.5, size = 14), # centers the title
            axis.title.x = element_text(color = "grey20", size = 14),
            axis.title.y = element_text(color = "grey20", size = 14),
            axis.text.x = element_text(color = "grey20", size = 14, angle = 90, hjust = 1), # adjusts x-axis to vertical
            axis.text.y = element_text(color = "grey20", size = 14),
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank()
        ) +
        scale_y_discrete(labels = function(x) str_wrap(x, width = 20))
```
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_plots_long_text_label_fixed.R_TIPS.png)


