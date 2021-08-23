#!/bin/sh

# Activate dotfiles by installing thoughtbot rcm and symlinking the dotfiles
# to home directory.
#
# This script is also used by GitHub Codespaces to bootstrap dotfiles.

set -e

if [[ ! `which rcup` ]]; then
    if [[ `which apt-get` ]]; then
        sudo wget -q https://apt.thoughtbot.com/thoughtbot.gpg.key -O /etc/apt/trusted.gpg.d/thoughtbot.gpg
        echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list
        sudo apt-get update
        sudo apt-get install rcm
    elif [[ `which brew` ]]; then
        brew install rcm
    else
        echo "No recognized package manager."
    fi
fi

if [[ ! -L ~/.rcrc ]]; then
    ln -s `pwd`/rcrc ~/.rcrc
fi

cd $HOME
rcup
