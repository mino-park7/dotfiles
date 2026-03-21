#!/bin/bash
set -e

# Check if oh-my-zsh is already installed
if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh is already installed. Skipping installation."
else
    echo "oh-my-zsh is not installed. Installing..."
    sh 0>/dev/null -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
# Install powerlevel10k and configure it.
if [ ! -d "${ZSH_CUSTOM}"/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
fi
# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e '/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST' ${HOME}/.zshrc

# Install fzf
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

echo "oh-my-zsh installation and configuration completed."
