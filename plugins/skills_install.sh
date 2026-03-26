#!/bin/bash

# Agent skills 설치
# .skill-lock.json에서 npx skills를 사용하여 스킬을 복원합니다.

ensure_node() {
    if command -v node &> /dev/null && command -v npx &> /dev/null; then
        return 0
    fi

    echo "Node.js가 설치되어 있지 않습니다. 설치를 시도합니다..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install node
        else
            echo "경고: Homebrew가 없어 Node.js를 설치할 수 없습니다."
            return 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/debian_version ]; then
            sudo apt-get update && sudo apt-get install -y nodejs npm
        elif [ -f /etc/redhat-release ]; then
            sudo yum install -y nodejs npm
        else
            echo "경고: 지원되지 않는 리눅스 배포판입니다."
            return 1
        fi
    else
        echo "경고: 지원되지 않는 운영체제입니다."
        return 1
    fi
}

install_skills() {
    if ! ensure_node; then
        echo "Node.js 설치 실패. 스킬 설치를 건너뜁니다."
        return 0
    fi

    if [ ! -f "${HOME}/.agents/.skill-lock.json" ]; then
        echo "skill-lock.json이 없습니다. 스킬 설치를 건너뜁니다."
        return 0
    fi

    echo "Agent 스킬 설치를 시작합니다..."
    npx -y skills experimental_install || echo "경고: 스킬 복원 실패"
    echo "Agent 스킬 설치가 완료되었습니다."
}
