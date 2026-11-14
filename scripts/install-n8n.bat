@echo off
echo ========================================================
echo Installing n8n strictly on D:\ drive (Zero C: footprint)
echo ========================================================
set TEMP=D:\temp
set TMP=D:\temp
set npm_config_cache=D:\.npm-cache
set npm_config_prefix=D:\npm-global

if not exist "D:\temp" mkdir "D:\temp"
if not exist "D:\npm-global" mkdir "D:\npm-global"
if not exist "D:\.npm-cache" mkdir "D:\.npm-cache"

call npm install -g n8n
echo n8n installation finished.

