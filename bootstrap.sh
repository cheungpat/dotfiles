#!/bin/sh

# Activate dotfiles by installing thoughtbot rcm and symlinking the dotfiles
# to home directory.
#
# This script is also used by GitHub Codespaces to bootstrap dotfiles.

set -e

if [ ! `which rcup` ]; then
    if [ `which apt-get` ]; then
        curl https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo tee /etc/apt/trusted.gpg.d/thoughtbot.gpg > /dev/null
        echo "deb https://apt.thoughtbot.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/thoughtbot.list > /dev/null
        sudo apt-get update
        sudo apt-get install rcm
    elif [ `which brew` ]; then
        brew install rcm
    else
        echo "No recognized package manager."
    fi
fi

git submodule update --init --recursive

# ~/.rcrc has to exist to be discovered by rcm.
if [ ! -L ~/.rcrc ]; then
    ln -s `pwd`/rcrc ~/.rcrc
fi

# For Codespace, symlink current directory to ~/.dotfiles.
if [ ! -e ~/.dotfiles ]; then
    ln -s `pwd` ~/.dotfiles
fi

cd $HOME
rcup -f
