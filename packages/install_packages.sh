# Define packages to install
PACKAGES="zsh git curl wget autojump thefuck"



# Detect OS type
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - install Homebrew if not installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install all packages at once using Homebrew
    echo "macOS에서 패키지 설치 중..."
    brew install $PACKAGES

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check Linux distribution
    if [ -f /etc/debian_version ]; then
        # Ubuntu/Debian
        echo "Ubuntu/Debian에서 패키지 설치 중..."
        apt-get update
        apt-get install -y $PACKAGES
    elif [ -f /etc/redhat-release ]; then
        # CentOS/RHEL
        echo "CentOS/RHEL에서 패키지 설치 중..."
        # EPEL repository is required for some packages
        yum install -y epel-release
        yum update -y
        yum install -y $PACKAGES
    else
        echo "지원되지 않는 리눅스 배포판입니다."
        exit 1
    fi
else
    echo "지원되지 않는 운영체제입니다."
    exit 1
fi
