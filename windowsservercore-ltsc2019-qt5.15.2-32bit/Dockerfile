FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Add OpenGL DLLs from a Windows desktop to allow running unit tests within the container
ADD *.dll C:/Windows/SysWOW64/

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

# Install OpenCascade
ARG OCC_VERSION="7_7_2"
ARG OCC_URL="https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V$OCC_VERSION.zip"
RUN powershell -Command Invoke-WebRequest $env:OCC_URL -OutFile 'C:/tmp.zip' -UseBasicParsing ; \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && cd C:\OCCT-%OCC_VERSION% \
  && cmake . -G "Ninja" \
       -DCMAKE_BUILD_TYPE=Release \
       -DINSTALL_DIR=C:/OpenCascade \
       -DBUILD_LIBRARY_TYPE=Shared \
       -DBUILD_MODULE_ApplicationFramework=0 \
       -DBUILD_MODULE_DataExchange=1 \
       -DBUILD_MODULE_Draw=0 \
       -DBUILD_MODULE_FoundationClasses=0 \
       -DBUILD_MODULE_ModelingAlgorithms=0 \
       -DBUILD_MODULE_ModelingData=0 \
       -DBUILD_MODULE_Visualization=0 \
       -DUSE_DRACO=0 \
       -DUSE_FREEIMAGE=0 \
       -DUSE_FREETYPE=0 \
       -DUSE_GLES2=0 \
       -DUSE_OPENGL=0 \
       -DUSE_OPENVR=0 \
       -DUSE_RAPIDJSON=0 \
       -DUSE_TBB=0 \
       -DUSE_TK=0 \
       -DUSE_VTK=0 \
  && cmake --build . \
  && cmake --install . \
  && setx OpenCASCADE_DIR C:/OpenCascade/cmake \
  && setx PATH "%PATH%;C:\OpenCascade\win32\gcc\bin" \
  && cd .. \
  && rmdir C:\OCCT-%OCC_VERSION% /s /q \
  && del C:\tmp.zip

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

# Install Qt Quick Controls 2
ARG QT_QUICKCONTROLS2_URL="${QT_URL}qtquickcontrols2-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_QUICKCONTROLS2_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Translations
ARG QT_TRANSLATIONS_URL="${QT_URL}qttranslations-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_TRANSLATIONS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Image Formats Plugin
ARG QT_IMAGEFORMATS_URL="${QT_URL}qtimageformats-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_IMAGEFORMATS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Installer Framework
ADD QtIFW-3.2.2.tar.bz2 C:/Qt
RUN setx PATH "%PATH%;C:\Qt\QtIFW-3.2.2\bin"

# Install OpenSSL
ADD OpenSSL.tar.bz2 C:/Qt/Tools

# Install Windows App Certification Kit
#
# How to create the *.tar.bz2 (on Linux):
#  1. Download ISO from https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/
#  2. Extract ISO and navigate to the directory where the *.msi files are located
#  3. msiextract "Windows App Certification Kit x64 (OnecoreUAP)-x86_en-us.msi"
#  4. msiextract "Windows App Certification Kit x64-x86_en-us.msi"
#  5. Archive the directory "Program Files" to a *.tar.bz2
ADD WindowsAppCertificationKitX64.tar.bz2 C:/
RUN setx PATH "%PATH%;C:\Program Files\Windows Kits\10\App Certification Kit"

# Allow installing pip packages system-wide since there's no risk in a container
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Put Python user site in PATH to allow installing packages with --user
RUN FOR /F %i IN ('python -m site --user-base') DO setx PATH "%PATH%;%i\bin"
