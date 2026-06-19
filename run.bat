@echo off
setlocal enabledelayedexpansion

set "FILE=main.lua"
set "LUA=.\lua55.exe"
set "LAST_MOD="

echo Watching %FILE% for changes... (Ctrl+C to stop)
echo.

:loop
for %%F in (%FILE%) do set "CURR_MOD=%%~tF"

if "!CURR_MOD!" neq "!LAST_MOD!" (
    if defined LAST_MOD (
        echo [CHANGED] Running %FILE%...
        echo.
    ) else (
        echo [START] Running %FILE%...
        echo.
    )
    %LUA% %FILE%
    echo.
    echo --- Done. Waiting for changes... ---
    echo.
    set "LAST_MOD=!CURR_MOD!"
)

timeout /t 1 /nobreak >nul
goto loop
