REM Extract Photos.sqlite
REM In: drag and drop an IOS FFS zip file to the script.
REM Out: Photos.sqlite-{wal,shm}
REM Version 1

@echo off

set PathTo7zip=C:\Program Files\7-Zip\7z.exe
set UnixPathToPhotosSqlite=/private/var/mobile/media/PhotoData/
set OutDir=_Photos.sqlite
set "FullOutPath=%cd%\%OutDir%\private\var\mobile\Media\PhotoData"

IF EXIST "%PathTo7zip%" (GOTO EXTRACT_FILES) ELSE (GOTO NOT_INSTALLED)

:EXTRACT_FILES
"%PathTo7zip%" x "%~1" -o"%OutDir%" %UnixPathToPhotosSqlite%Photos.Sqlite %UnixPathToPhotosSqlite%Photos.Sqlite-shm %UnixPathToPhotosSqlite%Photos.Sqlite-wal

echo Done. Now opening output folder %FullOutPath%
%SystemRoot%\explorer.exe %FullOutPath%
exit


:NOT_INSTALLED
echo 7zip not installed in default path %PathTo7zip%
pause