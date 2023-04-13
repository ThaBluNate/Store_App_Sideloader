#First in list = first to be installed. wildcards allowed
#You usually want to install dependencies like .NET first.
$fileArray= "*Framework*x64*","*Runtime*x64*","20983*"
#Name of zip containing files
$zipName= "Cheese.7z"
#Folder moved from "Progarm Files\WindowsApps" to "Local\Windowsapps"
$toPath= "CheeseTerminatorReloaded"
$fromPath= "20983MSme*_*__*"

$cwd=$pwd|Out-String
$cwd=$cwd-split"\n"

#Elevate if required
if (-Not(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    $CommandLine="-NoLogo -ExecutionPolicy Bypass -Command `"Set-Location "+$cwd[3]+";./Sideload`""
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
}

"Getting 7za..."
Invoke-WebRequest -URI "https://7-zip.org/a/7zr.exe" -OutFile "z.exe"
Invoke-WebRequest -URI "https://7-zip.org/a/7z2201-extra.7z" -OutFile "z.7z"
./z e z.7z -o"." -y 7za.exe|Out-Null
Remove-Item z.exe
Remove-Item z.7z    

reg import ./devMode.reg

"Extracting files..."
foreach($item in $fileArray){
    ./7za e -y $zipName $item -o"ExtractedApp"|Out-Null
    $fullPath=Resolve-Path -Relative -Path ExtractedApp\$item
    Add-AppxPackage -Path $fullPath
}

"Cleaning up..."
Remove-Item -Recurse ExtractedApp
Remove-Item 7za.exe

#Who is the owner of WindowsApps? If not administrators, MAKE IT ADMINISTRATORS
$o=Get-Acl 'C:\Program Files\WindowsApps'|Format-List -Property Owner|Out-String
$o=$o-split"\\"-split" "
$o=$o[3]|findstr $o[3]
if ($o -ne "Administrators"){"Gaining access to WindowsApps...";takeown /a /r /d Y /f "C:\Program Files\WindowsApps"|Out-Null}

"Copying files..."
New-Item -ItemType "directory" $env:localappdata"\WindowsApps" -ErrorAction SilentlyContinue|Out-Null
Set-Location $env:ProgramFiles"\WindowsApps"
Move-Item -Path $fromPath -Destination $env:localappdata"\WindowsApps\"$toPath -ErrorAction SilentlyContinue

"Setting up installation..."
Set-Location $env:localappdata"\WindowsApps\"$toPath
Remove-Item AppxSignature.p7x

"Uninstalling installed files..."
$pkg=Get-AppxPackage|findstr "CheeseTerminatorReloaded"|findstr "Full"
$pkg=$pkg-split" "
Remove-AppxPackage -AllUsers $pkg[4]

"Installing..."
Add-AppxPackage AppxManifest.xml -Register

Read-Host -Prompt "Done! Press enter to exit."