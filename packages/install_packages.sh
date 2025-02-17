# Define packages to install
PACKAGES="zsh git curl wget autojump thefuck vim"

# Function to check if user has sudo privileges
check_sudo() {
    if sudo -n true 2>/dev/null; then
        return 0
    else
        echo "권한이 없어 패키지 설치를 건너뜁니다."
        return 1
    fi
}

# Detect OS type
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - install Homebrew if not installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        if check_sudo; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            exit 0
        fi
    fi
    
    # Install all packages at once using Homebrew
    echo "macOS에서 패키지 설치 중..."
    brew install $PACKAGES

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if user has sudo privileges
    if ! check_sudo; then
        exit 0
    fi

    # Check Linux distribution
    if [ -f /etc/debian_version ]; then
        # Ubuntu/Debian
        echo "Ubuntu/Debian에서 패키지 설치 중..."
        sudo apt-get update
        sudo apt-get install -y $PACKAGES
    elif [ -f /etc/redhat-release ]; then
        # CentOS/RHEL
        echo "CentOS/RHEL에서 패키지 설치 중..."
        # EPEL repository is required for some packages
        sudo yum install -y epel-release
        sudo yum update -y
        sudo yum install -y $PACKAGES
    else
        echo "지원되지 않는 리눅스 배포판입니다."
        exit 1
    fi
else
    echo "지원되지 않는 운영체제입니다."
    exit 1
fi
