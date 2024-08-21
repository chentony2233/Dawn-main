#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/Dawn.sh"

# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费 -- ct魔改自用_去除proxy"
        echo "================================================================"
        echo "节点社区 Telegram 群组: https://t.me/niuwuriji"
        echo "节点社区 Telegram 频道: https://t.me/niuwuriji"
        echo "节点社区 Discord 社群: https://discord.gg/GbMV5EcNWF"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "请选择要执行的操作:"
        echo "1) 安装并启动 Dawn"
        echo "2) 退出"

        read -p "请输入选项 [1-2]: " choice

        case $choice in
            1)
                install_and_start_dawn
                ;;
            2)
                echo "退出脚本..."
                exit 0
                ;;
            *)
                echo "无效选项，请重新选择。"
                ;;
        esac
    done
}

# 安装特定版本 Go 的函数
function install_go() {
    REQUIRED_GO_VERSION="1.22.3"
    CURRENT_GO_VERSION=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')

    if [ "$CURRENT_GO_VERSION" != "$REQUIRED_GO_VERSION" ]; then
        echo "当前 Go 版本 ($CURRENT_GO_VERSION) 不符合要求 ($REQUIRED_GO_VERSION)。正在安装正确版本..."
        wget https://golang.org/dl/go$REQUIRED_GO_VERSION.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go$REQUIRED_GO_VERSION.linux-amd64.tar.gz
        export PATH=$PATH:/usr/local/go/bin
        echo "Go $REQUIRED_GO_VERSION 安装完成。"
        source ~/.bashrc
    else
        echo "Go 已经是正确版本 ($REQUIRED_GO_VERSION)。"
    fi
}

# 安装 Go 环境并启动 Dawn 的函数
function install_and_start_dawn() {
    echo "更新包列表..."
    sudo apt update

    if ! command -v go &> /dev/null; then
        echo "Go 未安装，开始安装..."
        install_go
    else
        echo "Go 已经安装，检查版本..."
        install_go
    fi

    if ! command -v git &> /dev/null; then
        echo "Git 未安装，开始安装..."
        sudo apt install -y git
    else
        echo "Git 已经安装，跳过安装。"
    fi

    echo "克隆项目..."
    git clone https://github.com/chentony2233/Dawn-main.git
    cd Dawn-main || { echo "无法进入 Dawn-main 目录"; exit 1; }

    if [ ! -f "conf.toml" ]; then
        echo "配置文件 conf.toml 不存在，请确保文件存在并重新运行脚本。"
        exit 1
    fi

    echo "下载 Go 依赖..."
    go mod download

    echo "请编辑 conf.toml 文件。完成编辑后，按任意键继续..."
    nano conf.toml

    read -n 1 -s -r -p "按任意键继续..."

    echo "构建项目..."
    go build -o main .

    if [ ! -f "main" ]; then
        echo "构建失败，未找到可执行文件 main。"
        exit 1
    fi

    mv main dawn_runner

    

    echo "执行项目..."
    pm2 start dawn_runner

    # 等待用户按任意键返回主菜单
    read -n 1 -s -r -p "项目执行完成。按任意键返回主菜单..."
}

# 运行主菜单
main_menu
