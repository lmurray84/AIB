
$softwareRepo = "C:\Software\FSLogix"

# Create FSLogix software repository
Write-Host "Azure Image Builder: Creating FSLogix software repository"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Download FSLogix Apps
Write-Host "Azure Image Builder: Downloading FSLogix Apps latest software"
Invoke-WebRequest -Uri https://aka.ms/fslogix_download -OutFile "$softwareRepo\FSLogix.zip"

# Extract FSLogix Apps
Write-Host "Azure Image Builder: Extracting FSLogix Apps software"
Expand-Archive -Path "$softwareRepo\FSLogix.zip" -DestinationPath "$softwareRepo\FSLogix\" -Force
Start-Sleep 5

# Install FSLogix Apps
Write-Host "Azure Image Builder: Installing FSLogix Apps"
Invoke-Expression -Command "$softwareRepo\FSLogix\x64\Release\FSLogixAppsSetup.exe /install /quiet /norestart"
Write-Host "Azure Image Builder: FSLogix Apps install complete"
