# VNDB.org API v2 (Kana) Documentation

This document describes the HTTPS API to query information from the [VNDB](https://vndb.org/) database and manage user lists.

**API endpoint**: `https://api.vndb.org/kana`

A sandbox endpoint is available for testing and development at [https://beta.vndb.org/api/kana](https://beta.vndb.org/api/kana).

---

## Table of Contents

1. [Usage Terms](#usage-terms)
2. [Common Data Types](#common-data-types)
3. [User Authentication](#user-authentication)
4. [Simple Requests](#simple-requests)
5. [Database Querying](#database-querying)
6. [POST /vn](#post-vn)
7. [POST /release](#post-release)
8. [POST /producer](#post-producer)
9. [POST /character](#post-character)
10. [POST /staff](#post-staff)
11. [POST /tag](#post-tag)
12. [POST /trait](#post-trait)
13. [POST /quote](#post-quote)
14. [List Management](#list-management)
15. [HTTP Response Codes](#http-response-codes)
16. [Tips & Troubleshooting](#tips--troubleshooting)
17. [Change Log](#change-log)

---

## Usage Terms

This service is free for non-commercial use. The API is provided on a best-effort basis.

The data obtained through this API is subject to the [Data License](https://vndb.org/d17#4).

### Rate Limits

- Up to 200 requests per 5 minutes
- Up to 1 second of execution time per minute
- Requests taking longer than 3 seconds will be aborted

---

## Common Data Types

### vndbid

A 'vndbid' is an identifier for an entry in the database, typically formatted as a number with a one or two character prefix:
- `v17` - visual novel
- `c123` - character
- `r456` - release
- `p789` - producer
- `s101` - staff
- `g202` - tag
- `t303` - trait

### release date

Release dates are represented as JSON strings:
- `"YYYY-MM-DD"` - full date
- `"YYYY-MM"` - year and month
- `"YYYY"` - year only
- `"TBA"` - to be announced
- `"unknown"` - unknown date
- `"today"` - supported in filters

### enumeration types

Several fields use integer or string values with limited options. See the [schema JSON](https://api.vndb.org/kana/schema) for complete lists.

---

## User Authentication

Most endpoints work without authentication. User list management requires authentication.

### Token Authentication

1. Obtain a token from VNDB: Profile → Applications tab (or `https://vndb.org/u/tokens`)
2. Token format: `xxxx-xxxxx-xxxxx-xxxx-xxxxx-xxxxx-xxxx` (lowercase z-base-32)
3. Include in header: `Authorization: Token <token>`

Example:
```
Authorization: Token hsoo-ybws4-j8yb9-qxkw-5obay-px8to-bfyk
```

### Permissions

- `listread` - Read access to private labels and entries
- `listwrite` - Write access to user's visual novel list

---

## Simple Requests

### GET /schema

Returns metadata about API objects, including enumeration values and available fields.

### GET /stats

Returns database statistics.

```json
{
  "chars": 112347,
  "producers": 14789,
  "releases": 91490,
  "staff": 27929,
  "tags": 2783,
  "traits": 3115,
  "vn": 36880
}
```

### GET /user

Lookup users by ID or username.

Query parameters:
- `q` - User ID or username (can be given multiple times)
- `fields` - Additional fields to select

### GET /authinfo

Validates token and returns user information.

---

## Database Querying

### Query Format

All database queries use POST with a JSON body:

```json
{
  "filters": [],
  "fields": "",
  "sort": "id",
  "reverse": false,
  "results": 10,
  "page": 1,
  "user": null,
  "count": false,
  "compact_filters": false,
  "normalized_filters": false
}
```

### Response Format

```json
{
  "results": [],
  "more": false,
  "count": 1,
  "compact_filters": "",
  "normalized_filters": []
}
```

### Filters

Simple predicate: `["field", "operator", "value"]`

Operators: `=`, `!=`, `>=`, `>`, `<=`, `<`

Combine with `and`/`or`:
```json
["and", ["lang", "=", "en"], ["rating", ">", 80]]
```

### Filter Flags

| Flag | Description |
|------|-------------|
| o | Supports ordering operators |
| n | Accepts null as value |
| m | Single entry can match multiple values |
| i | Inverting filter != inverting selection |

---

## POST /vn

Query visual novel entries.

**Sort options**: `id`, `title`, `released`, `rating`, `votecount`, `searchrank`

### VN Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search on titles, aliases, release titles |
| `lang` | m | Language availability |
| `olang` | | Original language |
| `platform` | m | Platform availability |
| `length` | o | Play time estimate (1-5) |
| `released` | o,n | Release date |
| `rating` | o,i | Bayesian rating (10-100) |
| `votecount` | o | Number of votes |
| `has_description` | | Has description (value: 1) |
| `has_anime` | | Has anime (value: 1) |
| `has_screenshot` | | Has screenshots (value: 1) |
| `has_review` | | Has reviews (value: 1) |
| `devstatus` | | Development status (0=Finished, 1=In dev, 2=Cancelled) |
| `tag` | m | Tags applied |
| `dtag` | m | Direct tags only |
| `anime_id` | | AniDB anime ID |
| `label` | m | User labels |
| `release` | m | Match releases |
| `character` | m | Match characters |
| `staff` | m | Match staff |
| `developer` | m | Match developers |

### VN Fields

- `id` - vndbid
- `title` - Main title (romanized)
- `alttitle` - Alternative title (original script)
- `titles` - Array of all titles
- `aliases` - Array of aliases
- `olang` - Original language
- `devstatus` - Development status
- `released` - Release date
- `languages` - Available languages
- `platforms` - Available platforms
- `image` - Image object with `id`, `url`, `dims`, `sexual`, `violence`, `votecount`, `thumbnail`, `thumbnail_dims`
- `length` - Length estimate (1-5)
- `length_minutes` - Average play time
- `length_votes` - Number of play time votes
- `description` - Description (with formatting codes)
- `average` - Raw vote average
- `rating` - Bayesian rating
- `votecount` - Number of votes
- `screenshots` - Array of screenshot objects
- `relations` - Related VNs
- `tags` - Applied tags
- `developers` - Developer producers
- `editions` - Edition info
- `staff` - Staff members
- `va` - Voice actors
- `extlinks` - External links

---

## POST /release

Query release entries.

**Sort options**: `id`, `title`, `released`, `searchrank`

### Release Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search |
| `lang` | m | Language |
| `platform` | m | Platform |
| `released` | o | Release date |
| `resolution` | o,i | Image resolution [width, height] |
| `resolution_aspect` | o,i | Resolution with aspect ratio match |
| `minage` | o,n,i | Age rating (0-18) |
| `medium` | m,n | Medium type |
| `voiced` | n | Voiced status |
| `engine` | n | Engine |
| `rtype` | m | Release type (trial, partial, complete) |
| `extlink` | m | External link |
| `drm` | m | DRM implementation |
| `image` | m,n | Image type |
| `patch` | | Is patch (value: 1) |
| `freeware` | | Is freeware |
| `uncensored` | i | Is uncensored |
| `official` | | Is official |
| `has_ero` | | Has ero content |
| `vn` | m | Match VNs |
| `producer` | m | Match producers |

### Release Fields

- `id`, `title`, `alttitle`
- `languages` - Array with `lang`, `title`, `latin`, `mtl`, `main`
- `platforms` - Array of platform strings
- `media` - Array with `medium`, `qty`
- `vns` - Linked VNs with `rtype`
- `producers` - Array with `developer`, `publisher`
- `images` - Array of image objects
- `released` - Release date
- `minage` - Age rating
- `patch`, `freeware`, `uncensored`, `official`, `has_ero`
- `resolution` - [width, height] or "non-standard"
- `engine` - Engine name
- `voiced` - 1=not voiced, 2=ero only, 3=partial, 4=fully voiced
- `notes` - Notes
- `gtin` - JAN/EAN/UPC code
- `catalog` - Catalog number
- `extlinks` - External links

---

## POST /producer

Query producer entries.

**Sort options**: `id`, `name`, `searchrank`

### Producer Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search |
| `lang` | | Language |
| `type` | | Producer type |
| `extlink` | m | External link |

### Producer Fields

- `id`, `name`, `original`, `aliases`
- `lang` - Primary language
- `type` - "co" (company), "in" (individual), "ng" (amateur group)
- `description` - Description
- `extlinks` - External links

---

## POST /character

Query character entries.

**Sort options**: `id`, `name`, `searchrank`

### Character Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search |
| `role` | m | Character role |
| `blood_type` | | Blood type |
| `sex` | | Sex |
| `sex_spoil` | | Spoiler sex |
| `gender` | | Gender |
| `gender_spoil` | | Spoiler gender |
| `height` | o,n,i | Height in cm |
| `weight` | o,n,i | Weight in kg |
| `bust` | o,n,i | Bust in cm |
| `waist` | o,n,i | Waist in cm |
| `hips` | o,n,i | Hips in cm |
| `cup` | o,n,i | Cup size |
| `age` | o,n,i | Age |
| `trait` | m | Traits applied |
| `dtrait` | m | Direct traits only |
| `birthday` | n | [month, day] |
| `seiyuu` | m | Voice actor |
| `vn` | m | Match VNs |

### Character Fields

- `id`, `name`, `original`, `aliases`
- `description` - Description
- `image` - Image object
- `blood_type` - "a", "b", "ab", "o"
- `height`, `weight`, `bust`, `waist`, `hips` - Measurements
- `cup` - Cup size
- `age` - Age
- `birthday` - [month, day]
- `sex` - [apparent, real] (null, "m", "f", "b", "n")
- `gender` - [apparent, real] (null, "m", "f", "o", "a")
- `vns` - Array of VN appearances
- `traits` - Array of traits

---

## POST /staff

Query staff entries.

**Sort options**: `id`, `name`, `searchrank`

### Staff Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `aid` | | Alias ID |
| `search` | m | String search |
| `lang` | | Language |
| `gender` | | Gender |
| `role` | m | Staff role |
| `extlink` | m | External link |
| `ismain` | | Main alias only (value: 1) |

### Staff Fields

- `id`, `aid`, `ismain`, `name`, `original`
- `lang` - Primary language
- `gender` - "m" or "f"
- `description` - Description
- `extlinks` - External links
- `aliases` - Array of aliases

---

## POST /tag

Query tags.

**Sort options**: `id`, `name`, `vn_count`, `searchrank`

### Tag Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search |
| `category` | | Category |

### Tag Fields

- `id`, `name`, `aliases`
- `description` - Description
- `category` - "cont" (content), "ero" (sexual), "tech" (technical)
- `searchable` - Boolean
- `applicable` - Boolean
- `vn_count` - Number of VNs with this tag

---

## POST /trait

Query character traits.

**Sort options**: `id`, `name`, `char_count`, `searchrank`

### Trait Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `search` | m | String search |

### Trait Fields

- `id`, `name`, `aliases`
- `description` - Description
- `searchable` - Boolean
- `applicable` - Boolean
- `sexual` - Boolean
- `group_id`, `group_name` - Parent group
- `char_count` - Number of characters with this trait

---

## POST /quote

Query visual novel quotes.

**Sort options**: `id`, `score`

### Quote Filters

| Name | Flags | Description |
|------|-------|-------------|
| `id` | o | vndbid |
| `vn` | | Match VNs |
| `character` | | Match characters |
| `random` | | Random quote (value: 1) |

### Quote Fields

- `id`, `quote`, `score`
- `vn` - Visual novel info
- `character` - Character info

---

## List Management

### POST /ulist

Fetch user's visual novel list.

**Sort options**: `id`, `title`, `released`, `rating`, `votecount`, `voted`, `vote`, `added`, `lastmod`, `started`, `finished`, `searchrank`

### Ulist Fields

- `id` - VN ID
- `added`, `voted`, `lastmod` - Timestamps
- `vote` - Vote (10-100)
- `started`, `finished` - Dates
- `notes` - Notes
- `labels` - Array of labels
- `vn` - VN info
- `releases` - User's releases

### GET /ulist_labels

Fetch user's labels.

Query parameters:
- `user` - User ID (optional, defaults to authenticated user)
- `fields` - Additional fields

### PATCH /ulist/<id>

Add or update a VN in user's list.

Request body:
- `vote` - Integer 10-100
- `notes` - String
- `started`, `finished` - Dates
- `labels` - Array of label IDs (overwrites existing)
- `labels_set` - Array to add
- `labels_unset` - Array to remove

### PATCH /rlist/<id>

Add or update a release in user's list.

Request body:
- `status` - 0=Unknown, 1=Pending, 2=Obtained, 3=On loan, 4=Deleted

### DELETE /ulist/<id>

Remove VN from user's list.

### DELETE /rlist/<id>

Remove release from user's list.

---

## HTTP Response Codes

| Code | Meaning |
|------|---------|
| 200 | Success with JSON body |
| 204 | Success (DELETE/PATCH) |
| 400 | Invalid request |
| 401 | Invalid authentication token |
| 404 | Invalid API path or HTTP method |
| 429 | Rate limited |
| 500 | Server error |
| 502 | Server down |

---

## Tips & Troubleshooting

### "Too much data selected"

Select fewer fields or reduce results per page.

### List of Identifiers

Batch lookups in a single request:
```json
{
  "filters": ["or", ["id", "=", "v1"], ["id", "=", "v2"]],
  "results": 100
}
```

### Pagination

Use ID filtering instead of page parameter for better performance:
```json
{
  "filters": ["id", ">", "v123"],
  "fields": "title"
}
```

### Random Entry

1. Get highest ID
2. Pick random number
3. Query with `>=` filter

---

## Change Log

**2026-01-10**
- Add `image` filter to POST /release

**2025-06-02**
- Add `sexual` field to POST /trait

**2025-05-02**
- Limit maximum filter predicates to 1000

**2025-04-05**
- Add `gender` field to POST /character

**2025-01-11**
- Add `gender` and `gender_spoil` filters to POST /character

**2025-01-09**
- Add `extlink` filter and `extlinks` field to POST /producer

**2025-01-07**
- Add POST /quote

**2024-09-09**
- Add `images` field to POST /release

**2024-07-06**
- Add "n" (sexless) as sex value

**2024-06-05**
- Add `average` field to POST /vn

**2024-05-23**
- Add `extlinks` field to POST /vn

**2024-05-18**
- Add `va` field to POST /vn

**2024-05-11**
- Add `image{thumbnail,thumbnail_dims}` fields

**2024-03-13**
- Add POST /staff
- Add `editions` and `staff` fields to POST /vn

**2023-11-20**
- Add `relations` field to POST /vn

**2023-08-02**
- Add `developers` field to POST /vn

**2023-07-11**
- Deprecated `popularity` sort and filter

**2023-04-05**
- Add `searchrank` sort option

**2023-03-19**
- Add `voiced`, `gtin`, `catalog` fields to POST /release

**2023-01-17**
- Add `listwrite` permission
- Add PATCH /ulist/<id>, PATCH /rlist/<id>
- Add DELETE /ulist/<id>, DELETE /rlist/<id>
