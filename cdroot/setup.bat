@echo off
PATH tools

echo.
echo.
echo.
type logo.txt
echo.
echo.
echo.
echo.
echo  Cobalt is still in development, so you might encounter bugs. Please report
echo  bugs to https://github.com/corbindavenport/cobalt/issues.
echo.
echo  This setup will install Cobalt to your computer's internal drive.
echo.
echo  Press ENTER to continue.
echo.
echo.
echo.
echo.
type date.txt
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
echo  Type the drive letter to be used for the Cobalt installation (such as 'C').
echo  The target drive/partition will be formatted. ALL DATA WILL BE ERASED.
echo.
choice /C:ABCDEFGHIJKLMNOPQRSTUVWXYZ /N " What drive? [C,E,F,...]?"
if errorlevel 1 set installdrive=A
if errorlevel 2 set installdrive=B
if errorlevel 3 set installdrive=C
if errorlevel 4 set installdrive=D
if errorlevel 5 set installdrive=E
if errorlevel 6 set installdrive=F
if errorlevel 7 set installdrive=G
if errorlevel 8 set installdrive=H
if errorlevel 9 set installdrive=I
if errorlevel 10 set installdrive=J
if errorlevel 11 set installdrive=K
if errorlevel 12 set installdrive=L
if errorlevel 13 set installdrive=M
if errorlevel 14 set installdrive=N
if errorlevel 15 set installdrive=O
if errorlevel 16 set installdrive=P
if errorlevel 17 set installdrive=Q
if errorlevel 18 set installdrive=R
if errorlevel 19 set installdrive=S
if errorlevel 20 set installdrive=T
if errorlevel 21 set installdrive=U
if errorlevel 22 set installdrive=V
if errorlevel 23 set installdrive=W
if errorlevel 24 set installdrive=X
if errorlevel 25 set installdrive=Y
if errorlevel 26 set installdrive=Z
goto driveconfirm

:driveconfirm
if %installdrive% == A goto invdrive
echo.
choice " Are you sure you want to use the %installdrive%: drive? "
if not errorlevel 1 goto cancel
goto format

:format
cls
format %installdrive%: /V:Cobalt /A /z:seriously
if not errorlevel 0 goto formaterror
sys A: %installdrive%:
if not errorlevel 0 goto formaterror
goto completed

:invdrive
echo.
echo  You cannot install to the %installdrive%: drive. Press any key to pick another drive.
pause >nul
goto driveselect

:formaterror
echo.
echo  There was an error. Press any key to select a drive and try again.
pause >nul
goto driveselect

:completed
cls
echo.
echo.
echo.
type logo.txt
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo. Cobalt is now installed! You may now remove the Cobalt CD and reboot your PC.
echo.
goto loop

:cancel
cls
echo.
echo  Cobalt installation has been canceled. Remove the Cobalt CD and restart.
echo.
goto loop

:loop
pause > nul
goto loop

:end
echo.