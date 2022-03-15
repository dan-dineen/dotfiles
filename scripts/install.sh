#! /bin/bash

_0=$(dirname "$0")
_0=$(realpath "$_0")
DOTFILES=$(dirname "$_0")

###############################################################################
# Helper Methods
###############################################################################

function install_config {
  rm -rf $2
  ln -s $1 $2
  echo "installed $1->$2"
}
###############################################################################
# Install Configuration Files
###############################################################################

install_config ${DOTFILES}/nvim/init.vim "${HOME}/.config/nvim/init.vim"
install_config ${DOTFILES}/nvim/coc-settings.json "${HOME}/.config/nvim/coc-settings.json"
install_config ${DOTFILES}/i3/config "${HOME}/.config/i3/config"


