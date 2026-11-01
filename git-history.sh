#!/usr/bin/env bash
# Author: Nalini Jain
# Generates an explicitly synthetic, backdated demo history.
# Do not represent these generated timestamps as actual development history.
set -euo pipefail
AUTHOR_NAME="Nalini Jain"
AUTHOR_EMAIL="nalini.jain@example.com"
export GIT_AUTHOR_NAME="$AUTHOR_NAME" GIT_AUTHOR_EMAIL="$AUTHOR_EMAIL"
export GIT_COMMITTER_NAME="$AUTHOR_NAME" GIT_COMMITTER_EMAIL="$AUTHOR_EMAIL"
if [[ -d .git ]]; then echo "Git repository already exists; refusing to rewrite history." >&2; exit 1; fi
git init
git config user.name "$AUTHOR_NAME"
git config user.email "$AUTHOR_EMAIL"
commit_at(){ local stamp="$1"; local msg="$2"; GIT_AUTHOR_DATE="$stamp" GIT_COMMITTER_DATE="$stamp" git commit -m "$msg" --allow-empty; }
git add README.md git-history.sh docker-compose.yml .gitignore
git commit -m "docs: add LinkSphere project overview and local setup" --date="2026-10-12T10:00:00"
git add backend/pom.xml backend/src/main/java/com/nalinijain/linksphere/LinkSphereApplication.java
commit_at "2026-10-13T14:20:00" "build: bootstrap Spring Boot service"
git add backend/src/main/java/com/nalinijain/linksphere/model backend/src/main/java/com/nalinijain/linksphere/repository
commit_at "2026-10-14T11:45:00" "feat: add URL and click persistence models"
git add backend/src/main/java/com/nalinijain/linksphere/dto backend/src/main/java/com/nalinijain/linksphere/service/UrlService.java
commit_at "2026-10-15T16:10:00" "feat: implement URL creation and Redis cache-aside resolution"
git add backend/src/main/java/com/nalinijain/linksphere/service/AnalyticsService.java backend/src/main/java/com/nalinijain/linksphere/config
commit_at "2026-10-16T13:30:00" "feat: persist click analytics asynchronously"
git add backend/src/main/java/com/nalinijain/linksphere/service/QrCodeService.java backend/src/main/java/com/nalinijain/linksphere/controller
commit_at "2026-10-18T10:15:00" "feat: expose redirect, QR and analytics endpoints"
git add backend/src/main/resources/application.yml backend/Dockerfile
commit_at "2026-10-20T15:00:00" "chore: configure runtime and container build"
git add frontend/package.json frontend/index.html frontend/tsconfig.json frontend/vite.config.ts frontend/tailwind.config.js frontend/postcss.config.js
commit_at "2026-10-21T12:25:00" "build: scaffold React dashboard"
git add frontend/src/types.ts frontend/src/services
commit_at "2026-10-22T17:40:00" "feat: add typed API client"
git add frontend/src/components/UrlForm.tsx
commit_at "2026-10-23T11:05:00" "feat: add link creation and QR preview"
git add frontend/src/components/Analytics.tsx
commit_at "2026-10-24T14:50:00" "feat: add click analytics chart"
git add frontend/src/App.tsx frontend/src/main.tsx frontend/src/styles.css
commit_at "2026-10-25T16:30:00" "feat: complete dashboard experience"
git add .
commit_at "2026-10-26T18:00:00" "docs: finalize LinkSphere project"
echo "Synthetic demonstration history generated. Inspect using git log --pretty=fuller."
