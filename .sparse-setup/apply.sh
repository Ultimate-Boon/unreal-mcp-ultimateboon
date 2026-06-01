#!/usr/bin/env bash
#
# Applies this fork's sparse-checkout layout to the current clone.
#
# Sparse-checkout settings live inside .git/ and are NOT copied by `git clone`,
# so each fresh clone must apply them once:
#
#     ./.sparse-setup/apply.sh
#
# Re-run any time you edit .sparse-setup/patterns.
#
# This only changes which tracked files are materialized on disk -- it never
# touches tracked content or history, so syncing from upstream stays conflict-free.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
root="$(git -C "$here" rev-parse --show-toplevel)"

git -C "$root" sparse-checkout init --no-cone
cp "$here/patterns" "$root/.git/info/sparse-checkout"
git -C "$root" sparse-checkout reapply

echo "Sparse-checkout layout applied to: $root"
echo "Excluded paths are now hidden from the working tree (see .sparse-setup/patterns)."
