@echo off
REM Drag and drop an IOS FFS zip on the bat file and defined files will be extracted.
REM Just add or delete file paths in the files variable to modificate the outcome.
REM Version 1.2

set files[0]=/private/var/mobile/media/PhotoData/Photos.Sqlite
set files[1]=/private/var/mobile/media/PhotoData/Photos.Sqlite-shm
set files[2]=/private/var/mobile/media/PhotoData/Photos.Sqlite-wal
set PathTo7zip=C:\Program Files\7-Zip\7z.exe

setlocal enabledelayedexpansion

FOR /L %%a IN (0,1,2) DO (
"C:\Program Files\7-Zip\7z.exe" x "%~1" -o"_Extracted_" !files[%%a]!
)

pause
exit


