#Requires -Version 5.1
<#
  Applies this fork's sparse-checkout layout to the current clone.

  Sparse-checkout settings live inside .git/ and are NOT copied by `git clone`,
  so each fresh clone must apply them once:

      powershell -ExecutionPolicy Bypass -File .sparse-setup\apply.ps1

  Re-run any time you edit .sparse-setup\patterns.

  This only changes which tracked files are materialized on disk -- it never
  touches tracked content or history, so syncing from upstream stays conflict-free.
#>
$ErrorActionPreference = 'Stop'

$root = (git -C $PSScriptRoot rev-parse --show-toplevel 2>$null)
if (-not $root) { throw 'Not inside a git repository.' }
$root = $root.Trim()

git -C $root sparse-checkout init --no-cone
Copy-Item -Force -LiteralPath (Join-Path $PSScriptRoot 'patterns') `
    -Destination (Join-Path $root '.git/info/sparse-checkout')
git -C $root sparse-checkout reapply
if ($LASTEXITCODE -ne 0) { throw "git sparse-checkout reapply failed (exit $LASTEXITCODE)" }

Write-Host "Sparse-checkout layout applied to: $root" -ForegroundColor Green
Write-Host "Excluded paths are now hidden from the working tree (see .sparse-setup\patterns)."
