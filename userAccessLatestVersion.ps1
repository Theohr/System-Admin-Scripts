$sourcePath = "\\sharedfolder\Public\TempIT\projects"
$destinationPath = "C:\Temp\projects"
$softwarePath = "C:\Temp\projects"

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
