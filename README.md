# Vibecast

A full-stack web application that transforms a mood or moment into a personalized music recommendation. Users describe how they are feeling and receive a curated set of artists, tracks, and genres with AI-generated context for each match.

Built with Ruby on Rails, React, TypeScript, PostgreSQL, and the Anthropic API.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React, TypeScript, Vite |
| Backend | Ruby on Rails (API mode) |
| Database | PostgreSQL |
| AI | Anthropic Claude (Haiku) |
| Testing | RSpec, WebMock |

---

## Architecture Overview

Vibecast follows a decoupled frontend/backend architecture. The Rails API and React frontend run as separate processes and communicate over HTTP.

```
React (Vite)-> Rails API -> Anthropic API
                 |
                 v
             PostgreSQL
```

**Request flow:**

1. User submits a mood input from the React frontend
2. Rails validates the input and constructs a structured prompt
3. The Anthropic API returns a JSON array of recommendations
4. Rails parses the response and persists each recommendation as a structured row in PostgreSQL
5. The full session with recommendations is returned to the frontend

**Why structured rows over JSON blobs?**

Recommendations are stored as individual rows rather than a single JSON column. This allows the database to query by field — filtering favorites, sorting by genre, aggregating by artist — without application-level parsing. It also makes the data accessible to any future analytics or reporting layer.

**Data Model:**

```
VibeSession
  - id
  - mood_input: string
  - created_at

Recommendation
  - id
  - vibe_session_id (foreign key)
  - artist: string
  - track: string
  - genre: string
  - reason: string
  - favorite: boolean
  - created_at
```

**API Endpoints:**

```
GET    /api/v1/vibe_sessions           List all sessions
POST   /api/v1/vibe_sessions           Create session, trigger AI recommendation
GET    /api/v1/vibe_sessions/:id       Fetch session with recommendations
GET    /api/v1/recommendations         List all recommendations
GET    /api/v1/recommendations/favorites  List favorited recommendations
PATCH  /api/v1/recommendations/:id     Toggle favorite
```

---

## Setup

### Prerequisites

- Ruby 3.3+
- Rails 7+
- PostgreSQL
- Node 20+
- An [Anthropic API key](https://console.anthropic.com)

---

### Backend

```bash
cd vibecast/backend
bundle install
```

Create a `.env` file in `vibecast/backend/`:

```
DB_USERNAME=your_postgres_user
DB_PASSWORD=your_postgres_password
ANTHROPIC_API_KEY=your_anthropic_api_key
```

Set up the database:

```bash
rails db:create
rails db:migrate
```

Start the server:

```bash
rails s
```

The API runs on `http://localhost:3000`.

---

### Frontend

```bash
cd vibecast/frontend
npm install
npm run dev
```

The frontend runs on `http://localhost:5173`.

---

### Running Tests

```bash
cd vibecase/backend
bundle exec rspec
```

---

## Features

- Mood-to-music recommendations powered by Claude Haiku
- Favorite and unfavorite individual tracks
- Session history with expandable recommendation views
- Dedicated favorites page
- Responsive card grid with staggered animations