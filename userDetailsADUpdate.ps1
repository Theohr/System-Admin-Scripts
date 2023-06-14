# Import the Active Directory module
Import-Module ActiveDirectory

$users = Import-Csv 'C:\Temp\CodeTwo\UsersDetails.csv'

foreach ($user in $users) {

    $userDisplayName = $user.DisplayName

    $Company = $user.Company
    if ($Company.Length -lt 1)
    { $Company = $null }

    $Department = $user.Department
    if ($Department.Length -lt 1)
    { $Department = $null }

    $Title = $user.Title
    if ($Title.Length -lt 1)
    { $Title = $null }

    $Country = $user.Country
    if ($Country.Length -lt 1)
    { $Country = $null }

    $City = $user.City
    if ($City.Length -lt 1)
    { $City = $null }

    $Street = $user.Street
    if ($Street.Length -lt 1)
    { $Street = $null }

    $PostalCode = $user.PostalCode
    if ($PostalCode.Length -lt 1)
    { $PostalCode = $null }

    $OfficePhone = $user.Phone
    if ($OfficePhone.Length -lt 1)
    { $OfficePhone = $null }

    $MobilePhone = $user.Mobile
    if ($MobilePhone.Length -lt 1)
    { $MobilePhone = $null }

    $Office = $user.Office
    if ($Office.Length -lt 1)
    { $Office = $null }

    $userAD = Get-ADUser -Filter "Name -eq '$userDisplayName'"

    try
    {
        Set-ADUser -Identity $userAD.SamAccountName -Company $Company -Department $Department -Title $Title -Country $Country -City $City -Street $Street -PostalCode $PostalCode -OfficePhone $OfficePhone -MobilePhone $MobilePhone -Office $Office
        <# Set-ADUser -Identity $userAD.SamAccountName -Company $user.Company -Department $user.Department -Title $user.Title -Country $user.Country -City $user.City -Street $user.Street -PostalCode $user.PostalCode -OfficePhone $user.Phone -MobilePhone $user.Mobile -Office $user.Office #>
    }
    catch
    {
        Write-Output "Could not update the Data of " $user.DisplayName
    }
}