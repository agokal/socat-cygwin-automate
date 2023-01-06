# socat-install-cygwin

This script automates the installation of [Cygwin](https://cygwin.com/) and the compilation of [socat version 1.7.4.4](http://www.dest-unreach.org/socat/download/socat-1.7.4.4.tar.gz) for Windows. It downloads the Cygwin installer and installs it with the necessary packages for socat compilation, then downloads and compiles socat. The resulting socat executable is located in the extracted socat folder.

## Usage

1. Save the script to a local folder on your Windows machine.
2. Open an elevated command prompt and navigate to the folder containing the script.
3. Run `socat-compile.bat`
4. The socat exe is located in `C:\cygwin64\socat-1.7.4.4\`

Note: socat.exe requires the .dll files within socat-1.7.4.4 to run

## Sources
- https://github.com/rtwolf/cygwin-auto-install
- https://gist.github.com/wjrogers/1016065
- https://github.com/valorisa/socat-1.7.4.4_for_Windows
- https://github.com/3ndG4me/socat

