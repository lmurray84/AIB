$softwareRepo = "C:\buildArtifacts\M365"
$progressPreference = "SilentlyContinue"

# Create M365 software repository
Write-Host "Azure Image Builder: Creating Microsoft 365 Apps for Enterprise software repository"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Download latest Office Deployment Tool
Write-Host "Azure Image Builder: Downloading the latest Office Deployment Tool software"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_13328-20420.exe" -OutFile "$softwareRepo\ODT.exe"

# Extract Office Deployment Tool software
Write-Host "Azure Image Builder: Extracting the Office Deployment Tool software"
Invoke-Expression -Command "$softwareRepo\ODT.exe /extract:$softwareRepo /quiet /norestart"
Start-Sleep 5

# Download XML configuration file
Write-Host "Azure Image Builder: Downloading the XML configuration file"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/lmurray84/AIB/main/Apps/Install-M365-Apps.xml" -OutFile "$softwareRepo\M365_Apps.xml"

# Install Microsoft 365 Apps for Enterprise
Write-Host "Azure Image Builder: Installing Microsoft 365 Apps for Enterprise"
Start-Process -FilePath "$softwareRepo\Setup.exe" -ArgumentList "/configure $softwareRepo\M365_Apps.xml" -Wait 
Write-Host "Azure Image Builder: Completed Microsoft 365 Apps for Enterprise installation"
