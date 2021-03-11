$softwareRepo = "C:\Temp\Software\OneDrive"

# Create OneDrive for Business software repository
Write-Host "Azure Image Builder: Creating OneDrive for Business software repository"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Download OneDrive for Business
$progressPreference = 'SilentlyContinue'
Write-Host "Azure Image Builder: Downloading OneDrive for Business latest software"
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=844652" -OutFile "$softwareRepo\OneDriveSetup.exe"

# Install OneDrive for Business
Write-Host "Azure Image Builder: Installing OneDrive for Business"
Start-Process -FilePath "$softwareRepo\OneDriveSetup.exe" -ArgumentList "/allusers /silent"
Write-Host "Azure Image Builder: Completed OneDrive for Business installation"
