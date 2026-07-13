# Maintenance

Everything in this directory is **upkeep apparatus** for the S-Loop skill — the
machinery that keeps the skill's understanding of the canonical S-Loop definition
current and versioned. **None of it is part of the installed skill.** A user of the
skill needs only the repository root: `SKILL.md`, `templates/`, `examples/`,
`README.md`, and `LICENSE`. This directory is for maintainers.

## What lives here

| Path | Purpose |
|------|---------|
| `S-LOOP-CANONICAL.md` | The reader-facing canonical definition of the S-Loop (SSSS). **Generated** — do not hand-edit; it is redrafted from the Workflowy source. |
| `canonical/source.md` | Raw markdown snapshot of the canonical Workflowy node (`a463d48d325f`). The byte the drift check compares against. |
| `canonical/source.sha256` | Normalised content hash of `source.md` (see below). |
| `sync-canonical.sh` | Fetches the canonical node, detects drift, and — on drift — re-extracts the snapshot and redrafts `S-LOOP-CANONICAL.md`. |
| `hooks/pre-commit` | Runs the drift check on every commit. |
| `install-hooks.sh` | Points `git config core.hooksPath` at `Maintenance/hooks`. |

## How the canonical stays in sync

The canonical S-Loop definition is authored in Workflowy, not here. The apparatus
keeps this repo's copy honest:

1. **On every commit**, the pre-commit hook runs `sync-canonical.sh hook`.
2. It fetches the node's current markdown via the headless `claude` CLI and the
   Workflowy MCP, reading the **raw tool result** out of `claude`'s stream-json
   (not the model's retyping of it, which is not byte-stable).
3. It compares a **normalised** hash — blank lines stripped, indentation trimmed,
   lines sorted — so that Workflowy re-ordering sibling nodes between fetches does
   not register as a change, while any genuine text edit does.
4. On drift it re-extracts `canonical/source.md`, redrafts `S-LOOP-CANONICAL.md`
   from it, updates the hash, and **stages all three into the current commit**.

The check **never blocks a commit**: offline, or with no `claude`/`python3` on
PATH, it degrades to a no-op.

## Commands

```bash
# One-time: activate the pre-commit hook in this clone
Maintenance/install-hooks.sh

# Detect drift without writing anything (exit 3 = drifted, 0 = in sync)
Maintenance/sync-canonical.sh --check

# Force a re-extract + redraft now (e.g. after editing the Workflowy node)
Maintenance/sync-canonical.sh --force

# Skip the check for a single commit
SLOOP_SKIP_CANONICAL_CHECK=1 git commit …
```

## Requirements

- `claude` CLI on PATH, configured with the Workflowy MCP (the `mcp__workflowy__*`
  tools). This is the only fetch path — there is no standalone API key in use.
- `python3` (extracts the raw tool result from the stream-json transcript).
- `git`. The hook is wired via `core.hooksPath`, so cloning the repo does **not**
  auto-install it — run `install-hooks.sh` once per clone.

## Changing the canonical definition

Edit the **Workflowy node** (`a463d48d325f`), not the files here. The next commit's
hook — or `sync-canonical.sh --force` — will pull the change through and redraft
`S-LOOP-CANONICAL.md`. Review the redraft's diff before pushing; the redraft is
machine-written prose.
