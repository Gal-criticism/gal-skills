# Steam Web API Reference

> Source: https://steamwebapi.azurewebsites.net/
> This documentation is auto-updated every 24 hours with the latest state of the Steam Web API public endpoints.

## How to Make a Steam Web API Request

### Getting Started

In order to use the Steam Web API, you have to request a key here: https://steamcommunity.com/dev/apikey
This key acts as your secret identifier when making requests to the API, so don't lose or share it.

### Request URL format

```
https://{base_url}/{interface}/{method}/{version}?{parameters}
```

**Base URL:** Usually `https://api.steampowered.com`

**Sample request URL:**
```
http://api.steampowered.com/ISteamWebAPIUtil/GetSupportedAPIList/v1/
```

**Sample request URL with parameters:**
```
http://api.steampowered.com/ISteamWebAPIUtil/GetSupportedAPIList/v1/?key=1234567890&steamid=000123000456
```

### Response format

Responses to the requests can come in three different formats:
- `json` (default and preferred)
- `vdf`
- `xml`

### Sample request/response

**Request:**
```
https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key={key}&steamids=76561197960361544
```

**Response:**
```json
{
  "response": {
    "players": [
      {
        "steamid": "76561197960361544",
        "communityvisibilitystate": 3,
        "profilestate": 1,
        "personaname": "aro",
        "lastlogoff": 1447902060,
        "commentpermission": 1,
        "profileurl": "http://steamcommunity.com/id/aro/",
        "avatar": "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/1c/1cc16a968510ac7a3cf79bdae96c2c494e3e5e03.jpg",
        "avatarmedium": "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/1c/1cc16a968510ac7a3cf79bdae96c2c494e3e5e03_medium.jpg",
        "avatarfull": "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/1c/1cc16a968510ac7a3cf79bdae96c2c494e3e5e03_full.jpg",
        "personastate": 1,
        "realname": "The Dude",
        "primaryclanid": "103582791435784710",
        "timecreated": 1063378043,
        "personastateflags": 0,
        "gameextrainfo": "Dota 2",
        "gameid": "570",
        "loccountrycode": "US",
        "locstatecode": "FL",
        "loccityid": 928
      }
    ]
  }
}
```

---

## Complete API Endpoints Reference

### IClientStats_1046930

**ReportEvent** (v1)
```
POST https://api.steampowered.com/IClientStats_1046930/ReportEvent/v1
```

---

### ICSGOPlayers_730

**GetNextMatchSharingCode** (v1)
```
GET https://api.steampowered.com/ICSGOPlayers_730/GetNextMatchSharingCode/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | The SteamID of the user |
| steamidkey | string | Authentication obtained from the SteamID |
| knowncode | string | Previously known match sharing code |

---

### ICSGOServers_730

**GetGameMapsPlaytime** (v1)
```
GET https://api.steampowered.com/ICSGOServers_730/GetGameMapsPlaytime/v1
```
| Name | Type | Description |
|------|------|-------------|
| interval | string | day, week, month |
| gamemode | string | competitive, casual |
| mapgroup | string | operation |

**GetGameServersStatus** (v1)
```
GET https://api.steampowered.com/ICSGOServers_730/GetGameServersStatus/v1
```

---

### ICSGOTournaments_730

**GetTournamentFantasyLineup** (v1)
```
GET https://api.steampowered.com/ICSGOTournaments_730/GetTournamentFantasyLineup/v1
```
| Name | Type | Description |
|------|------|-------------|
| event | uint32 | The event ID |
| steamid | uint64 | The SteamID of the user inventory |
| steamidkey | string | Authentication obtained from the SteamID |

**GetTournamentItems** (v1)
```
GET https://api.steampowered.com/ICSGOTournaments_730/GetTournamentItems/v1
```
| Name | Type | Description |
|------|------|-------------|
| event | uint32 | The event ID |
| steamid | uint64 | The SteamID of the user inventory |
| steamidkey | string | Authentication obtained from the SteamID |

**GetTournamentLayout** (v1)
```
GET https://api.steampowered.com/ICSGOTournaments_730/GetTournamentLayout/v1
```
| Name | Type | Description |
|------|------|-------------|
| event | uint32 | The event ID |

**GetTournamentPredictions** (v1)
```
GET https://api.steampowered.com/ICSGOTournaments_730/GetTournamentPredictions/v1
```
| Name | Type | Description |
|------|------|-------------|
| event | uint32 | The event ID |
| steamid | uint64 | The SteamID of the user inventory |
| steamidkey | string | Authentication obtained from the SteamID |

---

### IDOTA2MatchStats_570

**GetRealtimeStats** (v1)
```
GET https://api.steampowered.com/IDOTA2MatchStats_570/GetRealtimeStats/v1
```
| Name | Type | Description |
|------|------|-------------|
| server_steam_id | uint64 | Server Steam ID |

---

### IDOTA2Match_570

**GetLiveLeagueGames** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetLiveLeagueGames/v1
```
| Name | Type | Description |
|------|------|-------------|
| league_id | uint32 | Only show matches of the specified league id |
| match_id | uint64 | Only show matches of the specified match id |
| dpc | bool | Only show matches that are part of the DPC |

