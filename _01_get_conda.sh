#### CREDIT: https://gist.github.com/mherkazandjian/cce01cf3e15c0b41c1c4321245a99096
### curl -s https://raw.githubusercontent.com/TinasheMTapera/setup/TinasheMTapera/issue2/_01_get_conda.sh | bash -s -- ~/software
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

# the installation root directory of miniconda (e.g /opt/conda)
INSTALL_PREFIX=$1

# remove this first argument by "shifting" to the next (kinda like "pop")
shift

# loop over the list of args with $#; if the current arg is in the list, handle
while [ $# -gt 0 ]; do
    case "$1" in
        -i|--installer)

            # if the current flag is present, make sure the next string is not empty
            [ -n "$2" ] && INSTALLER=$2 || usage

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

shift $((OPTIND - 1))

# ---------------- process the cmd line args ----------------
## if the installer is latest use the latest online installed
if [ "${INSTALLER}" == "latest" ]; then
    INSTALLER="Miniconda3-latest-Linux-x86_64.sh"
fi


# -----------------------------------------------------------

# set the defaults and the values based on what has been passed from the
# command line, if not already set
INSTALLER=${INSTALLER:-Miniconda3-py39_23.5.2-0-Linux-x86_64.sh}
UPGRADE=${UPGRADE:-0}
MAMBA=${MAMBA:-0}

# ---------------------------------

# the absolute path of the miniconda installer (e.g Miniconda3-latest-Linux-x86_64.sh
# after it is downloaded. This is where curl will try to put it
INSTALLER_PATH=/tmp/${INSTALLER}

function _install_miniconda() {
    if command -v conda; then
        echo "Conda is already installed."
        echo $(conda --version)
    else
        echo "Installing miniconda to ${INSTALL_PREFIX}"
        echo "Installer: ${INSTALLER}"
        echo "Upgrade: ${UPGRADE}"
        curl -s -L https://repo.anaconda.com/miniconda/${INSTALLER} -o ${INSTALLER_PATH}
        chmod +x ${INSTALLER_PATH}
        ${INSTALLER_PATH} -b -p ${INSTALL_PREFIX}
        rm ${INSTALLER_PATH}
        ${INSTALL_PREFIX}/bin/conda upgrade -y --all
        ${INSTALL_PREFIX}/bin/conda clean -ya
        ${INSTALL_PREFIX}/bin/conda install -y conda-build conda-verify
        if [ $UPGRADE -eq 1 ]; then
                ${INSTALL_PREFIX}/bin/conda upgrade -y --all
                ${INSTALL_PREFIX}/bin/conda clean -ya
                ${INSTALL_PREFIX}/bin/conda install -y conda-build conda-verify
        fi
    fi

    if [ $MAMBA -eq 1 ]; then
        if command -v mamba; then
            echo "Mamba is already installed."
        else
            echo "Mamba: ${MAMBA}"
            ${INSTALL_PREFIX}/bin/conda install -y mamba -n base -c conda-forge
        fi
    fi
}

_install_miniconda
echo $PATH
ENV PATH=$INSTALL_PREFIX/bin/conda:$PATH
echo $PATH