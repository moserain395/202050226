@echo off
setlocal

REM Define a marker file to track progress
set markerFile=C:\Batch\CVE_Batch_Progress.txt

REM Define loop parameter files
set ms500LoopsFile=C:\Batch\t_SystemStatesPwrTest_IOM_MS_500_loops.txt
set s4500LoopsFile=C:\Batch\t_SystemStatesPwrTest_IOM_S4_500_loops.txt

REM Check if the marker file exists, if not create it
if not exist "%markerFile%" (
    echo 0 > "%markerFile%"
)

REM Initialize loop parameter files if they do not exist
if not exist "%ms500LoopsFile%" (
    echo 0 > "%ms500LoopsFile%"
)

if not exist "%s4500LoopsFile%" (
    echo 0 > "%s4500LoopsFile%"
)

REM Read the current progress from the marker file
set /p progress=<"%markerFile%"

REM Function to check if a test has completed 500 loops
:check_loops
set /p loops=<%1
if %loops% LSS 500 (
    echo Waiting for %1 to complete 500 loops...
    timeout /t 60
    goto check_loops
)

REM Run scripts based on progress
if "%progress%"=="0" (
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/Dell/t_Dell_Stress_PassMark_BurnInTest.py
    echo 1 > "%markerFile%"
    shutdown /r /t 30
    timeout /t 30
)

if "%progress%"=="1" (
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/General/t_SystemStatesPwrTest_IOM_MS_500.py
    echo 2 > "%markerFile%"
    shutdown /r /t 30
    timeout /t 30
)

if "%progress%"=="2" (
    call :check_loops t_SystemStatesPwrTest_IOM_MS_500_loops.txt
    echo 3 > "%markerFile%"
    shutdown /r /t 30
    timeout /t 30
)

if "%progress%"=="3" (
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/General/t_SystemStatesPwrTest_IOM_S4_500.py
    echo 4 > "%markerFile%"
    shutdown /r /t 30
    timeout /t 30
)

if "%progress%"=="4" (
    call :check_loops t_SystemStatesPwrTest_IOM_S4_500_loops.txt
    echo 5 > "%markerFile%"
    shutdown /r /t 30
    timeout /t 30
)

if "%progress%"=="5" (
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/Dell/t_Dell_FullDrive_Reboot_With_IO.py
    echo 6 > "%markerFile%"
    timeout /t 300
)

if "%progress%"=="6" (
    del "%markerFile%"
    echo All Test Complete > "%markerFile%"
    echo All Test Complete
)

@echo on
endlocal
