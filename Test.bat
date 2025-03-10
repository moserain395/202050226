@echo off
setlocal

set statusFile=C:\Batch\Status.txt

if not exist "%statusFile%" (
   echo 0 > "%statusFile%"
)


set /p progress=<"%statusFile%"


if "%progress%"=="0 " (
   copy "C:\Batch\Test.bat" "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
   echo on
   echo Running ModernStanby Test
   echo off
   echo 1 > "%statusFile%"
   set /p progress=<"%statusFile%"
   "C:\cve_scripts-release-MSB_VAL_Candidate@1ccef74148e\wrappers\ML2.2\General\t_SystemStatesPwrTest_IOM_MS_500.py"
   shutdown /r /t 30
   timeout /t 30
)


if "%progress%"=="1 " (
   Timeout /t 120
   echo on
   echo Running Hibernate Test
   echo off   
   echo 2 > "%statusFile%"
   set /p progress=<"%statusFile%"
   "C:\cve_scripts-release-MSB_VAL_Candidate@1ccef74148e\wrappers\ML2.2\General\t_SystemStatesPwrTest_IOM_S4_500.py"
   shutdown /r /t 30
   timeout /t 30
)


if "%progress%"=="2 " (
   Timeout /t 120
   echo on
   echo Running Reboot Test
   echo off
   echo 3 > "%statusFile%"
   set /p progress=<"%statusFile%"
   "C:\cve_scripts-release-MSB_VAL_Candidate@1ccef74148e\wrappers\ML2.2\Dell\t_Dell_FullDrive_Reboot_With_IO.py"
   timeout /t 300
)

if "%progress%"=="3 " (
   del "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Test.bat"
)

echo All Test Complete > "%statusFile%"
echo on
echo All Test Complete
echo off

pause

endlocal
