# Define the paths to the MSI and EXE files
$msiFiles = "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\SQLSysClrTypes.msi", "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\ReportViewer.msi" , "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\SQLSysClrTypes2012_x64-OLD-VERSION.msi", "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\ReportViewer2012.msi"
$exeFiles = "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\vs_community__1878856322.1548424377.exe", "\\sharedfolder\Public\TempIT\EasyEnquiry&Installation2019\CRforVS13SP27_0-10010309.exe" 
$sourcePath = "\\sharedfolder\Public\TempIT\easyenquiryLatestVersion"
$destinationPath = "C:\Temp\visualBasicProjects"
$softwarePath = "C:\Temp\visualBasicProjects\easyenquiry"

Write-Host "Installing .msi files..."

# Loop through the MSI files and install them
foreach ($msiFile in $msiFiles) {
    Start-Process msiexec.exe -ArgumentList "/i `"$msiFile`" /qn" -Wait
}

Write-Host "Installing .exe files..."

# Loop through the EXE files and install them
foreach ($exeFile in $exeFiles) {
    Start-Process $exeFile -ArgumentList "/S" -Wait
}
