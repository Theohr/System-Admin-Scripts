$file = "C:\Temp\serverServices.csv"
$servernames = "ioldanaosweb"
$AcceptableNames = @("MTMLLink-FX-Helper","MTMLLink-FX", "MTMLLinkFXClient")

#Gets all the services of the server and their status
Get-service -ComputerName $servernames | Select-Object MachineName, Name, DisplayName, Status, StartType | ForEach-Object{  
    if ($_.Name -in $AcceptableNames) {
        if($_.Status -eq "Running") {  
            Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Green 
        }  
        else{  
            Write-Host $_.MachineName,$_.Name, $_.DisplayName, $_.Status, $_.StartType -ForegroundColor Red  
            Get-Service -Name $_.Name -ComputerName $servernames | Start-service
        }  
    }
    $_ 
}