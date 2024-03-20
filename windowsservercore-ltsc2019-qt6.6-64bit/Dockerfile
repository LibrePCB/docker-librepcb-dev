FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Add OpenGL DLLs from a Windows desktop to allow running unit tests within the container
ADD *.dll C:/Windows/System32/

# Install Microsoft Visual C++ Redistributable for Visual Studio 2015-2022
ARG VCREDIST_URL="https://download.visualstudio.microsoft.com/download/pr/6ba404bb-6312-403e-83be-04b062914c98/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe"
RUN powershell -Command Invoke-WebRequest $env:VCREDIST_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe /quiet /norestart \
  && del C:\tmp.exe

# Install 7-Zip
ARG 7ZIP_URL="https://7-zip.org/a/7z2301-x64.exe"
RUN powershell -Command Invoke-WebRequest $env:7ZIP_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe /S /D="C:/7zip" \
  && setx PATH "%PATH%;C:\7zip" \
  && del C:\tmp.exe

# Install Git
ARG GIT_URL="https://github.com/git-for-windows/git/releases/download/v2.44.0.windows.1/Git-2.44.0-64-bit.exe"
RUN powershell -Command Invoke-WebRequest $env:GIT_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS \
                /COMPONENTS="gitlfs" /o:PathOption="CmdTools" /o:CRLFOption="LFOnly" \
  && del C:\tmp.exe

# Install Python
#  - Set PIP_BREAK_SYSTEM_PACKAGES to allow installing pip packages system-wide
#    since there's no risk in a container
#  - Put Python user site in PATH to allow installing packages with --user
ARG PYTHON_URL="https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe"
RUN powershell -Command Invoke-WebRequest $env:PYTHON_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe /quiet InstallAllUsers=1 PrependPath=1 Include_doc=0 Include_tcltk=0 TargetDir="C:\python" \
  && setx PYTHONIOENCODING "UTF-8" \
  && setx PIP_BREAK_SYSTEM_PACKAGES 1 \
  && cmd /c "FOR /F %i IN ('C:\python\python.exe -m site --user-base') DO setx PATH "%PATH%;%i\bin"" \
  && del C:\tmp.exe

# Install CMake
ARG CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v3.28.3/cmake-3.28.3-windows-x86_64.zip"
RUN powershell -Command Invoke-WebRequest $env:CMAKE_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/ -bsp1 \
  && rename cmake-3.28.3-windows-x86_64 cmake \
  && setx PATH "%PATH%;C:\cmake\bin" \
  && del C:\tmp.7z

# Install Ninja
ARG NINJA_URL="https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-win.zip"
RUN powershell -Command Invoke-WebRequest $env:NINJA_URL -OutFile 'C:/tmp.zip' -UseBasicParsing ; \
  && 7z x C:/tmp.zip -oC:/ninja -bsp1 \
  && setx PATH "%PATH%;C:\ninja" \
  && del C:\tmp.zip

# Install CCache
ARG CCACHE_URL="https://github.com/ccache/ccache/releases/download/v4.9.1/ccache-4.9.1-windows-x86_64.zip"
RUN powershell -Command Invoke-WebRequest $env:CCACHE_URL -OutFile 'C:/tmp.zip' -UseBasicParsing ; \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && rename ccache-4.9.1-windows-x86_64 ccache \
  && setx PATH "%PATH%;C:\ccache" \
  && del C:\tmp.zip

# Install MinGW
ARG MINGW_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw90/qt.tools.win64_mingw900/9.0.0-1-202203221220mingw-w64-x86_64-11.2.0-release-posix-seh-rt_v9-rev3.7z"
RUN powershell -Command Invoke-WebRequest $env:MINGW_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\Tools\mingw1120_64\bin" \
  && del C:\tmp.7z

