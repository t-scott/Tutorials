This page is focused on GREAT, the gene assignment/ontology tool: https://great.stanford.edu/great/public/html/

# The good
- This program is super easy to use!
- It's very accessible and well documented, so it's easy to rationalize the use of
- It has options for nearest neighbor, two nearest neighbor, and it's own quasi-but-smarter two nearest neighbor gene assignment
- It also provides numerous outputs that allow you download the assigned genes in a nice list
- It can also provide text files for the output tables in a couple clicks, which is super convenient
- Basically, we can find nearest neighbor genes and get them back in the matter of a minute and a couple clicks

# The bad 
- While this program is WELL-cited...
  - If you attempt to use RGreat, the R package someone designed to essentially wrap the server submissions, your results may differ from those provided directly by the standard website, but this R package, as far as I understand, was not written by the same people
- The original lab that produced this software has posted on the main GREAT page that they no longer support the help forum for their software 

# The ugly
- If you try to download an output table, if you download "shown" results, you will get back what you see online -- neat!
- If you try to download the full output table, the results are likely in a different order
  - I did some digging and am not able to explain this discordance through their documentation
  - Nor do significance values match up for changes expected by simple addition of all results, in terms of a bonferonni change, as order of results can also change
  - We have not been able to explain this difference, so be wary about using all results
  - Forums also have not discussed this, so this seems like a quiet issue that goes undiscussed, though the program has thousands of citations 
