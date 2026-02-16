#!/bin/bash
#
# Bangumi API Query Script (纯 Bash 版本)
#

set -eo pipefail

API_BASE="https://api.bgm.tv"
CALENDAR_BASE="https://api.bgm.tv"
BGM_TOKEN="${BGM_TOKEN:-}"
TIMEOUT=30
USER_AGENT="Bangumi-API-Query/1.0"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[OK]${NC} $1"; }

req() {
    local method="${1:-GET}"
    local url="$2"
    local data="${3:-}"

    local headers=(
        -H "User-Agent: $USER_AGENT"
    )

    if [[ -n "$BGM_TOKEN" ]]; then
        headers+=(-H "Authorization: Bearer $BGM_TOKEN")
    fi

    if [[ "$method" == "POST" ]]; then
        headers+=(-H "Content-Type: application/json")
        if [[ -n "$data" ]]; then
            response=$(curl -s -w "\n%{http_code}" --max-time "$TIMEOUT" "${headers[@]}" \
                -X POST -d "$data" "$url" 2>&1)
        else
            response=$(curl -s -w "\n%{http_code}" --max-time "$TIMEOUT" "${headers[@]}" \
                -X POST "$url" 2>&1)
        fi
    else
        response=$(curl -s -w "\n%{http_code}" --max-time "$TIMEOUT" "${headers[@]}" "$url" 2>&1)
    fi

    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "curl failed: $response"
        exit 1
    fi

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [[ "$http_code" != "200" ]]; then
        log_error "HTTP $http_code: $body"
        exit 1
    fi

    echo "$body"
}

json_get() {
    local json="$1"
    local key="$2"
    echo "$json" | sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\([^,}]*\).*/\1/p" | tr -d '"' | tr -d ' '
}

json_get_str() {
    local json="$1"
    local key="$2"
    echo "$json" | sed -n "s/.*\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p"
}

cmd_calendar() {
    log_info "Fetching broadcast calendar..."
    local result
    result=$(req GET "$CALENDAR_BASE/calendar")

    echo "$result" | grep -o '"weekday"[^}]*}' | while read -r day; do
        en=$(echo "$day" | sed 's/.*"en":"\([^"]*\)".*/\1/')
        cn=$(echo "$day" | sed 's/.*"cn":"\([^"]*\)".*/\1/')
        count=$(echo "$day" | grep -o '"id"' | wc -l)
        echo "  $en ($cn): $count items"
    done
}

cmd_me() {
    if [[ -z "$BGM_TOKEN" ]]; then
        log_warn "BGM_TOKEN not set"
    fi
    log_info "Getting current user info..."
    local result
    result=$(req GET "$API_BASE/v0/me")

    echo "  Username: $(json_get_str "$result" "username")"
    echo "  ID: $(json_get_str "$result" "id")"
    echo "  Nickname: $(json_get_str "$result" "nickname")"
}

cmd_user() {
    local username="${1:-}"
    if [[ -z "$username" ]]; then
        log_error "Username required"
        exit 1
    fi
    log_info "Getting user: $username"
    local result
    result=$(req GET "$API_BASE/v0/users/$username")
    echo "$result" | head -c 500
}

cmd_collections() {
    local username="${1:-}"
    local status="${2:-}"
    if [[ -z "$username" ]]; then
        log_error "Username required"
        exit 1
    fi
    log_info "Getting collections for: $username"
    local url="$API_BASE/v0/users/$username/collections"
    if [[ -n "$status" ]]; then
        url+="?status=$status"
    fi
    local result
    result=$(req GET "$url")
    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
}

cmd_subjects() {
    local type="${1:-2}"
    local limit="${2:-10}"
    local offset="${3:-0}"
    log_info "Browsing subjects type=$type limit=$limit offset=$offset"
    local url="$API_BASE/v0/subjects?type=$type&limit=$limit&offset=$offset"
    local result
    result=$(req GET "$url")
    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
}

cmd_subject() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting subject: $id"
    local result
    result=$(req GET "$API_BASE/v0/subjects/$id")

    echo "  Name: $(json_get_str "$result" "name")"
    echo "  Name CN: $(json_get_str "$result" "name_cn")"
    echo "  Type: $(json_get_str "$result" "type")"
    local rating=$(json_get_str "$result" "rating")
    if [[ -n "$rating" ]]; then
        echo "  Rating: $rating"
    fi
}

cmd_characters() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting characters for subject: $subject_id"
    local result
    result=$(req GET "$API_BASE/v0/subjects/$subject_id/characters")
    echo "$result" | grep -o '"name":"[^"]*"' | head -10 | while read -r line; do
        name=$(echo "$line" | sed 's/"name":"\([^"]*\)"/\1/')
        echo "    - $name"
    done
}

cmd_persons() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting persons for subject: $subject_id"
    local result
    result=$(req GET "$API_BASE/v0/subjects/$subject_id/persons")
    echo "$result" | grep -o '"name":"[^"]*"' | head -10 | while read -r line; do
        name=$(echo "$line" | sed 's/"name":"\([^"]*\)"/\1/')
        echo "    - $name"
    done
}

