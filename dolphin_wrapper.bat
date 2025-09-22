@echo off
REM ==================================================
REM Dolphin Launcher Wrapper
REM Copies ROM to cache and launches Dolphin
REM ==================================================

setlocal enabledelayedexpansion

REM === Configuration ===
set "CACHE_DIR=C:\Users\Public\Documents\DolphinCache"
set "DOLPHIN_EXE=C:\Users\Public\Documents\Dolphin\Dolphin.exe"

REM === ROM path from Playnite argument ===
set "ROM=%~1"
if "%ROM%"=="" (
    echo ERROR: No ROM path provided.
    exit /b
)

REM Get the base name of the ROM (without path)
for %%F in ("%ROM%") do set "BASENAME=%%~nF"

REM Local cached ROM path
set "LOCAL_ROM=%CACHE_DIR%\%BASENAME%%~x1"

echo ==========================================
echo Launching Dolphin: %BASENAME%
echo Source ROM: %ROM%
echo Cache location: %LOCAL_ROM%
echo ==========================================

REM Create cache directory if it doesn't exist
if not exist "%CACHE_DIR%" (
    echo Creating cache directory: %CACHE_DIR%
    mkdir "%CACHE_DIR%"
)

REM Copy ROM to cache if it doesn't exist or is newer
set "COPY_REQUIRED=0"
if not exist "%LOCAL_ROM%" (
    set "COPY_REQUIRED=1"
) else (
    for %%F in ("%ROM%") do set "SOURCE_TIME=%%~tF"
    for %%F in ("%LOCAL_ROM%") do set "CACHE_TIME=%%~tF"
    if not "%SOURCE_TIME%"=="%CACHE_TIME%" set "COPY_REQUIRED=1"
)

if "%COPY_REQUIRED%"=="1" (
    echo Copying ROM to cache...
    copy /Y "%ROM%" "%LOCAL_ROM%"
) else (
    echo ROM already up-to-date in cache.
)

REM Update .lastplayed marker
echo Updating last played marker...
type nul > "%LOCAL_ROM%.lastplayed"

echo Launching Dolphin...
"%DOLPHIN_EXE%" --exec="%LOCAL_ROM%" --batch
