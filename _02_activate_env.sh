#!/bin/bash

function usage() {
  local script_name=$(basename "$0")
  echo "Usage: $script_name /path/to/prefix/ [-u|--upgrade]"
  echo "  /path/to/prefix/   the installation root directory of miniconda (e.g /opt/conda)"
  echo "  -n|--name          name of the new environment"
  echo "  -u|--upgrade       upgrade miniconda packages"
  echo "  -h|--help          show this help text"
  exit 0
}

# the installation root directory of miniconda (e.g /opt/conda)
INSTALL_PREFIX=$1

# remove this first argument by "shifting" to the next (kinda like "pop")
shift

# loop over the list of args with $#; if the current arg is in the list, handle
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--name)

            # if the current flag is present, make sure the next string is not empty
            [ -n "$2" ] && NAME=$2 || usage

            # extra shift to handle arg string
            shift
            ;;
        -m|--mamba)

            # if the current flag is present, set true
            [ -n "$1" ] && MAMBA=1 || usage
            ;;
        -u|--upgrade)

            # if the current flag is present, set true
            [ -n "$1" ] && UPGRADE=1 || usage
            ;;
        -h|--help)
            usage
            ;;
        *)
            usage
            ;;
    esac
    shift
done

eval "$($INSTALL_PREFIX/conda shell.bash hook)"
echo conda version: $1/conda --version
$INSTALL_PREFIX/conda upgrade -y --all
echo conda version: $1/conda --version
echo here!!!
