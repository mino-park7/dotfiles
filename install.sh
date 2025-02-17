set -x
set -e

# Install packages
bash packages/install_packages.sh

# Install oh-my-zsh
bash zsh/install-omz.sh

# backup dotfiles
if [ -f ~/.zshrc ]; then
    mv ~/.zshrc ~/.zshrc.bak
fi
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.bak
fi
if [ -f ~/.tmux.conf ]; then
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi

# Copy dotfiles

cp vim/vimrc ~/.vimrc
cp zsh/zshrc ~/.zshrc
cp tmux/tmux.conf ~/.tmux.conf

