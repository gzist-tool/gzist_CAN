PowerShell set-executionpolicy remotesigned
echo ====== %date% %time% ======  >> login.log
PowerShell .\xyw_login.ps1 >> login.log
echo ====== end ======  >> login.log