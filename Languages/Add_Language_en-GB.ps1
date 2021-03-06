# Install language pack
Add-AppProvisionedPackage -Online -PackagePath C:\Languages\en-GB\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath C:\Languages\en-GB\License.xml
Add-WindowsPackage -Online -PackagePath C:\Languages\en-GB\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab

# Set language pack
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-GB")
Set-WinUserLanguageList $LanguageList -Force
