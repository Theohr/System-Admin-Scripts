DECLARE @name VARCHAR(50) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name 


SET @path = 'enter path of backup'


SELECT @fileDate = REPLACE(CONVERT(VARCHAR, GETDATE(),101),'/','-') + '_' +  REPLACE(CONVERT(VARCHAR, GETDATE(),108),':','')

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master','model','msdb','tempdb', 'desktopcentral', 'M-Files_Report_Vessels') 

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0  AND @name = 'easyenquiry' 
BEGIN   
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
       BACKUP DATABASE @name TO DISK = @fileName  

       FETCH NEXT FROM db_cursor INTO @name   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor 
