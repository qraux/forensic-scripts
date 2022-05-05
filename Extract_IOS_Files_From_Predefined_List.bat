@echo off
REM Extract files from an IOS FFS zip and predefined list.
REM Just add or delete paths in the files variable.
REM Version 1

set PathTo7zip=C:\Program Files\7-Zip\7z.exe
set "files=/private/var/mobile/media/PhotoData/Photos.Sqlite /private/var/mobile/media/PhotoData/Photos.Sqlite-shm /private/var/mobile/media/PhotoData/Photos.Sqlite-wal"

FOR %%a IN (%files%) DO (
"C:\Program Files\7-Zip\7z.exe" x "%~1" -o"_Extracted_" %%a
)

pause
exit

