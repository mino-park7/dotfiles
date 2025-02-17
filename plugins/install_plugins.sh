#!/bin/bash

# Source plugin lists and install functions
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source each plugin configuration
source "${DIR}/zsh_plugins.sh"
source "${DIR}/vim_plugins.sh"
source "${DIR}/tmux_plugins.sh"

# Install all plugins
echo "플러그인 설치를 시작합니다..."

# Install and configure zsh plugins
install_zsh_plugins

# Install and configure vim plugins
install_vim_plugins
update_vimrc

# Install and configure tmux plugins
install_tmux_plugins
update_tmux_conf

echo "모든 플러그인 설치 및 설정이 완료되었습니다."
echo
echo "변경사항을 적용하려면 다음 명령어들을 실행하세요:"
echo "1. zsh: source ~/.zshrc"
echo "2. vim: 다시 실행"
echo "3. tmux: tmux source-file ~/.tmux.conf" 