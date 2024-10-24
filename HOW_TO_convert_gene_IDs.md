# Introduction



# bitr
This strategy is our primary strategy for converting gene IDs. It relies upon either the *bitr* package or Guangchuang Yu's package *clusterProfiler* which basically just wraps the bitr package. You also need the *org.Hs.eg.db* package for refernence, which combines several reference databases to map between gene ID conventions. 

## bitr
```R
library(bitr)
bitr(sample_list, "SYMBOL","ENTREZID","org.Hs.eg.db")
```

## clusterProfiler
Example: 
```R
library(clusterProfiler)
library(DOSE)

df.v <- as.vector(unlist(some_dataframe$ENSG))
df.dict <- bitr(cl.v, fromType = "ENSEMBL",
                       toType = c("SYMBOL", "ENTREZID", "ENSEMBLPROT"),
                       OrgDb = "org.Hs.eg.db")

# You can then use ENTREZIDs to perform enrichGO in R, though we tend to prefer GREAT
ego_downstream_df <- enrichGO(gene          = cl.dict$ENTREZID,
                OrgDb         = org.Hs.eg.db,
                ont           = "BP",
                pAdjustMethod = "BH",
                pvalueCutoff  = 0.5,
                qvalueCutoff  = 0.5,
                readable      = TRUE)
```

## HOMER2
This is a bit of an uncoventional approach that *may* or very well *may not* work for your purposes.
You can "hijack" the annotatePeaks function of HOMER to assign genome annotation to a BED file.
This approach is attractive for the amount of information you get back. In addition to the genome annotation ("intergenic," genic, etc.), you also get a lot of information back regarding the nearest gene: 
  - Nearest TSS: Native ID of annotation file
  - Nearest TSS: Entrez Gene ID
  - Nearest TSS: Unigene ID
  - Nearest TSS: RefSeq ID
  - Nearest TSS: Ensembl ID
  - Nearest TSS: Gene Symbol
  - Nearest TSS: Gene Aliases
  - Nearest TSS: Gene description
So, this provides another method for getting back lots of gene information, human-readable descriptions, and interstingly, a lot of gene IDs across major gene annotation consortiums. 



