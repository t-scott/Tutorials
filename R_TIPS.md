# My ggplot *theme()* section I use in most plots as a starting point
```R
theme(
    plot.title = element_text(hjust = 0.5, size = 14), # centers the title
    axis.title.x = element_text(color = "grey20", size = 14), # readable font size in Jupyter, YMMV
    axis.title.y = element_text(color = "grey20", size = 14),
    axis.text.x = element_text(color = "grey20", size = 14, angle = 90, hjust = 1), # adjusts x-axis to vertical
    axis.text.y = element_text(color = "grey20", size = 14),
    # You're able to remove major/minor lines which may help reduce visual clutter
    panel.grid.minor.x = element_blank(), 
    panel.grid.minor.y = element_blank()
)
```

# Using *mutate()* + *case_when()* to add columns
I love the function *mutate()* alongside *case_when()*. I think the combination is powerful. There are many, many use cases for this (I hope you continue finding more!), though I tend to use them in concert with ggplot.

**case_when()** is like an if-else block, but with easier-to-write syntax. Details below.

**mutate()**: The basics for this dplyr function is that you can add a new column. It can be simple, 
```R
dataframe %>% mutate(new_column_id = "new string")
```
or you can calculate a new column from other columns with simple syntax. I do this to calculate fold differences from HOMER output. 
```R
dataframe %>% mutate(diff_colA_colB = colA - colB)
```

But what if you wanted to assign a group name based on some value (e.g. if p-value <= 0.05, assign "significant", and if  0.05 < p-value =<, assign "nearing significance", and so on)? Or what if you want to assign categorical labels to your data, where the category assignment depends on the values in some column? That's a perfect use case for *mutate()* + *case_when()*

Here's an example. Let's say you have 10 HMRs, where each HMR has a p-value for each of 5 tests/groups/ontologies/phenotypes/etc. Here's repeatable code to make a practice dataframe: 
```R
set.seed(100)
df <- tibble(pval = abs(rnorm(50, 0.5, .4)),
             test_ID = rep(paste0("TEST", seq(1,5)), 10),
             HMR_ID = rep(paste0(rep("HMR", 10), seq(1, 10)), each=5))
df
```
The dataframe looks like this: 

![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_mutate_case_when_practice_dataframe.png)


We could then make a quick ggplot call to plot all these p-values across the 5 "tests". 
```R
options(repr.plot.width = 6, repr.plot.height = 5)

df %>%
    ggplot(aes(x = test_ID, y = -log10(pval))) +
        geom_point(aes(color = test_ID)) +
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
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_mutate_case_when_premutate.png)


Neat. But, the coloring doesn't really help the plot. 

What if, each HMR had an associated gene near it and we colored the data by GENE ID instead. HMR1-3 belong to GENE_1. HMR3-6 belong to GENE_2. And HMR7-10 are assigned to GENE_3. 

We can quickly use *mutate()* + *case_when()* to create a new column to reflect this. 

Again, *case_when()* is like an if-else block, but with easier-to-write syntax. The syntax for case_when() is, at it's simplest:
```R
case_when(
    condition1 ~ what_to_put_in_the_new_column_1,
    condition2 ~ what_to_put_in_the_new_column_2,
    condition3 ~ what_to_put_in_the_new_column_3,
    [...]
}
```

So, we can add the "GENE" info to the dataframe using *mutate()* + *case_when()* and plot using the gene_IDs for coloring. 
```R
df %>%
    mutate(gene_ID = case_when(
                        HMR_ID %in% c("HMR1","HMR2","HMR3") ~ "GENE_1",
                        HMR_ID %in% c("HMR4","HMR5","HMR6") ~ "GENE_2",
                        HMR_ID %in% c("HMR7","HMR8","HMR9","HMR10") ~ "GENE_3",
    )) %>%
    ggplot(aes(x = test_ID, y = -log10(pval))) +
        geom_point(aes(color = gene_ID)) +
        theme_minimal()
```
![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_mutate_case_when_postmutate.png)

Better, though I would 100% change the palette. I hope it's clear that the use of *mutate()* + *case_when()* has many use cases and can allow for quick generation of new columns you need in a readable manner. Also, for the p-value example above, just to show this again, you could do:
```R
df %>%
    mutate(p_val_significance_label = case_when(
                                        pval <= 0.05 ~ "significant",
                                        0.05 < pval & pval < 0.2 ~ "nearing significance", 
                                        pval > 0.2 ~ "not significant"
           ))
```
And, the output would look something like: 

![alt text](https://github.com/t-scott/Tutorials/blob/main/tutorial_imgs/Screenshot_mutate_case_when_pval_example.png)












