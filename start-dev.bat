@echo off
REM Flow Studio IDE Development Server Startup Script

cd /d "%~dp0"

echo.
echo ========================================
echo Flow Studio IDE - Dev Server
echo ========================================
echo.

set PATH=%CD%\node;%PATH%

echo Starting Vite dev server on http://localhost:3000/
echo.

npm run dev

pause
