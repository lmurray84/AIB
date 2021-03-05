
$softwareRepo = "C:\Temp\Software"

# Create software repository
New-Item -ItemType Directory -Path $softwareRepo -Force | Out-Null

# Install FSLogix Apps Agent
Invoke-WebRequest -Uri https://aka.ms/fslogix_download -OutFile "$softwareRepo\FSLogix.zip"
Expand-Archive -Path "$softwareRepo\FSLogix.zip" -DestinationPath "$softwareRepo\FSLogix\" -Force
Start-Sleep 5
Invoke-Expression -Command "$softwareRepo\FSLogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart"
Start-Sleep 10

# Install Microsoft Teams per-machine
#REG ADD "HKLM\Software\Microsoft\Teams" /v "IsWVDEnvironment" /t REG_DWORD /d 1 /reg:64
Invoke-WebRequest -Uri https://support.microsoft.com/help/2977003/the-latest-supported-visual-c-downloads -OutFile "$softwareRepo\vc_redist.x64.exe"
Invoke-Expression -Command "$softwareRepo\vc_redist.x64.exe /quiet /norestart"
Start-Sleep 5
Invoke-WebRequest -Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt -OutFile "$softwareRepo\MsRdcWebRTCSvc_HostSetup.msi"
msiexec /i "$softwareRepo\MsRdcWebRTCSvc_HostSetup.msi" /qn
Start-Sleep 5
Invoke-WebRequest -Uri https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true -OutFile "$softwareRepo\Teams.msi"
msiexec /i "$softwareRepo\Teams.msi" /l*v "$softwareRepo\TeamsInstall.txt" ALLUSER=1 /qn
Start-Sleep 10

# Install OneDrive for Business per-machine
Invoke-WebRequest -Uri https://aka.ms/OneDriveWVD-Installer -OutFile "$softwareRepo\OneDriveSetup.exe"
Invoke-Expression -Command "$softwareRepo\OneDriveSetup.exe /allusers /silent /norestart"
Start-Sleep 10

# Install Microsoft 365 Apps for Enterprise
Invoke-WebRequest -Uri https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_13328-20420.exe -OutFile "$softwareRepo\ODT.exe"
Invoke-Expression -Command "$softwareRepo\ODT.exe /extract:$softwareRepo\M365 /quiet /norestart"
Start-Sleep 5
Invoke-WebRequest -Uri https://raw.githubusercontent.com/lmurray84/AIB/main/M365_Apps.xml -OutFile "$softwareRepo\M365\M365_Apps.xml"
Invoke-Expression -Command "$softwareRepo\M365\Setup.exe /configure $softwareRepo\M365\M365_Apps.xml" -ErrorAction Stop
