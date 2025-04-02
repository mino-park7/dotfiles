set -e

# Install packages
bash packages/install_packages.sh

# Check zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Please install zsh first."
    exit 1
fi

# backup dotfiles with timestamp
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d%H%M%S)
fi
if [ -f ~/.p10k.zsh ]; then
    mv ~/.p10k.zsh ~/.p10k.zsh.bak.$(date +%Y%m%d%H%M%S)
fi
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak.$(date +%Y%m%d%H%M%S)
fi
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.bak.$(date +%Y%m%d%H%M%S)
fi

# Install oh-my-zsh
bash zsh/install-omz.sh

# Link dotfiles

ln -s vim/vimrc ~/.vimrc
ln -s zsh/p10k.zsh ~/.p10k.zsh
ln -s tmux/tmux.conf ~/.tmux.conf

# Install plugins
bash plugins/install_plugins.sh
ln -s zsh/zshrc ~/.zshrc

# Guide to change shell to zsh
echo "Please change shell to zsh by running 'chsh -s $(which zsh)' and then restart your terminal."
