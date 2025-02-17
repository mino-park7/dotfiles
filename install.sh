set -x
set -e

# Install packages
bash packages/install_packages.sh

# Check zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Please install zsh first."
    exit 1
fi

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
cp zsh/p10k.zsh ~/.p10k.zsh
cp tmux/tmux.conf ~/.tmux.conf

chsh -s `which zsh`