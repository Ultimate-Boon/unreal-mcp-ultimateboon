# .sparse-setup — reproducible working-tree layout

This fork keeps the **full upstream content tracked** (so `git pull` from upstream
stays conflict-free), but trims the **working tree** to only the files this project
needs, using git's built-in *sparse-checkout*.

Sparse-checkout settings live inside `.git/` and are **not** copied by `git clone`,
so each clone must apply them once. This folder makes that a single command.

## Usage (run once after cloning)

**Windows (PowerShell):**

    powershell -ExecutionPolicy Bypass -File .sparse-setup\apply.ps1

**macOS / Linux:**

    ./.sparse-setup/apply.sh

After it runs, the excluded paths (see `patterns`) disappear from the working tree.
Re-run it any time you edit `patterns`.

## What gets excluded

See `patterns` (gitignore-style; last match wins). Currently:

- Everything under `MCPGameProject/` **except** the `Plugins/UnrealMCP/` plugin.
- `LaunchProject.bat`, `RebuildProject.bat`, `build_log.bat` — the upstream author's
  machine-specific build/launch helpers.

To exclude more, add `!/path` lines to `patterns`, commit, and re-run the script.

## Why this keeps upstream sync clean

Sparse-checkout only controls which tracked files are *materialized on disk* — it
never changes tracked content or history. Syncing from upstream merges normally;
excluded files are simply not written to disk. The only thing this fork adds on top
of upstream is this `.sparse-setup/` folder, which lives at a unique path and
therefore never conflicts.

> **Sync with `merge` / `rebase`, not `git reset --hard upstream/main`.** A hard
> reset would discard this folder's commit. For example:
>
>     git fetch upstream
>     git rebase upstream/main      # replays the .sparse-setup commit on top
>     powershell -File .sparse-setup\apply.ps1   # only if patterns changed
