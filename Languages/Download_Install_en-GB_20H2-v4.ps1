# Define variables
$languagesDir = 'C:\Languages\en-GB'


# Create languages software repository
Write-Host "Azure Image Builder: Creating 'Languages' software repository"
New-Item -ItemType Directory -Path $languagesDir -Force


# Download language ISO files
Write-Host "Azure Image Builder: Downloading language pack ISO files"
$progressPreference = 'SilentlyContinue'
Invoke-WebRequest "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso" -OutFile "$languagesDir\en-GB_Language.iso"
Invoke-WebRequest "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso" -OutFile "$languagesDir\en-GB_FOD.iso"


# Mount language ISO files
Write-Host "Azure Image Builder: Mounting language pack ISO files to system"
$mount1 = Mount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso -PassThru
$mount2 = Mount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso -PassThru


# Define device paths
Write-Host "Azure Image Builder: Storing ISO file device paths as variables"
$devicePath1 = ($mount1).DevicePath
$devicePath2 = ($mount2).DevicePath


# Define language pack paths
Write-Host "Azure Image Builder: Storing language pack paths as variables"
$pathLXP = "$devicePath1" + "\LocalExperiencePack" + "\en-GB"
$pathLP = "$devicePath1" + "\x64" + "\langpacks"
$pathFOD = "$devicePath2"


# Copy language files
Write-Host "Azure Image Builder: Copying Local Experience Pack files to software repository"
Robocopy "$pathLXP" "$languagesDir\Language" /256

Write-Host "Azure Image Builder: Copying Language Pack files to software repository"
Robocopy "$pathLP" "$languagesDir\Language" Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab /256

Write-Host "Azure Image Builder: Copying Features on Demand files to software repository"
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-LanguageFeatures-Basic-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-LanguageFeatures-Handwriting-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-LanguageFeatures-OCR-en-gb-Package~1bf3856ad364e35~amd64~~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-LanguageFeatures-Speech-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-LanguageFeatures-TextToSpeech-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy "$pathFOD" "$languagesDir\FOD" Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256


# Dismount language ISO files
Write-Host "Azure Image Builder: Dismounting language pack ISO files from system"
Dismount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso
Dismount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso


# Disable language pack cleanup
Write-Host "Azure Image Builder: Disabling scheduled task 'Pre-staged app cleanup'"
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue


# Install language packs
#Write-Host "Azure Image Builder: Installing Language Experience Pack"
#Start-Process -FilePath PowerShell -ArgumentList "Add-AppProvisionedPackage -Online -PackagePath $languagesDir\Language\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath $languagesDir\Language\License.xml" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Client Language Pack"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\Language\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Language Features Basic"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Basic-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Language Features Handwriting"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Handwriting-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Language Features OCR"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-OCR-en-gb-Package~1bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Language Features Text-to-Speech"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-TextToSpeech-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing NetFx3 package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Internet Explorer package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing MS Paint package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Notepad package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing PowerShell ISE package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Printing WFS package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing Steps Recorder package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Installing WordPad package"
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue

Write-Host "Azure Image Builder: Setting Windows User Language"
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-gb")
Set-WinUserLanguageList $LanguageList -Force

#Write-Host "Azure Image Builder: Setting Windows System Locale"
#Set-WinSystemLocale -SystemLocale "en-GB"
