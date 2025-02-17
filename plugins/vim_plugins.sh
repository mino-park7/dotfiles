#!/bin/bash

# vim plugins list
VIM_PLUGINS=(
    # 파일 탐색기
    "preservim/nerdtree"                # 파일 트리 보기
    "junegunn/fzf.vim"                 # 퍼지 파일 검색
    
    # 코드 편집
    "tpope/vim-surround"               # 괄호, 따옴표 등 편집
    "jiangmiao/auto-pairs"             # 자동 괄호 닫기
    
    # 문법 하이라이팅 및 자동완성
    "sheerun/vim-polyglot"             # 다양한 언어 문법 지원
    "neoclide/coc.nvim"                # 코드 자동완성
    
    # Git 관련
    "tpope/vim-fugitive"               # Git 명령어 지원
    "airblade/vim-gitgutter"           # Git 변경사항 표시
    
    # 테마
    "vim-airline/vim-airline"          # 상태바 테마
    "vim-airline/vim-airline-themes"   # 상태바 테마 추가
)

# Function to install vim plugins
install_vim_plugins() {
    echo "vim 플러그인 설치 중..."
    
    # Install vim-plug if not installed
    if [ ! -f "${HOME}/.vim/autoload/plug.vim" ]; then
        echo "Installing vim-plug..."
        curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    
    # Generate vim plugin configuration
    {
        echo "call plug#begin('~/.vim/plugged')"
        for plugin in "${VIM_PLUGINS[@]}"; do
            if [[ $plugin == "neoclide/coc.nvim" ]]; then
                echo "Plug 'neoclide/coc.nvim', {'branch': 'release'}"
            else
                echo "Plug '${plugin}'"
            fi
        done
        echo "call plug#end()"
    } > "${HOME}/.vim/plugins.vim"
    
    # Install plugins
    vim +PlugInstall +qall
    
    # Install coc.nvim dependencies
    if [ -d "${HOME}/.vim/plugged/coc.nvim" ]; then
        echo "coc.nvim 의존성 설치 중..."
        cd "${HOME}/.vim/plugged/coc.nvim" && npm ci
    fi
    
    echo "vim 플러그인 설치 완료"
}

# Function to update .vimrc
update_vimrc() {
    echo "vim 설정 파일 업데이트 중..."
    
    VIMRC="${HOME}/.vimrc"
    
    # Check if plugins.vim is sourced in .vimrc
    if [ -f "$VIMRC" ]; then
        if ! grep -q "source ~/.vim/plugins.vim" "$VIMRC"; then
            echo "source ~/.vim/plugins.vim" >> "$VIMRC"
        fi
    else
        echo "source ~/.vim/plugins.vim" > "$VIMRC"
    fi
    
    echo "vim 설정 완료"
    echo "vim을 다시 실행하면 변경사항이 적용됩니다."
} 