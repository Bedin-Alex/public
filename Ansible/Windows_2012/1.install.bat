xcopy %CD%\Ansible %HOMEPATH%\Ansible\ /S /R
cls
echo "Files was copied successfully"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList 'Set-ExecutionPolicy RemoteSigned -Force' -Verb RunAs}"
echo "Setting up execution policy..."
timeout /t 5 > nul
echo "Policy was changed successfully"
echo "Running script.. Don't close this window"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList 'powershell $HOME\Ansible\script.ps1' -Verb RunAs}"
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList 'powershell $HOME\Ansible\Ansible.ps1' -Verb RunAs}"