**GetMatchDetails** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/v1
```
| Name | Type | Description |
|------|------|-------------|
| match_id | uint64 | Match id |
| include_persona_names | bool | Include persona names as part of the response |

**GetMatchHistory** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetMatchHistory/v1
```
| Name | Type | Description |
|------|------|-------------|
| hero_id | uint32 | The ID of the hero that must be in the matches |
| game_mode | uint32 | Which game mode to return matches for |
| skill | uint32 | Average skill range [1-3], lower is lower skill |
| min_players | string | Minimum number of human players |
| account_id | string | An account ID to get matches from |
| league_id | string | The league ID to return games from |
| start_at_match_id | uint64 | The minimum match ID to start from |
| matches_requested | string | Number of requested matches (max 100) |

**GetMatchHistoryBySequenceNum** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetMatchHistoryBySequenceNum/v1
```
| Name | Type | Description |
|------|------|-------------|
| start_at_match_seq_num | uint64 | Starting sequence number |
| matches_requested | uint32 | Number of matches to request |

**GetTeamInfoByTeamID** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetTeamInfoByTeamID/v1
```
| Name | Type | Description |
|------|------|-------------|
| start_at_team_id | uint64 | Starting team ID |
| teams_requested | uint32 | Number of teams to request |

**GetTopLiveEventGame** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetTopLiveEventGame/v1
```
| Name | Type | Description |
|------|------|-------------|
| partner | int32 | Which partner's games to use |

**GetTopLiveGame** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetTopLiveGame/v1
```
| Name | Type | Description |
|------|------|-------------|
| partner | int32 | Which partner's games to use |

**GetTopWeekendTourneyGames** (v1)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetTopWeekendTourneyGames/v1
```
| Name | Type | Description |
|------|------|-------------|
| partner | int32 | Which partner's games to use |
| home_division | int32 | Prefer matches from this division |

**GetTournamentPlayerStats** (v1, v2)
```
GET https://api.steampowered.com/IDOTA2Match_570/GetTournamentPlayerStats/v1
GET https://api.steampowered.com/IDOTA2Match_570/GetTournamentPlayerStats/v2
```
| Name | Type | Description |
|------|------|-------------|
| account_id | string | Account ID |
| league_id | string | League ID |
| hero_id | string | Hero ID |
| time_frame | string | Time frame |
| match_id | uint64 | Match ID |
| phase_id | uint32 | Phase ID (v2 only) |

---

### IDOTA2StreamSystem_570

**GetBroadcasterInfo** (v1)
```
GET https://api.steampowered.com/IDOTA2StreamSystem_570/GetBroadcasterInfo/v1
```
| Name | Type | Description |
|------|------|-------------|
| broadcaster_steam_id | uint64 | 64-bit Steam ID of the broadcaster |
| league_id | uint32 | LeagueID to use if we aren't in a lobby |

---

### IDOTA2Ticket_570

**GetSteamIDForBadgeID** (v1)
```
GET https://api.steampowered.com/IDOTA2Ticket_570/GetSteamIDForBadgeID/v1
```
| Name | Type | Description |
|------|------|-------------|
| BadgeID | string | The badge ID |

**SetSteamAccountPurchased** (v1)
```
POST https://api.steampowered.com/IDOTA2Ticket_570/SetSteamAccountPurchased/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | The 64-bit Steam ID |
| BadgeType | uint32 | Badge Type |

