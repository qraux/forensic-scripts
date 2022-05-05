@echo off
REM Drag and drop an IOS FFS zip on the bat file and defined files will be extracted.
REM Just add or delete file paths in the files variable to modificate the outcome.
REM Version 1.1

set PathTo7zip=C:\Program Files\7-Zip\7z.exe
set "files=/private/var/mobile/media/PhotoData/Photos.Sqlite /private/var/mobile/media/PhotoData/Photos.Sqlite-shm /private/var/mobile/media/PhotoData/Photos.Sqlite-wal"

FOR %%a IN (%files%) DO (
"C:\Program Files\7-Zip\7z.exe" x "%~1" -o"_Extracted_" %%a
)

pause
exit

