@echo off

if [%1]==[] goto usage

set AUTHOR=Leblond
set DESCRIPTION=Parsec by Scille
set TIMESTAMP=http://time.certum.pl

EZSignIt\EZSignIt.exe /sn "%1" /f "%AUTHOR%" /d "%DESCRIPTION%" /ts2 "%TIMESTAMP%"

@echo Done.
goto :eof

:usage
@echo Usage: %0 ^<parsec_installer_absolute_file_path^>
exit /B 1