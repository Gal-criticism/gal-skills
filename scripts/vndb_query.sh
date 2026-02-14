#!/bin/bash
#
# VNDB API Query Tool - Curl-based
# 轻量级VNDB (Visual Novel Database) API v2 (Kana) 查询脚本
# 用于在沙箱环境中替代curl命令
#
# 用法:
#   ./vndb_query.sh <command> [参数]
#
# 快捷命令:
#   ./vndb_query.sh character <关键词>              # 搜索角色
#   ./vndb_query.sh vn <关键词>                     # 搜索视觉小说
#   ./vndb_query.sh vn_id <ID>                      # 通过ID获取VN
#   ./vndb_query.sh latest [数量]                   # 最新发售游戏
#   ./vndb_query.sh stats                           # 数据库统计
#   ./vndb_query.sh user <用户名>                   # 查询用户
#
# 高级用法:
#   ./vndb_query.sh query <endpoint> <filters> <fields> [sort] [results]
#
# 示例:
#   ./vndb_query.sh character "美雪"
#   ./vndb_query.sh vn "Steins;Gate"
#   ./vndb_query.sh vn_id "v17"
#   ./vndb_query.sh latest 5
#   ./vndb_query.sh query vn '{"search": "悬疑"}' "title,rating" "votecount" 20

set -e

API_BASE_URL="https://api.vndb.org/kana"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印错误信息
error() {
    echo -e "${RED}错误: $1${NC}" >&2
    exit 1
}

# 打印成功信息
success() {
    echo -e "${GREEN}$1${NC}"
}

# 打印警告信息
warn() {
    echo -e "${YELLOW}警告: $1${NC}"
}

# 检查依赖
check_deps() {
    if ! command -v curl &> /dev/null; then
        error "curl 未安装，请先安装curl"
    fi
    if ! command -v jq &> /dev/null; then
        warn "jq 未安装，JSON格式化功能将受限"
    fi
}

# 发送POST请求
api_post() {
    local endpoint="$1"
    local data="$2"
    local url="${API_BASE_URL}/${endpoint}"
    
    curl -s -X POST "${url}" \
        -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "${data}" \
        --max-time 30
}

# 发送GET请求
api_get() {
    local endpoint="$1"
    local url="${API_BASE_URL}/${endpoint}"
    
    curl -s -X GET "${url}" \
        -H "Accept: application/json" \
        --max-time 30
}

# 格式化JSON输出
format_json() {
    if command -v jq &> /dev/null; then
        jq '.'
    else
        cat
    fi
}

# 搜索角色
search_character() {
    local keyword="$1"
    local fields="${2:-name,original,image.url,description,vns.title}"
    local results="${3:-20}"
    
    local data=$(cat <<EOF
{
    "filters": ["search", "=", "${keyword}"],
    "fields": "${fields}",
    "results": ${results}
}
EOF
)
    
    echo "搜索角色: ${keyword}..."
    api_post "character" "${data}" | format_json
}

# 搜索VN
search_vn() {
    local keyword="$1"
    local fields="${2:-title,alttitle,image.url,rating,released,developers.name}"
    local results="${3:-10}"
    
    local data=$(cat <<EOF
{
    "filters": ["search", "=", "${keyword}"],
    "fields": "${fields}",
    "results": ${results}
}
EOF
)
    
    echo "搜索视觉小说: ${keyword}..."
    api_post "vn" "${data}" | format_json
}

# 通过ID获取VN
get_vn_by_id() {
    local vn_id="$1"
    local fields="${2:-title,alttitle,image.url,rating,description,released,developers.name}"
    
    local data=$(cat <<EOF
{
    "filters": ["id", "=", "${vn_id}"],
    "fields": "${fields}"
}
EOF
)
    
    echo "查询VN ID: ${vn_id}..."
    api_post "vn" "${data}" | format_json
}

# 获取最新发售的VN
get_latest_vn() {
    local results="${1:-5}"
    local fields="${2:-title,alttitle,released,developers.name,rating,votecount}"
    
    local data=$(cat <<EOF
{
    "filters": ["released", ">=", "2024-01-01"],
    "fields": "${fields}",
    "sort": "released",
    "reverse": true,
    "results": ${results}
}
EOF
)
    
    echo "获取最新 ${results} 款游戏..."
    api_post "vn" "${data}" | format_json
}

