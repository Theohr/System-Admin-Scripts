$backupEE = Get-ChildItem -Path "\\sharedfolder\Departments\IOL\IT\EasyEnquiryMSSQLBackup" | Sort-Object -Property LastWriteTime | Select-Object -Last 1
$filePath = "C:\Temp\latestDBBackups.txt"

# Set the file path
$backupOrcl = "\\sharedfolder\Departments\IOL\IT\OracleDBBackup\FULLBACKUP.DMP"

# Get the file's date and time
$fileDateOrcl = (Get-ChildItem $backupOrcl).LastWriteTime
$fileSizeOrcl = [math]::Round((Get-ChildItem $backupOrcl).Length/1GB,2)

$fileDateEE = $backupEE.LastWriteTime
$fileTimeEE = $backupEE.LastWriteTime.TimeOfDay
$fileSizeEE = [math]::Round($backupEE.Length/1GB,2)

New-Item -ItemType File -Path $filePath -Force

Set-Content -Path $filePath -Value "ORCL Latest Backup File Date & Time: $fileDateOrcl"
Add-Content -Path $filePath -Value "EE Latest Backup File Date & Time: $fileDateEE"

$Body = "ORCL Latest Backup File Date & Time: $fileDateOrcl / Size: $fileSizeOrcl GB || `n"
$Body = $Body + "EE Latest Backup File Date & Time: $fileDateEE / Size: $fileSizeEE GB"

$EmailTo = "email_to"
$EmailCc = "email_cc"
$EmailFrom = "email_from"
$Subject = "Latest DB Backups"

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$SMTPUser = "smtp_user"
$SMTPPassword = "smtp_pass"

# create email message with attachment
$Message = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$Message.CC.Add($EmailCc)
$Attachment = New-Object System.Net.Mail.Attachment($filePath)
$Message.Attachments.Add($filePath)

# connect to smtp client and send email
$SMTPClient = New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort)
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($SMTPUser, $SMTPPassword)
$SMTPClient.EnableSsl = $true
$SMTPClient.Send($Message)