**SteamAccountValidForBadgeType** (v1)
```
GET https://api.steampowered.com/IDOTA2Ticket_570/SteamAccountValidForBadgeType/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | The 64-bit Steam ID |
| ValidBadgeType1-4 | uint32 | Valid Badge Types |

---

### IEconDOTA2_570

**GetEventStatsForAccount** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetEventStatsForAccount/v1
```
| Name | Type | Description |
|------|------|-------------|
| eventid | uint32 | The Event ID |
| accountid | uint32 | The account ID to look up |
| language | string | Language for hero names |

**GetHeroes** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v1
```
| Name | Type | Description |
|------|------|-------------|
| language | string | Language for hero names |
| itemizedonly | bool | Return itemized heroes only |

**GetItemCreators** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetItemCreators/v1
```
| Name | Type | Description |
|------|------|-------------|
| itemdef | uint32 | Item definition to get creator info |

**GetItemWorkshopPublishedFileIDs** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetItemWorkshopPublishedFileIDs/v1
```
| Name | Type | Description |
|------|------|-------------|
| itemdef | uint32 | Item definition to get published file ids |

**GetRarities** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetRarities/v1
```
| Name | Type | Description |
|------|------|-------------|
| language | string | Language for rarity names |

**GetTournamentPrizePool** (v1)
```
GET https://api.steampowered.com/IEconDOTA2_570/GetTournamentPrizePool/v1
```
| Name | Type | Description |
|------|------|-------------|
| leagueid | uint32 | ID of the league |

---

### IEconItems (Multiple Games)

**IEconItems_440 (Team Fortress 2)**
- `GetPlayerItems` - Get player's items
- `GetSchema` - Get item schema
- `GetSchemaItems` - Get schema items
- `GetSchemaOverview` - Get schema overview
- `GetSchemaURL` - Get schema URL
- `GetStoreMetaData` - Get store metadata
- `GetStoreStatus` - Get store status

**IEconItems_570 (Dota 2)**
- `GetPlayerItems` - Get player's items
- `GetStoreMetaData` - Get store metadata

**IEconItems_730 (CS:GO)**
- `GetPlayerItems` - Get player's items
- `GetSchema` (v2) - Get item schema
- `GetSchemaURL` (v2) - Get schema URL
- `GetStoreMetaData` - Get store metadata

---

### ISteamApps

**GetSDRConfig** (v1)
```
GET https://api.steampowered.com/ISteamApps/GetSDRConfig/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | AppID of game |

**GetServersAtAddress** (v1)
```
GET https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1
```
| Name | Type | Description |
|------|------|-------------|
| addr | string | IP or IP:queryport to list |

**UpToDateCheck** (v1)
```
GET https://api.steampowered.com/ISteamApps/UpToDateCheck/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | AppID of game |
| version | uint32 | The installed version |

---

### ISteamDirectory

**GetCMList** (v1)
```
GET https://api.steampowered.com/ISteamDirectory/GetCMList/v1
```
| Name | Type | Description |
|------|------|-------------|
| cellid | uint32 | Client's Steam cell ID |
| maxcount | uint32 | Max number of servers |

**GetCMListForConnect** (v1)
```
GET https://api.steampowered.com/ISteamDirectory/GetCMListForConnect/v1
```
| Name | Type | Description |
|------|------|-------------|
| cellid | uint32 | Client's Steam cell ID |
| cmtype | string | CM type filter |
| realm | string | Steam Realm filter |
| maxcount | uint32 | Max servers to return |
| qoslevel | uint32 | Connection priority |

**GetSteamPipeDomains** (v1)
```
GET https://api.steampowered.com/ISteamDirectory/GetSteamPipeDomains/v1
```

---

### ISteamEconomy

**GetAssetClassInfo** (v1)
```
GET https://api.steampowered.com/ISteamEconomy/GetAssetClassInfo/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | Steam economy app |
| language | string | User's local language |
| class_count | uint32 | Number of classes |
| classid0 | uint64 | Class ID |
| instanceid0 | uint64 | Instance ID |

**GetAssetPrices** (v1)
```
GET https://api.steampowered.com/ISteamEconomy/GetAssetPrices/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | Steam economy app |
| currency | string | Currency to filter |
| language | string | User's local language |

---

### ISteamNews

