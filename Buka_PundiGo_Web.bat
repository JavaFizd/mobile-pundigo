@echo off
title PundiGo! Web Server
color 0A
cd /d "%~dp0"

echo ===================================================
echo     MEMULAI SERVER WEB PUNDIGO (PORT 7700)
echo ===================================================
echo.
echo Sedang membuka browser ke http://localhost:7700 ...
echo.

start "" "http://localhost:7700"

echo Server sedang aktif terus-menerus.
echo JANGAN TUTUP jendela hitam ini agar link http://localhost:7700
echo bisa terus dibuka kapan saja di browser Anda.
echo ===================================================
echo.

python serve_nocache.py
pause

