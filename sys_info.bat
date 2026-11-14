@ECHO OFF
:: CIP-B101 Lab 1C - Windows system information collection
:: Student: LELAH NAOMIE
TITLE CIP-B101 System Info Collection
SETLOCAL
SET "OUTDIR=%~dp0..\outputs"
IF NOT EXIST "%OUTDIR%" MKDIR "%OUTDIR%"
SET "OUT=%OUTDIR%\sys_info_report.txt"
SET "HAVE_WMIC=0"
WHERE wmic >nul 2>&1 && SET "HAVE_WMIC=1"

ECHO Please wait... Checking system information.

ECHO ========================== > "%OUT%"
ECHO WINDOWS INFO >> "%OUT%"
ECHO ========================== >> "%OUT%"
systeminfo | find "OS Name" >> "%OUT%"
systeminfo | find "OS Version" >> "%OUT%"
systeminfo | find "System Type" >> "%OUT%"
ECHO. >> "%OUT%"
ECHO ========================== >> "%OUT%"
ECHO HARDWARE INFO >> "%OUT%"
ECHO ========================== >> "%OUT%"
systeminfo | find "Total Physical Memory" >> "%OUT%"
IF "%HAVE_WMIC%"=="1" GOTO USE_WMIC_HW
powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object Name | Format-Table -AutoSize" >> "%OUT%"
powershell -NoProfile -Command "Get-CimInstance Win32_DiskDrive | Select-Object Name,Model,Size | Format-Table -AutoSize" >> "%OUT%"
GOTO NET_INFO
:USE_WMIC_HW
wmic cpu get name >> "%OUT%"
wmic diskdrive get name,model,size >> "%OUT%"

:NET_INFO
ECHO. >> "%OUT%"
ECHO ========================== >> "%OUT%"
ECHO NETWORK INFO >> "%OUT%"
ECHO ========================== >> "%OUT%"
ipconfig | findstr IPv4 >> "%OUT%"
IF "%HAVE_WMIC%"=="1" GOTO USE_WMIC_NET
powershell -NoProfile -Command "Get-CimInstance Win32_NetworkAdapter | Select-Object MACAddress,Description | Format-Table -AutoSize" >> "%OUT%"
GOTO DONE
:USE_WMIC_NET
wmic nic get macaddress,description >> "%OUT%"

:DONE
START https://support.microsoft.com/en-us/windows/windows-10-system-requirements-6d4e9a79-66bf-7950-467c-795cf0386715
ECHO Collection complete. See outputs\sys_info_report.txt
ENDLOCAL
PAUSE