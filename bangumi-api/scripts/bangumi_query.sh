#!/bin/bash
#
# Bangumi API Query Script
# Lightweight curl-based helper for querying Bangumi
#

set -euo pipefail

API_BASE="https://api.bgm.tv"
CALENDAR_BASE="https://api.bgm.tv"
BGM_TOKEN="${BGM_TOKEN:-}"
MAX_RETRIES=3
RETRY_DELAY=2
TIMEOUT=30

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" >&2
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

check_deps() {
    if ! command -v curl &> /dev/null; then
        log_error "curl is required"
        exit 1
    fi
}

check_token() {
    if [[ -z "$BGM_TOKEN" ]]; then
        log_warn "BGM_TOKEN not set, some endpoints may fail"
    fi
}

req() {
    local method="${1:-GET}"
    local url="$2"
    local data="$3"
    
    local curl_opts=(
        -s
        -w "\n%{http_code}"
        --max-time "$TIMEOUT"
    )
    
    if [[ -n "$BGM_TOKEN" ]]; then
        curl_opts+=(-H "Authorization: Bearer $BGM_TOKEN")
    fi
    
    case "$method" in
        POST)
            curl_opts+=(-X POST -H "Content-Type: application/json")
            if [[ -n "$data" ]]; then
                curl_opts+=(-d "$data")
            fi
            ;;
        GET)
            ;;
    esac
    
    curl_opts+=("$url")
    
    local response
    response=$(curl "${curl_opts[@]}" 2>/dev/null)
    local http_code
    http_code=$(echo "$response" | tail -n1)
    local body
    body=$(echo "$response" | sed '$d')
    
    if [[ "$http_code" != "200" ]]; then
        log_error "HTTP $http_code: $body"
        return 1
    fi
    
    echo "$body"
}

cmd_calendar() {
    log_info "Fetching broadcast calendar..."
    req GET "$CALENDAR_BASE/calendar" | jq -r '.[] | "\(.weekday.en): \(.items | length) items"'
}

cmd_me() {
    check_token
    log_info "Getting current user info..."
    req GET "$API_BASE/v0/me" | jq '.'
}

cmd_user() {
    local username="${1:-}"
    if [[ -z "$username" ]]; then
        log_error "Username required"
        exit 1
    fi
    log_info "Getting user: $username"
    req GET "$API_BASE/v0/users/$username" | jq '.'
}

cmd_collections() {
    local username="${1:-}"
    if [[ -z "$username" ]]; then
        log_error "Username required"
        exit 1
    fi
    log_info "Getting collections for: $username"
    req GET "$API_BASE/v0/users/$username/collections" | jq '.'
}

cmd_subjects() {
    local type="${1:-2}"
    local limit="${2:-10}"
    log_info "Browsing subjects type=$type limit=$limit"
    req GET "$API_BASE/v0/subjects?type=$type&limit=$limit" | jq '.'
}

cmd_subject() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting subject: $id"
    req GET "$API_BASE/v0/subjects/$id" | jq '.'
}

cmd_characters() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting characters for subject: $subject_id"
    req GET "$API_BASE/v0/subjects/$subject_id/characters" | jq '.'
}

cmd_persons() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting persons for subject: $subject_id"
    req GET "$API_BASE/v0/subjects/$subject_id/persons" | jq '.'
}

cmd_person() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Person ID required"
        exit 1
    fi
    log_info "Getting person: $id"
    req GET "$API_BASE/v0/persons/$id" | jq '.'
}

cmd_character() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Character ID required"
        exit 1
    fi
    log_info "Getting character: $id"
    req GET "$API_BASE/v0/characters/$id" | jq '.'
}

cmd_search_subjects() {
    local keyword="${1:-}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    local data
    data=$(jq -n --arg kw "$keyword" '{"keyword": $kw}')
    log_info "Searching subjects: $keyword"
    req POST "$API_BASE/v0/search/subjects" "$data" | jq '.'
}

cmd_search_characters() {
    local keyword="${1:-}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    local data
    data=$(jq -n --arg kw "$keyword" '{"keyword": $kw}')
    log_info "Searching characters: $keyword"
    req POST "$API_BASE/v0/search/characters" "$data" | jq '.'
}

cmd_search_persons() {
    local keyword="${1:-}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    local data
    data=$(jq -n --arg kw "$keyword" '{"keyword": $kw}')
    log_info "Searching persons: $keyword"
    req POST "$API_BASE/v0/search/persons" "$data" | jq '.'
}

usage() {
    cat <<EOF
Bangumi API Query Script

Usage: $0 <command> [arguments]

Commands:
  calendar                          Get broadcast calendar
  me                               Get current user info (requires token)
  user <username>                  Get user info
  collections <username>           Get user collections
  subjects <type> [limit]         Browse subjects (type: 1=book, 2=anime, 3=music, 4=game, 6=real)
  subject <id>                    Get subject by ID
  characters <subject_id>          Get characters for subject
  persons <subject_id>             Get persons for subject
  person <id>                     Get person by ID
  character <id>                  Get character by ID
  search_subjects <keyword>       Search subjects
  search_characters <keyword>     Search characters
  search_persons <keyword>        Search persons

Environment:
  BGM_TOKEN                       Bangumi access token

Examples:
  $0 calendar
  $0 search_subjects "Clannad"
  $0 subject 100228
  BGM_TOKEN=xxx $0 me

EOF
    exit 1
}

check_deps

if [[ $# -lt 1 ]]; then
    usage
fi

cmd="$1"
shift

case "$cmd" in
    calendar) cmd_calendar "$@";;
    me) cmd_me "$@";;
    user) cmd_user "$@";;
    collections) cmd_collections "$@";;
    subjects) cmd_subjects "$@";;
    subject) cmd_subject "$@";;
    characters) cmd_characters "$@";;
    persons) cmd_persons "$@";;
    person) cmd_person "$@";;
    character) cmd_character "$@";;
    search_subjects) cmd_search_subjects "$@";;
    search_characters) cmd_search_characters "$@";;
    search_persons) cmd_search_persons "$@";;
    *) usage;;
esac
