set SENTRY_URL=https://863e60bbef39406896d2b7a5dbd491bb@sentry.io/1212848
set FUSE_LIBRARY_PATH=%programfiles(x86)%\WinFsp\bin\winfsp-x64.dll
mkdir %APPDATA%\parsec 2> nul
echo Starting parsec core >> "%APPDATA%"\parsec\parsec-core.log
start powershell -Command "Get-Content %APPDATA%\parsec\parsec-core.log -Wait"
core\parsec.exe core gui --log-level=INFO --log-file "%APPDATA%"\parsec\parsec-core.log
