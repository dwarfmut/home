#!/bin/bash

[ -e ~/.bashrc ] && source ~/.bashrc

for profile in ~/.bash.d/*.sh
do
  [ -x "$profile" ] && source "$profile"
done 


