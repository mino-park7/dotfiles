# Dotfiles

개발 환경 설정을 위한 dotfiles 저장소입니다.

## 빠른 설치

아래 명령어 한 줄로 설치할 수 있습니다:

```bash
curl -fsSL https://mino-park7.github.io/dotfiles/etc/install | bash
```

## 구성

```
dotfiles/
├── agents/           # Agent skills 관리 (.skill-lock.json)
├── aliases/          # 커스텀 쉘 별칭
├── claude/           # Claude Code 설정 (settings, skills, plugins)
├── packages/         # 시스템 패키지 설치 스크립트
├── plugins/          # zsh/vim/tmux/skills 플러그인 설치
├── tmux/             # tmux 설정 (tmux.conf)
├── vim/              # vim 설정 (vimrc)
├── zsh/              # zsh 설정 (zshrc, p10k, oh-my-zsh)
└── install.sh        # 통합 설치 스크립트
```

## 설치되는 도구들

### 시스템 패키지
- zsh + [Oh My Zsh](https://ohmyz.sh/) + [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- git, curl, wget
- autojump, thefuck, fzf

### Zsh 플러그인
- zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
- git, docker, kubectl, helm, aws 자동완성
- 기타: extract, jsontools, colored-man-pages 등

### 심볼릭 링크
설치 시 아래 파일들이 홈 디렉토리에 심볼릭 링크됩니다:

| 소스 | 대상 |
|------|------|
| `vim/vimrc` | `~/.vimrc` |
| `zsh/zshrc` | `~/.zshrc` |
| `zsh/p10k.zsh` | `~/.p10k.zsh` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `claude/` | `~/.claude` |
| `agents/.skill-lock.json` | `~/.agents/.skill-lock.json` |

### Claude Code

`claude/` 디렉토리는 Claude Code의 사용자 설정을 관리합니다:
- `settings.json` — 전역 설정
- `scripts/` — 커스텀 스크립트
- `skills/` — 사용자 스킬 (네이티브 + `~/.agents/skills/` symlink)
- `plugins/` — 플러그인 설정 (config만 추적, cache는 제외)

> `.local.env` 등 credential 파일은 `.gitignore`로 제외됩니다.

### Agent Skills

`agents/` 디렉토리는 [npx skills](https://skills.sh/)로 설치한 스킬을 관리합니다:
- `.skill-lock.json` — 설치된 스킬 목록 (lock file)
- 설치 시 `npx skills experimental_install`로 스킬을 자동 복원합니다
- Node.js가 없으면 OS에 맞게 자동 설치를 시도합니다

## 시스템 요구사항

- macOS 또는 Linux (Ubuntu/Debian/CentOS/RHEL)
- curl
- sudo 권한 (패키지 설치에 필요)

## 주의사항

- macOS의 경우 Homebrew가 설치되어 있지 않다면 자동으로 설치를 시도합니다.
- sudo 권한이 없는 경우 설치가 진행되지 않습니다.
- 지원되지 않는 Linux 배포판에서는 실행되지 않습니다.

## 문제 해결

1. 권한 오류 발생 시
   - sudo 권한이 있는지 확인하세요
   - `sudo -v` 명령어로 권한을 미리 확인할 수 있습니다

2. 패키지 설치 실패 시
   - 인터넷 연결을 확인하세요
   - 패키지 매니저(apt, yum, brew)가 정상 작동하는지 확인하세요
