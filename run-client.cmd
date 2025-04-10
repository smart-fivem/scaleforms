@echo off
setlocal enabledelayedexpansion

for /f "tokens=1,2 delims==" %%a in (.env) do (
    if "%%a"=="FIVEM_EXE" set FIVEM_EXE=%%b
)

start /B %FIVEM_EXE% +connect localhost
