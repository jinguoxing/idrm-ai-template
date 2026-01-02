#!/bin/bash
# ============================================================================
# Spec 输出验证脚本
# 用于验证生成的 spec/plan/tasks 文档是否符合标准
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 打印函数
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[PASS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[FAIL]${NC} $1"; }

# 统计变量
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0

# 检查函数
check() {
    local description=$1
    local condition=$2
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    if eval "$condition"; then
        print_success "$description"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        return 0
    else
        print_error "$description"
        FAILED_CHECKS=$((FAILED_CHECKS + 1))
        return 1
    fi
}

warn_check() {
    local description=$1
    local condition=$2
    
    if ! eval "$condition"; then
        print_warning "$description"
        WARNINGS=$((WARNINGS + 1))
    fi
}

# 显示帮助
show_help() {
    echo "Spec 输出验证脚本"
    echo ""
    echo "用法: $0 [feature_name] [--all]"
    echo ""
    echo "参数:"
    echo "  feature_name    要验证的功能名称"
    echo "  --all           验证所有功能目录"
    echo ""
    echo "示例:"
    echo "  $0 user-login       # 验证单个功能"
    echo "  $0 --all            # 验证所有功能"
    echo ""
    echo "验证项目:"
    echo "  - spec.md 文件存在性和格式"
    echo "  - plan.md 文件存在性和格式"
    echo "  - tasks.md 文件存在性和格式"
    echo "  - 占位符是否已替换"
    echo "  - 必要章节是否存在"
}

# 验证单个 spec.md
validate_spec() {
    local spec_file=$1
    echo ""
    print_info "验证 spec.md: $spec_file"
    
    # 文件存在
    check "文件存在" "[ -f '$spec_file' ]" || return 1
    
    # 必要章节
    check "包含 User Stories 章节" "grep -q 'User Stories\|用户故事' '$spec_file'"
    check "包含 Acceptance Criteria 章节" "grep -q 'Acceptance Criteria\|验收标准' '$spec_file'"
    
    # 格式检查
    check "使用 EARS 表示法 (WHEN/SHALL)" "grep -qE '(WHEN|THE.*SHALL|IF|THEN)' '$spec_file'" || \
        warn_check "建议使用 EARS 表示法" "false"
    
    # 占位符检查
    check "无占位符 {{" "! grep -q '{{' '$spec_file'"
    check "无占位符 {feature}" "! grep -q '{feature}' '$spec_file'"
    
    # 元数据
    warn_check "包含版本信息" "grep -qE 'Version|版本' '$spec_file'"
    warn_check "包含日期信息" "grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}|Date|日期' '$spec_file'"
}

# 验证单个 plan.md
validate_plan() {
    local plan_file=$1
    echo ""
    print_info "验证 plan.md: $plan_file"
    
    check "文件存在" "[ -f '$plan_file' ]" || return 1
    
    # 必要章节
    check "包含 API 设计" "grep -qiE 'api|接口' '$plan_file'"
    check "包含文件清单" "grep -qiE 'File|文件' '$plan_file'"
    
    # goctl 命令格式
    warn_check "goctl 命令使用 api.api 入口" "grep -q 'api/doc/api.api' '$plan_file'"
    warn_check "goctl 命令包含 --type-group" "grep -q '\-\-type-group' '$plan_file'"
    
    # 占位符检查
    check "无占位符 {{" "! grep -q '{{' '$plan_file'"
    check "无占位符 {module}" "! grep -q '{module}' '$plan_file'"
}

# 验证单个 tasks.md
validate_tasks() {
    local tasks_file=$1
    echo ""
    print_info "验证 tasks.md: $tasks_file"
    
    check "文件存在" "[ -f '$tasks_file' ]" || return 1
    
    # 任务格式
    check "包含 Task 定义" "grep -qE '^##.*Task|^###.*Task' '$tasks_file'"
    check "包含 Status 状态" "grep -qE 'Status|状态' '$tasks_file'"
    check "包含验收标准" "grep -qE 'Acceptance|Criteria|验收' '$tasks_file'"
    
    # 占位符检查
    check "无占位符 {{" "! grep -q '{{' '$tasks_file'"
    
    # 任务大小警告
    if grep -qE 'Estimated.*Lines.*[0-9]{3,}|预估.*行.*[0-9]{3,}' "$tasks_file"; then
        warn_check "存在超过100行的大任务，建议拆分" "false"
    fi
}

# 验证单个功能目录
validate_feature() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    echo ""
    echo "============================================"
    print_info "验证功能: ${feature_name}"
    echo "============================================"
    
    if [ ! -d "$spec_dir" ]; then
        print_error "目录不存在: $spec_dir"
        return 1
    fi
    
    # 检查是否是版本化目录
    if [ -d "${spec_dir}/v1" ] || [ -d "${spec_dir}/v2" ]; then
        print_info "检测到版本化目录结构"
        
        for version_dir in "${spec_dir}"/v*/; do
            if [ -d "$version_dir" ]; then
                version=$(basename "$version_dir")
                print_info "验证版本: $version"
                [ -f "${version_dir}spec.md" ] && validate_spec "${version_dir}spec.md"
                [ -f "${version_dir}plan.md" ] && validate_plan "${version_dir}plan.md"
                [ -f "${version_dir}tasks.md" ] && validate_tasks "${version_dir}tasks.md"
            fi
        done
    else
        # 普通目录结构
        [ -f "${spec_dir}/spec.md" ] && validate_spec "${spec_dir}/spec.md"
        [ -f "${spec_dir}/plan.md" ] && validate_plan "${spec_dir}/plan.md"
        [ -f "${spec_dir}/tasks.md" ] && validate_tasks "${spec_dir}/tasks.md"
    fi
}

# 验证所有功能
validate_all() {
    print_info "验证所有功能目录..."
    
    if [ ! -d "specs" ]; then
        print_warning "specs 目录不存在"
        return 0
    fi
    
    local found_features=0
    
    for feature_dir in specs/*/; do
        if [ -d "$feature_dir" ]; then
            feature_name=$(basename "$feature_dir")
            validate_feature "$feature_name"
            found_features=$((found_features + 1))
        fi
    done
    
    if [ $found_features -eq 0 ]; then
        print_warning "未找到任何功能目录"
    fi
}

# 打印总结
print_summary() {
    echo ""
    echo "============================================"
    echo "验证总结"
    echo "============================================"
    echo ""
    echo "总检查项: $TOTAL_CHECKS"
    echo -e "通过: ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "失败: ${RED}$FAILED_CHECKS${NC}"
    echo -e "警告: ${YELLOW}$WARNINGS${NC}"
    echo ""
    
    if [ $FAILED_CHECKS -eq 0 ]; then
        if [ $WARNINGS -eq 0 ]; then
            print_success "所有检查通过！🎉"
        else
            print_warning "检查通过，但有警告需要关注"
        fi
        return 0
    else
        print_error "存在失败项，请检查并修复"
        return 1
    fi
}

# 主函数
main() {
    if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_help
        exit 0
    fi
    
    echo ""
    print_info "Spec 输出验证脚本"
    print_info "时间: $(date '+%Y-%m-%d %H:%M:%S')"
    
    if [ "$1" == "--all" ]; then
        validate_all
    else
        validate_feature "$1"
    fi
    
    print_summary
}

main "$@"
