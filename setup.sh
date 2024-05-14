#!/bin/bash

echo "Setting up Tinashe's data science dev environment!"

# eg source startup.sh -p 3.10 -c -n foo

# ARGUMENTS
PY_VERSION="3.8"
R_VERSION="4.2"
USE_CONDA=false
ENV_NAME=""

OPTSTRING="n:p:r:c"

while getopts ${OPTSTRING} opt; do
  case ${opt} in
    n)
      ENV_NAME=${OPTARG}
      echo "Environment name:" ${OPTARG}
      ;;

    p)
      PY_VERSION=${OPTARG}
      echo "Using Python version:" ${OPTARG}
      ;;
    r)
      R_VERSION=${OPTARG}
      echo "Using R version:" ${OPTARG}
      ;;
    c)
      USE_CONDA=true
      echo "Installing conda from scratch"
      ;;
    :)
      echo "Option -${OPTARG} requires an argument."
      exit 1
      ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
    
  esac
done

# test args
if [ -z "$ENV_NAME" ]; then
        echo 'Error: Environment name not set! Please set environment name with -n [NAME]'
        exit 1
fi

# 1. install conda

# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
# && chmod +x miniconda.sh && bash miniconda.sh -b -p miniconda

# base_dir=$(echo $PWD)

# export PATH=$base_dir/miniconda/bin:$PATH
# source ~/.bashrc
# echo -e "$base_dir/miniconda/etc/profile.d/conda.sh" >> ~/.profile
# conda init bash

# # 2. install mamba

conda install mamba -n base -c conda-forge -y
conda update conda -y
conda update --all -y

# # 3. create a new conda environment with python
# ## params: python version, optional packages
# ## default packages: jupyter, pandas, scikit learn
# ## resources: 

mamba create -n $ENV_NAME -y python=$PY_VERSION
source activate base
mamba activate $ENV_NAME

conda install -y jupyter pandas scikit-learn

# 4. install R in that environment
## params: R version, optional packages
## default packages: r-essentials
## resources: https://www.biostars.org/p/450316/

mamba install -y -c conda-forge r-essentials r-tidyverse
pip install radian

Rscript -e "install.packages(c('languageserver', 'httpgd'), repos='http://cran.us.r-project.org')"

# 5. install quarto