**GetNewsForApp** (v1, v2)
```
GET https://api.steampowered.com/ISteamNews/GetNewsForApp/v1
GET https://api.steampowered.com/ISteamNews/GetNewsForApp/v2
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | AppID to retrieve news for |
| maxlength | uint32 | Maximum length for content |
| enddate | uint32 | Posts earlier than this date |
| count | uint32 | # of posts to retrieve (default 20) |
| feeds | string | Comma-separated feed names (v2) |
| tags | string | Comma-separated tags to filter |

---

### ISteamRemoteStorage

**GetCollectionDetails** (v1)
```
POST https://api.steampowered.com/ISteamRemoteStorage/GetCollectionDetails/v1
```
| Name | Type | Description |
|------|------|-------------|
| collectioncount | uint32 | Number of collections |
| publishedfileids[0] | uint64 | Collection ids |

**GetPublishedFileDetails** (v1)
```
POST https://api.steampowered.com/ISteamRemoteStorage/GetPublishedFileDetails/v1
```
| Name | Type | Description |
|------|------|-------------|
| itemcount | uint32 | Number of items |
| publishedfileids[0] | uint64 | Published file ids |

**GetUGCFileDetails** (v1)
```
GET https://api.steampowered.com/ISteamRemoteStorage/GetUGCFileDetails/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | Steam ID of user |
| ugcid | uint64 | UGC ID |
| appid | uint32 | AppID |

---

### ISteamUser

**CheckAppOwnership** (v1)
```
GET https://api.steampowered.com/ISteamUser/CheckAppOwnership/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| appid | uint32 | AppID to check |

**GetAppPriceInfo** (v1)
```
GET https://api.steampowered.com/ISteamUser/GetAppPriceInfo/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| apps | string | Comma-delimited list of appids |

**GetDeletedSteamIDs** (v1)
```
POST https://api.steampowered.com/ISteamUser/GetDeletedSteamIDs/v1
```

**GetFriendList** (v1)
```
GET https://api.steampowered.com/ISteamUser/GetFriendList/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| relationship | string | Relationship filter (all, friend) |

**GetPlayerBans** (v1)
```
GET https://api.steampowered.com/ISteamUser/GetPlayerBans/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamids | string | Comma-delimited list of SteamIDs |

**GetPlayerSummaries** (v1, v2)
```
GET https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v1
GET https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamids | string | Comma-delimited list of SteamIDs (max 100) |

**GetPublisherAppOwnership** (v1, v2, v3, v4)
```
GET https://api.steampowered.com/ISteamUser/GetPublisherAppOwnership/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| packageid | uint32 | Query for specific package |
| appid | uint32 | Query for specific app |

**GetPublisherAppOwnershipChanges** (v1)
```
GET https://api.steampowered.com/ISteamUser/GetPublisherAppOwnershipChanges/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| since_change_number | uint64 | Start at change number |
| max_results | uint32 | Max results |

**GetUserGroupList** (v1)
```
GET https://api.steampowered.com/ISteamUser/GetUserGroupList/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |

**GrantPackage** (v1)
```
POST https://api.steampowered.com/ISteamUser/GrantPackage/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| packageid | uint32 | Package to grant |
| ipaddress | string | IP address |
| third_party_key | string | Third party key |
| third_party_app_id | string | Third party app ID |

**ResolveVanityURL** (v1)
```
GET https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| vanityurl | string | Vanity URL to resolve |
| url_type | int32 | Type of vanity URL |

**RevokePackage** (v1)
```
POST https://api.steampowered.com/ISteamUser/RevokePackage/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| packageid | uint32 | Package to revoke |

---

### ISteamUserAuth

**AuthenticateUserTicket** (v1)
```
GET https://api.steampowered.com/ISteamUserAuth/AuthenticateUserTicket/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| appid | uint32 | AppID |
| ticket | string | Ticket from GetAuthSessionTicket |
| identity | string | Identity string |

---

### ISteamUserOAuth

**GetTokenDetails** (v1)
```
GET https://api.steampowered.com/ISteamUserOAuth/GetTokenDetails/v1
```
| Name | Type | Description |
|------|------|-------------|
| access_token | string | OAuth token |

---

### ISteamUserStats

**GetGlobalAchievementPercentagesForApp** (v1, v2)
```
GET https://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v1
GET https://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v2
```
| Name | Type | Description |
|------|------|-------------|
| gameid | uint64 | Game ID |

