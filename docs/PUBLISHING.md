# Publishing checklist (private → public)

This is the operator runbook for cutting the public release. It contains the
steps that must be done **deliberately, at publish time** — chiefly rotating
secrets and squashing history — and are intentionally *not* automated, because
they are destructive and touch live secrets.

> The old private repository stays private. The public repo is a fresh,
> single-commit snapshot of the cleaned tree.

## 1. Rotate the credentials vault (fresh, separate from production)

The committed `config/credentials.yml.enc` is treated as compromised-by-exposure
(its key has lived on developer machines for years). Cut a brand-new vault for
the public repo that contains only placeholder / dev-safe values. Run inside the
container so tooling versions match:

```bash
# Remove the existing vault and key
rm -f config/credentials.yml.enc config/master.key

# Create a fresh vault (writes a new config/master.key). Populate ONLY with
# placeholder/dev-safe values using the schema in credentials.sample:
#   secret_key_base:  <output of `bin/rails secret`>
#   database.<env>.name, redis.<env>.{url,password}, subdomain.{app,player}.<env>
docker compose run --rm runner bin/rails credentials:edit
```

- Commit **only** the new `config/credentials.yml.enc`.
- The new `config/master.key` stays untracked (already git-ignored) and is
  **not** published. Public users generate their own on first run.

**Separately, for the real production deployment (do NOT publish):**
independently rotate production's `master.key`, `secret_key_base`, and any real
DB/Redis passwords, so the old vault/key becomes worthless everywhere it has
ever lived. Production and the public repo must never share a key.

## 2. Fill in the placeholders left for the maintainer

- `CODE_OF_CONDUCT.md` — replace `<INSERT CONTACT EMAIL>`.
- `SECURITY.md` — replace `<INSERT SECURITY CONTACT EMAIL>`.
- `LICENSE` — confirm the chosen license and copyright holder.

## 3. Verify the tree is clean

```bash
# Nothing sensitive is tracked (all should print nothing / be git-ignored):
git ls-files | grep -E 'master\.key|\.env$|public/uploads/|\.sqlite3$' || echo clean

# Scan for secrets before going public:
gitleaks detect --no-banner
```

Also confirm a fresh clone builds with **no** OSU/registry access (see the
verification section of `docs/OPEN_SOURCE_PLAN.md`).

## 4. Publish as a single commit (drop history)

History contains real student submission files (FERPA) and years of internal
data, so we do **not** push it.

```bash
# From a clean checkout of the finished tree:
rm -rf .git
git init
git add -A
git commit -m "Initial open-source release"
git branch -M main
git remote add origin git@github.com:<org>/<repo>.git
git push -u origin main
```

## 5. Post-publish

- Enable branch protection and the CI workflow on the new repo.
- Enable GitHub's private vulnerability reporting (referenced by `SECURITY.md`).
- Double-check the repo has no forks/mirrors of the old history.

## 6. Known follow-ups (tracked tech debt, not release-blocking)

Security-audit status at time of prep:
- **Ruby (`bundle-audit`): clean** — 0 advisories. All runtime-exposed CVEs
  were fixed (Rails 7.2.3.1, rack 3.2.6, nokogiri 1.19.4, net-imap 0.6.4.1,
  puma 8.0.2, devise 5.0.4, etc.).
- **JS (`npm audit`): 4 remaining, all build-time only** (not shipped to
  browsers/production): `vite`, `esbuild`, `picomatch`, `immutable`.
  (`yarn audit` itself is defunct in Yarn Classic — its endpoint returns 410;
  use `npm audit` via a generated package-lock, or a Yarn Berry / osv-scanner.)

Two larger framework upgrades clear the rest and are worth planning together:

1. **Rails 8 upgrade.** Rails 7.2 reaches end-of-support **2026-08-09**
   (flagged by brakeman). Plan the 7.2 → 8.0 migration before/soon after that.

2. **Vite 5 → 7 upgrade.** Clears the 4 remaining JS advisories (the flagged
   `vite <= 6.4.2` range cascades fixed `esbuild`/`rollup`/`picomatch`).
   Needs compatibility checks for `vite.config.mts`, `vite-plugin-ruby`,
   `vite-plugin-rails`, and the Vue plugin, plus verification that
   `bin/vite build` and the system specs still pass.
