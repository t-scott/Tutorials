# Why is this a HOW-TO?
The basis of this write-up is to explain how to use environmental variables in awk. 

## Why would that be important? 
Sometimes, you might want to write a new column in a file that uses either: a variable you've already initialized in bash through the terminal. Or, you might want to use the filename itself or part of the filename as part of the column. This can be useful if you wish to combine a lot of files, and know you will put them into one dataframe in R for plotting eventually, so you want to keep track of where they came from by adding an ID column (You can also do this in R by taking advantage of the filenames, and that's in another tutorial). Or, for example, the genomic program PLINK will accept a BED file but wants a 4th column that can really be anything--but I'll use that opportunity to generate an ID column for tracking. 

## Okay, cool. But can't I just write in *awk '{print $0, ${some_variable}}' file.txt*?
Unfortunately, you can't just use bash variables directly within awk. i.e., this won't fly:
```bash
variable_name="rep1"
awk 'BEGIN{OFS=FS="\t"}{print $0,${variable_name}' file.txt > out.txt
```

# Proper way to use bash environmental variable in awk: 
Instead, you have to declare the variable to awk as a variable with the *-v* option:
```bash
variable_name="rep1"
awk -v vname=${variable_name} 'BEGIN{OFS=FS="\t"}{print $0, vname}' file.txt > out.txt
```
- Note: It's a generally a good practice to name the variable something else within awk to avoid confusion. 
- Note: You don't need any special formatting when you call the variable in awk.


# Example of looping over files: 
I have a directory with practice files on ACCRE located at: /data/hodges_lab/Tim/github_tutorials/bash
```bash
> cd /data/hodges_lab/Tim/github_tutorials/bash
> ls
cluster1.post_some_process.bed  cluster2.post_some_process.bed  cluster3.post_some_process.bed
> head -n 3 cluster*
==> cluster1.post_some_process.bed <==
chr1	100	200
chr2	200	300
chr3	300	400

==> cluster2.post_some_process.bed <==
chr2	250	350
chr3	350	450
chr4	450	550

==> cluster3.post_some_process.bed <==
chr6	600	700
chr7	700	800
chr8	800	900
```

I would like to put "cluster1," "cluster2," and "cluster3" as the fourth column. 

First, I know if I start a bash loop with 
```bash
for FILE in cluster*
do
   ...
done
```
that the filenames will be the entire filename (e.g. cluster1.post_some_process.bed), so I need to clean them up:
```bash
> for FILE in cluster*
> do
>      FILE_cleaned=${FILE%%.*}
>      echo ${FILE_cleaned}
>      awk -v fname=${FILE_cleaned} 'BEGIN{OFS=FS="\t"}{print $0, fname}' ${FILE}
> done
cluster1
chr1	100	200	cluster1
chr2	200	300	cluster1
chr3	300	400	cluster1
chr4	400	500	cluster1
chr5	500	600	cluster1
cluster2
chr2	250	350	cluster2
chr3	350	450	cluster2
chr4	450	550	cluster2
chr5	550	650	cluster2
chr6	650	750	cluster2
cluster3
chr6	600	700	cluster3
chr7	700	800	cluster3
chr8	800	900	cluster3
chr9	900	949	cluster3
chr9	950	999	cluster3

```
- The ${FILE%%.*} is stripping away any text from the string following and including the first period.
  - You can also have bash strip away text preceding some character using the ## characters. For example, I could have taken everything before the last period:
```bash
> for FILE in cluster*
> do
>      FILE_string_end=${FILE##*.}
>      echo ${FILE_string_end}
> done
bed
bed
bed

# https://stackoverflow.com/questions/4168371/how-can-i-remove-all-text-after-a-character-in-bash
$ a='hello:world'

$ b=${a%:*}
$ echo "$b"
hello

$ a='hello:world:of:tomorrow'

$ echo "${a%:*}"
hello:world:of

$ echo "${a%%:*}"
hello

$ echo "${a#*:}"
world:of:tomorrow

$ echo "${a##*:}"
tomorrow
```
    




#
