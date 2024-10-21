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
I love the function *mutate()* alongside *case_when()*. I think the combination is powerful, and I tend to use them in concert with ggplot.
