#!/bin/bash

# Function to install zsh plugins
install_zsh_plugins() {
    echo "zsh 플러그인 설치 중..."

    # oh-my-zsh custom plugins directory
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # Read and install external plugins
    while read -r line; do
        # Skip comments and empty lines
        [[ $line =~ ^[[:space:]]*# ]] && continue
        [[ -z $line ]] && continue

        # Get plugin and comment
        plugin=$(echo "$line" | cut -d'#' -f1 | xargs)
        comment=$(echo "$line" | grep -o '#.*' || echo "")

        # Install external plugins
        if [[ $plugin == *"/"* ]]; then
            plugin_name=$(echo "$plugin" | cut -d'/' -f2)
            plugin_path="${ZSH_CUSTOM}/plugins/${plugin_name}"

            if [ ! -d "$plugin_path" ]; then
                echo "Installing ${plugin_name}..."
                git clone "https://github.com/${plugin}.git" "$plugin_path"
            fi
        fi
    done <"$(dirname "$0")/plugin_list.txt"
    if [[ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM}"/themes/powerlevel10k
    fi
    echo "zsh 플러그인 설치 완료"
}
