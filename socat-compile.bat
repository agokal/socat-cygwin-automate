@ECHO OFF
REM -- Automates cygwin installation and cygwin 1.7.4.4 compilation
REM -- Sources: 
REM --- https://github.com/rtwolf/cygwin-auto-install
REM --- https://gist.github.com/wjrogers/1016065
REM --- https://github.com/valorisa/socat-1.7.4.4_for_Windows
 
SETLOCAL

SET TEMPDIR=C:\Temp

REM -- change to C:\Temp 
if NOT EXIST %TEMPDIR% (
	mkdir %TEMPDIR%
)
cd /d %TEMPDIR%

REM -- Download the Cygwin installer
IF NOT EXIST cygwin-setup64.exe (
	ECHO cygwin-setup64.exe NOT found! Downloading installer...
	bitsadmin /transfer cygwinDownloadJob /download /priority normal https://cygwin.com/setup-x86_64.exe %CD%\\cygwin-setup64.exe
) ELSE (
	ECHO cygwin-setup64.exe found! Skipping installer download...
)
 
REM -- Configure our paths
SET SITE=http://ucmirror.canterbury.ac.nz/cygwin
SET LOCALDIR=%CD%
SET ROOTDIR=C:\cygwin64
SET CYGWINROOTDIR=\
SET SOCAT=socat-1.7.4.4
 
REM -- These are the packages we will install to compile socat (in addition to the default packages)
SET PACKAGES=wget,gcc-g++,gcc-core,make,gcc-fortran,gcc-objc,gcc-objc++,libkrb5-devel,libkrb5_3,libreadline-devel,libssl-devel,libwrap-devel,tcp_wrappers
 
REM -- More info on command line options at: https://cygwin.com/faq/faq.html#faq.setup.cli
REM -- Do it!
ECHO *** INSTALLING DEFAULT PACKAGES
cygwin-setup64 --quiet-mode --no-desktop --download --local-install --no-verify -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%"
ECHO.
ECHO.
ECHO *** INSTALLING CUSTOM PACKAGES
cygwin-setup64 -q -d -D -L -X -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P %PACKAGES%
 
REM -- Show what we did
ECHO.
ECHO.
ECHO cygwin installation updated
ECHO  - %PACKAGES%
ECHO.

ENDLOCAL

REM -- Change to Cygwin Root folder
CD %ROOTDIR%

REM -- Download socat
IF NOT EXIST %SOCAT:~0%.tar.gz (
	ECHO %SOCAT:~0%.tar.gz NOT found! Downloading Socat...
	bitsadmin /transfer socatDownloadJob /download /priority normal http://www.dest-unreach.org/socat/download/%SOCAT:~0%.tar.gz %CD%\%SOCAT:~0%.tar.gz
) ELSE (
	ECHO %SOCAT:~0%.tar.gz found! Skipping socat download...
)

REM -- Extract Socat
%ROOTDIR%\bin\bash.exe --login -c "cd / && tar xzf socat*.tar.gz"

REM -- Configure Socat
%ROOTDIR%\bin\bash.exe --login -c "cd $(find / -maxdepth 1 -type d -name 'socat*') && ./configure"

REM -- Make Socat
%ROOTDIR%\bin\bash.exe --login -c "cd $(find / -maxdepth 1 -type d -name 'socat*') && make"

REM -- Copy cygwin .dll's into socat folder
%ROOTDIR%\bin\bash.exe --login -c "find /bin/ -name 'cyg*.dll' -exec cp {} $(find / -maxdepth 1 -type d -name 'socat*') \;"

ECHO.
ECHO Socat is compiled and installed! You should see an error that socat expected two inputs but none were given, below.
ECHO.
ECHO.

REM -- test Socat
%ROOTDIR%\%SOCAT%\socat.exe

PAUSE
EXIT /B 0