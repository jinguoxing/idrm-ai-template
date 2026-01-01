#!/bin/bash

# IDRM AI Template 初始化脚本
# 用法: 
#   交互式: ./scripts/init.sh <module_path>
#   非交互: ./scripts/init.sh <module_path> --services api,rpc --yes
# 示例: 
#   ./scripts/init.sh github.com/myorg/my-project
#   ./scripts/init.sh github.com/myorg/my-project --services api,rpc,job

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 模板默认模块路径
OLD_MODULE="github.com/idrm/template"

# 默认服务列表
SERVICES=("api")
INTERACTIVE=true
NEW_MODULE=""
NEW_PROJECT=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --services)
            IFS=',' read -ra SERVICES <<< "$2"
            shift 2
            ;;
        --yes|-y)
            INTERACTIVE=false
            shift
            ;;
        *)
            if [ -z "$NEW_MODULE" ]; then
                NEW_MODULE=$1
            elif [ -z "$NEW_PROJECT" ]; then
                NEW_PROJECT=$1
            fi
            shift
            ;;
    esac
done

# 参数检查
if [ -z "$NEW_MODULE" ]; then
    echo -e "${YELLOW}用法: ./scripts/init.sh <module_path> [options]${NC}"
    echo -e ""
    echo -e "参数:"
    echo -e "  ${BLUE}module_path${NC}     - Go 模块路径 (必填)"
    echo -e ""
    echo -e "选项:"
    echo -e "  ${BLUE}--services${NC}      - 服务类型，逗号分隔 (默认: api)"
    echo -e "                   可选: api,rpc,job,consumer,all"
    echo -e "  ${BLUE}--yes, -y${NC}       - 跳过交互式确认"
    echo -e ""
    echo -e "示例:"
    echo -e "  ./scripts/init.sh github.com/myorg/my-service"
    echo -e "  ./scripts/init.sh github.com/myorg/my-service --services api,rpc"
    echo -e "  ./scripts/init.sh github.com/myorg/my-service --services all --yes"
    exit 1
fi

# 从模块路径提取项目名
if [ -z "$NEW_PROJECT" ]; then
    NEW_PROJECT=$(basename "$NEW_MODULE")
fi

echo -e "${GREEN}🚀 IDRM 模板初始化${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "模块路径: ${YELLOW}$NEW_MODULE${NC}"
echo -e "项目名称: ${YELLOW}$NEW_PROJECT${NC}"

# 交互式服务选择
if [ "$INTERACTIVE" = true ]; then
    echo -e ""
    echo -e "${CYAN}请选择需要的服务类型 (多选用空格分隔):${NC}"
    echo -e "  ${BLUE}1)${NC} api      - HTTP API 服务 (默认)"
    echo -e "  ${BLUE}2)${NC} rpc      - gRPC 服务"
    echo -e "  ${BLUE}3)${NC} job      - 定时任务服务"
    echo -e "  ${BLUE}4)${NC} consumer - 消息消费者服务"
    echo -e "  ${BLUE}5)${NC} all      - 全部服务"
    echo -e ""
    read -p "输入选择 [1]: " choices
    
    if [ -z "$choices" ]; then
        choices="1"
    fi
    
    # 解析选择
    SERVICES=()
    for choice in $choices; do
        case $choice in
            1) SERVICES+=("api") ;;
            2) SERVICES+=("rpc") ;;
            3) SERVICES+=("job") ;;
            4) SERVICES+=("consumer") ;;
            5) SERVICES=("api" "rpc" "job" "consumer") ;;
            *) echo -e "${YELLOW}⚠️ 忽略无效选项: $choice${NC}" ;;
        esac
    done
    
    if [ ${#SERVICES[@]} -eq 0 ]; then
        SERVICES=("api")
    fi
fi

# 处理 all 选项
if [[ " ${SERVICES[@]} " =~ " all " ]]; then
    SERVICES=("api" "rpc" "job" "consumer")
fi

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "初始化服务: ${YELLOW}${SERVICES[*]}${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 确认
if [ "$INTERACTIVE" = true ]; then
    read -p "确认继续? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        echo -e "${YELLOW}已取消${NC}"
        exit 0
    fi
fi

# sed inplace 函数
sed_inplace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# 1. 替换 go.mod
echo -e "\n${GREEN}[1/5] 更新 go.mod...${NC}"
if [ -f "go.mod" ]; then
    sed_inplace "s|module $OLD_MODULE|module $NEW_MODULE|g" go.mod
    echo -e "  ✅ go.mod 模块路径已更新"
else
    echo -e "  ${RED}❌ go.mod 不存在${NC}"
    exit 1
fi

# 2. 替换 Go 文件 import
echo -e "\n${GREEN}[2/5] 更新 Go 文件 import...${NC}"
GO_FILES=$(find . -name "*.go" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$GO_FILES" -gt 0 ]; then
    find . -name "*.go" -type f | while read file; do
        if grep -q "$OLD_MODULE" "$file" 2>/dev/null; then
            sed_inplace "s|\"$OLD_MODULE/|\"$NEW_MODULE/|g" "$file"
        fi
    done
    echo -e "  ✅ 已更新 $GO_FILES 个 Go 文件"
else
    echo -e "  ${YELLOW}⚠️ 未找到 Go 文件${NC}"
fi

# 3. 更新配置文件
echo -e "\n${GREEN}[3/5] 更新配置文件...${NC}"
CONFIG_FILES=$(find . -name "*.yaml" -type f 2>/dev/null)
for config in $CONFIG_FILES; do
    if grep -q "Name: .*" "$config" 2>/dev/null; then
        sed_inplace "s|Name: .*|Name: $NEW_PROJECT|g" "$config"
    fi
done
echo -e "  ✅ 配置文件已更新"

# 4. 清理不需要的服务目录
echo -e "\n${GREEN}[4/5] 清理服务目录...${NC}"
ALL_SERVICES=("api" "rpc" "job" "consumer")
for svc in "${ALL_SERVICES[@]}"; do
    if [[ ! " ${SERVICES[@]} " =~ " $svc " ]]; then
        if [ -d "$svc" ]; then
            rm -rf "$svc"
            echo -e "  🗑️  已移除 $svc/ 目录"
        fi
    fi
done

# 5. 安装依赖
echo -e "\n${GREEN}[5/5] 安装依赖...${NC}"
go mod tidy
echo -e "  ✅ 依赖安装完成"

# 完成
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 项目初始化完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BLUE}下一步操作:${NC}"
echo -e "  1. 编辑配置文件（etc/*.yaml）"

# 根据选择的服务给出不同提示
if [[ " ${SERVICES[@]} " =~ " api " ]]; then
    echo -e "  2. ${YELLOW}make api${NC} 生成 API 代码"
fi

if [[ " ${SERVICES[@]} " =~ " rpc " ]]; then
    echo -e "  3. ${YELLOW}goctl rpc protoc rpc/proto/service.proto ...${NC} 生成 RPC 代码"
fi

echo -e "\n${BLUE}运行服务:${NC}"
for svc in "${SERVICES[@]}"; do
    echo -e "  ${YELLOW}go run $svc/$svc.go -f $svc/etc/$svc.yaml${NC}"
done

echo -e ""
