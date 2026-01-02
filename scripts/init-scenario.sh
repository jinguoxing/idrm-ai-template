#!/bin/bash
# ============================================================================
# 场景初始化脚本
# 用于快速设置不同开发场景的环境
# ============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "场景初始化脚本"
    echo ""
    echo "用法: $0 <feature_name> [scenario]"
    echo ""
    echo "参数:"
    echo "  feature_name    功能名称 (必需)"
    echo "  scenario        场景类型 (可选, 默认自动检测)"
    echo ""
    echo "场景类型:"
    echo "  new       场景一: 新项目新功能"
    echo "  update    场景二: 已有功能小改动"
    echo "  extend    场景三: 已有功能扩展"
    echo "  refactor  场景四: 已有功能重构"
    echo ""
    echo "示例:"
    echo "  $0 user-login new          # 创建新功能"
    echo "  $0 user-login update       # 小改动"
    echo "  $0 user-login extend       # 功能扩展"
    echo "  $0 user-login refactor     # 大规模重构"
    echo "  $0 user-login              # 自动检测场景"
    echo ""
    echo "工作流文档:"
    echo "  .specify/workflows/README.md             场景选择决策树"
    echo "  .specify/workflows/scenario-1-new.md     场景一指南"
    echo "  .specify/workflows/scenario-2-update.md  场景二指南"
    echo "  .specify/workflows/scenario-3-extend.md  场景三指南"
    echo "  .specify/workflows/scenario-4-refactor.md 场景四指南"
}

# 检测场景类型
detect_scenario() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    if [ ! -d "$spec_dir" ]; then
        echo "new"
        return
    fi
    
    if [ ! -f "${spec_dir}/spec.md" ]; then
        echo "new"
        return
    fi
    
    # 如果存在文档，默认是小改动，让用户选择
    echo "exists"
}

# 场景一: 新项目新功能
init_scenario_new() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    print_info "初始化场景一: 新项目新功能"
    print_info "功能名称: ${feature_name}"
    
    # 创建目录
    mkdir -p "${spec_dir}"
    print_success "创建目录: ${spec_dir}/"
    
    # 创建空的 spec.md 文件（可选）
    if [ ! -f "${spec_dir}/spec.md" ]; then
        cat > "${spec_dir}/spec.md" << EOF
# Feature: ${feature_name}

