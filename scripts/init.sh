#!/bin/bash

# IDRM AI Template 初始化脚本
# 用法: ./scripts/init.sh <module_path> [project_name]
# 示例: ./scripts/init.sh github.com/myorg/my-project
#       ./scripts/init.sh github.com/myorg/my-project my-project

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 模板默认模块路径（用于替换）
OLD_MODULE="github.com/idrm/template"

# 参数检查
if [ -z "$1" ]; then
    echo -e "${YELLOW}用法: ./scripts/init.sh <module_path> [project_name]${NC}"
    echo -e ""
    echo -e "参数说明:"
    echo -e "  ${BLUE}module_path${NC}  - Go 模块路径 (必填)"
    echo -e "  ${BLUE}project_name${NC} - 项目名称，用于配置文件 (可选，默认从 module_path 提取)"
    echo -e ""
    echo -e "示例:"
    echo -e "  ./scripts/init.sh github.com/myorg/my-service"
    echo -e "  ./scripts/init.sh github.com/myorg/my-service my-service"
    exit 1
fi

NEW_MODULE=$1
# 从模块路径提取项目名（取最后一部分）
NEW_PROJECT=${2:-$(basename "$NEW_MODULE")}

echo -e "${GREEN}🚀 初始化项目...${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "模块路径: ${YELLOW}$NEW_MODULE${NC}"
echo -e "项目名称: ${YELLOW}$NEW_PROJECT${NC}"
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检测操作系统，选择正确的 sed 语法
if [[ "$OSTYPE" == "darwin"* ]]; then
    SED_INPLACE="sed -i ''"
else
    SED_INPLACE="sed -i"
fi

# 1. 替换 go.mod 中的模块路径
echo -e "\n${GREEN}[1/5] 更新 go.mod...${NC}"
if [ -f "go.mod" ]; then
    $SED_INPLACE "s|module $OLD_MODULE|module $NEW_MODULE|g" go.mod
    echo -e "  ✅ go.mod 模块路径已更新"
else
    echo -e "  ${YELLOW}⚠️ go.mod 不存在，创建新文件...${NC}"
    cat > go.mod << EOF
module $NEW_MODULE

go 1.21

require (
    github.com/zeromicro/go-zero v1.9.0
    gorm.io/gorm v1.25.0
    gorm.io/driver/mysql v1.5.0
    github.com/go-playground/validator/v10 v10.15.0
    go.opentelemetry.io/otel v1.21.0
    go.opentelemetry.io/otel/trace v1.21.0
)
EOF
    echo -e "  ✅ go.mod 已创建"
fi

# 2. 替换所有 Go 文件中的 import 路径
echo -e "\n${GREEN}[2/5] 更新 Go 文件 import 路径...${NC}"
GO_FILES=$(find . -name "*.go" -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$GO_FILES" -gt 0 ]; then
    find . -name "*.go" -type f | while read file; do
        if grep -q "$OLD_MODULE" "$file" 2>/dev/null; then
            $SED_INPLACE "s|\"$OLD_MODULE/|\"$NEW_MODULE/|g" "$file"
        fi
    done
    echo -e "  ✅ 已扫描 $GO_FILES 个 Go 文件，import 路径已更新"
else
    echo -e "  ${YELLOW}⚠️ 未找到 Go 文件${NC}"
fi

# 3. 更新配置文件中的项目名
echo -e "\n${GREEN}[3/5] 更新配置文件...${NC}"
if [ -f "api/etc/api.yaml" ]; then
    $SED_INPLACE "s|Name: .*|Name: $NEW_PROJECT|g" api/etc/api.yaml
    echo -e "  ✅ api/etc/api.yaml 已更新"
fi

# 4. 更新 Makefile 中的项目名
echo -e "\n${GREEN}[4/5] 更新 Makefile...${NC}"
if [ -f "Makefile" ]; then
    $SED_INPLACE "s|PROJECT_NAME := .*|PROJECT_NAME := $NEW_PROJECT|g" Makefile
    echo -e "  ✅ Makefile 已更新"
else
    echo -e "  ${YELLOW}⚠️ Makefile 不存在，跳过${NC}"
fi

# 5. 安装依赖
echo -e "\n${GREEN}[5/5] 安装依赖...${NC}"
go mod tidy
echo -e "  ✅ 依赖安装完成"

# 完成
echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ 项目初始化完成！${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${BLUE}下一步操作:${NC}"
echo -e "  1. 编辑 ${YELLOW}api/etc/api.yaml${NC} 配置数据库等信息"
echo -e "  2. 运行 ${YELLOW}make gen${NC} 生成 API 代码"
echo -e "  3. 运行 ${YELLOW}make run${NC} 启动服务"
echo -e ""
echo -e "${BLUE}常用命令:${NC}"
echo -e "  ${YELLOW}make build${NC}   - 编译项目"
echo -e "  ${YELLOW}make test${NC}    - 运行测试"
echo -e "  ${YELLOW}make lint${NC}    - 代码检查"
