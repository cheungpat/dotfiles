#!/bin/sh

# Activate dotfiles by installing thoughtbot rcm and symlinking the dotfiles
# to home directory.
#
# This script is also used by GitHub Codespaces to bootstrap dotfiles.

set -e

if [ ! `which rcup` ]; then
    if [ `which apt-get` ]; then
        if [ `id -u` -ne 0 ]; then
            if [ `which sudo` ]; then
                SUDO=sudo
            else
                echo "Unable to run apt-get because user is not root and no sudo installed."
                exit 1
            fi
        fi
        $SUDO apt-get update
        $SUDO apt-get install -y libgnutls-openssl27  # Let's Encrypt cert not recognized. May not need this in the future.
        curl https://apt.thoughtbot.com/thoughtbot.gpg.key | $SUDO tee /etc/apt/trusted.gpg.d/thoughtbot.gpg > /dev/null
        echo "deb https://apt.thoughtbot.com/debian/ stable main" | $SUDO tee /etc/apt/sources.list.d/thoughtbot.list > /dev/null
        $SUDO apt-get update
        $SUDO apt-get install -y rcm
    elif [ `which brew` ]; then
        brew install rcm
    else
        echo "No recognized package manager to install rcm."
        exit 1
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
