# Contributing to STEMcoding

Thanks for your interest in contributing! This document explains how to set up
your environment and submit changes.

## Getting set up

Follow the "Getting started" instructions in the [README](README.md) to run the
app under Docker. Confirm the test suite passes before you start:

```bash
docker compose run --rm -e RAILS_ENV=test runner bin/rails db:create db:schema:load
docker compose run --rm -e RAILS_ENV=test runner bundle exec rspec
```

## Making changes

1. Fork the repository and create a topic branch from the default branch.
2. Make your change with tests. New behavior should come with specs.
3. Run the checks locally — they must pass in CI:
   ```bash
   docker compose run --rm runner bundle exec rubocop
   docker compose run --rm runner bundle exec brakeman
   docker compose run --rm -e RAILS_ENV=test runner bundle exec rspec
   ```
4. Keep changes focused; write a clear commit message and PR description
   explaining the motivation.

## Guidelines

- Match the style of the surrounding code; RuboCop enforces the baseline.
- Do not commit secrets. `config/master.key`, `.env`, and anything under
  `public/uploads` are git-ignored and must stay that way.
- Avoid committing real user data or personally identifying information in
  seeds, fixtures, or tests — use `Faker` / example.com addresses.

## Reporting bugs

Open an issue describing the problem, steps to reproduce, and expected vs.
actual behavior. For security-sensitive reports, follow [SECURITY.md](SECURITY.md)
instead of opening a public issue.

By contributing, you agree that your contributions are licensed under the
project's [LICENSE](LICENSE).