# 获取数据库统计
get_stats() {
    echo "获取数据库统计..."
    api_get "stats" | format_json
}

# 查询用户
get_user() {
    local username="$1"
    local fields="${2:-lengthvotes,lengthvotes_sum}"
    
    echo "查询用户: ${username}..."
    api_get "user?q=${username}&fields=${fields}" | format_json
}

# 获取schema
get_schema() {
    echo "获取API Schema..."
    api_get "schema" | format_json
}

# 通用查询
query_endpoint() {
    local endpoint="$1"
    local filters="$2"
    local fields="$3"
    local sort="${4:-id}"
    local results="${5:-10}"
    
    # 构建filter JSON
    local filter_json
    if [[ "${filters}" == *"["* ]]; then
        # 已经是JSON格式
        filter_json="${filters}"
    else
        # 简单键值对，转换为filter格式
        local key=$(echo "${filters}" | cut -d':' -f1 | tr -d '{"}')
        local val=$(echo "${filters}" | cut -d':' -f2- | tr -d '{"}')
        filter_json="[\"${key}\", \"=\", \"${val}\"]"
    fi
    
    local data=$(cat <<EOF
{
    "filters": ${filter_json},
    "fields": "${fields}",
    "sort": "${sort}",
    "results": ${results}
}
EOF
)
    
    echo "查询端点: ${endpoint}"
    echo "请求: ${data}"
    api_post "${endpoint}" "${data}" | format_json
}

# 显示帮助
show_help() {
    cat << 'EOF'
VNDB API Query Tool - Curl-based
轻量级VNDB API v2 (Kana) 查询脚本

用法:
  ./vndb_query.sh <command> [参数]

快捷命令:
  character <关键词> [字段] [数量]     搜索角色
  vn <关键词> [字段] [数量]            搜索视觉小说
  vn_id <ID> [字段]                    通过ID获取VN
  latest [数量] [字段]                 最新发售游戏
  stats                                数据库统计
  user <用户名> [字段]                 查询用户
  schema                               获取API Schema

高级命令:
  query <endpoint> <filters> <fields> [sort] [results]
                                       通用查询

示例:
  ./vndb_query.sh character "美雪"
  ./vndb_query.sh vn "Steins;Gate"
  ./vndb_query.sh vn_id "v17"
  ./vndb_query.sh latest 5
  ./vndb_query.sh stats
  ./vndb_query.sh user "yorhel"

字段格式 (逗号分隔):
  常用角色字段: name,original,image.url,description,vns.title
  常用VN字段: title,alttitle,image.url,rating,released,developers.name

注意:
  - 需要安装 curl
  - 可选安装 jq 以获得更好的JSON格式化
  - API限制: 200请求/5分钟

EOF
}

# 主函数
main() {
    # 检查依赖
    check_deps
    
    # 检查参数
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    local command="$1"
    shift
    
    case "${command}" in
        character)
            if [ $# -lt 1 ]; then
                error "用法: ./vndb_query.sh character <关键词> [字段] [数量]"
            fi
            search_character "$@"
            ;;
        vn)
            if [ $# -lt 1 ]; then
                error "用法: ./vndb_query.sh vn <关键词> [字段] [数量]"
            fi
            search_vn "$@"
            ;;
        vn_id)
            if [ $# -lt 1 ]; then
                error "用法: ./vndb_query.sh vn_id <ID> [字段]"
            fi
            get_vn_by_id "$@"
            ;;
        latest)
            get_latest_vn "$@"
            ;;
        stats)
            get_stats
            ;;
        user)
            if [ $# -lt 1 ]; then
                error "用法: ./vndb_query.sh user <用户名> [字段]"
            fi
            get_user "$@"
            ;;
        schema)
            get_schema
            ;;
        query)
            if [ $# -lt 3 ]; then
                error "用法: ./vndb_query.sh query <endpoint> <filters> <fields> [sort] [results]"
            fi
            query_endpoint "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            error "未知命令: ${command}. 使用 './vndb_query.sh help' 查看帮助"
            ;;
    esac
}

# 运行主函数
main "$@"