> **Branch**: \`feature/${feature_name}\`  
> **Spec Path**: \`specs/${feature_name}/\`  
> **Created**: $(date +%Y-%m-%d)  
> **Status**: Draft

---

## 待使用 AI 工具生成

请使用以下命令生成完整的需求规范:

- **Cursor**: \`/speckit-scenario-new\`
- **Claude Code**: \`/speckit.scenario.new\`

或参考工作流文档: \`.specify/workflows/scenario-1-new.md\`
EOF
        print_success "创建模板: ${spec_dir}/spec.md"
    fi
    
    echo ""
    print_success "场景一初始化完成!"
    echo ""
    echo "下一步操作:"
    echo "  1. 在 Cursor 中输入: /speckit-scenario-new"
    echo "  2. 或在 Claude Code 中输入: /speckit.scenario.new"
    echo "  3. 或参考: .specify/workflows/scenario-1-new.md"
}

# 场景二: 小改动
init_scenario_update() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    print_info "初始化场景二: 已有功能小改动"
    print_info "功能名称: ${feature_name}"
    
    if [ ! -d "$spec_dir" ]; then
        print_error "目录不存在: ${spec_dir}/"
        print_error "请确认功能名称是否正确，或使用场景一创建新功能"
        exit 1
    fi
    
    echo ""
    print_success "场景二准备完成!"
    echo ""
    echo "下一步操作:"
    echo "  1. 在 Cursor 中输入: /speckit-scenario-update"
    echo "  2. 或在 Claude Code 中输入: /speckit.scenario.update"
    echo "  3. 或参考: .specify/workflows/scenario-2-update.md"
    echo ""
    echo "现有文档:"
    ls -la "${spec_dir}/" 2>/dev/null || true
}

# 场景三: 功能扩展
init_scenario_extend() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    print_info "初始化场景三: 已有功能扩展"
    print_info "功能名称: ${feature_name}"
    
    if [ ! -d "$spec_dir" ]; then
        print_error "目录不存在: ${spec_dir}/"
        print_error "请确认功能名称是否正确，或使用场景一创建新功能"
        exit 1
    fi
    
    echo ""
    print_success "场景三准备完成!"
    echo ""
    echo "下一步操作:"
    echo "  1. 在 Cursor 中输入: /speckit-scenario-extend"
    echo "  2. 或在 Claude Code 中输入: /speckit.scenario.extend"
    echo "  3. 或参考: .specify/workflows/scenario-3-extend.md"
    echo ""
    echo "现有文档:"
    ls -la "${spec_dir}/" 2>/dev/null || true
}

# 场景四: 大规模重构
init_scenario_refactor() {
    local feature_name=$1
    local spec_dir="specs/${feature_name}"
    
    print_info "初始化场景四: 已有功能重构"
    print_info "功能名称: ${feature_name}"
    
    if [ ! -d "$spec_dir" ]; then
        print_error "目录不存在: ${spec_dir}/"
        print_error "请确认功能名称是否正确，或使用场景一创建新功能"
        exit 1
    fi
    
    # 创建 v1 和 v2 目录
    if [ ! -d "${spec_dir}/v1" ]; then
        mkdir -p "${spec_dir}/v1" "${spec_dir}/v2"
        
        # 移动现有文件到 v1
        for file in spec.md plan.md tasks.md; do
            if [ -f "${spec_dir}/${file}" ]; then
                mv "${spec_dir}/${file}" "${spec_dir}/v1/"
                print_info "移动到 v1: ${file}"
            fi
        done
        
        print_success "创建版本化目录结构"
    else
        print_warning "版本化目录已存在"
    fi
    
    echo ""
    print_success "场景四准备完成!"
    echo ""
    echo "目录结构:"
    echo "  ${spec_dir}/"
    echo "  ├── v1/  (旧版本，已保留)"
    echo "  └── v2/  (新版本，待创建)"
    echo ""
    echo "下一步操作:"
    echo "  1. 在 Cursor 中输入: /speckit-scenario-refactor"
    echo "  2. 或在 Claude Code 中输入: /speckit.scenario.refactor"
    echo "  3. 或参考: .specify/workflows/scenario-4-refactor.md"
}

# 交互式选择场景
interactive_select() {
    local feature_name=$1
    
    echo ""
    echo "检测到功能 '${feature_name}' 已存在相关文档。"
    echo ""
    echo "请选择场景类型:"
    echo "  2) 场景二: 小改动 (Bug 修复, < 50 行)"
    echo "  3) 场景三: 功能扩展 (添加新功能, 向后兼容)"
    echo "  4) 场景四: 大规模重构 (破坏性变更)"
    echo ""
    read -p "请输入选择 [2-4]: " choice
    
    case $choice in
        2)
            init_scenario_update "$feature_name"
            ;;
        3)
            init_scenario_extend "$feature_name"
            ;;
        4)
            init_scenario_refactor "$feature_name"
            ;;
        *)
            print_error "无效选择"
            exit 1
            ;;
    esac
}

# 主函数
main() {
    # 检查参数
    if [ $# -lt 1 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        show_help
        exit 0
    fi
    
    local feature_name=$1
    local scenario=${2:-""}
    
    # 如果指定了场景，直接执行
    if [ -n "$scenario" ]; then
        case $scenario in
            new)
                init_scenario_new "$feature_name"
                ;;
            update)
                init_scenario_update "$feature_name"
                ;;
            extend)
                init_scenario_extend "$feature_name"
                ;;
            refactor)
                init_scenario_refactor "$feature_name"
                ;;
            *)
                print_error "未知场景类型: $scenario"
                show_help
                exit 1
                ;;
        esac
    else
        # 自动检测场景
        local detected=$(detect_scenario "$feature_name")
        
        case $detected in
            new)
                init_scenario_new "$feature_name"
                ;;
            exists)
                interactive_select "$feature_name"
                ;;
        esac
    fi
}

# 执行主函数
main "$@"
