@echo off

REM Define a marker file to track progress
set markerFile=CVE_Batch_Progress.txt

REM Check if the marker file exists, if not create it
if not exist %markerFile% (
    echo 0 > %markerFile%
)

REM Read the current progress from the marker file
set /p progress=<%markerFile%

REM Function to check if a test has completed 500 loops
:check_loops
set /p loops=<%1
if %loops% LSS 500 (
    echo Waiting for %1 to complete 500 loops...
    timeout /t 60
    goto check_loops
)

REM Run scripts based on progress
if %progress% LSS 1 (
    REM Run t_Dell_Stress_PassMark_BurnInTest.py
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/Dell/t_Dell_Stress_PassMark_BurnInTest.py
    echo 1 > %markerFile%
    shutdown /r /t 0
    exit
)

if %progress% LSS 2 (
    REM Run t_SystemStatesPwrTest_IOM_MS_500.py
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/General/t_SystemStatesPwrTest_IOM_MS_500.py
    echo 2 > %markerFile%
    shutdown /r /t 0
    exit
)

if %progress% EQU 2 (
    REM Check if t_SystemStatesPwrTest_IOM_MS_500.py has completed 500 loops
    call :check_loops t_SystemStatesPwrTest_IOM_MS_500_loops.txt
    echo 3 > %markerFile%
    shutdown /r /t 0
    exit
)

if %progress% LSS 4 (
    REM Run t_SystemStatesPwrTest_IOM_S4_500.py
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/General/t_SystemStatesPwrTest_IOM_S4_500.py
    echo 4 > %markerFile%
    shutdown /r /t 0
    exit
)

if %progress% EQU 4 (
    REM Check if t_SystemStatesPwrTest_IOM_S4_500.py has completed 500 loops
    call :check_loops t_SystemStatesPwrTest_IOM_S4_500_loops.txt
    echo 5 > %markerFile%
    shutdown /r /t 0
    exit
)

if %progress% LSS 6 (
    REM Run t_Dell_FullDrive_Reboot_With_IO.py
    python C:/cve_scripts-Tag3.7.1@c218c590a66_OFFICIAL/wrappers/ML2.2/Dell/t_Dell_FullDrive_Reboot_With_IO.py
    echo 6 > %markerFile%
)

REM Cleanup marker file after all scripts have run
del %markerFile%

@echo on
