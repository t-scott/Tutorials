# How to clean up bash variables
Say you have a list of files, and you'd like to use part of their file names in a process--perhaps to name the output files. 

Here's a great tutorial written by Dennis Williamson on Stack Overflow:
```bash 
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

- Basically, "%" means remove after the last instance. 
- "%%" means to remove after the first instance. I use this one the most, as most of my files have IDs on the front end (e.g. rsID1234.output.txt or ENSG123.output.txt)
- "#" means remove everything before the first instance.
- "##" mean to remove everything before the last instance. 
- If your ID you need is in the middle of a filename, you can combine these two processes to isolate what you need--most of the time. For example:
Say you have the following file name pattern and want the "sampleID_1" (and "sampleID_2", "sampleID_3", and so on) out. Note, I surrounded the part we want with two different characters to make it a little trickier to think about.
```bash
$ FILENAME_1="mapped_sampleID_1.cleaned_sorted_filtered.txt"

# Cut off the front part we don't want
$ FILENAME_cut_front=${FILENAME_1#*_} # NOTE: I use the single "#" as I dont want to cut after the later underscores
$ echo $FILENAME_cut_front
sampleID_1.cleaned_sorted_filtered.txt

# Cut off the back part we don't want
$ FILENAME_clean=${FILENAME_cut_front%%.*}
$ echo $FILENAME_clean
sampleID_1
```

This is useful for looping, especially, as you can then use this to name outputs!

```bash
$ for FILE in example_files*
$ do
$  FILENAME_cleaned=${FILE%%.*}
$  # Maybe these are BED files that have extra columns and we only want the first three out
$  awk 'BEGIN{OFS=FS="\t"}{print $1,$2,$3}' $FILE > /some/output/directory/${FILENAME_cleaned}.cleaned_three_column.bed
$ done
```

