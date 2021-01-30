
### Define software repository ###
$softwareRepo = "C:\Temp\Software"


#### Create software repository ###
New-Item -ItemType Directory -Path $softwareRepo -Force | Out-Null


### Set logging ### 
$logFile = "C:\Temp\" + (get-date -format 'ddMMyyyy') + '_SoftwareInstall.log'
function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'ddMMyyyy HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}


### Install FSLogix Apps Agent ###
try {
    Invoke-WebRequest -Uri https://aka.ms/fslogix_download -OutFile "$softwareRepo\FSLogix.zip"
    Expand-Archive -Path "$softwareRepo\FSLogix.zip" -DestinationPath "$softwareRepo\FSLogix\" -Force
    Start-Sleep 5
    Invoke-Expression -Command "$softwareRepo\FSLogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart" -ErrorAction Stop
    Start-Sleep 10
    if (Test-Path "C:\Program Files\FSLogix\Apps\frx.exe") {

        Write-Log "Microsoft FSLogix Apps has been installed successfully"

    } else {

        Write-Log "Error locating Microsoft FSLogix Apps installation"}
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Log "Error installing FSLogix Apps: $ErrorMessage"
}


### Install Microsoft 365 Apps for Enterprise ###
try {
    Invoke-WebRequest -Uri https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_13328-20420.exe -OutFile "$softwareRepo\ODT.exe"
    Invoke-Expression -Command "$softwareRepo\ODT.exe /extract:$softwareRepo\M365 /quiet /norestart"
    Start-Sleep 5
    Invoke-WebRequest -Uri https://raw.githubusercontent.com/lmurray84/AIB/main/M365_Apps.xml -OutFile "$softwareRepo\M365\M365_Apps.xml"
    Invoke-Expression -Command "$softwareRepo\M365\Setup.exe /configure $softwareRepo\M365\M365_Apps.xml" -ErrorAction Stop
    Start-Sleep 10
    if (Test-Path "C:\Program Files\Microsoft Office\root\Office16\Outlook.exe") {

        Write-Log "Microsoft 365 Apps for Enterprise has been installed successfully"

    } else {

        Write-Log "Error locating Microsoft 365 Apps for Enterprise installation"}
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Log "Error installing Microsoft 365 Apps for Enterprise: $ErrorMessage"
}


### Install OneDrive for Business per-machine mode ###
try {
    Invoke-WebRequest -Uri https://go.microsoft.com/fwlink/?linkid=844652 -OutFile "$softwareRepo\OneDriveSetup.exe"
    Invoke-Expression -Command "$softwareRepo\OneDriveSetup.exe /allusers /silent /norestart"
    Start-Sleep 10
        if (Test-Path "C:\Program Files (x86)\Microsoft OneDrive\OneDrive.exe") {

        Write-Log "Microsoft OneDrive for Business has been installed successfully"

    } else {

        Write-Log "Error locating Microsoft OneDrive for Business installation"}
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Log "Error installing Microsoft OneDrive for Business: $ErrorMessage"
}


### Install Microsoft Teams per-machine mode ###
try {
    REG ADD "HKLM\Software\Microsoft\Teams" /v "IsWVDEnvironment" /t REG_DWORD /d 1 /reg:64
    Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vc_redist.x64.exe -OutFile "$softwareRepo\vc_redist.x64.exe"
    Invoke-Expression -Command "$softwareRepo\vc_redist.x64.exe /quiet /norestart"
    Start-Sleep 5
    Invoke-WebRequest -Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt -OutFile "$softwareRepo\MsRdcWebRTCSvc_HostSetup.msi"
    msiexec /i "$softwareRepo\MsRdcWebRTCSvc_HostSetup.msi" /qn
    Start-Sleep 5
    Invoke-WebRequest -Uri https://teams.microsoft.com/downloads/desktopurl?env=production"&"plat=windows"&"arch=x64"&"managedInstaller=true"&"download=true -OutFile "$softwareRepo\Teams.msi"
    msiexec /i "$softwareRepo\Teams.msi" /l*v "$softwareRepo\TeamsInstall.txt" ALLUSER=1 ALLUSERS=1 /qn
    Start-Sleep 20
    if (Test-Path "C:\Program Files (x86)\Microsoft\Teams\current\Teams.exe") {

        Write-Log "Microsoft Teams per-machine has been installed successfully"

    } else {

        Write-Log "Error locating Microsoft Teams per-machine installation"}
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Log "Error installing Microsoft Teams per-machine: $ErrorMessage"
}


### Update Windows Store Apps ###
$namespaceName = "root\cimv2\mdm\dmmap"
$className = "MDM_EnterpriseModernAppManagement_AppManagement01"
$wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
$result = $wmiObj.UpdateScanMethod()


### Install en-GB Language Pack ###
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/LanguageExperiencePack.en-GB.Neutral.appx?raw=true -OutFile "$softwareRepo\LanguageExperiencePack.en-GB.Neutral.appx"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/lmurray84/AIB/main/License.xml -OutFile "$softwareRepo\License.xml"
Invoke-WebRequest -Uri https://github.com/lmurray84/AIB/blob/main/Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab?raw=true -OutFile "$softwareRepo\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab"
Add-AppProvisionedPackage -Online -PackagePath "$softwareRepo\LanguageExperiencePack.en-GB.Neutral.appx" -LicensePath "$softwareRepo\License.xml"
Add-WindowsPackage -Online -PackagePath "$softwareRepo\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab"
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-GB")
Set-WinUserLanguageList $LanguageList -Force


### Set Time Zone ###
Set-TimeZone "GMT Standard Time" -Confirm:$false
 

### Disable Automatic Windows Update ###
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f


### Disable Storage Sense ###
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 0 /f