cmd_relations() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting relations for subject: $subject_id"
    local result
    result=$(req GET "$API_BASE/v0/subjects/$subject_id/relations")
    echo "$result" | grep -o '"sourceId"[^}]*}' | head -10 | while read -r rel; do
        source=$(echo "$rel" | sed 's/.*"sourceId"\s*:\s*\([^,}]*\).*/\1/')
        target=$(echo "$rel" | sed 's/.*"targetId"\s*:\s*\([^,}]*\).*/\1/')
        relation=$(echo "$rel" | sed 's/.*"relation"\s*:\s*"\([^"]*\)".*/\1/')
        echo "  $source -> $relation -> $target"
    done
}

cmd_episodes() {
    local subject_id="${1:-}"
    if [[ -z "$subject_id" ]]; then
        log_error "Subject ID required"
        exit 1
    fi
    log_info "Getting episodes for subject: $subject_id"
    local result
    result=$(req GET "$API_BASE/v0/episodes/$subject_id")
    local total=$(json_get_str "$result" "total")
    echo "  Total episodes: $total"
}

cmd_person() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Person ID required"
        exit 1
    fi
    log_info "Getting person: $id"
    local result
    result=$(req GET "$API_BASE/v0/persons/$id")

    echo "  Name: $(json_get_str "$result" "name")"
    echo "  Name CN: $(json_get_str "$result" "name_cn")"
    echo "  Type: $(json_get_str "$result" "type")"
}

cmd_character() {
    local id="${1:-}"
    if [[ -z "$id" ]]; then
        log_error "Character ID required"
        exit 1
    fi
    log_info "Getting character: $id"
    local result
    result=$(req GET "$API_BASE/v0/characters/$id")

    echo "  Name: $(json_get_str "$result" "name")"
    echo "  Name CN: $(json_get_str "$result" "name_cn")"
}

cmd_search_subjects() {
    local keyword="${1:-}"
    local sort="${2:-match}"
    local limit="${3:-10}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    log_info "Searching subjects: $keyword (sort=$sort)"
    local data="{\"keyword\": \"$keyword\", \"sort\": \"$sort\", \"limit\": $limit}"
    local result
    result=$(req POST "$API_BASE/v0/search/subjects" "$data")

    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
    echo "$result" | grep -o '"name":"[^"]*"' | head -10 | while read -r line; do
        name=$(echo "$line" | sed 's/"name":"\([^"]*\)"/\1/')
        echo "    - $name"
    done
}

cmd_search_characters() {
    local keyword="${1:-}"
    local limit="${3:-10}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    log_info "Searching characters: $keyword"
    local data="{\"keyword\": \"$keyword\", \"limit\": $limit}"
    local result
    result=$(req POST "$API_BASE/v0/search/characters" "$data")

    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
    echo "$result" | grep -o '"name":"[^"]*"' | head -10 | while read -r line; do
        name=$(echo "$line" | sed 's/"name":"\([^"]*\)"/\1/')
        echo "    - $name"
    done
}

cmd_search_persons() {
    local keyword="${1:-}"
    local limit="${3:-10}"
    if [[ -z "$keyword" ]]; then
        log_error "Keyword required"
        exit 1
    fi
    log_info "Searching persons: $keyword"
    local data="{\"keyword\": \"$keyword\", \"limit\": $limit}"
    local result
    result=$(req POST "$API_BASE/v0/search/persons" "$data")

    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
    echo "$result" | grep -o '"name":"[^"]*"' | head -10 | while read -r line; do
        name=$(echo "$line" | sed 's/"name":"\([^"]*\)"/\1/')
        echo "    - $name"
    done
}

cmd_index() {
    local type="${1:-new}"
    local limit="${2:-20}"
    log_info "Getting index: $type (limit=$limit)"
    local url="$API_BASE/v0/index/$type?limit=$limit"
    local result
    result=$(req GET "$url")
    local total=$(json_get_str "$result" "total")
    echo "  Total: $total"
}

usage() {
    cat <<EOF
Bangumi API Query Script (纯 Bash 版本)

Usage: $0 <command> [arguments]

Commands:
  calendar                        Get broadcast calendar
  me                             Get current user info (requires token)
  user <username>                 Get user info
  collections <username> [status] Get user collections (status: collect/wish/doing/on_hold/dropped)
  subjects [type] [limit] [off]  Browse subjects (type: 1=book 2=anime 3=music 4=game 6=real)
  subject <id>                   Get subject by ID
  characters <subject_id>        Get characters for subject
  persons <subject_id>           Get persons for subject
  relations <subject_id>        Get relations for subject
  episodes <subject_id>          Get episodes for subject
  person <id>                    Get person by ID
  character <id>                  Get character by ID
  search <keyword> [sort] [lim]  Search subjects (sort: match/heat/rank/score)
  search_chars <keyword>         Search characters
  search_persons <keyword>       Search persons
  index <type> [limit]           Get index (new/hot/jk/tb)

Environment:
  BGM_TOKEN                      Bangumi access token

Examples:
  $0 calendar
  $0 search Clannad
  $0 subject 100228
  $0 collections gealachlee
  BGM_TOKEN=xxx $0 me

EOF
    exit 1
}

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
    relations) cmd_relations "$@";;
    episodes) cmd_episodes "$@";;
    person) cmd_person "$@";;
    character) cmd_character "$@";;
    search) cmd_search_subjects "$@";;
    search_chars) cmd_search_characters "$@";;
    search_persons) cmd_search_persons "$@";;
    index) cmd_index "$@";;
    *) usage;;
esac
