$softwareRepo = "C:\Temp\Software\OneDrive"

# Create OneDrive for Business software repository
Write-Host "Azure Image Builder: Creating OneDrive for Business software repository"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Download OneDrive for Business
Write-Host "Azure Image Builder: Downloading OneDrive for Business latest software"
Invoke-WebRequest -Uri "https://aka.ms/OneDriveWVD-Installer" -OutFile "$softwareRepo\OneDriveSetup.exe"

# Install OneDrive for Business
Write-Host "Azure Image Builder: Installing OneDrive for Business"
Start-Process -FilePath "$softwareRepo\OneDriveSetup.exe" -ArgumentList "/allusers /silent /norestart /log $softwareRepo\OneDrive.log" -Wait
Write-Host "Azure Image Builder: Completed OneDrive for Business installation"
