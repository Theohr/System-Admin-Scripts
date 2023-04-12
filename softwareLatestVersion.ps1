# Define the source and destination paths
# $sourcePath = "\\SourcePC\C$\Path\To\Folder"
# $destinationPath = "\\DestinationPC\C$\Path\To\Destination\Folder"

$sourcePath = "\\iolfs01\Public\TempIT\easyenquiryLatestVersion"
$destinationPaths = "C:\Temp\visualBasicProjects"
$softwarePaths = "C:\Temp\visualBasicProjects"

Write-Host "Checking if new version exists in path..."

# Check if the source folder exists
if (!(Test-Path $sourcePath -PathType Container)) {
    Write-Error "Software does not exist in path."
}
else
{
    Write-Host "New version exists!"
}

Write-Host "Deleting old software version..."

# Check if the path exists if yes then delete
if (Test-Path $softwarePath -PathType Container) {
    Remove-Item $softwarePath -Recurse -Force
}


Write-Host "Creating software destination path..."

# Create the destination folder if it doesn't already exist
if (!(Test-Path $destinationPath -PathType Container)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
}


Write-Host "Copying latest version..."

# Copy the contents of the source folder to the destination folder
Copy-Item $sourcePath\* -Destination $destinationPath -Recurse -Force

# Define the path of the shortcut on the desktop
$shortcutPathDel = [Environment]::GetFolderPath("Desktop") + "\easyEnquiry.lnk"
$shortcutPathDel1 = [Environment]::GetFolderPath("Desktop") + "\easyEnquiry - Shortcut.lnk"

# Check if the shortcut exists
if ((Test-Path $shortcutPathDel) -or (Test-Path $shortcutPathDel1)) {
    Remove-Item $shortcutPathDel
    Remove-Item $shortcutPathDel1
}

# Define the source path of the .exe file
$sourcePathExe = "C:\Temp\visualBasicProjects\easyenquiry\bin\Debug\easyEnquiry.exe"

# Define the destination path for the shortcut on the desktop
$destinationPathExe = [Environment]::GetFolderPath("Desktop") + "\easyEnquiry.lnk"
 
# Define the "Start in" folder path
$startInFolder = "C:\Temp\visualBasicProjects\easyenquiry\bin\Debug"

# Create a WScript.Shell object
$shell = New-Object -ComObject WScript.Shell

# Create the shortcut
$shortcut = $shell.CreateShortcut($destinationPathExe)

$shortcut.TargetPath = $sourcePathExe
$shortcut.WorkingDirectory = $startInFolder

$shortcut.Save()