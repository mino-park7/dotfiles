#!/bin/bash

# Claude Code plugin installation
# Marketplaces must be cloned before installing plugins.
# The marketplace directories are gitignored, so they need to be set up on fresh installs.

MARKETPLACE_DIR="${HOME}/.claude/plugins/marketplaces"

CLAUDE_PLUGINS=(
    "dx@ykdojo"
    "superpowers@superpowers-marketplace"
    "claude-hud@claude-hud"
    "ralph-loop@claude-plugins-official"
)

clone_marketplace() {
    local name="$1"
    local repo="$2"
    local dest="${MARKETPLACE_DIR}/${name}"
    if [ -d "${dest}" ]; then
        echo "  이미 존재: ${name}"
    else
        echo "  클론 중: ${repo} -> ${name}"
        git clone "https://github.com/${repo}.git" "${dest}" 2>/dev/null \
            || echo "  경고: ${name} marketplace 클론 실패"
    fi
}

setup_claude_marketplaces() {
    echo "Claude Code marketplace 설정 중..."
    mkdir -p "${MARKETPLACE_DIR}"

    # Fix hardcoded paths in known_marketplaces.json for current machine
    local km_file="${HOME}/.claude/plugins/known_marketplaces.json"
    if [ -f "$km_file" ]; then
        sed -i.bak "s|/Users/[^/]*/\.claude|${HOME}/.claude|g" "$km_file" && rm -f "${km_file}.bak"
    fi

    clone_marketplace "claude-plugins-official" "anthropics/claude-plugins-official"
    clone_marketplace "ykdojo" "ykdojo/claude-code-tips"
    clone_marketplace "superpowers-marketplace" "obra/superpowers-marketplace"
    clone_marketplace "claude-hud" "jarrodwatts/claude-hud"

    # Fix: remove git-subdir source plugins that cause schema validation failure
    # in current claude CLI versions, preventing the entire marketplace from loading
    fix_marketplace_schema
}

fix_marketplace_schema() {
    local mj="${MARKETPLACE_DIR}/claude-plugins-official/.claude-plugin/marketplace.json"
    [ -f "$mj" ] || return 0
    if command -v python3 &> /dev/null; then
        python3 -c "
import json, sys
with open('$mj') as f:
    data = json.load(f)
plugins = data.get('plugins', [])
filtered = [p for p in plugins if not (isinstance(p.get('source',''), dict) and p['source'].get('source') == 'git-subdir')]
if len(filtered) < len(plugins):
    data['plugins'] = filtered
    with open('$mj', 'w') as f:
        json.dump(data, f, indent=2)
    print('  marketplace schema 수정: git-subdir 항목 %d개 제거' % (len(plugins) - len(filtered)))
"
    fi
}

install_claude_plugins() {
    if ! command -v claude &> /dev/null; then
        echo "Claude Code가 설치되어 있지 않습니다. 건너뜁니다."
        return 0
    fi

    setup_claude_marketplaces

    echo "Claude Code 플러그인 설치를 시작합니다..."
    for plugin in "${CLAUDE_PLUGINS[@]}"; do
        echo "  설치 중: ${plugin}"
        claude plugin install "${plugin}" || echo "  경고: ${plugin} 설치 실패"
    done
    echo "Claude Code 플러그인 설치가 완료되었습니다."
}
