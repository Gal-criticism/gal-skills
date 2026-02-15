#!/usr/bin/env python3
"""
Bangumi API Example Script

This script demonstrates how to make requests to the Bangumi API.
It provides examples of common API calls.

Usage:
    export BGM_TOKEN="your_access_token"
    python bangumi_api_example.py

Or pass the token as an argument:
    python bangumi_api_example.py --token "your_token"

API docs: https://bangumi.github.io/api/
Token: https://next.bgm.tv/demo/access-token
"""

import os
import sys
import argparse
import urllib.request
import urllib.error
import json
from typing import Optional, Dict, Any, List


class BangumiAPI:
    """Bangumi API v0 client."""

    BASE_URL = "https://api.bgm.tv"
    CALENDAR_URL = "https://api.bgm.tv/calendar"

    def __init__(self, access_token: str):
        """
        Initialize Bangumi API client.

        Args:
            access_token: Bangumi access token from https://next.bgm.tv/demo/access-token
        """
        if not access_token:
            raise ValueError("Access token is required. Get one at https://next.bgm.tv/demo/access-token")
        self.access_token = access_token

    def _make_request(self, url: str, method: str = "GET", data: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """
        Make a request to the API.

        Args:
            url: Full URL
            method: HTTP method
            data: JSON request body

        Returns:
            JSON response as dictionary
        """
        headers = {
            "Authorization": f"Bearer {self.access_token}",
            "User-Agent": "Bangumi-API-Example/1.0"
        }
        if method == "POST":
            headers["Content-Type"] = "application/json"
        else:
            headers["Accept"] = "application/json"

        req = urllib.request.Request(url, headers=headers, method=method)
        if data:
            req.data = json.dumps(data).encode("utf-8")

        try:
            with urllib.request.urlopen(req, timeout=30) as response:
                return json.loads(response.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            print(f"HTTP Error: {e.code} {e.reason}")
            raise

    def _get(self, path: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Make a GET request."""
        url = f"{self.BASE_URL}{path}"
        if params:
            query = "&".join(f"{k}={v}" for k, v in params.items() if v is not None)
            url += f"?{query}"
        return self._make_request(url)

    def _post(self, path: str, data: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
        """Make a POST request."""
        url = f"{self.BASE_URL}{path}"
        return self._make_request(url, method="POST", data=data)

    def get_calendar(self) -> List[Dict[str, Any]]:
        """
        Get broadcast calendar (no auth required).

        Returns:
            List of weekday items with anime information
        """
        req = urllib.request.Request(
            self.CALENDAR_URL,
            headers={"Accept": "application/json", "User-Agent": "Bangumi-API-Example/1.0"},
            method="GET"
        )
        with urllib.request.urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode("utf-8"))

    def get_me(self) -> Dict[str, Any]:
        """
        Get current user info.

        Returns:
            Current user data
        """
        return self._get("/v0/me")

    def get_user(self, username: str) -> Dict[str, Any]:
        """
        Get user info by username.

        Args:
            username: Username to query

        Returns:
            User data
        """
        return self._get(f"/v0/users/{username}")

    def search_subjects(self, keyword: str, sort: str = "match",
                        filter: Optional[Dict[str, Any]] = None,
                        limit: int = 10) -> Dict[str, Any]:
        """
        Search subjects (anime, manga, games, etc.).

        Args:
            keyword: Search keyword
            sort: Sort order (match, heat, rank, score)
            filter: Filter conditions
            limit: Number of results

        Returns:
            Search results
        """
        body = {"keyword": keyword, "sort": sort, "limit": limit}
        if filter:
            body["filter"] = filter
        return self._post("/v0/search/subjects", body)

    def search_characters(self, keyword: str, limit: int = 10) -> Dict[str, Any]:
        """
        Search characters.

        Args:
            keyword: Search keyword
            limit: Number of results

        Returns:
            Search results
        """
        return self._post("/v0/search/characters", {"keyword": keyword, "limit": limit})

    def search_persons(self, keyword: str, limit: int = 10) -> Dict[str, Any]:
        """
        Search persons.

        Args:
            keyword: Search keyword
            limit: Number of results

        Returns:
            Search results
        """
        return self._post("/v0/search/persons", {"keyword": keyword, "limit": limit})

    def get_subject(self, subject_id: int) -> Dict[str, Any]:
        """
        Get subject details by ID.

        Args:
            subject_id: Subject ID

        Returns:
            Subject data
        """
        return self._get(f"/v0/subjects/{subject_id}")

    def get_subjects(self, subject_type: int, limit: int = 10, offset: int = 0) -> Dict[str, Any]:
        """
        Browse subjects by type.

        Args:
            subject_type: Subject type (1=book, 2=anime, 3=music, 4=game, 6=real)
            limit: Number of results
            offset: Pagination offset

        Returns:
            Subjects list
        """
        return self._get("/v0/subjects", {"type": subject_type, "limit": limit, "offset": offset})

    def get_subject_characters(self, subject_id: int) -> List[Dict[str, Any]]:
        """
        Get characters for a subject.

        Args:
            subject_id: Subject ID

        Returns:
            List of characters
        """
        return self._get(f"/v0/subjects/{subject_id}/characters")

    def get_subject_persons(self, subject_id: int) -> List[Dict[str, Any]]:
        """
        Get related persons for a subject.

        Args:
            subject_id: Subject ID

        Returns:
            List of persons
        """
        return self._get(f"/v0/subjects/{subject_id}/persons")

    def get_subject_relations(self, subject_id: int) -> List[Dict[str, Any]]:
        """
        Get related subjects.

        Args:
            subject_id: Subject ID

        Returns:
            List of related subjects
        """
        return self._get(f"/v0/subjects/{subject_id}/relations")

    def get_subject_episodes(self, subject_id: int) -> Dict[str, Any]:
        """
        Get episodes for a subject.

        Args:
            subject_id: Subject ID

        Returns:
            Episodes data
        """
        return self._get(f"/v0/episodes/{subject_id}")

    def get_person(self, person_id: int) -> Dict[str, Any]:
        """
        Get person details by ID.

        Args:
            person_id: Person ID

        Returns:
            Person data
        """
        return self._get(f"/v0/persons/{person_id}")

    def get_character(self, character_id: int) -> Dict[str, Any]:
        """
        Get character details by ID.

        Args:
            character_id: Character ID

        Returns:
            Character data
        """
        return self._get(f"/v0/characters/{character_id}")

    def get_user_collections(self, username: str, status: Optional[str] = None,
                             limit: int = 10) -> Dict[str, Any]:
        """
        Get user's collection.

        Args:
            username: Username
            status: Filter by status (collect, wish, doing, on_hold, dropped)
            limit: Number of results

        Returns:
            Collection data
        """
        params = {"limit": limit}
        if status:
            params["status"] = status
        return self._get(f"/v0/users/{username}/collections", params)

    def get_index(self, index_type: str = "new", limit: int = 20) -> Dict[str, Any]:
        """
        Get index (new, hot, jk, tb).

        Args:
            index_type: Type (new, hot, jk, tb)
            limit: Number of results

        Returns:
            Index data
        """
        return self._get(f"/v0/index/{index_type}", {"limit": limit})


def main():
    parser = argparse.ArgumentParser(description="Bangumi API Example")
    parser.add_argument("--token", help="Bangumi access token (or set BGM_TOKEN env var)")
    parser.add_argument("--username", help="Username to query", default=None)
    parser.add_argument("--search", help="Search keyword", default="Clannad")
    args = parser.parse_args()

    token = args.token or os.environ.get("BGM_TOKEN")

    if not token:
        print("Error: Bangumi access token is required.")
        print("Get one at: https://next.bgm.tv/demo/access-token")
        print("\nUsage:")
        print("  export BGM_TOKEN='your_token'")
        print("  python bangumi_api_example.py")
        print("\nOr:")
        print("  python bangumi_api_example.py --token 'your_token' --search 'keyword'")
        sys.exit(1)

    bgm = BangumiAPI(token)

    print("=" * 50)
    print("Current User")
    print("=" * 50)
    try:
        me = bgm.get_me()
        print(f"Username: {me.get('username')}")
        print(f"ID: {me.get('id')}")
        print(f"Nickname: {me.get('nickname')}")
        username = me.get("username")
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

    print("\n" + "=" * 50)
    print("Broadcast Calendar")
    print("=" * 50)
    try:
        calendar = bgm.get_calendar()
        print(f"Weekdays: {len(calendar)}")
        for day in calendar[:2]:
            weekday = day.get("weekday", {})
            items = day.get("items", [])
            print(f"  {weekday.get('en')}: {len(items)} items")
    except Exception as e:
        print(f"Error: {e}")

    print("\n" + "=" * 50)
    print(f"Search Subjects: {args.search}")
    print("=" * 50)
    try:
        results = bgm.search_subjects(args.search, sort="rank", limit=5)
        print(f"Total: {results.get('total')}")
        for item in results.get("data", [])[:3]:
            print(f"  - {item.get('name')} ({item.get('name_cn')}) ID:{item.get('id')}")
    except Exception as e:
        print(f"Error: {e}")

    query_username = args.username or username
    print("\n" + "=" * 50)
    print(f"User Collections: {query_username}")
    print("=" * 50)
    try:
        collections = bgm.get_user_collections(query_username, limit=5)
        print(f"Total: {collections.get('total')}")
    except Exception as e:
        print(f"Error: {e}")

    print("\n" + "=" * 50)
    print("Subject Details: 100228")
    print("=" * 50)
    try:
        subject = bgm.get_subject(100228)
        print(f"Name: {subject.get('name')}")
        print(f"Name CN: {subject.get('name_cn')}")
        print(f"Type: {subject.get('type')}")
        rating = subject.get("rating", {})
        print(f"Rating: {rating.get('score')} ({rating.get('total')} votes)")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
