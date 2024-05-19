#!/bin/bash

function usage() {
  local script_name=$(basename "$0")
  echo "Usage: $script_name /path/to/prefix/ [-u|--upgrade] [-i|--installer <installer_name>]"
  echo "  /path/to/prefix/   the installation root directory of miniconda (e.g /opt/conda)"
  echo "  -i|--installer     the miniconda installer name (e.g Miniconda3-latest-Linux-x86_64.sh)"
  echo "                     others can be specified from https://repo.anaconda.com/miniconda/"
  echo "  -m|--mamba         install mamba in the base environment"
  echo "  -u|--upgrade       upgrade miniconda packages"
  echo "  -h|--help          show this help text"
  exit 0
}

eval "$(conda shell.bash hook)"