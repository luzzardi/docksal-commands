#!/usr/bin/env bash

shopt -s extglob

bold='\x1b[1m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
light_red='\033[1;31m'
light_green='\033[1;32m'
light_blue='\033[1;34m'
light_purple='\033[1;35m'
light_cyan='\033[1;36m'
nc='\033[0m'
DOUBLE_FONT_SIZE='\033#6'


function echo_color() {
  echo -e "${!1}$2$nc"
}

function color_text() {
  local text=$2
  text="${!1}$text$nc"
}

function warning() {
  spaces=4
  size=$((${#1} + $spaces))
  print_hifen $size prefix
  echo -e "|  ${yellow}${bold}${DOUBLE_FONT_SIZE}${1}$nc  |"
  print_hifen $size suffix
}

function print_hifen() {
  hifen=""
  whitespaces=""
  for n in $(seq 1 ${1}); do
    hifen="-${hifen}"
    whitespaces=" ${whitespaces}"
  done
  if [[ "${2}" == 'suffix' ]]; then
    echo -e "|${whitespaces}|"
  fi
  echo -e "|${hifen}|"
  if [[ "${2}" == 'prefix' ]]; then
    echo -e "|${whitespaces}|"
  fi
}

function theme_pre_run() {
  if [[ -z "${1}" ]]; then
    echo_color red "Error: theme path is required"
    exit 1
  fi
  theme_folder=${1}
  clean_modules=${2-clean}
  current_node_version=$(node -v)
  current_node_version="${current_node_version%.*.*}"

  if [[ "${current_node_version}" != "v14" ]]; then
    echo_color red "Node version found $(node -v), node version expected: 14"
    exit 1;
  fi

  if [[ -d "${theme_folder}" ]] && [[ ${clean_modules} == 'clean' ]] ; then
    echo_color yellow "Removing node modules folder."
    rm -rf ${theme_folder}/node_modules
  fi

  echo_color green "Installing node modules..."
  npm --prefix ${theme_folder} install
}
