# Open-sourcing STEMcoding — Preparation Plan

## Context

STEMcoding is a Rails 7.2 LMS (in-browser code IDE, p5.js player, courses/labs/submissions/gradebook) that has lived in a **private** OSU repo since 2016 (~1,600 commits). The goal is to publish it publicly in a way that is **safe** (no leaked secrets or student PII) and **usable** (a stranger can clone it and get it running).

The current working tree is already in good shape on secrets — Rails encrypted credentials are used correctly, `config/master.key` is untracked, and there are **no hardcoded live secrets**. The real work is: (1) purge history-borne risk by starting from a clean tree, (2) remove real personal data and a private dependency, (3) genericize internal OSU infrastructure into configuration while **keeping the STEMcoding identity**, and (4) add the licensing/docs that make it a legitimate open-source project.

### Decisions locked with the user
- **History:** publish a **fresh repo with a single squashed commit** (old private repo stays private). This sidesteps the FERPA concern — student submission files were committed to `public/uploads` in the past (removed in `4fd3bd89`) and remain in history.
- **Branding:** **keep the STEMcoding / OSU identity**; only remove internal infra + secrets and make host/email values configurable.
- **Private gem + OSU navbar:** **completely remove** `osu-navbar-rails` (private `code.osu.edu` git source — breaks `bundle install`) *and* the OSU navbar itself — the helper call, the static partial, and its styles.
- **License:** undecided — plan recommends **MIT** (see step 6); easy to swap.

---

## Progress checklist

- [x] 0. Save this plan into the repo for tracking
- [x] 1. Scrub real PII from the tree — `db/seeds.rb`
- [x] 2. Completely remove the OSU navbar (gem + helper + partial + styles + npm package)
- [x] 3. Genericize internal infra → configuration (keep STEMcoding name)
- [x] 4. Rewrite the Docker configs so a public clone actually builds
- [x] 5. CI: replace stale GitLab CI with GitHub Actions running through Docker
- [ ] 6. Ship a brand-new credentials vault — **publish-time procedure**, see `docs/PUBLISHING.md`
- [x] 7. Add licensing + attribution — AGPL-3.0 LICENSE + THIRD_PARTY_NOTICES.md (© The STEMcoding project)
- [x] 8. Documentation for usability (README/CONTRIBUTING/CoC/SECURITY/.env.example)
- [ ] 9. Produce the clean publish tree — **publish-time procedure**, see `docs/PUBLISHING.md`

---

## Work items

### 0. Save this plan into the repo for tracking
Copy this plan to a tracked file in the repo (`docs/OPEN_SOURCE_PLAN.md`) so it's version-controlled and visible to collaborators. Do this first, then work through the items below, checking them off as they land.

### 1. Scrub real PII from the tree — `db/seeds.rb`
Real people are seeded as admins with a real weak dev password.
- Replace `mueller.128@osu.edu` / `orban.14@osu.edu` (lines 12–13) with generic seed accounts (e.g. `admin@example.com`, `teacher@example.com`).
- Replace the hardcoded dev password `"buckeye$"` (line 30) with an ENV-driven value defaulting to a clearly-fake dev password, e.g. `ENV.fetch("SEED_ADMIN_PASSWORD", "password")`.
- Also fix `spec/mailers/previews/course_lab_mailer_preview.rb:24` (`buckeye.614@osu.edu` → `example.com`).

### 2. Completely remove the OSU navbar (gem + helper + partial + styles)
Remove all four pieces so the app has no OSU navbar and no private dependency:
- **Gem:** delete `gem "osu-navbar-rails", git: "https://code.osu.edu/osu/osu-navbar-rails.git"` from `Gemfile:17`; run `bundle` to regenerate `Gemfile.lock` without it.
- **Helper call:** delete the `= osu_navbar` line at `app/views/shared/_header.html.haml:2`. The header keeps the app's own `shared/navbar` (line 4) and flash — only the OSU bar goes.
- **Partial:** delete the orphaned static copy `app/views/shared/_osu_navbar.html.haml` entirely.
- **Styles:** delete the gem-provided import at `app/assets/stylesheets/application.scss:17` (`@import "osu-navbar/white-responsive";`) — this path is served by the gem and will fail to compile once the gem is gone. Grep for any leftover `.osu-navbar` / `.osu-semantic` / `#osu_navbar` selectors and layout offsets that assumed the bar's height, and clean those up.

