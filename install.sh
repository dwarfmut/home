#!/bin/bash
# 
# dwarfmut/home (git repo) install
#
# Daniel Faria - dwarfmut@gmail.com
#
# git clone https://github.com/dwarfmut/home.git
#

# Configure home files
ln -snf ${PWD}/dot.bashrc ~/.bashrc
ln -snf ${PWD}/dot.bash_profile ~/.bash_profile
ln -snf ${PWD}/dot.bash.d ~/.bash.d

# Install brew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


