# Deploy — Cloudflare Pages

The four reference artifacts are deployed to Cloudflare Pages so anyone
can preview them by clicking a link, no clone or build. Two paths to
set this up; pick one.

## Path 1 — Dashboard (recommended, one-time)

1. Cloudflare dashboard → **Workers & Pages → Create → Pages → Connect to Git**.
2. Authorise the **Royalti-io** GitHub account if Cloudflare hasn't seen it before.
3. Pick repo **`Royalti-io/ikenga-artifact-builder`**.
4. Build settings:
   - **Project name**: `ikenga-artifacts` (this becomes `ikenga-artifacts.pages.dev`)
   - **Production branch**: `main`
   - **Framework preset**: *None*
   - **Build command**: *(leave empty — pure static)*
   - **Build output directory**: `skills/ikenga-artifact-builder/references`
   - **Root directory**: *(leave at `/`)*
5. **Save and Deploy**. First deploy takes ~30 seconds.
6. After it goes green: **Custom domains → Set up a custom domain → `artifacts.ikenga.ai`** (requires `ikenga.ai` to be on Cloudflare DNS).

Every `git push origin main` after that auto-deploys.

## Path 2 — Wrangler CLI (one-shot, no GitHub integration)

```bash
npm i -g wrangler
wrangler login

wrangler pages deploy skills/ikenga-artifact-builder/references \
  --project-name=ikenga-artifacts \
  --branch=main
```

This skips the GitHub link and uploads from your local working tree.
Useful for the first deploy or for emergencies; the dashboard path is
the steady state.

## What gets served

Output dir contents:

```
hello-world.html
cfo-daily.html
ceo-overview.html
ikenga-symbol.html
index.html      ← /
_redirects      ← strips .html from URLs
_headers        ← cache + content-type headers
```

URL surface after deploy:

| URL | Serves |
|-----|--------|
| `https://ikenga-artifacts.pages.dev/` | index page listing all four artifacts |
| `https://ikenga-artifacts.pages.dev/hello-world` | rewrites to `hello-world.html` |
| `https://ikenga-artifacts.pages.dev/cfo-daily` | rewrites to `cfo-daily.html` |
| `https://ikenga-artifacts.pages.dev/ceo-overview` | rewrites to `ceo-overview.html` |
| `https://ikenga-artifacts.pages.dev/ikenga-symbol` | rewrites to `ikenga-symbol.html` |

After `artifacts.ikenga.ai` is bound, swap the host — paths are unchanged.

## Why not Workers / Workers Sites

This is pure static HTML. Pages is the right primitive — no edge logic,
no KV/R2 bindings, no auth. Workers would add complexity (a `worker.js`
that proxies static assets) without buying anything.

## Why not raw.githack.com

`raw.githack.com` works for spin-up but: (a) the URLs aren't ours, (b)
there's no analytics or 404 handling, (c) the host can rate-limit or
disappear without notice. Pages gives us `artifacts.ikenga.ai` —
forever — with auto-deploys from `main`.