### 3. Genericize internal infra → configuration (keep STEMcoding name)
Move OSU-internal server/host/email values out of committed source into ENV/credentials with sane defaults. Files:
- **Deploy configs** — `config/deploy.rb` (private remote `git@code.osu.edu:asctech/...`), `config/deploy/production.rb`, `config/deploy/staging.rb` (real hostnames, `/var/www/...`, deploy user). These describe OSU-only infrastructure: **remove `config/deploy/*` and the Capistrano deploy plugins from `Capfile`/Gemfile**. The rebuilt Docker setup (step 4) becomes the supported run/deploy path.
- **Mailer host / SMTP** — `config/environments/production.rb:81–86` and `config/environments/staging.rb`: replace `smtp.asc.ohio-state.edu`, `stemcoding.osu.edu`, `stemcoding-s.asc.ohio-state.edu` with `ENV.fetch("SMTP_ADDRESS", ...)` / `ENV.fetch("APP_HOST", ...)` style config.
- **Mailer sender** — `config/initializers/devise.rb:23` (`no-reply@stemcoding.osu.edu`) → `ENV.fetch("MAILER_SENDER", "no-reply@example.com")`.
- **CSP** — `config/initializers/content_security_policy.rb`: the frame-ancestors list (`stemcoding.osu.edu`, `player.stemcoding.osu.edu`, `stemcoding-s.asc.ohio-state.edu`) should read from config/ENV so the player subdomain works on any host.
- **Subdomain routing** — `config/routes.rb:109` already reads from credentials; document those keys.
- Clean up: `app/mailers/development_email_interceptor.rb` (`dummyemail@osu.edu`), `app/mailers/staging_email_interceptor.rb` (commented list address), `app/views/p5_file_inline/show.html.haml:7` (`asctech@osu.edu`) — swap to example/config values.
- Delete commented Devise sample `secret_key`/`pepper` lines (`config/initializers/devise.rb:14`, `:106`) to avoid confusion.

### 4. Rewrite the Docker configs so a public clone actually builds
The current Docker setup **cannot build for the public** and is the reason the README's install flow is broken — it must be rewritten, not just verified:
- `Dockerfile:3` pulls the base image from the **private** registry `code.osu.edu:5000/asctech/docker/ruby` → public `docker-compose build` fails. Replace with a **public** base image (official `ruby:3.4.5` per `.ruby-version`, Debian-slim).
- Versions are stale and inconsistent with the app: `docker-compose.yml` args pin Ruby **2.6** / Node **12** / PG **11** (+ `postgres:11.1`, `redis:3.2`), but the app is **Rails 7.2 / Ruby 3.4.5 / Node 20** (`package.json` engines). Bump base image, Node (20.x), Postgres, and Redis to current supported versions.
- Frontend migrated to **Vite** but the compose files still wire up **Webpacker**: the `webpacker` service + `./bin/webpack-dev-server` (`docker-compose.yml:90-104`, `docker-compose.override.yml`) and `npm rebuild node-sass` (`Dockerfile:46`). Replace the `webpacker` service with a **vite** service (`bin/vite dev`, port 3036) matching `Procfile.dev`, and drop the `node-sass` rebuild.
- Rework the CentOS7/yum base (`rpm.nodesource.com/setup_12.x`, EL-7 pgdg, `yum`) into the Debian/apt equivalent for the new base image.
- Keep the non-sensitive local dev defaults already present (`DATABASE_URL: postgres://postgres:postgres@postgres`, `REDIS_URL`), and keep `docker-entrypoint.sh` (review it for OSU assumptions).
- Update `dip.yml` if its service names/commands reference `webpacker`.
- After the rewrite, re-verify the README's documented flow end-to-end (it's currently aspirational).

### 5. CI: replace stale GitLab CI with GitHub Actions that run through the new Docker setup
Yes — GitHub Actions works with the rewritten Docker configs, and we should deliberately wire it that way so CI **is** the proof that the public Docker flow builds and passes. Approach:
- Delete `.gitlab-ci.yml` (references internal registry `code.osu.edu:5000`, Slack `asctech-developers`, OSU deploy hosts, and a stale Ruby 2.7 / Node 12 / PG 11 stack).
- Add `.github/workflows/ci.yml` that, on push/PR, runs `docker compose build` then executes the existing analysis + test stack **inside the container via `docker compose run`** (`bundle-audit`, `brakeman`, `rubocop`, `rspec`), using the compose-provided `postgres` + `redis` services. Because CI uses the same `Dockerfile`/`docker-compose.yml` from step 4, runtime versions live in **one place** and can't drift between CI, dev, and the documented install — and a green build guarantees the public Docker path works.
- Use GitHub Actions layer caching (`docker/build-push-action` with `cache-from/to: gha`, or `actions/cache` on the buildx cache) so the image build doesn't rebuild from scratch each run — the main tradeoff of the compose-based approach.
- Provide a headless-browser path for system specs: run the compose `selenium`/Chrome service (already in the compose file) rather than the OSU `selenium/standalone-chrome-debug` image if that image tag is stale; update it to a current public Selenium image as part of step 4.
- (Alternative, if compose-in-CI proves too slow: a native `ruby/setup-ruby` + `actions/setup-node` workflow with Postgres/Redis `services:` containers, versions pinned from `.ruby-version`/`package.json`. Faster, but duplicates version config and does **not** verify the Docker build — so the compose-based approach is preferred for the "usable" goal.)

