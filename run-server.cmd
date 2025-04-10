@echo off
setlocal enabledelayedexpansion

for /f "tokens=1,2 delims==" %%a in (.env) do (
    if "%%a"=="FXSERVER_EXE" set FXSERVER_EXE=%%b
)

%FXSERVER_EXE% +exec server.cfg
