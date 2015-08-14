#!/bin/bash

alias             ls="ls -G"
alias           grep="grep --color"
alias             ll="ls -Glht"
alias      docker_rm="docker rm $(docker ps -lq)"
alias  docker_puppet="docker run -itd --name puppetmaster -v ~/Gits/puppet-master/:/etc/puppet puppet"
alias docker_varnish="docker run -it --name varnish --link puppetmaster varnish bash"