### 6. Ship a brand-new credentials vault in the open-sourced version (fully rotated)
The published repo must **not** contain the same `credentials.yml.enc`/`secret_key_base` that production uses — even though the ciphertext is encrypted and `master.key` never ships, we treat the current vault as compromised-by-exposure (the key has been on dev machines for years) and cut a completely fresh one for open source, separate from production.

**For the open-sourced repo:**
1. Delete the existing `config/credentials.yml.enc` and the local `config/master.key`.
2. Regenerate a fresh vault: `EDITOR=... bin/rails credentials:edit` creates a **new** `master.key` + empty `credentials.yml.enc`. Populate it only with **placeholder / dev-safe** values (blank or example DB/Redis creds), never real production secrets — the schema is documented in `credentials.sample`.
3. Generate a **new** `secret_key_base` (`bin/rails secret`) and store it in the fresh vault.
4. Commit only the new encrypted `config/credentials.yml.enc`; the new `master.key` stays untracked (already gitignored) and is **not** published. Public users generate their own key on first run.
5. Update `credentials.sample` if the schema changed.

**Separately, for the real production deployment (not published):** independently rotate production's `master.key`, `secret_key_base`, and any real DB/Redis passwords, so the old vault/key — wherever it has ever lived — becomes worthless. This is decoupled from the OSS vault above; the two must never share a key.

### 7. Add licensing + attribution
- Add a top-level **LICENSE** — recommend **MIT** (most common for education projects; permissive). Swap for Apache-2.0/AGPL-3.0/GPL-3.0 if preferred — this is a quick change, just the file text + any README badge.
- Add a **NOTICE / THIRD-PARTY / licenses** note for bundled third-party assets so their terms are honored:
  - `app/assets/javascripts/p5.min.js`, `p5_norandom.min.js` (modified variant), `p5_sound.min.js` — **p5.js is LGPL-2.1**; keep its license header/attribution. The `_norandom` modified copy must retain LGPL notice.
  - `app/javascript/vendor/cocoon.js` — MIT.
  - TinyMCE (`config/tinymce.yml`) — dual GPL/commercial; note it.
  - `processing3-logo.png` (Processing Foundation trademark) and `STEMcoding_v*.png/jpg` — confirm the project owns/has rights to publish the STEMcoding logos; leave Processing logo attribution.

### 8. Documentation for usability
- Rewrite **README.md**: keep the STEMcoding attribution (Lilith Daemon / Kurt Mueller / Prof. Chris Orban), add: what the app is, feature overview, tech stack, full local setup (Docker path: `docker-compose build` → `bin/setup` → `up`), required ENV vars / credentials keys, how to seed, how to run tests, and the p5 player-subdomain note.
- Add a `.env.example` documenting the newly-introduced ENV vars (APP_HOST, SMTP_*, MAILER_SENDER, SEED_ADMIN_PASSWORD, subdomain/player-host settings).
- Add **CONTRIBUTING.md** and **CODE_OF_CONDUCT.md** (Contributor Covenant).
- Add a `SECURITY.md` with a disclosure contact.

### 9. Produce the clean publish tree (final step, done at publish time)
Because we're squashing to a fresh repo:
- Verify none of these are tracked (confirmed currently untracked, re-check before publish): `config/master.key`, `.byebug_history`, `.env*`, `public/uploads/*`, `log/*`, `*.sqlite3`.
- Create the new public repo from the cleaned working tree as a **single initial commit**; do **not** push the old `.git` history.

---

## Verification

1. **Fresh-clone install works with no private access:** on a machine with **no OSU credentials/registry access**, clone the clean tree, generate a fresh `master.key`, and run the rewritten Docker flow (`docker-compose build && docker-compose run --rm runner ./bin/setup && docker-compose up rails`). Confirm the image builds from the **public** base image (no `code.osu.edu` pull), `bundle install` succeeds with the private gem removed, Vite assets build (not Webpacker), and the app boots at `localhost:3000`.
2. **Navbar removed cleanly:** load a page and confirm the OSU bar is gone, the app's own `shared/navbar` still renders, assets compile (no missing `osu-navbar/white-responsive` import, no undefined `osu_navbar` helper), and there's no leftover blank space/offset where the OSU bar used to sit.
3. **Seeds contain no real people:** run `rails db:seed` and confirm only generic accounts are created; grep the tree for `osu.edu`, `asc.ohio-state.edu`, `buckeye$`, `mueller.128`, `orban.14`, `code.osu.edu` and confirm only intentional attribution remains.
4. **Tests + analysis pass:** run `rspec`, `brakeman`, `bundle-audit`, `rubocop` (locally and via the new GitHub Actions workflow).
5. **Player subdomain / CSP** still functions with host values driven from config on a non-osu host.
6. **Secret sweep:** run a scanner (e.g. `gitleaks detect`) over the final single-commit tree to confirm zero findings before making the repo public.