**GetGlobalStatsForGame** (v1)
```
GET https://api.steampowered.com/ISteamUserStats/GetGlobalStatsForGame/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | AppID |
| count | uint32 | Number of stats |
| name[0] | string | Stat name |
| startdate | uint32 | Start date |
| enddate | uint32 | End date |

**GetNumberOfCurrentPlayers** (v1)
```
GET https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1
```
| Name | Type | Description |
|------|------|-------------|
| appid | uint32 | AppID |

**GetPlayerAchievements** (v1)
```
GET https://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| appid | uint32 | AppID |
| l | string | Language |

**GetSchemaForGame** (v1, v2)
```
GET https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v1
GET https://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| appid | uint32 | AppID |
| l | string | Language |

**GetUserStatsForGame** (v1, v2)
```
GET https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v1
GET https://api.steampowered.com/ISteamUserStats/GetUserStatsForGame/v2
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| appid | uint32 | AppID |

**SetUserStatsForGame** (v1)
```
POST https://api.steampowered.com/ISteamUserStats/SetUserStatsForGame/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| appid | uint32 | AppID |
| count | uint32 | Number of stats |
| name[0] | string | Stat name |
| value[0] | uint32 | Stat value |

---

### ISteamWebAPIUtil

**GetServerInfo** (v1)
```
GET https://api.steampowered.com/ISteamWebAPIUtil/GetServerInfo/v1
```

**GetSupportedAPIList** (v1)
```
GET https://api.steampowered.com/ISteamWebAPIUtil/GetSupportedAPIList/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |

---

### IPlayerService

**GetOwnedGames** (v1)
```
GET https://api.steampowered.com/IPlayerService/GetOwnedGames/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| include_appinfo | bool | Include game info |
| include_played_free_games | bool | Include free games |
| appids_filter | uint32 | Filter by appids |
| include_free_sub | bool | Include free subscriptions |
| skip_unvetted_apps | bool | Skip unvetted apps |
| language | string | Language |
| include_extended_appinfo | bool | Include extended info |

**GetRecentlyPlayedGames** (v1)
```
GET https://api.steampowered.com/IPlayerService/GetRecentlyPlayedGames/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| count | uint32 | Number of games to return |

**GetSteamLevel** (v1)
```
GET https://api.steampowered.com/IPlayerService/GetSteamLevel/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |

**GetBadges** (v1)
```
GET https://api.steampowered.com/IPlayerService/GetBadges/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |

**GetCommunityBadgeProgress** (v1)
```
GET https://api.steampowered.com/IPlayerService/GetCommunityBadgeProgress/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| badgeid | int32 | Badge ID |

**IsPlayingSharedGame** (v1)
```
GET https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of user |
| appid_playing | uint32 | AppID currently playing |

**RecordOfflinePlaytime** (v1)
```
POST https://api.steampowered.com/IPlayerService/RecordOfflinePlaytime/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |
| ticket | string | Authentication ticket |
| play_sessions | {message} | Play sessions data |

---

### IGameServersService

**GetAccountList** (v1)
```
GET https://api.steampowered.com/IGameServersService/GetAccountList/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |

**CreateAccount** (v1)
```
POST https://api.steampowered.com/IGameServersService/CreateAccount/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| appid | uint32 | AppID |
| memo | string | Memo |

**DeleteAccount** (v1)
```
POST https://api.steampowered.com/IGameServersService/DeleteAccount/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of account |

**UpdateAccount** (v1)
```
POST https://api.steampowered.com/IGameServersService/UpdateAccount/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of account |
| appid | uint32 | AppID |
| memo | string | Memo |

**ResetLoginToken** (v1)
```
POST https://api.steampowered.com/IGameServersService/ResetLoginToken/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid | uint64 | SteamID of account |

**GetServerSteamIDsByIP** (v1)
```
GET https://api.steampowered.com/IGameServersService/GetServerSteamIDsByIP/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| server_ips | string | Server IPs |

**GetServerIPsBySteamID** (v1)
```
GET https://api.steampowered.com/IGameServersService/GetServerIPsBySteamID/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| server_steamids | string | Server SteamIDs |

---

### IEconService

