# Load all files from .zshrc.d directory.
if [ -d $HOME/.zshrc.d ]; then
  for file in $HOME/.zshrc.d/*.zsh; do
    source $file
  done
fi

# Load .zshrc.local. This file is not shared.
if [ -e ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi 
