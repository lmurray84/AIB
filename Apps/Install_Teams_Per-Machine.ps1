$softwareRepo = "C:\Temp\Software\Teams"
$progressPreference = "SilentlyContinue"

# Create Microsoft Teams software repository
Write-Host "Azure Image Builder: Creating Microsoft Teams software repository"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Create registry key for Microsoft Teams on WVD
Write-Host "Azure Image Builder: Adding registry key for Microsoft Teams on WVD"
New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "Teams" -ErrorAction SilentlyContinue
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams -Name "IsWVDEnvironment" -Type "Dword" -Value "1" -ErrorAction SilentlyContinue
Write-Host "Azure Image Builder: Completed adding registry key for Microsoft Teams on WVD"

# Download the latest Microsoft Visual C++ Redistributable
Write-Host "Azure Image Builder: Downloading the latest Microsoft Visual C++ Redistributable"
Invoke-WebRequest -Uri "https://aka.ms/vs/16/release/vc_redist.x64.exe" -OutFile "$softwareRepo\VisualC++Redist.exe"

# Install Microsoft Visual C++ Redistributable
Write-Host "Azure Image Builder: Installing Microsoft Visual C++ Redistributable"
Start-Process -FilePath "$softwareRepo\VisualC++Redist.exe" -ArgumentList "/q /norestart /log $softwareRepo\VisualC++Redist.log" -Wait
Write-Host "Azure Image Builder: Completed Microsoft Visual C++ Redistributable installation"

# Download the latest Microsoft Teams WebSocket Service
Write-Host "Azure Image Builder: Downloading the latest Microsoft Teams WebSocket Service software"
Invoke-WebRequest -Uri "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt" -OutFile "$softwareRepo\MsTeamsWebSocket.msi"

# Install Teams WebSocket Service
Write-Host "Azure Image Builder: Installing Teams WebSocket Service"
Start-Process -FilePath Msiexec.exe -ArgumentList "/i $softwareRepo\MsTeamsWebSocket.msi /qn /l*v $softwareRepo\MsTeamsWebSocket.log"
Write-Host "Azure Image Builder: Completed Teams WebSocket Service installation"

# Download the latest Microsoft Teams per-machine software
Write-Host "Azure Image Builder: Downloading the latest Microsoft Teams per-machine software"
Invoke-WebRequest -Uri "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true" -OutFile "$softwareRepo\MsTeamsPerMachine.msi"

# Install Microsoft Teams per-machine
Write-Host "Azure Image Builder: Installing Microsoft Teams per-machine"
Start-Process -FilePath Msiexec.exe -ArgumentList "/i $softwareRepo\MsTeamsPerMachine.msi /l*v $softwareRepo\MsTeamsPerMachine.log ALLUSER=1 ALLUSERS=1 /qn" -Wait
Write-Host "Azure Image Builder: Completed Microsoft Teams per-machine installation"
