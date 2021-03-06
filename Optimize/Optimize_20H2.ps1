$softwareRepo = "C:\Temp\Optimize"

# Create repository for WVD OS optimization tool
Write-Host "Azure Image Builder: Creating repostiory for WVD OS optimization tool"
New-Item -ItemType Directory -Path $softwareRepo -Force -ErrorAction SilentlyContinue

# Download WVD OS optimization tool
Write-Host "Azure Image Builder: Downloading WVD OS optimization tool"
Invoke-WebRequest -Uri "https://github.com/lmurray84/AIB/blob/main/Optimize/Optimize.zip?raw=true" -OutFile "$softwareRepo\Optimize.zip"

# Extract WVD OS optimization tool
Write-Host "Azure Image Builder: Extracting WVD OS optimization tool"
Expand-Archive -Path "$softwareRepo\Optimize.zip" -DestinationPath "$softwareRepo" -Force

# Execute WVD OS optimization tool
Write-Host "Azure Image Builder: Executing WVD OS optimization tool"
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
Start-Process -FilePath PowerShell.exe -ArgumentList "$softwareRepo\Virtual-Desktop-Optimization-Tool-master\Win10_VirtualDesktop_Optimize.ps1 -WindowsVersion 2009 -Verbose" -Wait
Write-Host "Azure Image Builder: Completed WVD OS optimization"
