#!/usr/bin/env bash
#
# sync-canonical.sh — keep Maintenance/S-LOOP-CANONICAL.md in step with the
# canonical S-Loop definition held in Workflowy (node a463d48d325f).
#
# It fetches the canonical node via the headless `claude` CLI (which carries the
# Workflowy MCP), compares it to the committed snapshot, and — on drift —
# re-extracts the snapshot and redrafts the reader-facing doc, then stages both.
#
# Modes:
#   sync-canonical.sh            Hook mode: fetch; on drift redraft + stage; never blocks.
#   sync-canonical.sh --check    Detect only: exit 3 on drift, 0 if in sync; writes nothing.
#   sync-canonical.sh --force    Redraft even with no drift (manual refresh).
#
# Escape hatch: set SLOOP_SKIP_CANONICAL_CHECK=1 to skip entirely (e.g. offline work).
#
set -uo pipefail

NODE_ID="a463d48d325f"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "sync-canonical: not in a git repo" >&2; exit 0; }
SRC_FILE="$REPO_ROOT/Maintenance/canonical/source.md"
HASH_FILE="$REPO_ROOT/Maintenance/canonical/source.sha256"
DOC_FILE="$REPO_ROOT/Maintenance/S-LOOP-CANONICAL.md"

MODE="${1:-hook}"

warn() { printf '\033[33m[sync-canonical] %s\033[0m\n' "$*" >&2; }
info() { printf '[sync-canonical] %s\n' "$*" >&2; }

_raw_sha256() {
  if command -v sha256sum >/dev/null 2>&1; then sha256sum "$1" | awk '{print $1}';
  else shasum -a 256 "$1" | awk '{print $1}'; fi
}

# Content hash that is invariant to sibling re-ordering. Workflowy's export does
# not guarantee a stable child order between calls, so hashing the raw markdown
# would flag drift on nearly every commit. We strip blank lines, trim leading
# indentation, sort, and hash the result — reordering yields the same multiset of
# lines (same hash), while any genuine text change alters a line (different hash).
_norm_sha256() {
  grep -v '^[[:space:]]*$' "$1" | sed 's/^[[:space:]]*//' | LC_ALL=C sort \
    | { if command -v sha256sum >/dev/null 2>&1; then sha256sum; else shasum -a 256; fi; } \
    | awk '{print $1}'
}

# Extracts the FIRST tool_result's text from a claude stream-json transcript on
# stdin. We read the raw MCP output directly instead of asking the model to retype
# it into a file — the model occasionally paraphrases a word when copying, which
# would show up as spurious drift. The raw tool_result is byte-stable across calls.
_PY_EXTRACT='
import sys, json
for line in sys.stdin:
    line = line.strip()
    if not line: continue
    try: ev = json.loads(line)
    except Exception: continue
    msg = ev.get("message") or {}
    content = msg.get("content")
    if isinstance(content, list):
        for b in content:
            if isinstance(b, dict) and b.get("type") == "tool_result":
                c = b.get("content")
                if isinstance(c, list):
                    for t in c:
                        if isinstance(t, dict) and t.get("type") == "text":
                            sys.stdout.write(t["text"]); sys.exit(0)
                elif isinstance(c, str):
                    sys.stdout.write(c); sys.exit(0)
'

# Fetch the canonical node as raw markdown into $1. Returns non-zero on any failure
# (missing CLI/python3, offline, empty result) so callers can degrade gracefully.
_fetch() {
  local out="$1"
  command -v claude  >/dev/null 2>&1 || { warn "no 'claude' CLI on PATH — skipping canonical check"; return 1; }
  command -v python3 >/dev/null 2>&1 || { warn "no python3 on PATH — skipping canonical check"; return 1; }
  rm -f "$out"
  ( cd "$REPO_ROOT" && claude -p "Call the mcp__workflowy__export_subtree tool once with node_id \"$NODE_ID\" and format \"markdown\", then reply DONE. Do not call any other tool or edit any file." \
      --allowedTools "mcp__workflowy__export_subtree" \
      --output-format stream-json --verbose </dev/null 2>/dev/null ) \
    | python3 -c "$_PY_EXTRACT" > "$out" 2>/dev/null
  [ -s "$out" ] || { warn "canonical fetch returned nothing (offline, or MCP unavailable) — skipping"; return 1; }
  return 0
}

# Redraft the reader doc from the current snapshot, preserving structure & style.
_redraft() {
  info "redrafting $DOC_FILE from updated canonical source…"
  ( cd "$REPO_ROOT" && claude -p "The canonical S-Loop definition changed upstream. Its raw exported source is at $SRC_FILE. Redraft the reader-facing document at $DOC_FILE so it faithfully reflects the new source. Preserve the GENERATED header comment, the attribution footer, the section on how this skill's SDD workflow maps onto the S-Loop, and the British-English technical-docs register (direct and exhaustive, no marketing language). Let the section structure follow the current source rather than the old document. Change only what the source changed. Read both files first, then overwrite $DOC_FILE with the Write tool. Output only DONE." \
    --allowedTools "Read,Write,Edit" \
    --permission-mode acceptEdits >/dev/null 2>&1 </dev/null )
}

[ "${SLOOP_SKIP_CANONICAL_CHECK:-0}" = "1" ] && { info "SLOOP_SKIP_CANONICAL_CHECK=1 — skipping"; exit 0; }

TMP="$REPO_ROOT/Maintenance/canonical/.fetch.$$"; trap 'rm -f "$TMP"' EXIT
mkdir -p "$(dirname "$TMP")"

case "$MODE" in
  --check)
    _fetch "$TMP" || exit 0            # offline / no CLI → treat as "in sync", don't block
    new="$(_norm_sha256 "$TMP")"; old="$(cat "$HASH_FILE" 2>/dev/null || echo none)"
    if [ "$new" = "$old" ]; then info "canonical in sync"; exit 0; fi
    warn "canonical S-Loop has DRIFTED from Maintenance/S-LOOP-CANONICAL.md — run: Maintenance/sync-canonical.sh --force"
    exit 3
    ;;
  --force)
    _fetch "$TMP" || { warn "cannot fetch canonical — aborting force sync"; exit 1; }
    mkdir -p "$(dirname "$SRC_FILE")"
    cp "$TMP" "$SRC_FILE"; _norm_sha256 "$SRC_FILE" > "$HASH_FILE"
    _redraft || warn "redraft step failed — snapshot updated, review $DOC_FILE manually"
    info "forced sync complete"
    exit 0
    ;;
  hook)
    _fetch "$TMP" || exit 0            # offline / no CLI → never block the commit
    new="$(_norm_sha256 "$TMP")"; old="$(cat "$HASH_FILE" 2>/dev/null || echo none)"
    [ "$new" = "$old" ] && exit 0      # in sync → nothing to do
    warn "canonical S-Loop changed upstream — re-extracting snapshot and redrafting doc"
    mkdir -p "$(dirname "$SRC_FILE")"
    cp "$TMP" "$SRC_FILE"; echo "$new" > "$HASH_FILE"
    _redraft || warn "redraft failed — snapshot updated; review $DOC_FILE before pushing"
    git add "$SRC_FILE" "$HASH_FILE" "$DOC_FILE" 2>/dev/null || true
    info "updated + staged: source.md, source.sha256, S-LOOP-CANONICAL.md (this commit now includes them)"
    exit 0
    ;;
  *)
    echo "usage: sync-canonical.sh [--check | --force]" >&2; exit 2 ;;
esac
