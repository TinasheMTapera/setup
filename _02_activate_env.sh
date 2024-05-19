#!/bin/bash

function usage() {
  local script_name=$(basename "$0")
  echo "Usage: $script_name /path/to/prefix/ [-u|--upgrade] [-i|--installer <installer_name>]"
  echo "  /path/to/prefix/   the installation root directory of miniconda (e.g /opt/conda)"
  echo "  -n|--name          name of the new environment"
  echo "  -u|--upgrade       upgrade miniconda packages"
  echo "  -h|--help          show this help text"
  exit 0
}

echo eval "$($1/conda shell.bash hook)"