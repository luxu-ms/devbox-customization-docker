# install choco
Write-Host "Downloading Chocolatey ..."
(new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1', 'C:\Windows\Temp\chocolatey.ps1')

Write-Host "Installing Chocolatey ..."
C:/Windows/Temp/chocolatey.ps1

# install packages
choco install -y git 
choco install -y vscode 
choco install -y azure-cli 
choco install -y docker-desktop

Restart-Computer
#net localgroup docker-users "$Env:UserDomain\$Env:UserName" /add