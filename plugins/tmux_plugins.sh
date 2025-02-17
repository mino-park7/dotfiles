#!/bin/bash

# tmux plugins list
TMUX_PLUGINS=(
    "tmux-plugins/tpm"                  # tmux 플러그인 매니저
    "tmux-plugins/tmux-sensible"        # 기본 tmux 설정
    "tmux-plugins/tmux-resurrect"       # 세션 저장 및 복구
    "tmux-plugins/tmux-continuum"       # 자동 세션 저장
    "tmux-plugins/tmux-yank"            # 클립보드 통합
    "tmux-plugins/tmux-pain-control"    # 팬 컨트롤 개선
    "tmux-plugins/tmux-prefix-highlight" # 프리픽스 키 하이라이트
)

# Function to install tmux plugins
install_tmux_plugins() {
    echo "tmux 플러그인 설치 중..."
    
    # Install tpm if not installed
    TMUX_DIR="${HOME}/.tmux"
    TPM_DIR="${TMUX_DIR}/plugins/tpm"
    
    if [ ! -d "$TPM_DIR" ]; then
        echo "Installing tpm..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
    
    # Generate tmux plugin configuration
    {
        echo "# List of plugins"
        for plugin in "${TMUX_PLUGINS[@]}"; do
            echo "set -g @plugin '${plugin}'"
        done
        echo
        echo "# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)"
        echo "run '~/.tmux/plugins/tpm/tpm'"
    } > "${TMUX_DIR}/plugins.conf"
    
    # Install plugins
    "${TPM_DIR}/bin/install_plugins"
    
    echo "tmux 플러그인 설치 완료"
}

# Function to update tmux.conf
update_tmux_conf() {
    echo "tmux 설정 파일 업데이트 중..."
    
    TMUX_CONF="${HOME}/.tmux.conf"
    
    # Check if plugins.conf is sourced in .tmux.conf
    if [ -f "$TMUX_CONF" ]; then
        if ! grep -q "source-file ~/.tmux/plugins.conf" "$TMUX_CONF"; then
            echo "source-file ~/.tmux/plugins.conf" >> "$TMUX_CONF"
        fi
    else
        echo "source-file ~/.tmux/plugins.conf" > "$TMUX_CONF"
    fi
    
    echo "tmux 설정 완료"
    echo "변경사항을 적용하려면 다음 명령어를 실행하세요: tmux source-file ~/.tmux.conf"
} 