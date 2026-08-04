# STEMcoding

STEMcoding is a learning management system (LMS) for teaching coding. Teachers
create courses and programming labs; students write and submit code in an
in-browser editor and run [p5.js](https://p5js.org) / Processing sketches
directly in the browser.

This is the STEMcoding learning management system, originally developed by
Lilith Daemon with improvements by Kurt Mueller. The STEMcoding project is led by
Prof. Chris Orban (orban@physics.osu.edu) at The Ohio State University.

## Features

- **Roles**: student, teacher, super-teacher, and admin, each with its own area.
- **Courses & enrollment**: course creation, enrollment, signups, and cloneable
  course templates.
- **Programming labs**: assign coding labs (with starter/support files) to
  courses.
- **Submissions & grading**: students submit code; teachers grade via a
  gradebook.
- **In-browser IDE**: an Ace-based editor for writing and submitting code.
- **p5.js player**: runs student sketches in-browser on a dedicated subdomain.

## Tech stack

- Ruby on Rails 7.2 (Ruby 3.4.10), PostgreSQL, Redis + Sidekiq
- Devise (auth) + Pundit (authorization)
- Vite + Vue for the frontend; HAML views
- Docker / docker-compose for local development

## Getting started (Docker)

Prerequisites: Docker and Docker Compose. [DIP](https://github.com/bibendi/dip)
is optional but convenient.

```bash
# 1. Set up your secrets. The repo ships an encrypted credentials vault but not
#    its key. Create your own (see "Credentials" below):
rm -f config/credentials.yml.enc config/master.key
docker compose run --rm runner bin/rails credentials:edit   # fills in the schema

# 2. (Optional) copy environment defaults
cp .env.example .env

# 3. Build, set up the database (also seeds it), and boot
docker compose build
docker compose run --rm runner ./bin/setup
docker compose up
```

With DIP:

```bash
dip build
dip provision
dip compose up
```

Then open **http://localhost:3000** and sign in with the seeded admin:

- **Email:** `admin@example.com`
- **Password:** `password` (override with `SEED_ADMIN_PASSWORD`)

`bin/setup` creates and **seeds** the development database (admin/teacher
accounts plus sample courses and labs), so there's data to click through
immediately. Vite runs as its own service and hot-reloads assets.

### Subdomains (local)

The p5 "player" runs on its own subdomain and works out of the box at
`http://player.localhost:3000` (`*.localhost` resolves to 127.0.0.1). The
development environment sets `config.action_dispatch.tld_length = 0` so
`localhost` is treated as the domain and `player.localhost` parses to the
`player` subdomain — without that, the subdomain-constrained route would 404.
The subdomain prefixes per environment come from the credentials `subdomain:`
section.

## Credentials

Secrets are stored in Rails' encrypted credentials
(`config/credentials.yml.enc`), decrypted with `config/master.key` /
`RAILS_MASTER_KEY`. **The master key is not committed.** To run the app you
create your own vault following the schema in
[`credentials.sample`](credentials.sample):

```bash
docker compose run --rm runner bin/rails credentials:edit
```

Required keys: `database.<env>.name` (+ host/username/password when not using
`CONTAINERIZED`/`DATABASE_URL`), `redis.<env>.{url,password}`,
`secret_key_base`, and `subdomain.{app,player}.<env>`.

Non-secret runtime configuration is read from environment variables — see
[`.env.example`](.env.example).

## Seeding

```bash
docker compose run --rm runner bin/rails db:seed
```

In development this creates an admin (`admin@example.com`) whose password is
`SEED_ADMIN_PASSWORD` (default `password`) plus sample courses and labs.

## Running tests

```bash
docker compose run --rm -e RAILS_ENV=test runner bin/rails db:create db:schema:load
docker compose run --rm -e RAILS_ENV=test runner bundle exec rspec
```

Static analysis:

```bash
docker compose run --rm runner bundle exec rubocop
docker compose run --rm runner bundle exec brakeman
docker compose run --rm runner bundle exec bundle-audit check --update
```

CI runs all of the above through the same Docker image (see
[`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and
[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). To report a security issue, see
[SECURITY.md](SECURITY.md).

## License

Copyright (C) 2026 The STEMcoding project.

This program is free software: you can redistribute it and/or modify it under
the terms of the **GNU Affero General Public License** as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version. It is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the [LICENSE](LICENSE) file for the full text.

Bundled third-party components (p5.js, cocoon.js, TinyMCE, brand assets) retain
their own licenses — see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
