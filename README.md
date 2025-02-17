# Dotfiles

개발 환경 설정을 위한 dotfiles 저장소입니다.

## 빠른 설치

아래 명령어 한 줄로 설치할 수 있습니다:

```bash
curl -fsSL https://mino-park7.github.io/dotfiles/etc/install | bash
```

## 설치되는 도구들

- zsh: 향상된 쉘
- git: 버전 관리 시스템
- curl: URL을 통한 데이터 전송 도구
- wget: 파일 다운로드 도구
- autojump: 디렉토리 빠른 이동 도구
- thefuck: 명령어 오타 교정 도구

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