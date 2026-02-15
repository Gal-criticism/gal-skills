---
name: bangumi-api
description: This skill provides guidance for making requests to the Bangumi (番组计划) API. It should be used when querying anime, manga, game information, characters, persons, user collections, and calendar from Bangumi.
---

# Bangumi API Skill

This skill helps interact with the Bangumi (番组计划) API to query information about anime, manga, games, characters, persons, user collections, and broadcast calendar.

## API Endpoint

**Base URL**: `https://api.bgm.tv`

**Calendar URL**: `https://api.bgm.tv/calendar` (no v0 prefix)

## Authentication

Bangumi uses OAuth 2.0 with Authorization Code Grant flow for user authentication.

### Getting a Token (Two Methods)

#### Method 1: Quick Access Token (Recommended for Testing)
1. Obtain a token from: https://next.bgm.tv/demo/access-token
2. Token format: Base64-like string (e.g., `6goCbAIAxl9prt1M6LGpkQg2BOzOj2jTMG9d8rey`)
3. Include in requests: `Authorization: Bearer <your-token>`

#### Method 2: Full OAuth 2.0 Flow (For Applications)

**Step 1: Redirect user to authorization page**
```
GET https://bgm.tv/oauth/authorize
```

Parameters:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `client_id` | string | Yes | App ID from registration |
| `response_type` | string | Yes | Must be `code` |
| `redirect_uri` | string | No | Callback URL (must match app registration) |
| `state` | string | No | Random string for CSRF protection |

**Step 2: Exchange code for access token**
```
POST https://bgm.tv/oauth/access_token
```

Parameters:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `grant_type` | string | Yes | Use `authorization_code` |
| `client_id` | string | Yes | App ID |
| `client_secret` | string | Yes | App Secret |
| `code` | string | Yes | Code from Step 1 callback |
| `redirect_uri` | string | Yes | Must match Step 1 |
| `state` | string | No | Same value as Step 1 |

Response:
```json
{
  "access_token": "YOUR_ACCESS_TOKEN",
  "expires_in": 604800,
  "token_type": "Bearer",
  "scope": null,
  "refresh_token": "YOUR_REFRESH_TOKEN",
  "user_id": USER_ID
}
```

Note: The `code` is valid for only 60 seconds!

**Step 3: Use access token**
Include in requests: `Authorization: Bearer <your-access-token>`

### Token Refresh

Use refresh token to get a new access token:
```
POST https://bgm.tv/oauth/access_token
```

Parameters:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `grant_type` | string | Yes | Use `refresh_token` |
| `client_id` | string | Yes | App ID |
| `client_secret` | string | Yes | App Secret |
| `refresh_token` | string | Yes | Refresh token from previous response |
| `redirect_uri` | string | Yes | Must match app registration |

### Token Status Check

Check current token validity:
```
POST https://bgm.tv/oauth/token_status
```

Parameters:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `access_token` | string | Yes | Your access token |

Response:
```json
{
  "access_token": "YOUR_ACCESS_TOKEN",
  "client_id": "YOUR_CLIENT_ID",
  "expires": 1520323182,
  "scope": null,
  "user_id": USER_ID
}
```

### Auth Base URLs

- Authorization: `https://bgm.tv/oauth/authorize`
- Token: `https://bgm.tv/oauth/access_token`
- Token Status: `https://bgm.tv/oauth/token_status`
- API: `https://api.bgm.tv`

## Rate Limits

- No explicit rate limit documented
- Recommended: 1 request per second

## Available Endpoints

### Public (No Auth Required)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/calendar` | GET | 每日放送 (Broadcast calendar) |

### Authenticated (GET)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v0/me` | GET | Get current user info |
| `/v0/users/{username}` | GET | Get user info by username |
| `/v0/users/{username}/collections` | GET | Get user's collections |
| `/v0/subjects` | GET | Browse subjects (requires `type` param) |
| `/v0/subjects/{id}` | GET | Get subject by ID |
| `/v0/subjects/{id}/persons` | GET | Get related persons |
| `/v0/subjects/{id}/characters` | GET | Get characters |
| `/v0/persons/{id}` | GET | Get person by ID |
| `/v0/characters/{id}` | GET | Get character by ID |

