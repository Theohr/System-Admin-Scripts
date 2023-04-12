Import-Module ExchangeOnlineManagement

# Connect to Office 365 through certification
Connect-ExchangeOnline -CertificateFilePath "CertPath" -CertificatePassword (ConvertTo-SecureString -String "CertPass" -AsPlainText -Force) -AppID "CertAppID" -Organization "organizationDomain"

# Get mailbox usage statistics for all users
$mailboxStats = Get-Mailbox -ResultSize Unlimited 

$csvFilePath = "C:\Temp\mailboxUsageIOHL.csv"

# If excel exists delete
if (Test-Path $csvFilePath) {
    Remove-Item $csvFilePath
    Write-Output "CSV file deleted."
}
else {
    Write-Output "CSV file does not exist."
}

# create a new excel object
$excel = New-Object -ComObject Excel.Application

# create workbook and worksheet
$workbook = $excel.Workbooks.Add()
$worksheet = $workbook.Worksheets.Item(1)

# row counts of mailboxes
$row = 1
$mailboxCount = 0

# body of the email
$Body = "Mailboxes that are over 90% usage:`n`n"

# Loop through each user's mailbox and print the percentage used
foreach ($stats in $mailboxStats) {
    Try
    {
        # if first row then enter below titles
        if ($row -eq 1) {
            $worksheet.Cells.Item($row, 1) = "User"
            $worksheet.Cells.Item($row, 2) = "Mailbox Used (GB)"
            $worksheet.Cells.Item($row, 3) = "Mailbox Capacity (GB)"
            $worksheet.Cells.Item($row, 4) = "Items Count"
            $worksheet.Cells.Item($row, 5) = "Mailbox % to reach Max Capacity"

            $row++
        }

        # get mailbox stats
        $mb=Get-MailboxStatistics $stats

        # convert to numbers mailbox stats and calculate percentage used
        $mailboxUsed = [math]::Round(($mb.TotalItemSize.value.ToString().Split(“(“)[1].Split(” “)[0].Replace(“,”,””)/1024MB),2)
        $totalMailbox = [math]::Round(($stats.ProhibitSendQuota.Split(“(“)[1].Split(” “)[0].Replace(“,”,””)/1024MB),2)
        $percentageUsed = [math]::Round($mailboxUsed / $totalMailbox * 100,2)

        # enter details in user row
        $worksheet.Cells.Item($row, 1) = $stats.DisplayName
        $worksheet.Cells.Item($row, 2) = $mailboxUsed 
        $worksheet.Cells.Item($row, 3) = $totalMailbox 
        $worksheet.Cells.Item($row, 4) = $mb.ItemCount
        $worksheet.Cells.Item($row, 5) = $percentageUsed
        
        # if percentage is over 90 then red add it to mailbox count and enter to email's body the user details
        if ($percentageUsed -le 90) {
            $worksheet.Cells.Item($row, 5).Interior.ColorIndex = 4
        }
        else
        {
            $worksheet.Cells.Item($row, 5).Interior.ColorIndex = 3
            $mailboxCount++
            $Body = $Body + $mailboxCount + ")" + $stats.DisplayName + "'s mailbox is currently at " + $percentageUsed + " which is over 90& to be full. This requires immediate attention!`n"
        }

        # add row
        $row++
    }
    catch 
    {

    }
}

if ($mailboxCount -eq 0)
{
    $Body = "There are currently no mailboxes that are above the limit (>90%) of maxing out."
}
else
{
    $Body = $Body + "Total mailboxes above 90% count is: " + $mailboxCount
}

# save csv and exit
$workbook.SaveAs($csvFilePath)
$excel.Quit()

# email details
$EmailTo = "recipientEmail"
$EmailFrom = "senderEmail"
$Subject = "Weekly Mailbox Usage CSV"

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$SMTPUser = "gmailUSer"
$SMTPPassword = "gmailPassword"

# create email message with attachment
$Message = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$Attachment = New-Object System.Net.Mail.Attachment($csvFilePath)
$Message.Attachments.Add($csvFilePath)

# connect to smtp client and send email
$SMTPClient = New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort)
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($SMTPUser, $SMTPPassword)
$SMTPClient.EnableSsl = $true
$SMTPClient.Send($Message)