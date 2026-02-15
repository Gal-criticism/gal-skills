# Bangumi API Reference

## Base URLs

- API: `https://api.bgm.tv`
- OAuth Authorization: `https://bgm.tv/oauth/authorize`
- OAuth Token: `https://bgm.tv/oauth/access_token`
- OAuth Token Status: `https://bgm.tv/oauth/token_status`
- Calendar: `https://api.bgm.tv/calendar` (no v0 prefix)

## Authentication

### Method 1: Quick Access Token (Testing)

Get token at: https://next.bgm.tv/demo/access-token

Use Bearer token in Authorization header:
```
Authorization: Bearer <token>
```

### Method 2: Full OAuth 2.0 Flow (Applications)

**Step 1: Authorization**
```
GET https://bgm.tv/oauth/authorize?client_id=xxx&response_type=code&redirect_uri=xxx&state=xxx
```

**Step 2: Exchange code for token**
```
POST https://bgm.tv/oauth/access_token
```

Parameters:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `grant_type` | Yes | Use `authorization_code` |
| `client_id` | Yes | App ID |
| `client_secret` | Yes | App Secret |
| `code` | Yes | Code from callback (valid 60 seconds) |
| `redirect_uri` | Yes | Must match registration |

**Step 3: Token Refresh**
```
POST https://bgm.tv/oauth/access_token
```

Parameters:
| Parameter | Required | Description |
|-----------|----------|-------------|
| `grant_type` | Yes | Use `refresh_token` |
| `client_id` | Yes | App ID |
| `client_secret` | Yes | App Secret |
| `refresh_token` | Yes | Refresh token |
| `redirect_uri` | Yes | Must match registration |

**Token Status Check**
```
POST https://bgm.tv/oauth/token_status
```

## Endpoints

### Public

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/calendar` | 每日放送 |

### Authenticated - User

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v0/me` | Current user info |
| GET | `/v0/users/{username}` | User info by username |
| GET | `/v0/users/{username}/collections` | User's collection |
| GET | `/v0/users/{id}/collections/{subject_id}` | Specific collection item |

### Authenticated - Subjects

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v0/subjects` | Browse (requires type param) |
| GET | `/v0/subjects/{id}` | Subject details |
| GET | `/v0/subjects/{id}/persons` | Related persons |
| GET | `/v0/subjects/{id}/characters` | Characters |
| GET | `/v0/subjects/{id}/relations` | Related subjects |
| GET | `/v0/subjects/{id}/tags` | Subject tags |
| GET | `/v0/episodes/{subject_id}` | Episodes |

### Authenticated - Search (POST)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/v0/search/subjects` | Search subjects |
| POST | `/v0/search/characters` | Search characters |
| POST | `/v0/search/persons` | Search persons |

### Search Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `keyword` | string | Search keyword (required) |
| `sort` | string | `match`, `heat`, `rank`, `score` |
| `limit` | integer | Results limit |
| `offset` | integer | Pagination offset |

### Filter Object

| Filter | Type | Description |
|--------|------|-------------|
| `type` | array | Subject type IDs |
| `tag` | array | Tags (AND) |
| `air_date` | string | Air/release date |
| `rating` | object | `{min, max}` range |
| `rating_count` | object | `{min, max}` range |
| `rank` | object | `{min, max}` range |
| `nsfw` | string | `include` to include NSFW |

### Authenticated - Other

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/v0/persons/{id}` | Person details |
| GET | `/v0/persons/{id}/characters` | Person's characters |
| GET | `/v0/characters/{id}` | Character details |
| GET | `/v0/tags` | Browse tags |
| GET | `/v0/comments/{subject_id}` | Subject comments |
| GET | `/v0/index/{type}` | Index (new/hot/jk/tb) |

### Index Types

| Type | Description |
|------|-------------|
| `new` | Newly added |
| `hot` | Popular now |
| `jk` | Weekly popular |
| `tb` | Today's calendar |

## Query Parameters

### /v0/subjects
- `type`: 1=书籍, 2=动画, 3=音乐, 4=游戏, 6=三次元
- `limit`: 每页数量
- `offset`: 偏移量
- `sort`: date | rank
- `year`: 年份
- `month`: 月份

### /v0/users/{id}/collections
- `type`: Subject type filter
- `status`: collect, wish, doing, on_hold, dropped
- `tag`: Filter by tag
- `limit`, `offset`: Pagination

## Response Examples

### Subject
```json
{
  "id": 100228,
  "name": "...",
  "name_cn": "",
  "type": 3,
  "rating": {"score": 9, "total": 2},
  "collection": {"collect": 2, "wish": 0, "doing": 0}
}
```

### Calendar
```json
[
  {
    "weekday": {"en": "Mon", "cn": "星期一", "id": 1},
    "items": [...]
  }
]
```

### Search Result
```json
{
  "total": 68,
  "data": [{"id": 13, "name": "CLANNAD", "name_cn": ""}]
}
```

## Subject Types

| Type ID | Description |
|---------|-------------|
| 1 | Book (书籍) |
| 2 | Anime (动画) |
| 3 | Music (音乐) |
| 4 | Game (游戏) |
| 6 | Real (三次元) |

## Collection Status

| Status | Description |
|--------|-------------|
| `collect` | 已收藏 |
| `wish` | 想看 |
| `doing` | 在看 |
| `on_hold` | 暂停 |
| `dropped` | 抛弃 |

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK |
| 400 | Bad Request |
| 401 | Unauthorized |
| 404 | Not Found |
| 500 | Server Error |
