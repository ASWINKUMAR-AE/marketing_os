@echo off
title ZetHub Marketing OS - n8n Automation Engine
echo ========================================================
echo        ZetHub Marketing OS - n8n Automation Engine
echo ========================================================
cd /d D:\marketing_os

set TEMP=D:\temp
set TMP=D:\temp
set npm_config_cache=D:\.npm-cache
set npm_config_prefix=D:\npm-global
set PATH=D:\npm-global;%PATH%

set GENERIC_TIMEZONE=Asia/Kolkata
set TZ=Asia/Kolkata
set N8N_USER_FOLDER=D:\marketing_os\n8n_data
set N8N_ENCRYPTION_KEY=zethub_secure_local_encryption_key_2026_madurai
set N8N_SECURE_COOKIE=false
set NODES_EXCLUDE=[]
set N8N_BLOCK_ENV_ACCESS_IN_NODE=false
set N8N_DEFAULT_BINARY_DATA_MODE=filesystem
set N8N_PORT=5678
set N8N_HOST=127.0.0.1

where n8n >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo n8n executable not found in D:\npm-global.
    echo Installing n8n now strictly on D:\ drive...
    call D:\marketing_os\scripts\install-n8n.bat
)

echo.
echo n8n storage configured strictly on D:\marketing_os\n8n_data
echo Opening http://localhost:5678 ...
echo.
call n8n start
pause
