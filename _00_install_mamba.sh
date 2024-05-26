#!/bin/bash

function usage() {
  local script_name=$(basename "$0")
  echo
  echo "Usage: $script_name  /path/to/prefix/ [-n|--name <new_environment_name>] [-p|--platform <platform>]"
  echo
  echo "  /path/to/prefix/   the installation root directory of miniconda (e.g /opt/conda)"
  echo "  -n|--name          proposed name of new environment for your project"
  echo "  -p|--platform      choose a platform:"
  echo "                        - mac: MacOS"
  echo "                        - linux: E.g. for a Docker container"
  echo "  -h|--help          show this help text"
  echo

}

# ensure path is given
if [[ $# -gt 1 ]]; then
    if [[ "${1?}" == -* ]] || [[ ! -d $1 ]]; then
        echo "Error: Invalid first argument <path/to/prefix>"
        usage
        exit 0
    fi
else
    usage
    exit 0
fi

# the installation root directory of miniconda (e.g /opt/conda)
INSTALLATION_PATH=$1
CONDA_PATH=$HOME

# remove this first argument by "shifting" to the next (kinda like "pop")
shift

# loop over the list of args with $#; if the current arg is in the list, handle
while [ $# -gt 0 ]; do
    case "$1" in
        -n|--name)
            # extra shift to handle arg string
            shift

            # if the current flag is present, use name
            if [[ -n "$1" ]]; then

                if [[ "${1?}" == -* ]]; then
                    echo "Error: expected flag value for [-n|--name]"
                    usage
                    exit 0
                else
                    VENV_NAME=$1
                fi
            else

                VENV_NAME=""
            fi
            
            ;;
            
        -p|--platform)

            # if the current flag is present, then test the next flag
            shift

            case "$1" in
                "mac")
                    PLATFORM="MACOS"
                    ;;
                "linux")
                    PLATFORM="LINUX"
                    ;;
                *)  
                    PLATFORM=""
                    ;;
            esac
            
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

shift $((OPTIND - 1))

# Check if arguments came through
if [ -z "$VENV_NAME" ]; then
    echo "Error: Please provide a name for the environment."
    usage
    exit 1
fi

if [ -z "$PLATFORM" ]; then
    echo "Error: Please provide the platform of your machine."
    usage
    exit 1
fi

echo
echo "Downloading Conda for $PLATFORM to $(realpath $INSTALLATION_PATH) and initializing environment: $VENV_NAME..."
echo

if [ "$PLATFORM" = "LINUX" ]; then
    
    # get the linux installer
    pushd $INSTALLATION_PATH
    wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname -s)-$(uname -m).sh"
    
    ### Run installation
    bash Miniforge3.sh -b -p "${CONDA_PATH}/conda"
    
    ### return
    rm -f Miniforge3.sh
    popd

elif [ "$PLATFORM" = "MACOS" ]; then
    
    # get the mac installer
    pushd $INSTALLATION_PATH
    curl -fsSLo Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh"
    
    ### Run installation
    bash Miniforge3.sh -b -p "${CONDA_PATH}/conda"

    ### return
    rm -f Miniforge3.sh
    popd
else
    echo "Unknown platform: $PLATFORM"
    exit 1
fi

echo here!
echo $CONDA_PATH

function _configure_conda(){
    
    ### add conda to bashrc
    local condapath="$1"
    cd "${condapath}/conda/bin"
    ./conda init bash

    ### activate now for non-interactive installs
    source "${condapath}/conda/etc/profile.d/conda.sh"
    # For mamba support also run the following command
    source "${condapath}/conda/etc/profile.d/mamba.sh"

    conda activate
    mamba activate

    mamba create -n foofy -y python=3.9

    mamba activate foofy

    mamba install -y jupyter pandas scikit-learn
    mamba install -y -c conda-forge r-essentials r-tidyverse r-languageserver r-httpgd radian
}

echo Configuring conda for your user...

_configure_conda() "${CONDA_PATH}"

echo
echo "Installation complete. Start a new shell and conda should be ready to run."
echo
