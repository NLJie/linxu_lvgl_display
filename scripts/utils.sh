#!/bin/bash

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 打印欢迎头
print_welcome_header() {
    echo -e "${GREEN}"
    echo "=============================================="
    echo "  __  __       _        _____ _       _       "
    echo " |  \/  |     | |      |_   _| |     | |      "
    echo " | \  / | __ _| |_ __ _  | | | |__   | |_   _ "
    echo " | |\/| |/ _\` | __/ _\` | | | | '_ \  | | | | |"
    echo " | |  | | (_| | || (_| |_| |_| | | |_| | |_| |"
    echo " |_|  |_|\__,_|\__\__,_|_____|_| |_(_)_|\__,_|"
    echo "                                              "
    echo "=============================================="
    echo -e "${NC}"
    echo "项目: ${PROJECT_NAME} (版本: ${PROJECT_VERSION})"
    echo "构建系统已启动..."
    echo
}

# 打印信息消息
print_info() {
    echo -e "${YELLOW}[INFO] $1${NC}"
}

# 打印成功消息
print_success() {
    echo -e "${GREEN}[SUCCESS] $1${NC}"
}

# 打印错误消息并退出
print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# 检查命令是否存在
check_command() {
    if ! command -v "$1" &> /dev/null; then
        print_error "未找到必需的命令: $1"
        return 1
    fi
    return 0
}