### LINUX
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

### MAC

#curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"

###
bash Miniforge3.sh -b -p "${HOME}/conda"

source "${HOME}/conda/etc/profile.d/conda.sh"
# For mamba support also run the following command
source "${HOME}/conda/etc/profile.d/mamba.sh"

conda activate
mamba activate

mamba create -n foofy -y python=3.9

mamba activate foofy

conda install -y jupyter pandas scikit-learn
pip install radian
mamba install -y -c conda-forge r-essentials r-tidyverse
Rscript -e "install.packages(c('languageserver', 'httpgd'), repos='http://cran.us.r-project.org')"