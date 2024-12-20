# ~ Default jupyter notebook code ~
- The .yml for this should be in /Tutorials/ymls/

# !!!!!      Easy env option     !!!!
- Instead of proceeding through these steps, you can make the same environment from the .yml file here:
  - https://github.com/t-scott/Tutorials/blob/main/yml_files/jupyter_py3.10.9_r4.4.1.yml
    or, on ACCRE at: 
  - /data/hodges_lab/Tim/github_tutorials/yml/jupyter_py3.10.9_r4.4.1.yml
  - On ACCRE, through my testing, this can be made in ~7 minutes in a standard gateway
    - This has all the basic jupyter notebook, python, and R (including tidyverse) packages you would normally need
    - It's possible to add more to this for your purposes, but the intention was to provide a useful "default" environment for use on ACCRE with python, R, and jupyter notebooks





# !!!!!      NOTES     !!!!
- **Post-conda commercialization, only conda-forge and bioconda remain free (not the "defaults" channel)**

- You can see what channels you have currently set in your condarc (like a .bashrc but for conda) with the command:
    > conda config --show channels

- To avoid using the default channel by mistake, you can run the following code:
    > conda config --remove channels defaults
  
-  You can also manually look at your config file and even edit it like a bash config file.
    -  It should be located by default in your home folder: ~/.condarc



# Steps for a default environment
```bash
# Make env
conda create -n jnb3109 python=3.10.9
# Activate env
source activate jnb3109
# Upgrade pip
python -m pip install --upgrade pip


# Install packages
conda install ipykernel
conda install numpy
conda install scipy
conda install numpy
conda install matplotlib
conda install pandas
conda install scikit-learn
conda install anaconda::python-hdfs
conda install bash_kernel
# NB extensions (useful for Table of Contents (2) is currently unavailable for notebook v.7)
# Solution currently (Aug 30, 2024): Downgrade through uninstall and redownload
conda uninstall notebook # will also uninstall lots of dependencies
conda install notebook==6.5.5
# This won't work if you download everything above as is 
conda install -c conda-forge jupyter_contrib_nbextensions   
```


# Install/Activate kernels
## Activate kernel for notebook - so it shows up in the list as display-name
So, now you have an environment. Here, we need to link the python kernel to your environment so if you go into a Jupyter Notebook on ACCRE, it will allow you to see a python kernel to use

```bash
    > python -m ipykernel install --user --name jupyter_py3109 --display-name "Python (3.10.9)"
```


## Install R kernel 
```bash
    > conda install r-irkernel
    > cd /data/hodges_lab/Tim/.conda/envs/jnb3109/lib/R/bin
    > # Activate kernel
    > R -e "IRkernel::installspec()"
    > # alternatively, you can open an R session in terminal: ./R --> IRkernel::installspec() --> q()
```

# Install R packages
    > conda install r-essentials
    > conda install r-tidyverse
