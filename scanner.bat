@echo off
title Mon Scanner Cyber
color 0A

:: 1. Demander l'IP à l'utilisateur
set /p target="Entrez l'IP a scanner (ex: 192.168.1.1) : "

echo.
echo [*] Verification de la cible %target%...
echo ------------------------------------------

:: 2. Test du Ping
ping -n 1 %target% | find "TTL=" >nul
if %errorlevel%==0 (
    echo [+] Cible EN LIGNE
) else (
    echo [-] Cible HORS LIGNE ou bloque le ping
    pause
    exit
)

echo.
echo [*] Scan des ports communs...
echo ------------------------------------------

:: 3. Test de ports basique (Via PowerShell car le Batch pur est limite pour les ports)
powershell -Command "22, 80, 443 | foreach { $t = New-Object System.Net.Sockets.TcpClient; $res = $t.BeginConnect('%target%', $_, $null, $null); $wait = $res.AsyncWaitHandle.WaitOne(500, $false); if($t.Connected){ Write-Host '[+] Port ' $_ ' : OUVERT' -ForegroundColor Green } else { Write-Host '[-] Port ' $_ ' : FERME' -ForegroundColor Red }; $t.Close() }"

echo.
echo Scan termine !
pause