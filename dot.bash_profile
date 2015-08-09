#!/bin/bash

for profile in ~/.bash.d/*.sh
do
  [ -x "$profile" ] && source "$profile"
done 

[ -e ~/.bashrc ] && source ~/.bashrc

