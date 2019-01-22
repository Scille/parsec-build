set FILE_PATH=C:\Users\Downloads\parsec_version_amd64.exe
set AUTHOR=Leblond
set DESCRIPTION=Parsec by Scille
set TIMESTAMP=http://time.certum.pl

EZSignIt\EZSignIt.exe /sn "%FILE_PATH%" /f "%AUTHOR%" /d "%DESCRIPTION%" /ts2 "%TIMESTAMP%"
