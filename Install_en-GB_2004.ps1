
# Define variables
$languagesDir = 'C:\Languages'


# Create temp directory
New-Item -ItemType Directory -Path $languagesDir -Force


# Download language ISO files
Invoke-WebRequest https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_CLIENTLANGPACKDVD_OEM_MULTI.iso -OutFile $languagesDir\en-GB_Language.iso
Invoke-WebRequest https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_FOD-PACKAGES_OEM_PT1_amd64fre_MULTI.iso -OutFile $languagesDir\en-GB_FOD.iso
Invoke-WebRequest https://software-download.microsoft.com/download/pr/19041.1.191206-1406.vb_release_amd64fre_InboxApps.iso -OutFile $languagesDir\en-GB_Apps.iso


# Mount language ISO files
Mount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso -PassThru
Mount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso -PassThru
Mount-DiskImage -ImagePath $languagesDir\en-GB_Apps.iso -PassThru


# Copy language files
Robocopy \\.\CDROM0\LocalExperiencePack\en-gb $languagesDir\Language /256
Robocopy \\.\CDROM0\x64\langpacks $languagesDir\Language Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-LanguageFeatures-Basic-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-LanguageFeatures-Handwriting-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-LanguageFeatures-OCR-en-gb-Package~1bf3856ad364e35~amd64~~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-LanguageFeatures-Speech-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-LanguageFeatures-TextToSpeech-en-gb-Package~31bf3856ad364e35~amd64~~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM1 $languagesDir\FOD Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab /256
Robocopy \\.\CDROM2\amd64fre $languagesDir\Apps /256


# Dismount language ISO files
Dismount-DiskImage -ImagePath $languagesDir\en-GB_Language.iso
Dismount-DiskImage -ImagePath $languagesDir\en-GB_FOD.iso
Dismount-DiskImage -ImagePath $languagesDir\en-GB_Apps.iso


# Disable language pack cleanup
Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup"


# Install language packs
Add-AppProvisionedPackage -Online -PackagePath $languagesDir\Language\LanguageExperiencePack.en-GB.Neutral.appx -LicensePath $languagesDir\Language\License.xml
Add-WindowsPackage -Online -PackagePath $languagesDir\Language\Microsoft-Windows-Client-Language-Pack_x64_en-gb.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Basic-en-gb-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-Handwriting-en-gb-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-OCR-en-gb-Package~1bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-LanguageFeatures-TextToSpeech-en-gb-Package~31bf3856ad364e35~amd64~~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-NetFx3-OnDemand-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-InternetExplorer-Optional-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-MSPaint-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Notepad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-PowerShell-ISE-FOD-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-Printing-WFS-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-StepsRecorder-Package~31bf3856ad364e35~amd64~en-gb~.cab
Add-WindowsPackage -Online -PackagePath $languagesDir\FOD\Microsoft-Windows-WordPad-FoD-Package~31bf3856ad364e35~amd64~en-gb~.cab
$LanguageList = Get-WinUserLanguageList
$LanguageList.Add("en-gb")
Set-WinUserLanguageList $LanguageList -Force


# Update Inbox Store Apps

[string]$InboxApps = $languagesDir + "\" + "Apps"

$AllAppx = Get-Item $inboxapps\*.appx | Select-Object name
$AllAppxBundles = Get-Item $inboxapps\*.appxbundle | Select-Object name
$allAppxXML = Get-Item $inboxapps\*.xml | Select-Object name
foreach ($Appx in $AllAppx) {
    $appname = $appx.name.substring(0,$Appx.name.length-5)
    $appnamexml = $appname + ".xml"
    $pathappx = $InboxApps + "\" + $appx.Name
    $pathxml = $InboxApps + "\" + $appnamexml
    
    if($allAppxXML.name.Contains($appnamexml)){
    
    Write-Host "Handeling with xml $appname"  
  
    Add-AppxProvisionedPackage -Online -PackagePath $pathappx -LicensePath $pathxml
    } else {
      
      Write-Host "Handeling without xml $appname"
      
      Add-AppxProvisionedPackage -Online -PackagePath $pathappx -skiplicense
    }
}
foreach ($Appx in $AllAppxBundles) {
    $appname = $appx.name.substring(0,$Appx.name.length-11)
    $appnamexml = $appname + ".xml"
    $pathappx = $InboxApps + "\" + $appx.Name
    $pathxml = $InboxApps + "\" + $appnamexml
    
    if($allAppxXML.name.Contains($appnamexml)){
    Write-Host "Handeling with xml $appname"
    
    Add-AppxProvisionedPackage -Online -PackagePath $pathappx -LicensePath $pathxml
    } else {
       Write-Host "Handeling without xml $appname"
      Add-AppxProvisionedPackage -Online -PackagePath $pathappx -skiplicense
    }
}

# Delete temp directory
Remove-Item -Path $languagesDir -Force