Forfiles -p C:\Temp\Backup -s -m *.BAK  -c "cmd /c del /q @path"
sqlcmd -U db_username -P db_pass -S server -d database -i "C:\Temp\Backup\backup.sql"

quit

set year=%DATE:~6,4%
set day=%DATE:~0,2%
set mnt=%DATE:~3,2%
set hr=%TIME:~0,2%
set min=%TIME:~3,2%

IF %day% LSS 10 SET day=0%day:~1,1%
IF %mnt% LSS 10 SET mnt=0%mnt:~1,1%
IF %hr% LSS 10 SET hr=0%hr:~1,1%
IF %min% LSS 10 SET min=0%min:~1,1%

:: Error log path
set backupfldr=""

set backuptime=%day%-%mnt%-%year%_%hr%%min%
echo %backuptime%

:: Path to zip executable
set zipper=C:\Temp\Backup\7za\7za.exe


:: Number of days to retain .zip backup files 
set retaindays=2
echo "Zipping all files ending in .sql in the folder"

%zipper% a -tzip "%backupfldr%easyenquiry\Backup_%backuptime%.zip" "%backupfldr%\Backup_*.BAK"
echo "Deleting zip files older than 30 days now"

Forfiles -p V:\Temp\Backup -s -m *.BAK  -c "cmd /c del /q @path"

echo "Deleting zip files older than 30 days now"
Forfiles -p V:\Temp\Backup\easyenquiry -s -m *.* -d -%retaindays% -c "cmd /c del /q @path"

echo "Deleting backups over 15 days"
xcopy  /I C:\Temp\Backup\easyenquiry M:\IOL\IT\EasyEnquiryMSSQLBackup /x /Y
Forfiles -p M:\IOL\IT\EasyEnquiryMSSQLBackup -s -m *.* -d -15 -c "cmd /c del /q @path"

echo "done"