### Search (POST - Auth Required)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v0/search/subjects` | POST | Search subjects |
| `/v0/search/characters` | POST | Search characters |
| `/v0/search/persons` | POST | Search persons |

### Search Filter Options

**Search Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `keyword` | string | Search keyword (required) |
| `sort` | string | Sort order: `match` (default), `heat`, `rank`, `score` |
| `filter` | object | Filter conditions |

**Filter Conditions (all are AND relationships):**

| Filter | Type | Description |
|--------|------|-------------|
| `type` | array | Subject type IDs (e.g., `[2]` for anime) |
| `tag` | array | Tags (AND relationship) |
| `air_date` | string | Air/release date |
| `rating` | object | Rating range `{min: number, max: number}` |
| `rating_count` | object | Rating count range `{min: number, max: number}` |
| `rank` | object | Rank range `{min: number, max: number}` |
| `nsfw` | string | Include NSFW: `include` (default excludes) |

**Example with filters:**
```json
{
  "keyword": "Clannad",
  "sort": "rank",
  "filter": {
    "type": [2],
    "rating": {"min": 8},
    "tag": ["治愈"]
  }
}
```

### More API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v0/episodes/{subject_id}` | GET | Get episodes for a subject |
| `/v0/subjects/{id}/relations` | GET | Get related subjects |
| `/v0/subjects/{id}/tags` | GET | Get subject tags |
| `/v0/persons/{id}/characters` | GET | Characters voiced by person |
| `/v0/persons/{id}/characters` | GET | Characters related to person |
| `/v0/characters/{id}` | GET | Get character details |
| `/v0/tags` | GET | Browse tags |
| `/v0/comments/{subject_id}` | GET | Get subject comments |
| `/v0/index/{type}` | GET | Index by type (new in v0) |

### Index Endpoints (New in v0)

| Type | Description |
|------|-------------|
| `new` | Newly added |
| `hot` | Popular now |
| `jk` | Jump (weekly popular) |
| `tb` | Today's calendar |

Query parameters: `limit`, `offset`

### User Collections

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/v0/users/{id}/collections` | GET | Get user's collection |
| `/v0/users/{id}/collections/{subject_id}` | GET | Get specific item in collection |

**Collection query parameters:**
| Parameter | Description |
|------------|-------------|
| `type` | Subject type filter |
| `status` | Status: `collect`, `wish`, `doing`, `on_hold`, `dropped` |
| `tag` | Filter by tag |
| `limit`, `offset` | Pagination |

## Subject Types

| Type ID | Description |
|---------|-------------|
| 1 | Book (书籍) |
| 2 | Anime (动画) |
| 3 | Music (音乐) |
| 4 | Game (游戏) |
| 6 | Real (三次元) |

## Shell Script Usage

A lightweight curl-based script is provided at `scripts/bangumi_query.sh`:

### Quick Commands

```bash
# Get broadcast calendar
./scripts/bangumi_query.sh calendar

# Search subjects (anime)
./scripts/bangumi_query.sh search_subjects "Clannad"

# Search characters
./scripts/bangumi_query.sh search_characters "Higurashi"

# Search persons
./scripts/bangumi_query.sh search_persons "Miyazaki"

# Get subject by ID
./scripts/bangumi_query.sh subject 100228

# Get subject characters
./scripts/bangumi_query.sh characters 100228

# Get subject persons
./scripts/bangumi_query.sh persons 100228

# Get person by ID
./scripts/bangumi_query.sh person 1

# Get character by ID
./scripts/bangumi_query.sh character 1

# Get current user info (requires auth)
./scripts/bangumi_query.sh me

