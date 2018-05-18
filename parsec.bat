set BACKEND_URL=tcp://ec2-54-229-174-79.eu-west-1.compute.amazonaws.com:6777
set FUSE_LIBRARY_PATH=C:\Progra~2\WinFsp\bin\winfsp-x64.dll
mkdir %APPDATA%\parsec 2> nul
echo Starting parsec core >> %APPDATA%\parsec\parsec-core.log
start powershell -Command "Get-Content %APPDATA%\parsec\parsec-core.log -Wait"
start /b core\parsec.exe core --log-level=DEBUG --log-file %APPDATA%\parsec\parsec-core.log --I-am-John -A %BACKEND_URL%
timeout 1
gui\parsec-gui.exe
taskkill /im parsec.exe /f