### Tidyverse-associated packages for reference:
```R
#  pandoc             conda-forge/linux-64::pandoc-3.3-ha770c72_0 
#  r-askpass          conda-forge/linux-64::r-askpass-1.2.0-r44hb1dbf0f_1 
#  r-assertthat       conda-forge/noarch::r-assertthat-0.2.1-r44hc72bb7e_5 
# r-backports        conda-forge/linux-64::r-backports-1.5.0-r44hb1dbf0f_1 
#  r-bit              conda-forge/linux-64::r-bit-4.0.5-r44hb1dbf0f_2 
#  r-bit64            conda-forge/linux-64::r-bit64-4.0.5-r44hb1dbf0f_3 
#  r-blob             conda-forge/noarch::r-blob-1.2.4-r44hc72bb7e_2 
#  r-broom            conda-forge/noarch::r-broom-1.0.6-r44hc72bb7e_1 
#  r-bslib            conda-forge/noarch::r-bslib-0.8.0-r44hc72bb7e_0 
#  r-cachem           conda-forge/linux-64::r-cachem-1.1.0-r44hb1dbf0f_1 
#  r-callr            conda-forge/noarch::r-callr-3.7.6-r44hc72bb7e_1 
#  r-cellranger       conda-forge/noarch::r-cellranger-1.1.0-r44hc72bb7e_1007 
#  r-clipr            conda-forge/noarch::r-clipr-0.8.0-r44hc72bb7e_3 
#  r-colorspace       conda-forge/linux-64::r-colorspace-2.1_1-r44hdb488b9_0 
#  r-conflicted       conda-forge/noarch::r-conflicted-1.2.0-r44h785f33e_2 
#  r-cpp11            conda-forge/noarch::r-cpp11-0.5.0-r44hc72bb7e_0 
#  r-curl             conda-forge/linux-64::r-curl-5.2.1-r44h6b349a7_1 
#  r-data.table       conda-forge/linux-64::r-data.table-1.15.4-r44h5f06984_1 
#  r-dbi              conda-forge/noarch::r-dbi-1.2.3-r44hc72bb7e_1 
#  r-dbplyr           conda-forge/noarch::r-dbplyr-2.5.0-r44hc72bb7e_1 
#  r-dplyr            conda-forge/linux-64::r-dplyr-1.1.4-r44h0d4f4ea_1 
#  r-dtplyr           conda-forge/noarch::r-dtplyr-1.3.1-r44hc72bb7e_2 
#  r-farver           conda-forge/linux-64::r-farver-2.1.2-r44ha18555a_1 
#  r-fontawesome      conda-forge/noarch::r-fontawesome-0.5.2-r44hc72bb7e_1 
#  r-forcats          conda-forge/noarch::r-forcats-1.0.0-r44hc72bb7e_2 
#  r-fs               conda-forge/linux-64::r-fs-1.6.4-r44ha18555a_1 
#  r-gargle           conda-forge/noarch::r-gargle-1.5.2-r44h785f33e_1 
#  r-generics         conda-forge/noarch::r-generics-0.1.3-r44hc72bb7e_3 
#  r-ggplot2          conda-forge/noarch::r-ggplot2-3.5.1-r44hc72bb7e_1 
#  r-googledrive      conda-forge/noarch::r-googledrive-2.1.1-r44hc72bb7e_2 
#  r-googlesheets4    conda-forge/noarch::r-googlesheets4-1.1.1-r44h785f33e_2 
#  r-gtable           conda-forge/noarch::r-gtable-0.3.5-r44hc72bb7e_1 
#  r-haven            conda-forge/linux-64::r-haven-2.5.4-r44h0d4f4ea_1 
#  r-highr            conda-forge/noarch::r-highr-0.11-r44hc72bb7e_1 
#  r-hms              conda-forge/noarch::r-hms-1.1.3-r44hc72bb7e_2 
#  r-httr             conda-forge/noarch::r-httr-1.4.7-r44hc72bb7e_1 
#  r-ids              conda-forge/noarch::r-ids-1.0.1-r44hc72bb7e_4 
#  r-isoband          conda-forge/linux-64::r-isoband-0.2.7-r44ha18555a_3 
#  r-jquerylib        conda-forge/noarch::r-jquerylib-0.1.4-r44hc72bb7e_3 
#  r-knitr            conda-forge/noarch::r-knitr-1.48-r44hc72bb7e_0 
#  r-labeling         conda-forge/noarch::r-labeling-0.4.3-r44hc72bb7e_1 
#  r-lattice          conda-forge/linux-64::r-lattice-0.22_6-r44hb1dbf0f_1 
#  r-lubridate        conda-forge/linux-64::r-lubridate-1.9.3-r44hdb488b9_1 
#  r-magrittr         conda-forge/linux-64::r-magrittr-2.0.3-r44hb1dbf0f_3 
#  r-mass             conda-forge/linux-64::r-mass-7.3_60.0.1-r44hb1dbf0f_1 
#  r-matrix           conda-forge/linux-64::r-matrix-1.6_5-r44he966344_1 
#  r-memoise          conda-forge/noarch::r-memoise-2.0.1-r44hc72bb7e_3 
#  r-mgcv             conda-forge/linux-64::r-mgcv-1.9_1-r44h0d28552_1 
#  r-mime             conda-forge/linux-64::r-mime-0.12-r44hb1dbf0f_3 
#  r-modelr           conda-forge/noarch::r-modelr-0.1.11-r44hc72bb7e_2 
#  r-munsell          conda-forge/noarch::r-munsell-0.5.1-r44hc72bb7e_1 
#  r-nlme             conda-forge/linux-64::r-nlme-3.1_165-r44hbcb9c34_1 
#  r-openssl          conda-forge/linux-64::r-openssl-2.2.1-r44h5bbf899_0 
#  r-pkgconfig        conda-forge/noarch::r-pkgconfig-2.0.3-r44hc72bb7e_4 
#  r-prettyunits      conda-forge/noarch::r-prettyunits-1.2.0-r44hc72bb7e_1 
#  r-processx         conda-forge/linux-64::r-processx-3.8.4-r44hb1dbf0f_1 
#  r-progress         conda-forge/noarch::r-progress-1.2.3-r44hc72bb7e_1 
#  r-ps               conda-forge/linux-64::r-ps-1.7.7-r44hdb488b9_0 
#  r-purrr            conda-forge/linux-64::r-purrr-1.0.2-r44hdb488b9_1 
#  r-r6               conda-forge/noarch::r-r6-2.5.1-r44hc72bb7e_3 
#  r-ragg             conda-forge/linux-64::r-ragg-1.3.2-r44h6bbb899_1 
#  r-rappdirs         conda-forge/linux-64::r-rappdirs-0.3.3-r44hb1dbf0f_3 
#  r-rcolorbrewer     conda-forge/noarch::r-rcolorbrewer-1.1_3-r44h785f33e_3 
#  r-readr            conda-forge/linux-64::r-readr-2.1.5-r44h0d4f4ea_1 
#  r-readxl           conda-forge/linux-64::r-readxl-1.4.3-r44he58e087_1 
#  r-rematch          conda-forge/noarch::r-rematch-2.0.0-r44hc72bb7e_1 
#  r-rematch2         conda-forge/noarch::r-rematch2-2.1.2-r44hc72bb7e_4 
#  r-reprex           conda-forge/noarch::r-reprex-2.1.1-r44hc72bb7e_1 
#  r-rmarkdown        conda-forge/noarch::r-rmarkdown-2.28-r44hc72bb7e_0 
#  r-rstudioapi       conda-forge/noarch::r-rstudioapi-0.16.0-r44hc72bb7e_1 
#  r-rvest            conda-forge/noarch::r-rvest-1.0.4-r44hc72bb7e_1 
#  r-sass             conda-forge/linux-64::r-sass-0.4.9-r44ha18555a_1 
#  r-scales           conda-forge/noarch::r-scales-1.3.0-r44hc72bb7e_1 
#  r-selectr          conda-forge/noarch::r-selectr-0.4_2-r44hc72bb7e_4 
#  r-stringi          conda-forge/linux-64::r-stringi-1.8.4-r44h33cde33_3 
#  r-stringr          conda-forge/noarch::r-stringr-1.5.1-r44h785f33e_1 
#  r-sys              conda-forge/linux-64::r-sys-3.4.2-r44hb1dbf0f_2 
#  r-systemfonts      conda-forge/linux-64::r-systemfonts-1.1.0-r44h38d38ca_1 
#  r-textshaping      conda-forge/linux-64::r-textshaping-0.4.0-r44ha47bcaa_2 
#  r-tibble           conda-forge/linux-64::r-tibble-3.2.1-r44hdb488b9_3 
#  r-tidyr            conda-forge/linux-64::r-tidyr-1.3.1-r44h0d4f4ea_1 
#  r-tidyselect       conda-forge/noarch::r-tidyselect-1.2.1-r44hc72bb7e_1 
#  r-tidyverse        conda-forge/noarch::r-tidyverse-2.0.0-r44h785f33e_2 
#  r-timechange       conda-forge/linux-64::r-timechange-0.3.0-r44ha18555a_1 
#  r-tinytex          conda-forge/noarch::r-tinytex-0.52-r44hc72bb7e_0 
#  r-tzdb             conda-forge/linux-64::r-tzdb-0.4.0-r44ha18555a_2 
#  r-viridislite      conda-forge/noarch::r-viridislite-0.4.2-r44hc72bb7e_2 
#  r-vroom            conda-forge/linux-64::r-vroom-1.6.5-r44h0d4f4ea_1 
#  r-withr            conda-forge/noarch::r-withr-3.0.1-r44hc72bb7e_0 
#  r-xfun             conda-forge/linux-64::r-xfun-0.47-r44h0d4f4ea_0 
#  r-xml2             conda-forge/linux-64::r-xml2-1.3.6-r44h8194278_2 
#  r-yaml             conda-forge/linux-64::r-yaml-2.3.10-r44hdb488b9_0 
```
