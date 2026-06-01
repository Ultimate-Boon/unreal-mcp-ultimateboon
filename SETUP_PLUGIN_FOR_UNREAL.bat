@echo off
REM ============================================================================
REM  SETUP_PLUGIN_FOR_UNREAL.bat
REM
REM  Run this once after cloning the repo (double-click or run from a terminal).
REM  It applies the fork's sparse-checkout layout so the working tree contains
REM  only the files needed to build the plugin in Unreal -- the rest of the
REM  upstream game project is hidden from disk (but stays tracked, so pulling
REM  from upstream remains conflict-free). Safe to re-run any time.
REM
REM  Pass "nopause" as the first argument to skip the closing prompt
REM  (e.g. for automation):  SETUP_PLUGIN_FOR_UNREAL.bat nopause
REM ============================================================================
setlocal

echo Setting up the UnrealMCP plugin sparse-checkout layout...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.sparse-setup\apply.ps1"
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
    echo Done. The plugin files are ready for Unreal.
) else (
    echo SETUP FAILED ^(exit %RC%^). See the messages above.
)

if /I not "%~1"=="nopause" pause
exit /b %RC%
