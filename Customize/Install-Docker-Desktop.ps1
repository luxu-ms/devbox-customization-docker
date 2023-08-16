# install choco
Write-Host "Downloading Chocolatey ..."
(new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1', 'C:\Windows\Temp\chocolatey.ps1')

Write-Host "Installing Chocolatey ..."
C:/Windows/Temp/chocolatey.ps1

# install packages
choco install -y docker-desktop

Restart-Computer
