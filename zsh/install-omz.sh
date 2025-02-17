#!/bin/bash
set -e


# Install oh-my-zsh.
0>/dev/null sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_CUSTOM
# Configure plugins.
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search "${ZSH_CUSTOM}"/plugins/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use
sed -i 's/^plugins=.*/plugins=(git\n extract\n thefuck\n autojump\n jsontools\n colored-man-pages\n zsh-autosuggestions\n zsh-syntax-highlighting\n zsh-history-substring-search\n you-should-use\n nvm\n debian)/g' ${HOME}/.zshrc
# Enable nvm plugin feature to automatically read `.nvmrc` to toggle node version.
sed -i "1s/^/zstyle ':omz:plugins:nvm' autoload yes\n/" ${HOME}/.zshrc
# Install powerlevel10k and configure it.
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ${HOME}/.zshrc
# Move ".zcompdump-*" file to "$ZSH/cache" directory.
sed -i -e '/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST' ${HOME}/.zshrc
# Configure the default ZSH configuration for new users.
echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> ${HOME}/.zshrc
cp ${HOME}/.zshrc /etc/skel/
cp ${ZSH_CUSTOM}/themes/powerlevel10k/config/p10k-classic.zsh ${HOME}/.p10k.zsh
cp ${HOME}/.p10k.zsh /etc/skel/
cp -r ${HOME}/.oh-my-zsh /etc/skel/
