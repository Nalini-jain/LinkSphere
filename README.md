# LinkSphere — Enterprise URL & Analytics Engine

**Primary author and developer: Nalini Jain**

LinkSphere is a full-stack URL shortener with custom aliases, QR-code generation, Redis cache-aside redirection, and click analytics. The frontend uses React, Tailwind CSS and Recharts; the API uses Java 21 and Spring Boot; PostgreSQL stores mappings and click events; Redis accelerates alias resolution.

## Architecture

```text
Browser (React + Recharts)
        | REST /api
        v
Spring Boot API ---- ZXing QR PNG generation
   |         |
   |         +---- Async click event writer ---- PostgreSQL click_events
   |
   +---- URL service ---- Redis cache (alias -> destination)
                    \---- PostgreSQL on cache miss
```

### Redirect flow
1. `GET /api/{alias}` checks Redis key `linksphere:url:{alias}`.
2. A cache hit returns the destination without a PostgreSQL read.
3. A cache miss queries PostgreSQL, checks expiry, then populates Redis.
4. Click details are persisted asynchronously so analytics storage does not block the redirect response.

## Structure
- `backend/`: Spring Boot REST API, JPA entities, Redis cache, QR generation and analytics.
- `frontend/`: React dashboard, URL creation, QR preview/download and click chart.

## Requirements
Java 21+, Maven 3.9+, Node.js 20+, PostgreSQL 15+, Redis 7+.

## Run locally

Start infrastructure:

```bash
docker compose up -d
```

Or run PostgreSQL and Redis separately. Default local DB credentials are `linksphere` / `linksphere`.

Start the API:

```bash
cd backend
mvn spring-boot:run
```

Start the frontend in another terminal:

```bash
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`. Set `VITE_API_BASE_URL` if the API is hosted somewhere other than `http://localhost:8080/api`.

## API

| Method | Endpoint | Description |
|---|---|---|
| POST | `/api/urls` | Create a short URL |
| GET | `/api/{alias}` | Redirect to destination |
| GET | `/api/urls/{alias}` | Read URL metadata |
| GET | `/api/urls/{alias}/qr?size=420` | Return QR PNG |
| GET | `/api/analytics/{alias}?days=30` | Total clicks and daily series |

Example request:

```json
{"originalUrl":"https://example.com/a/long/path","customAlias":"launch-2026"}
```

The custom alias is optional. Generated aliases are seven characters. Custom aliases accept 3–32 letters, numbers, underscores or hyphens. Only absolute HTTP(S) destinations are accepted.

## Production hardening

- Replace Hibernate `ddl-auto: update` with Flyway or Liquibase migrations.
- Use managed secrets and TLS; do not reuse development credentials.
- Add authentication, tenant ownership, authorization, abuse reporting, rate limiting and domain policies before public launch.
- The asynchronous analytics executor is in-process; a process crash can lose queued events. Use Kafka or RabbitMQ when durable event delivery is required.
- Add Redis failure handling/circuit-breaking, bot filtering, integration tests, load tests, metrics, tracing and structured logs.
- Analytics are bucketed in UTC. Add timezone-aware reporting where required.

## Author
Designed and implemented by **Nalini Jain**.
