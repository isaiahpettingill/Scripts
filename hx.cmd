
@echo off
REM Replace "C:\path\to\your\executable.exe" with the actual path
REM Or just use "executable.exe" if it's in the system PATH
REM or in the same directory as the batch script.

d:\source\helix\hx.exe %*

REM Optional: Preserve the exit code of the executable
exit /b %ERRORLEVEL%
