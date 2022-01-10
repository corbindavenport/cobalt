@echo off
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
if not errorlevel 1 goto fatfs
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
if not errorlevel 2 fdisk
goto

:fatfs
cls
echo.
echo  Found a FAT file system.
goto end

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