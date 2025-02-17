#!/bin/bash
set -e

# Check if oh-my-zsh is already installed
if [ -d ~/.oh-my-zsh ]; then
    echo "oh-my-zsh is already installed. Skipping installation."
    exit 0
else
    echo "oh-my-zsh is not installed. Installing..."
    0>/dev/null sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install oh-my-zsh.
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
# Configure plugins.
if [ ! -d "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
fi
if [ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search ]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search
fi
if [ ! -d "${ZSH_CUSTOM}"/plugins/you-should-use ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM}"/plugins/you-should-use
fi
sed -i 's/^plugins=.*/plugins=(git\n extract\n thefuck\n autojump\n jsontools\n colored-man-pages\n zsh-autosuggestions\n zsh-syntax-highlighting\n zsh-history-substring-search\n you-should-use\n nvm\n debian)/g' ${HOME}/.zshrc
# Enable nvm plugin feature to automatically read `.nvmrc` to toggle node version.
sed -i "1s/^/zstyle ':omz:plugins:nvm' autoload yes\n/" ${HOME}/.zshrc
# Install powerlevel10k and configure it.
if [ ! -d "${ZSH_CUSTOM}"/themes/powerlevel10k ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
fi
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ${HOME}/.zshrc
# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e '/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST' ${HOME}/.zshrc
# Configure the default ZSH configuration for new users.
echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ${HOME}/.zshrc

echo "oh-my-zsh installation and configuration completed."