# Get user collections
./scripts/bangumi_query.sh collections "username"

# Browse subjects by type
./scripts/bangumi_query.sh subjects 2 10
```

### Advanced Usage

```bash
# Set token
export BGM_TOKEN="your-token"

# Search with filter
./scripts/bangumi_query.sh search_subjects "Clannad" "score"

# Get user collections with status
./scripts/bangumi_query.sh collections "username" "doing"
```

### Available Commands

| Command | Arguments | Description |
|---------|-----------|-------------|
| `calendar` | - | Get broadcast calendar |
| `search_subjects` | `<keyword>` [sort] | Search subjects |
| `search_characters` | `<keyword>` | Search characters |
| `search_persons` | `<keyword>` | Search persons |
| `subjects` | `<type>` [limit] | Browse subjects by type |
| `subject` | `<id>` | Get subject by ID |
| `characters` | `<subject_id>` | Get characters for subject |
| `persons` | `<subject_id>` | Get persons for subject |
| `person` | `<id>` | Get person by ID |
| `character` | `<id>` | Get character by ID |
| `me` | - | Get current user info |
| `collections` | `<username>` | Get user collections |
| `user` | `<username>` | Get user info |

## curl Example Requests

### Get Calendar
```bash
curl https://api.bgm.tv/calendar \
  --header 'Accept: application/json'
```

### Search Subjects
```bash
curl -X POST https://api.bgm.tv/v0/search/subjects \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer <token>' \
  --data '{"keyword": "Clannad"}'
```

### Search with Filter
```bash
curl -X POST https://api.bgm.tv/v0/search/subjects \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer <token>' \
  --data '{
    "keyword": "Clannad",
    "sort": "rank",
    "filter": {"type": [2]}
  }'
```

### Get Subject by ID
```bash
curl https://api.bgm.tv/v0/subjects/100228 \
  --header 'Authorization: Bearer <token>'
```

### Get Subject Characters
```bash
curl https://api.bgm.tv/v0/subjects/100228/characters \
  --header 'Authorization: Bearer <token>'
```

### Get Subject Persons
```bash
curl https://api.bgm.tv/v0/subjects/100228/persons \
  --header 'Authorization: Bearer <token>'
```

### Get User Info
```bash
curl https://api.bgm.tv/v0/users/540730 \
  --header 'Authorization: Bearer <token>'
```

### Get Current User
```bash
curl https://api.bgm.tv/v0/me \
  --header 'Authorization: Bearer <token>'
```

### Get User Collections
```bash
curl "https://api.bgm.tv/v0/users/540730/collections?limit=10" \
  --header 'Authorization: Bearer <token>'
```

## Response Format

### Subject
```json
{
  "id": 100228,
  "name": "ラジオCD「中二病でも恋がしたい!~闇の炎に抱かれて聴け~」 Vol.6",
  "name_cn": "",
  "type": 3,
  "summary": "...",
  "rating": {"score": 9, "total": 2},
  "collection": {"collect": 2, "wish": 0, "doing": 0, "on_hold": 0, "dropped": 1}
}
```

### Search Result
```json
{
  "total": 68,
  "data": [
    {"id": 13, "name": "CLANNAD", "name_cn": ""}
  ]
}
```

### Calendar
```json
[
  {
    "weekday": {"en": "Mon", "cn": "星期一", "ja": "月耀日", "id": 1},
    "items": [...]
  }
]
```

## Error Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Invalid request |
| 401 | Invalid token |
| 404 | Not found |
| 500 | Server error |

## Tips

- Calendar endpoint uses `/calendar` (no v0 prefix)
- Search endpoints require POST with JSON body
- Use `type` parameter to filter subjects by type (1=book, 2=anime, 3=music, 4=game, 6=real)
- Subject IDs are integers, not strings
- User identifiers can be username (string) or user ID (integer)

## Reference Documentation

For complete API documentation, see `references/api_docs.md` in this skill folder.
