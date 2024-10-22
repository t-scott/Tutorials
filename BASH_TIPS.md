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
$     FILENAME_cleaned=${FILE%%.*}
$     # Maybe these are BED files that have extra columns and we only want the first three out
$     awk 'BEGIN{OFS=FS="\t"}{print $1,$2,$3}' $FILE > /some/output/directory/${FILENAME_cleaned}.cleaned_three_column.bed
$ done
```


<br>
<br>
<br>
<br>


# Consider making yourself some helpful shortcuts for bash
If you find yourself typing the same thing over and over in the terminal, considering making yourself a shortcut by putting them in your ~/.bashprofile

For example, I have a few such as:
```bash
alias mydir="cd /data/hodges_lab/Tim/"
alias bfdir="cd /scratch/scottt7/Ferrell/"
alias tim="cd /data/hodges_lab/Tim/"
```


<br>
<br>
<br>
<br>


# Consider using Oh-My-Zsh to brighten up your terminal 
This is a popular program/plug in for ZShell. Mac has moved from a simple bash shell for their default terminal to Zshell, which supports some cooler formatting and much more. I just use OhMyZsh for aesthetic reasons primarily and to view my directory path a little clearer. Essentially, you install it and it creates a file: ~/.zshrc (like a .bashrc) that holds a simple text file that controls a lot of settings. 
- Main website here: https://ohmyz.sh/
- There's a large amount of plugins: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
- Good tutorial here for installation: https://www.freecodecamp.org/news/how-to-configure-your-macos-terminal-with-zsh-like-a-pro-c0ab3f3c1156/


