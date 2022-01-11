@echo off
echo.
echo  Cobalt OS
type date.txt
echo.
echo  Cobalt is still in development, so you might encounter bugs. Please report
echo  bugs to https://github.com/corbindavenport/cobalt/issues.
echo.
echo  This setup will install Cobalt to your computer's internal drive.
echo.
echo  Press ENTER to continue.
echo.
pause >nul
goto drivescan

:drivescan
fdisk /info | grep "FAT" > nul
if not errorlevel 1 goto driveselect
goto invalid

:invalid
cls
echo.
echo  The main drive is not formatted, or the disk format could not be detected.
echo.
echo  Press Y to open FDISK to create a partition, or N to cancel.
echo.
choice
if errorlevel 2 goto cancel
if not errorlevel 2 driveselect
goto

:driveselect
cls
fdisk /info
echo.
echo -------------------------------------------------------------------------------
echo.
echo  Type the drive letter to be used for the Cobalt installation (such as 'C'),
echo  then press ENTER on your keyboard.
echo.
echo  NOTE: The target drive/partition will be formatted. ALL DATA WILL BE ERASED.
echo.
set /p drive=
echo.
echo %drive% | grep -e "B\|C\|D\|E\|F\|G\|H\|I\|J\|K\|L\|M\|N\|O\|P\|Q\|R\|S\|T\|U\|V\|W\|X\|Y\|Z" > nul
if not errorlevel 0 goto formaterror
goto format

:format
cls
format %drive%: /V:Cobalt /S /A
if not errorlevel 0 goto formaterror
sys a: %drive%:
if not errorlevel 0 goto formaterror
goto end

:formaterror
echo.
echo  There was an error. Press any key to select a drive and try again.
pause >nul
goto driveselect

:cancel
cls
echo.
echo  Cobalt installation has been canceled.
echo.
goto loop

:loop
pause > nul
goto loop

:end
echo.