**GetTradeHistory** (v1)
```
GET https://api.steampowered.com/IEconService/GetTradeHistory/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| max_trades | uint32 | Max trades |
| start_after_time | uint32 | Start after time |
| start_after_tradeid | uint64 | Start after trade ID |
| navigating_back | bool | Navigating back |
| get_descriptions | bool | Get descriptions |
| language | string | Language |
| include_failed | bool | Include failed |
| include_total | bool | Include total |

**GetTradeOffers** (v1)
```
GET https://api.steampowered.com/IEconService/GetTradeOffers/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| get_sent_offers | bool | Get sent offers |
| get_received_offers | bool | Get received offers |
| get_descriptions | bool | Get descriptions |
| language | string | Language |
| active_only | bool | Active only |
| historical_only | bool | Historical only |
| time_historical_cutoff | uint32 | Time cutoff |

**GetTradeOffer** (v1)
```
GET https://api.steampowered.com/IEconService/GetTradeOffer/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| tradeofferid | uint64 | Trade offer ID |
| language | string | Language |

**GetTradeOffersSummary** (v1)
```
GET https://api.steampowered.com/IEconService/GetTradeOffersSummary/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| time_last_visit | uint32 | Time last visit |

**DeclineTradeOffer** (v1)
```
POST https://api.steampowered.com/IEconService/DeclineTradeOffer/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| tradeofferid | uint64 | Trade offer ID |

**CancelTradeOffer** (v1)
```
POST https://api.steampowered.com/IEconService/CancelTradeOffer/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| tradeofferid | uint64 | Trade offer ID |

**GetTradeHoldDurations** (v1)
```
GET https://api.steampowered.com/IEconService/GetTradeHoldDurations/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| steamid_target | uint64 | User you are trading with |
| trade_offer_access_token | string | Token for non-friends |

---

### IStoreService

**GetAppList** (v1)
```
GET https://api.steampowered.com/IStoreService/GetAppList/v1
```
| Name | Type | Description |
|------|------|-------------|
| key | string | Access key |
| if_modified_since | uint32 | Return only items modified since |
| have_description_language | string | Filter by description language |
| include_games | bool | Include games |
| include_dlc | bool | Include DLC |
| include_software | bool | Include software |
| include_videos | bool | Include videos |
| include_hardware | bool | Include hardware |
| last_appid | uint32 | For continuations |
| max_results | uint32 | Max results (default 10k, max 50k) |

**GetGamesFollowed** (v1)
```
GET https://api.steampowered.com/IStoreService/GetGamesFollowed/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |

**GetGamesFollowedCount** (v1)
```
GET https://api.steampowered.com/IStoreService/GetGamesFollowedCount/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |

**GetRecommendedTagsForUser** (v1)
```
GET https://api.steampowered.com/IStoreService/GetRecommendedTagsForUser/v1
```
| Name | Type | Description |
|------|------|-------------|
| language | string | Language |
| country_code | string | Country code |
| favor_rarer_tags | bool | Favor rarer tags |

---

### IWishlistService

**GetWishlist** (v1)
```
GET https://api.steampowered.com/IWishlistService/GetWishlist/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |

**GetWishlistItemCount** (v1)
```
GET https://api.steampowered.com/IWishlistService/GetWishlistItemCount/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |

**GetWishlistSortedFiltered** (v1)
```
GET https://api.steampowered.com/IWishlistService/GetWishlistSortedFiltered/v1
```
| Name | Type | Description |
|------|------|-------------|
| steamid | uint64 | SteamID of user |
| context | {message} | Context |
| data_request | {message} | Data request |
| sort_order | {enum} | Sort order |
| filters | {message} | Filters |
| start_index | int32 | Start index |
| page_size | int32 | Page size |

---

## Steam App IDs (Common Games)

| Game | App ID |
|------|--------|
| Counter-Strike 2 | 730 |
| Dota 2 | 570 |
| Team Fortress 2 | 440 |
| Left 4 Dead 2 | 550 |
| Portal 2 | 620 |
| Half-Life 2 | 220 |
| Garry's Mod | 4000 |
| Rust | 252490 |
| PUBG | 578080 |
| Apex Legends | 1172470 |

---

## Additional Resources

- Steam Web API Documentation: https://steamwebapi.azurewebsites.net/
- Steam API Key Registration: https://steamcommunity.com/dev/apikey
- Valve Developer Wiki: https://developer.valvesoftware.com/wiki/Steam_Web_API
- SteamID Conversion: https://steamid.io/