# Install ZLib
ARG ZLIB_VERSION="1.3.1"
ARG ZLIB_URL="https://github.com/madler/zlib/releases/download/v$ZLIB_VERSION/zlib131.zip"
RUN powershell -Command Invoke-WebRequest $env:ZLIB_URL -OutFile 'C:/tmp.zip' -UseBasicParsing ; \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && cd C:/zlib-%ZLIB_VERSION% \
  && cmake . -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/zlib \
  && ninja \
  && ninja install \
  && setx ZLIB_ROOT "C:/zlib" \
  && setx PATH "%PATH%;C:\zlib\bin" \
  && cd .. \
  && rmdir C:\zlib-%ZLIB_VERSION% /s /q \
  && del C:\tmp.zip

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
  && setx PATH "%PATH%;C:\OpenCascade\win64\gcc\bin" \
  && cd .. \
  && rmdir C:\OCCT-%OCC_VERSION% /s /q \
  && del C:\tmp.zip

# Install Qt whatever DLLs
ARG QT_VERSION="6.6.2"
ARG QT_BASEURL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/qt6_662"
ARG QT_URL="${QT_BASEURL}/qt.qt6.662.win64_mingw/6.6.2-0-202402121135"
ARG QT_DLLS_URL="${QT_URL}MinGW-w64-x86_64-11.2.0-release-posix-seh-rt_v9-rev1-runtime.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_DLLS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Tools
ARG QT_TOOLS_URL="${QT_URL}qttools-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_TOOLS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\%QT_VERSION%\mingw_64\bin" \
  && del C:\tmp.7z

# Install Qt Base
ARG QT_BASE_URL="${QT_URL}qtbase-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
ARG QT_PRI="C:\\Qt\\$QT_VERSION\\mingw_64\\mkspecs\\qconfig.pri"
RUN powershell -Command Invoke-WebRequest $env:QT_BASE_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z \
  && powershell -Command "((Get-Content -path $env:QT_PRI -Raw) -replace 'Enterprise', 'OpenSource') | Set-Content -Path $env:QT_PRI" \
  && powershell -Command "((Get-Content -path $env:QT_PRI -Raw) -replace 'licheck.exe', '') | Set-Content -Path $env:QT_PRI"

# Install Qt SVG
ARG QT_SVG_URL="${QT_URL}qtsvg-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_SVG_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Declarative
ARG QT_DECLARATIVE_URL="${QT_URL}qtdeclarative-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_DECLARATIVE_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt OpenGL (not sure if needed)
ARG QT_QT5OPENGL_URL="${QT_URL}opengl32sw-64-mesa_11_2_2-signed_sha256.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_QT5OPENGL_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt D3D (not sure if needed)
ARG QT_QT5D3D_URL="${QT_URL}d3dcompiler_47-x64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_QT5D3D_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Translations
ARG QT_TRANSLATIONS_URL="${QT_URL}qttranslations-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_TRANSLATIONS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt5 Compat
ARG QT_QT5COMPAT_URL="${QT_BASEURL}/qt.qt6.662.qt5compat.win64_mingw/6.6.2-0-202402121135qt5compat-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_QT5COMPAT_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Qt Image Formats Plugin
ARG QT_IMAGEFORMATS_URL="${QT_BASEURL}/qt.qt6.662.addons.qtimageformats.win64_mingw/6.6.2-0-202402121135qtimageformats-Windows-Windows_10_22H2-Mingw-Windows-Windows_10_22H2-X86_64.7z"
RUN powershell -Command Invoke-WebRequest $env:QT_IMAGEFORMATS_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && del C:\tmp.7z

# Install Inno Setup
ARG INNOSETUP_URL="https://files.jrsoftware.org/is/6/innosetup-6.2.2.exe"
RUN powershell -Command Invoke-WebRequest $env:INNOSETUP_URL -OutFile 'C:/tmp.exe' -UseBasicParsing ; \
  && C:/tmp.exe /NOICONS /VERYSILENT /DIR=C:\innosetup \
  && setx PATH "%PATH%;C:\innosetup" \
  && del C:\tmp.exe

# Install OpenSSL (last one in Dockerfile because it should be updated regularly)
ARG OPENSSL_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_opensslv3_x64/qt.tools.opensslv3.win_x64/3.0.12-1openssl_3.0.12_prebuild_x64.7z"
RUN powershell -Command Invoke-WebRequest $env:OPENSSL_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx OPENSSL_ROOT "C:/Qt/Tools/OpenSSLv3/Win_x64" \
  && del C:\tmp.7z
