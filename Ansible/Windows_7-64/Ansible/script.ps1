cd WSMan:\localhost\client
$host_name = Read-Host "Press IP-address of REMOTE PC"
set-item .\allowunencrypted $true
set-item WSMan:\localhost\Client\TrustedHosts -Value "$host_name"
Set-ExecutionPolicy RemoteSigned
powershell "$HOME\Ansible\NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
sleep 2
$install_id = (Get-Process NDP452-KB2901907-x86-x64-AllOS-ENU).id
Write-Host "Get process with ID = $install_id"
Wait-Process -Id $install_id
Read-Host -Prompt "Press Enter to continue"
Write-host "Updating " -foregroundcolor cyan "Powershell"
powershell "$HOME\Ansible\Install-WMF5.1.ps1"
sleep 2
$proc = (Get-Process wusa).id
Wait-Process -id $proc
Write-Host "Done. You can close the window. Please reboot PC."
Read-Host -Prompt "Press ENTER to close"