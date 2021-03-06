# Download language packs
Write-Host "Azure Image Builder: Downloading en-GB language packs"
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/Languages/LanguageExperiencePack.en-GB.Neutral.appx?raw=true -OutFile "$softwareRepo\LanguageExperiencePack.en-GB.Neutral.appx"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/lmurray84/AIB/main/Languages/License.xml -OutFile "$softwareRepo\License.xml"
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/Languages/Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab?raw=true -OutFile "$softwareRepo\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab"

# Install language packs
Write-Host "Azure Image Builder: Installing en-GB language packs"
Add-AppProvisionedPackage -Online -PackagePath C:\Languages\en-GB\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath C:\Languages\en-GB\License.xml
Add-WindowsPackage -Online -PackagePath C:\Languages\en-GB\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab

# Set language pack
Write-Host "Azure Image Builder: Adding en-GB language"
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-GB")
Set-WinUserLanguageList $LanguageList -Force
Write-Host "Azure Image Builder: Finished adding en-GB language pack"
