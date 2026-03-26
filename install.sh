set -e

# Install packages
bash packages/install_packages.sh

# Check zsh is installed
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Please install zsh first."
    exit 1
fi

# backup dotfiles with timestamp (handle both regular files and symlinks)
for target in ~/.zshrc ~/.p10k.zsh ~/.vimrc ~/.tmux.conf; do
    if [ -e "$target" ] || [ -L "$target" ]; then
        mv "$target" "${target}.bak.$(date +%Y%m%d%H%M%S)"
    fi
done
if [ -e ~/.claude ] || [ -L ~/.claude ]; then
    mv ~/.claude ~/.claude.bak.$(date +%Y%m%d%H%M%S)
fi
if [ -e ~/.agents/.skill-lock.json ] || [ -L ~/.agents/.skill-lock.json ]; then
    mv ~/.agents/.skill-lock.json ~/.agents/.skill-lock.json.bak.$(date +%Y%m%d%H%M%S)
fi

# Install oh-my-zsh
bash zsh/install-omz.sh

# Link dotfiles

ln -sf ${HOME}/.dotfiles/vim/vimrc ~/.vimrc
ln -sf ${HOME}/.dotfiles/zsh/p10k.zsh ~/.p10k.zsh
ln -sf ${HOME}/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -sfn ${HOME}/.dotfiles/claude ~/.claude
mkdir -p ~/.agents
ln -sf ${HOME}/.dotfiles/agents/.skill-lock.json ~/.agents/.skill-lock.json

# Install plugins
bash plugins/install_plugins.sh
ln -sf ${HOME}/.dotfiles/zsh/zshrc ~/.zshrc

# Guide to change shell to zsh
echo "Please change shell to zsh by running 'chsh -s $(which zsh)' and then restart your terminal."
