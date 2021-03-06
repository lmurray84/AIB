# Download language packs
Write-Host
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/LanguageExperiencePack.en-GB.Neutral.appx?raw=true -OutFile "$softwareRepo\LanguageExperiencePack.en-GB.Neutral.appx"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/lmurray84/AIB/main/License.xml -OutFile "$softwareRepo\License.xml"
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab?raw=true -OutFile "$softwareRepo\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab"

# Install language packs
Add-AppProvisionedPackage -Online -PackagePath C:\Languages\en-GB\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath C:\Languages\en-GB\License.xml
Add-WindowsPackage -Online -PackagePath C:\Languages\en-GB\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab

# Set language pack
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-GB")
Set-WinUserLanguageList $LanguageList -Force
