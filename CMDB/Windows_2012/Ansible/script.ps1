cd WSMan:\localhost\client
$host_name = Read-Host "Press IP-address of REMOTE PC"
set-item .\allowunencrypted $true
set-item WSMan:\localhost\Client\TrustedHosts -Value "$host_name"
Set-ExecutionPolicy RemoteSigned