# Releasing @ikenga/skill-artifact-builder

> Contributing in general? See the org-wide [CONTRIBUTING guide](https://github.com/ikenga-hq/.github/blob/main/CONTRIBUTING.md) and [ikenga.dev/docs/contributing](https://ikenga.dev/docs/contributing). This file covers **releases** only.

## Versioning — Changesets

This package is **private** (distributed via `npx skills add`, not npm), but it
still uses [Changesets](https://github.com/changesets/changesets) to derive its
version + CHANGELOG. **Every PR that changes behaviour should include a changeset.**

```bash
npx changeset          # pick patch / minor / major + write a summary
git add .changeset
```

On merge to `main`, CI opens a **"chore: version packages"** PR that bumps the
version + updates `CHANGELOG.md`. Merging it lands the new version (no npm
publish). Don't hand-edit `version` manually — Changesets owns that now.
