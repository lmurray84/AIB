
# Define variables
$languagesDir = 'C:\Languages\en-GB'


# Create temp directory
New-Item -ItemType Directory -Path $languagesDir -Force


# Download language ISO files
$progressPreference = 'SilentlyContinue'
Invoke-WebRequest "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso" -OutFile "$languagesDir\en-GB_Language.iso"
Invoke-WebRequest "https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso" -OutFile "$languagesDir\en-GB_FOD.iso"


# Mount language ISO files
$mount1 = Mount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso -PassThru
$mount2 = Mount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso -PassThru


# Define device paths
$devicePath1 = ($mount1).DevicePath
$devicePath2 = ($mount2).DevicePath


# Define language pack paths
$pathLXP = "$devicePath1" + "\LocalExperiencePack" + "\en-GB"
$pathLP = "$devicePath1" + "\x64" + "\langpacks"
$pathFOD = "$devicePath2"


# Copy language files
Robocopy "$pathLXP" "$languagesDir\Language" /256
Robocopy "$pathLP" "$languagesDir\Language" Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab /256
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
Dismount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso
Dismount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso


# Disable language pack cleanup
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue
Stop-ScheduledTask -TaskPath "\Microsoft\Windows\International\" -TaskName "Synchronize Language Settings" -ErrorAction SilentlyContinue
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\International\" -TaskName "Synchronize Language Settings" -ErrorAction SilentlyContinue


# Install language packs
Start-Process -FilePath PowerShell -ArgumentList "Add-AppProvisionedPackage -Online -PackagePath $languagesDir\Language\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath $languagesDir\Language\License.xml" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\Language\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Basic-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Handwriting-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-OCR-en-gb-Package~1bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-TextToSpeech-en-gb-Package~31bf3856ad364e35~amd64~~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
Start-Process -FilePath PowerShell -ArgumentList "Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab" -Wait -ErrorAction SilentlyContinue
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-gb")
Set-WinUserLanguageList $LanguageList -Force
Set-WinSystemLocale -SystemLocale "en-GB"