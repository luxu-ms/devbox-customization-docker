$newGuid = '683acd71-e45c-4358-9260-775805aa37de' #[guid]::NewGuid()
Write-Host "new guid: $newGuid"
$regHLMPath = 'HKLM:\Software\Microsoft\Active Setup\Installed Components'
$tempDirectory = 'C:\Temp'
$Name         = 'StubPath'

$newPath = "{$newGuid}"
$enableWSLFileName = 'Eanble-WSL2'
$Value        = "$tempDirectory\$enableWSLFileName.lnk"
New-Item -Path $regHLMPath -Name $newPath  -Force
New-ItemProperty -Path "$regHLMPath\$newPath" -Name '(Default)' -Value 'Enable WSL2' -PropertyType String -Force
New-ItemProperty -Path "$regHLMPath\$newPath" -Name $Name -Value $Value -PropertyType String -Force

$newPath2 = ">{$newGuid}"
$installToolsFileName = 'Install-Docker-Desktop'
$Value2 = "$tempDirectory\$installToolsFileName.lnk"
New-Item -Path $regHLMPath -Name $newPath2  -Force
New-ItemProperty -Path "$regHLMPath\$newPath2" -Name '(Default)' -Value 'Install Tools (Docker Desktop)' -PropertyType String -Force
New-ItemProperty -Path "$regHLMPath\$newPath2" -Name $Name -Value $Value2 -PropertyType String -Force

New-Item -ItemType Directory -Path $tempDirectory -Force
Copy-Item -Path ".\$enableWSLFileName.ps1" -Destination $tempDirectory -Force
Copy-Item -Path ".\$installToolsFileName.ps1" -Destination $tempDirectory -Force

function CreateShortcutWithAdminPermission {
    param(
        [Parameter(Mandatory = $true)]
        [string]$shortcutName,
        [String]$scriptFullPathName
    )

    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutName)
    $Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $Shortcut.Arguments = "-executionpolicy remotesigned -File $scriptFullPathName"
    $Shortcut.Save()

    $bytes = [System.IO.File]::ReadAllBytes($shortcutName)
    $bytes[0x15] = $bytes[0x15] -bor 0x20
    [System.IO.File]::WriteAllBytes($shortcutName, $bytes)
}

CreateShortcutWithAdminPermission -shortcutName $Value -scriptFullPathName "$tempDirectory\$enableWSLFileName.ps1"
CreateShortcutWithAdminPermission -shortcutName $Value2 -scriptFullPathName "$tempDirectory\$installToolsFileName.ps1"
