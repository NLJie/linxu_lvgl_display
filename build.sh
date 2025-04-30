#!/bin/bash

export PLATFORM=arm  # 默认平台
export VERBOSE=0
export CLEAN=0

source "$(dirname "$0")/scripts/help.sh"

# 解析命令行参数
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) print_help; exit 0 ;;
        -p|--platform) PLATFORM="$2"; shift ;;
        -c|--clean) CLEAN=1 ;;
        -v|--verbose) VERBOSE=1 ;;
        --toolchain) TOOLCHAIN_PATH="$2"; shift ;;
        *) echo "未知参数: $1"; exit 1 ;;
    esac
    shift
done

# 加载工具函数
source "$(dirname "$0")/scripts/utils.sh"

# 显示欢迎头
print_welcome_header

# 加载环境配置
source "$(dirname "$0")/scripts/env_setup.sh"

source "$(dirname "$0")/scripts/build_scripts.sh"

# 主构建逻辑
main() {
    print_info "开始构建流程..."
    
    # 如果设置了清理标志，则清理构建目录
    if [ $CLEAN -eq 1 ]; then
        print_info "清理构建目录..."
        rm -rf "$BUILD_DIR"
        mkdir -p "$BUILD_DIR"
        mkdir -p "$OUTPUT_DIR"
        print_success "构建目录已清理"
    fi
    
    # 在这里添加你的构建步骤
    # 例如:
    build_project

    run_tests
    
    package_artifact
    
    print_success "构建流程完成!"
}

# 执行主函数
main "$@"