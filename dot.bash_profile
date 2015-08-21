#!/bin/bash

[ -e ~/.bashrc ] && source ~/.bashrc

for profile in ~/.bash.d/*.sh
do
  [ -x "$profile" ] && source "$profile"
done 



[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
