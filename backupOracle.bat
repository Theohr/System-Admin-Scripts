set year=%DATE:~6,4%
set day=%DATE:~0,2%
set mnt=%DATE:~3,2%
set hr=%TIME:~0,2%
set min=%TIME:~3,2%

IF %day% LSS 10 SET day=0%day:~1,1%
IF %mnt% LSS 10 SET mnt=0%mnt:~1,1%
IF %hr% LSS 10 SET hr=0%hr:~1,1%
IF %min% LSS 10 SET min=0%min:~1,1%

set Binfldr="C:\Oracle19c\WINDOWS.X64_193000_db_home\bin"
set backupdate=%year%-%mnt%-%day%
set backuptime=%year%-%mnt%-%day%-%hr%-%min%
set backupfldr="C:\BackupScript\"
set Originalbackupfldr="C:\Oracle19c\app\administrator\admin\orcl\dpdump\"
set zipper="C:\BackupScript\7za\7za.exe"

:: Number of days to retain .zip backup files 
set retaindays=1
del "C:\BackupScript\FULLBACKUP.zip"
del "%backupfldr%FULLBACKUP.DMP"
del "%backupfldr%FULLBACKUP.log"

expdp user/user directory=FULLBACKUP_DIR dumpfile=FULLBACKUP.dmp logfile=FULLBACKUP.log full=y

::xcopy /S "%Originalbackupfldr%FULLBACKUP.DMP" C:\BackupScript /y
::xcopy /S "%Originalbackupfldr%FULLBACKUP.log" C:\BackupScript /y

:: %zipper% a -tzip "C:\BackupScript\FULLBACKUP.zip" "FULLBACKUP.DMP" "FULLBACKUP.log"
del $pathOfDMP
del $pathOfLOG

echo "Deleting dmp and log files from dpdump folder"
:: del "C:\BackupScript\FULLBACKUP.DMP"
:: del "C:\BackupScript\FULLBACKUP.log"

echo "Deleting backup zip files older than 10 days"
Forfiles -p %backupfldr% -s -m *.zip -d -%retaindays% -c "cmd /c del /q @path"

xcopy /S "C:\BackupScript\FULLBACKUP.DMP" $copyDestination /y
xcopy /S "C:\BackupScript\FULLBACKUP.log" $copyDestination /y