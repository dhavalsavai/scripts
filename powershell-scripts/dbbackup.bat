@echo off
setlocal

:: Set SQL Server login details
set SERVER=localhost
set USERNAME=sa
set PASSWORD=pwd123

:: Set the database name and backup folder
set DATABASE=database12
set BACKUPFOLDER=E:\DatabaseBackups

:: Generate a timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%

:: Create the backup filename with timestamp
set BACKUPFILENAME=%DATABASE%_%TIMESTAMP%.bak

:: Backup command
sqlcmd -S %SERVER% -U %USERNAME% -P %PASSWORD% -Q "BACKUP DATABASE [%DATABASE%] TO DISK = N'%BACKUPFOLDER%\%BACKUPFILENAME%' WITH NOFORMAT, NOINIT, NAME = N'%DATABASE%-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10"

echo Backup completed for %DATABASE% to %BACKUPFOLDER%\%BACKUPFILENAME%
endlocal
