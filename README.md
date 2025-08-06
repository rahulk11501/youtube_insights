# 📺 YouTube Channel Lookup – GraphQL API

A Rails 8 GraphQL-based backend to **search and fetch YouTube channel details** using YouTube Data API v3. Ideal for building analytics, discovery tools, or content research platforms.

---

## 🚀 Features

- 🔍 **Search Channels by Name/Keyword**
  - Returns basic info like title, channelId, description, and thumbnail.
- 🔐 **Create or Fetch Channel Lookup by**
  - `channelId`
  - `channelName`
  - `handle` (e.g., `@Google`)
  - Full or partial **YouTube URLs**
- 📦 **Caching with Smart Timestamping**
  - Skips re-fetching from YouTube if channel data was retrieved within the last 24 hours.
- 🧠 **Handles Errors Gracefully**
  - Includes detailed error messages and fallback handling.
- 🔁 **Idempotent Mutations**
  - Reuses existing `ChannelLookup` entries when possible.
- 🎞️ **Search YouTube Videos**
  - Query videos using a keyword and fetch summary info
- ➕ **Create or Fetch Video Details**
  - Input: `videoId`
  - Stores title, views, likes, comments, publish date, etc.
- 🔧 Built on **Ruby on Rails 8**, **GraphQL-Ruby**, and **YouTube API v3**
---

## 📦 Sample GraphQL Usage

### 🔍 Search Channels
```graphql
query {
  searchChannels(query: "Google Developers") {
    channelId
    title
    description
    thumbnailUrl
  }
}
```

### ➕ Create Channel Lookup (by channelId)
```graphql
mutation {
  createChannelLookup(channelId: "UC_x5XG1OV2P6uZZ5FSM9Ttw") {
    title
    subscriberCount
    lastFetchedAt
  }
}
```

### ➕ Create Channel Lookup (by YouTube handle or URL)
```graphql
mutation {
  createChannelLookup(handleOrUrl: "https://www.youtube.com/@Google") {
    title
    channelId
    viewCount
  }
}
```

### 🔍 Search Videos

```graphql
query {
  searchVideos(query: "Ruby on Rails") {
    videoId
    title
    thumbnailUrl
    publishedAt
  }
}
```

### ➕ Create Video Lookup
```graphql
mutation {
  createVideoLookup(videoId: "dQw4w9WgXcQ") {
    title
    viewCount
    likeCount
    publishedAt
  }
}
```

---
## 🗃️ Models

### `ChannelLookup`

Stores metadata like:

- `channel_id`
- `title`, `description`, `thumbnail_url`
- `subscriber_count`, `video_count`, `view_count`
- `last_fetched_at`

### `VideoLookup`

Stores metadata like:

- `video_id`
- `title`, `description`, `thumbnail_url`
- `published_at`
- `channel_id`, `channel_title`
- `view_count`, `like_count`, `comment_count`
- `last_fetched_at`
---

## ⚙️ Setup Instructions

- Project setup
```bash
bundle install
rails db:create db:migrate
```

- Set your YouTube API Key:

```bash
export YOUTUBE_API_KEY=your_api_key_here
```

- Run the server:

```bash
rails server
```

- Access GraphiQL (for testing GraphQL queries):

```
http://localhost:3000/graphiql
```