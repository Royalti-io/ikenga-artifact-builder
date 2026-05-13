# ikenga-artifact-builder

A Claude Code skill that teaches the agent to author **single-file HTML
artifacts** — dashboards, views, comparisons, mockups — that:

- Render standalone in any browser (claude.ai's artifact viewer included).
- Light up with live data when opened inside the [Ikenga](https://ikenga.dev) shell.
- Are easy to share, review, paste into chat, and iterate on.

Replaces `.md` for visual / interactive / data-bearing outputs.

## Install

### `npx skills` (recommended)

The [`skills`](https://skills.sh) CLI works with Claude Code, Codex,
Cursor, OpenCode, and 50+ other agents.

```bash
# Global install (recommended — available across all projects)
npx skills add royalti-io/ikenga-artifact-builder -g

# Project install (committed with your repo, shared with team)
npx skills add royalti-io/ikenga-artifact-builder
```

Target a specific agent if you have several configured:

```bash
npx skills add royalti-io/ikenga-artifact-builder -g -a claude-code
```

### Git clone

```bash
git clone https://github.com/royalti-io/ikenga-artifact-builder.git
cp -r ikenga-artifact-builder/skills/ikenga-artifact-builder ~/.claude/skills/
```

### Curl one-liner

```bash
curl -sSL https://raw.githubusercontent.com/royalti-io/ikenga-artifact-builder/main/install.sh | bash
```

The installer drops the skill into `~/.claude/skills/ikenga-artifact-builder/`
via symlink against a cached clone in `~/.cache/ikenga-skills/`, so
`git pull` is the update path.

## What you get

After install, in any Claude Code session, ask for a dashboard / view /
mockup and the agent will produce a self-contained HTML file that
opens in any browser. Inside the Ikenga shell, the same file lights
up with live data (Supabase, SQL, MCP, HTTP).

The skill ships with three worked references the agent uses as
structural templates:

| Reference | Sources | Purpose |
|-----------|---------|---------|
| `hello-world.html` | 1 (fetch) | Smallest valid artifact. ~150 lines. |
| `cfo-daily.html` | 4 (supabase + sql + fetch + file) | Financial dashboard with KPI tiles, AR aging, FX, cash-by-account. ~330 lines. |
| `ceo-overview.html` | 6 (all four types + cross-artifact links) | Exec digest. The shape most real artifacts take. ~470 lines. |

Open any reference in a browser — no build step.

## Skill spec

See [`skills/ikenga-artifact-builder/SKILL.md`](skills/ikenga-artifact-builder/SKILL.md)
for the full agent-facing spec: trigger rules, hard constraints,
single-file template, data-source types, refresh modes, CSP
compatibility, bridge API cheat sheet.

## License

[Apache-2.0](LICENSE). Copyright © 2026 Royalti.io.
