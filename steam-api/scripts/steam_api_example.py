#!/usr/bin/env python3
"""
Steam Web API Example Script

This script demonstrates how to make requests to the Steam Web API.
It handles API key management and provides examples of common API calls.

Usage:
    export STEAM_API_KEY="your_api_key_here"
    python steam_api_example.py

Or pass the API key as an argument:
    python steam_api_example.py --key "your_api_key_here"
"""

import os
import sys
import argparse
import requests
from typing import Optional, Dict, Any


class SteamAPI:
    """Steam Web API client."""

    BASE_URL = "https://api.steampowered.com"

    def __init__(self, api_key: str):
        """
        Initialize Steam API client.

        Args:
            api_key: Steam Web API key from https://steamcommunity.com/dev/apikey
        """
        if not api_key:
            raise ValueError("API key is required. Get one at https://steamcommunity.com/dev/apikey")
        self.api_key = api_key

    def _make_request(self, interface: str, method: str, version: str = "v1",
                      params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Make a request to the Steam Web API.

        Args:
            interface: API interface (e.g., "ISteamUser")
            method: API method (e.g., "GetPlayerSummaries")
            version: API version (default: "v1")
            params: Additional query parameters

        Returns:
            JSON response as dictionary
        """
        url = f"{self.BASE_URL}/{interface}/{method}/{version}/"

        # Add API key to params
        request_params = {"key": self.api_key}
        if params:
            request_params.update(params)

        try:
            response = requests.get(url, params=request_params, timeout=30)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error making request: {e}")
            raise

    def get_player_summaries(self, steamids: str) -> Dict[str, Any]:
        """
        Get player summaries for given Steam IDs.

        Args:
            steamids: Comma-separated list of Steam IDs (max 100)

        Returns:
            Player summaries data
        """
        return self._make_request(
            "ISteamUser",
            "GetPlayerSummaries",
            "v2",
            {"steamids": steamids}
        )

    def get_owned_games(self, steamid: str, include_appinfo: bool = True) -> Dict[str, Any]:
        """
        Get list of games owned by a user.

        Args:
            steamid: Steam ID of the user
            include_appinfo: Whether to include game info

        Returns:
            Owned games data
        """
        return self._make_request(
            "IPlayerService",
            "GetOwnedGames",
            "v1",
            {
                "steamid": steamid,
                "include_appinfo": str(include_appinfo).lower(),
                "include_played_free_games": "true"
            }
        )

    def get_recently_played_games(self, steamid: str, count: int = 5) -> Dict[str, Any]:
        """
        Get recently played games for a user.

        Args:
            steamid: Steam ID of the user
            count: Number of games to return

        Returns:
            Recently played games data
        """
        return self._make_request(
            "IPlayerService",
            "GetRecentlyPlayedGames",
            "v1",
            {"steamid": steamid, "count": count}
        )

    def get_steam_level(self, steamid: str) -> Dict[str, Any]:
        """
        Get Steam level for a user.

        Args:
            steamid: Steam ID of the user

        Returns:
            Steam level data
        """
        return self._make_request(
            "IPlayerService",
            "GetSteamLevel",
            "v1",
            {"steamid": steamid}
        )

    def resolve_vanity_url(self, vanityurl: str) -> Dict[str, Any]:
        """
        Resolve a vanity URL to a Steam ID.

        Args:
            vanityurl: Vanity URL name (e.g., "gaben")

        Returns:
            Vanity URL resolution data
        """
        return self._make_request(
            "ISteamUser",
            "ResolveVanityURL",
            "v1",
            {"vanityurl": vanityurl}
        )

    def get_friend_list(self, steamid: str, relationship: str = "friend") -> Dict[str, Any]:
        """
        Get friend list for a user.

        Args:
            steamid: Steam ID of the user
            relationship: Relationship filter ("all" or "friend")

        Returns:
            Friend list data
        """
        return self._make_request(
            "ISteamUser",
            "GetFriendList",
            "v1",
            {"steamid": steamid, "relationship": relationship}
        )

    def get_player_bans(self, steamids: str) -> Dict[str, Any]:
        """
        Get ban status for given Steam IDs.

        Args:
            steamids: Comma-separated list of Steam IDs (max 100)

        Returns:
            Player bans data
        """
        return self._make_request(
            "ISteamUser",
            "GetPlayerBans",
            "v1",
            {"steamids": steamids}
        )

    def get_global_achievement_percentages(self, gameid: int) -> Dict[str, Any]:
        """
        Get global achievement percentages for a game.

        Args:
            gameid: App ID of the game

        Returns:
            Achievement percentages data
        """
        return self._make_request(
            "ISteamUserStats",
            "GetGlobalAchievementPercentagesForApp",
            "v2",
            {"gameid": gameid}
        )

    def get_number_of_current_players(self, appid: int) -> Dict[str, Any]:
        """
        Get number of current players for a game.

        Args:
            appid: App ID of the game

        Returns:
            Current player count data
        """
        return self._make_request(
            "ISteamUserStats",
            "GetNumberOfCurrentPlayers",
            "v1",
            {"appid": appid}
        )

    def get_news_for_app(self, appid: int, count: int = 5, maxlength: int = 300) -> Dict[str, Any]:
        """
        Get news for an app.

        Args:
            appid: App ID
            count: Number of news items
            maxlength: Maximum length of content

        Returns:
            News data
        """
        return self._make_request(
            "ISteamNews",
            "GetNewsForApp",
            "v2",
            {"appid": appid, "count": count, "maxlength": maxlength}
        )


def main():
    parser = argparse.ArgumentParser(description="Steam Web API Example")
    parser.add_argument("--key", help="Steam API key (or set STEAM_API_KEY env var)")
    parser.add_argument("--steamid", help="Steam ID to query", default="76561197960361544")
    args = parser.parse_args()

    # Get API key from argument or environment
    api_key = args.key or os.environ.get("STEAM_API_KEY")

    if not api_key:
        print("Error: Steam API key is required.")
        print("Get one at: https://steamcommunity.com/dev/apikey")
        print("\nUsage:")
        print("  export STEAM_API_KEY='your_key'")
        print("  python steam_api_example.py")
        print("\nOr:")
        print("  python steam_api_example.py --key 'your_key' --steamid '76561197960361544'")
        sys.exit(1)

    # Initialize API client
    steam = SteamAPI(api_key)

    # Example: Get player summary
    print("=" * 50)
    print("Player Summary")
    print("=" * 50)
    try:
        summary = steam.get_player_summaries(args.steamid)
        players = summary.get("response", {}).get("players", [])
        if players:
            player = players[0]
            print(f"Steam ID: {player.get('steamid')}")
            print(f"Persona Name: {player.get('personaname')}")
            print(f"Profile URL: {player.get('profileurl')}")
            print(f"Avatar: {player.get('avatar')}")
            print(f"Status: {player.get('personastate')}")
        else:
            print("No player found")
    except Exception as e:
        print(f"Error: {e}")

    # Example: Get owned games count
    print("\n" + "=" * 50)
    print("Owned Games")
    print("=" * 50)
    try:
        games = steam.get_owned_games(args.steamid)
        game_count = games.get("response", {}).get("game_count", 0)
        print(f"Total games owned: {game_count}")
    except Exception as e:
        print(f"Error: {e}")

    # Example: Get Steam level
    print("\n" + "=" * 50)
    print("Steam Level")
    print("=" * 50)
    try:
        level = steam.get_steam_level(args.steamid)
        player_level = level.get("response", {}).get("player_level", 0)
        print(f"Steam Level: {player_level}")
    except Exception as e:
        print(f"Error: {e}")

    # Example: Get CS2 player count
    print("\n" + "=" * 50)
    print("CS2 Current Players")
    print("=" * 50)
    try:
        players = steam.get_number_of_current_players(730)  # CS2 App ID
        count = players.get("response", {}).get("player_count", 0)
        print(f"Current CS2 players: {count:,}")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
