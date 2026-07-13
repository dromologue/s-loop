#!/usr/bin/env bash
#
# install-hooks.sh — point git at the Maintenance/hooks directory so the
# canonical-sync pre-commit hook runs on every commit.
#
set -euo pipefail
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

chmod +x Maintenance/hooks/* Maintenance/*.sh 2>/dev/null || true
git config core.hooksPath Maintenance/hooks

echo "Installed: core.hooksPath -> Maintenance/hooks/"
echo "The pre-commit hook now checks the canonical S-Loop on each commit."
echo "Skip a single commit's check with:  SLOOP_SKIP_CANONICAL_CHECK=1 git commit …"
echo "Force a manual refresh with:        Maintenance/sync-canonical.sh --force"
