$mfilesDetails = Get-WmiObject -Class Win32_Product | where Vendor -eq "M-Files Corporation"
#$mfilesAutoLogOutReg = "\\sharedfolder\Public\TempIT\M-Files\AutomaticLogoutTimeoutInMinutes.reg"
#$mfilesAutoFillingReg1 = "\\sharedfolder\Public\TempIT\M-Files\M-Files-AutoFillingProperies (version 23.2.12340.6).reg"
#$mfilesAutoFillingReg2 = "\\sharedfolder\Public\TempIT\M-Files\M-Files-AutoFillingProperies (version 23.4.12528.8).reg"

$mfilesVersion = $mfilesDetails.Version

# Set the registry path and name of the new entry
$registryPathAutoLogOut = "HKLM:\SOFTWARE\Motive\M-Files\$mfilesVersion\Client\MFClient"

$entryNameAutoLogOutDrive = "Drive"
$entryValueAutoLogOutDrive = "Z"

$entryNameAutoLogOutAutomaticLogoutTimeoutInMinutes = "AutomaticLogoutTimeoutInMinutes"
$entryValueAutoLogOutAutomaticLogoutTimeoutInMinutes = 0x0000000f

# Set the registry path and name of the new entry
$registryPathAutoFilling = "HKCU:\SOFTWARE\Motive\M-Files\$mfilesVersion\Client\Common\M-FILES\AutoFillingOfProperties"

$entryNameAutoFilling = "AutoFillLookupsOnly"
$entryValueAutoFilling = 0x00000000

Remove-ItemProperty $registryPathAutoLogOut -Name $entryNameAutoLogOutDrive -Force -Verbose
Remove-ItemProperty $registryPathAutoLogOut -Name $entryNameAutoLogOutAutomaticLogoutTimeoutInMinutes -Force -Verbose

Remove-ItemProperty HKCU:\SOFTWARE\Motive\M-Files\$mfilesVersion\Client\Common\M-FILES\AutoFillingOfProperties -Name $entryNameAutoFilling -Force -Verbose

# Create the new registry entry
New-ItemProperty -Path $registryPathAutoLogOut -Name $entryNameAutoLogOutDrive -PropertyType String -Value $entryValueAutoLogOutDrive
New-ItemProperty -Path $registryPathAutoLogOut -Name $entryNameAutoLogOutAutomaticLogoutTimeoutInMinutes -PropertyType DWord -Value $entryValueAutoLogOutAutomaticLogoutTimeoutInMinutes

New-ItemProperty -Path $registryPathAutoFilling -Name $entryNameAutoFilling -PropertyType DWord -Value $entryValueAutoFilling

<#if ($mfilesAutoFillingReg1.Contains($mfilesVersion))
{
    reg import $mfilesAutoFillingReg1
}
else
{
    reg import $mfilesAutoFillingReg2
}


reg import $mfilesAutoLogOutReg#>
