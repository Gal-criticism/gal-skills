---
name: steam-api
description: This skill provides guidance for making requests to the Steam Web API. It should be used when users need to query Steam user data, game information, player statistics, match history, inventory items, or any other Steam-related data through the official Steam Web API.
---

# Steam Web API Skill

This skill helps you interact with the Steam Web API to retrieve user data, game information, player statistics, and more.

## Getting Started

To use the Steam Web API, you need an API key. Users can obtain one at: https://steamcommunity.com/dev/apikey

**Important:** The API key should be kept secret and never shared or committed to version control.

## API Request Format

The Steam Web API follows this URL structure:

```
https://api.steampowered.com/{interface}/{method}/{version}?{parameters}
```

- **Base URL:** `https://api.steampowered.com`
- **Interface:** The method group (e.g., `ISteamUser`, `ISteamApps`)
- **Method:** The specific endpoint (e.g., `GetPlayerSummaries`, `GetAppList`)
- **Version:** API version (usually `v1` or `v2`)
- **Parameters:** Query parameters including the API key

## Response Format

Responses are returned in JSON format by default. Other formats (`vdf`, `xml`) are available but JSON is preferred.

## Common Interfaces and Methods

### ISteamUser - User Information

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetPlayerSummaries` | Get user profile data | `steamids` (comma-separated) |
| `GetFriendList` | Get user's friends | `steamid`, `relationship` |
| `GetPlayerBans` | Get ban status | `steamids` |
| `GetUserGroupList` | Get user's groups | `steamid` |
| `ResolveVanityURL` | Convert vanity URL to SteamID | `vanityurl` |

### ISteamApps - Application Data

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetAppList` | List all apps/games | None |
| `GetAppInfo` | Get app details | `appids` |
| `UpToDateCheck` | Check version status | `appid`, `version` |
| `GetServersAtAddress` | Get servers at IP | `addr` |

### IPlayerService - Player Services

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetOwnedGames` | Get user's game library | `steamid`, `include_appinfo` |
| `GetRecentlyPlayedGames` | Recently played games | `steamid`, `count` |
| `GetSteamLevel` | Get user's Steam level | `steamid` |
| `GetBadges` | Get user's badges | `steamid` |

### ISteamNews - Game News

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetNewsForApp` | Get news for a game | `appid`, `count`, `maxlength` |

### ISteamUserStats - Game Statistics

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetGlobalAchievementPercentagesForApp` | Achievement stats | `gameid` |
| `GetPlayerAchievements` | User's achievements | `steamid`, `appid` |
| `GetUserStatsForGame` | User's game stats | `steamid`, `appid` |
| `GetSchemaForGame` | Game schema | `appid` |

### IDOTA2Match_570 - Dota 2 Match Data

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetMatchHistory` | Get match history | `account_id`, `matches_requested` |
| `GetMatchDetails` | Get match details | `match_id` |
| `GetLiveLeagueGames` | Live league games | `league_id` |
| `GetTeamInfoByTeamID` | Team information | `start_at_team_id` |

### IEconDOTA2_570 - Dota 2 Economy

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetHeroes` | Get hero list | `language` |
| `GetTournamentPrizePool` | Prize pool info | `leagueid` |
| `GetRarities` | Item rarities | `language` |

### ICSGOServers_730 - CS:GO Data

| Method | Description | Key Parameters |
|--------|-------------|----------------|
| `GetGameServersStatus` | Server status | None |

## API Key Handling

When making API requests:

1. **Request the key from the user** if not provided
2. **Never hardcode** the API key in scripts
3. **Use environment variables** or secure storage for the key
4. **Validate the key** is present before making requests

Example Python pattern:
```python
import os
import requests

STEAM_API_KEY = os.environ.get('STEAM_API_KEY')
if not STEAM_API_KEY:
    raise ValueError("STEAM_API_KEY environment variable not set")

url = f"https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key={STEAM_API_KEY}&steamids={steamid}"
response = requests.get(url)
data = response.json()
```

## Common Use Cases

### 1. Get User Profile Information
```
GET https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key={key}&steamids={steamid}
```

### 2. Get User's Game Library
```
GET https://api.steampowered.com/IPlayerService/GetOwnedGames/v1/?key={key}&steamid={steamid}&include_appinfo=true
```

### 3. Get Recently Played Games
```
GET https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1/?key={key}&steamid={steamid}&count=5
```

### 4. Resolve Vanity URL
```
GET https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key={key}&vanityurl={username}
```

### 5. Get Game News
```
GET https://api.steampowered.com/ISteamNews/GetNewsForApp/v2/?appid={appid}&count=5
```

### 6. Get Dota 2 Match History
```
GET https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1/?key={key}&account_id={account_id}&matches_requested=10
```

## Error Handling

Common HTTP status codes:
- `200` - Success
- `400` - Bad Request (invalid parameters)
- `401` - Unauthorized (invalid API key)
- `403` - Forbidden (rate limit or access denied)
- `404` - Not Found
- `429` - Too Many Requests (rate limited)
- `500` - Internal Server Error

## Rate Limiting

Steam Web API has rate limits. Best practices:
- Cache responses when possible
- Implement exponential backoff for retries
- Respect `Retry-After` headers
- Consider using Steam Web API key with higher limits for production

## References

For detailed API documentation, see `references/steam_api_reference.md` which contains the complete list of all available endpoints.

## References

- Steam Web API Documentation: https://steamwebapi.azurewebsites.net/
- Steam API Key Registration: https://steamcommunity.com/dev/apikey
- Official Steam Web API Wiki: https://developer.valvesoftware.com/wiki/Steam_Web_API
