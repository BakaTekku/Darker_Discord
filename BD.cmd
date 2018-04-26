@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

setlocal
title BeautifulDiscord
color 1B
cd "%~d0%~p0"

pushd "%LOCALAPPDATA%\Programs\Python\Python*" >nul 2>&1
if %errorlevel% EQU 1 (
color 0C
echo Error^: Python not installed
echo During setup make sure to tick the box for "Add Python to path" option.
echo.
echo Press ENTER to Download Python...
pause >nul
start "" "https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe"
endlocal
exit
)
if exist "Python.exe" python --version 2>NUL
IF %ERRORLEVEL% NEQ 0 (
popd
color 0C
echo Error^: Python not added to path!
echo Please re-install and set "Add Python to path" option.
pause
endlocal
exit
) 

:Run_Check
tasklist | find /i "Discord" >nul 2>&1
if errorlevel 1 (
  cls
  echo Discord is not running, Please launch Discord!
  echo Waiting for Discord...
  goto Run_Check
) else (
  goto Menu
)

:Menu
cls
set Theme=
set option=
echo [i] - Install/Update BeautifulDiscord
echo [r] - Remove BeautifulDiscord
echo [1] - Apply Theme
echo [2] - Revert changes
echo.
set /p option="Enter Option:"
if /i "%option%"=="i" goto Install_BD
if /i "%option%"=="r" goto Remove_BD
if "%option%"=="1" goto Load_Theme
if "%option%"=="2" goto Revert_BD
goto Menu

:Install_BD
cls
python -m pip install -U https://github.com/leovoel/BeautifulDiscord/archive/master.zip
pause
goto Menu

:Remove_BD
cls
pip uninstall --yes beautifuldiscord
if exist "%userprofile%\.beautifuldiscord" rd "%userprofile%\.beautifuldiscord" /q /s
pause
goto Menu

:Load_Theme
setlocal enabledelayedexpansion
set chooser=%temp%\dfc.exe
>"%temp%\c.cs" echo using System;using System.Windows.Forms;
>>"%temp%\c.cs" echo class dummy{[STAThread]
>>"%temp%\c.cs" echo public static void Main^(^){
>>"%temp%\c.cs" echo OpenFileDialog f= new OpenFileDialog^(^);
>>"%temp%\c.cs" echo f.InitialDirectory=Environment.CurrentDirectory;
>>"%temp%\c.cs" echo f.RestoreDirectory = true;
>>"%temp%\c.cs" echo string formats = "css files (*.css)|*.css" ;
>>"%temp%\c.cs" echo f.Filter= formats;
>>"%temp%\c.cs" echo f.Multiselect = false;
>>"%temp%\c.cs" echo f.ShowHelp=true;
>>"%temp%\c.cs" echo f.ShowDialog^(^);
>>"%temp%\c.cs" echo foreach ^(String filename in f.FileNames^) {
>>"%temp%\c.cs" echo     Console.WriteLine^(filename^);
>>"%temp%\c.cs" echo         }
>>"%temp%\c.cs" echo     }
>>"%temp%\c.cs" echo  }
for /f "delims=" %%I in ('dir /b /s "%windir%\microsoft.net\*csc.exe"') do (
if not exist "!chooser!" "%%I" /nologo /out:"!chooser!" "%temp%\c.cs" 2>NUL
)
del "%temp%\c.cs"
setlocal disabledelayedexpansion	
for /f "delims=" %%I in ('%chooser%') do endlocal & set Theme=%%I
del "%temp%\dfc.exe" 2>NUL
if "%Theme%"=="" endlocal & goto Menu
beautifuldiscord --css "%Theme%"
pause
goto Menu

:Revert_BD
cls
beautifuldiscord --revert
pause
goto Menu