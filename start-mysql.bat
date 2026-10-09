@echo off
title Start MySQL Service
color 0A

echo ===================================================
echo           Starting Local MySQL Server...
echo ===================================================
echo.

:: Check for administrative permissions
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Administrator rights not detected.
    echo If the service fails to start, right-click this file and select:
    echo "Run as administrator"
    echo.
)

:: Attempt to start standalone Windows MySQL Service
net start MySQL >nul 2>&1
if %errorlevel% equ 0 goto success

net start MySQL80 >nul 2>&1
if %errorlevel% equ 0 goto success

:: Attempt to start MySQL if using XAMPP in default path
if exist "C:\xampp\mysql\bin\mysqld.exe" (
    echo Checking XAMPP MySQL installation...
    start "" /b "C:\xampp\mysql\bin\mysqld.exe" --defaults-file="C:\xampp\mysql\bin\my.ini" --standalone >nul 2>&1
    goto success
)

:: If none of the attempts succeed
echo [ERROR] Could not start MySQL automatically.
echo - Please ensure MySQL or XAMPP is installed.
echo - Try running this batch script as Administrator.
goto finish

:success
echo [SUCCESS] MySQL service is running and ready for JDBC connections.

:finish
echo.
echo ===================================================
pause
