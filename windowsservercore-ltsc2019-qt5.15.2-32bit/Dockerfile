FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
  "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" \
  && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# Install Chocolatey Packages
# Note: Funq requires to install x86 Python since Qt is also x86!
ENV PYTHONIOENCODING "UTF-8"
RUN choco install -y 7zip ccache vcredist2017 \
  && choco install -y git --params "/GitAndUnixToolsOnPath /NoAutoCrlf" \
  && choco install --forcex86 -y python3 --version 3.11.3 \
  && choco install -y cmake --version 3.26.3 --installargs "ADD_CMAKE_TO_PATH=System" \
  && choco install -y ninja --version 1.11.1

# Install MinGW
ARG MINGW_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw/qt.tools.win32_mingw810/8.1.0-1-202004170606i686-8.1.0-release-posix-dwarf-rt_v6-rev0.7z"
RUN powershell -Command Invoke-WebRequest $env:MINGW_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\Tools\mingw810_32\bin" \
  && del C:\tmp.7z

# Install Qt whatever DLLs
ARG QT_VERSION="5.15.2"
ARG QT_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/qt5_5152/qt.qt5.5152.win32_mingw81/5.15.2-0-202011130602"
ARG QT_DLLS_URL="${QT_URL}i686-8.1.0-release-posix-dwarf-rt_v6-rev0-runtime.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_DLLS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Tools
ARG QT_TOOLS_URL="${QT_URL}qttools-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_TOOLS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\%QT_VERSION%\mingw81_32\bin" \
  && del C:\tmp.7z

# Install Qt Base
ARG QT_BASE_URL="${QT_URL}qtbase-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
ARG QT_PRI="C:\\Qt\\$QT_VERSION\\mingw81_32\\mkspecs\\qconfig.pri"
RUN powershell -Command Invoke-WebRequest $env:QT_BASE_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z \
  && powershell -Command "((Get-Content -path $env:QT_PRI -Raw) -replace 'Enterprise', 'OpenSource') | Set-Content -Path $env:QT_PRI" \
  && powershell -Command "((Get-Content -path $env:QT_PRI -Raw) -replace 'licheck.exe', '') | Set-Content -Path $env:QT_PRI"

# Install Qt SVG
ARG QT_SVG_URL="${QT_URL}qtsvg-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_SVG_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Declarative
ARG QT_DECLARATIVE_URL="${QT_URL}qtdeclarative-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_DECLARATIVE_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Translations
ARG QT_TRANSLATIONS_URL="${QT_URL}qttranslations-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_TRANSLATIONS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Installer Framework
ARG QT_IFW_VERSION="3.2.2"
ARG QT_IFW_URL="https://download.qt.io/official_releases/qt-installer-framework/$QT_IFW_VERSION/QtInstallerFramework-win-x86.exe"
COPY qtifw-installer-noninteractive.qs C:/qtifw-installer-noninteractive.qs
RUN powershell -Command Invoke-WebRequest $env:QT_IFW_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe --script C:/qtifw-installer-noninteractive.qs --no-force-installations -v \
  && setx PATH "%PATH%;C:\Qt\QtIFW-%QT_IFW_VERSION%\bin" \
  && del C:\tmp.exe

# Install OpenSSL
ARG OPENSSL_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_openssl_x86/qt.tools.openssl.win_x86/1.1.1-17openssl_1.1.1q_prebuild_x86.7z"
RUN powershell -Command Invoke-WebRequest $env:OPENSSL_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\Tools\mingw810_32\bin" \
  && del C:\tmp.7z
