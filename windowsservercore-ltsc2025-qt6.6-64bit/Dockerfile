FROM mcr.microsoft.com/windows/servercore:ltsc2025

# Add OpenGL DLLs from a Windows desktop to allow running unit tests within the container
ADD *.dll C:/Windows/System32/

# Add Arial font since Slint requires it, see
# https://github.com/slint-ui/slint/issues/2556#issuecomment-2995413102
ADD arial.ttf C:/Windows/Fonts/

# Install Microsoft Visual C++ Redistributable for Visual Studio 2015-2022
ARG VCREDIST_URL="https://download.visualstudio.microsoft.com/download/pr/6ba404bb-6312-403e-83be-04b062914c98/1AD7988C17663CC742B01BEF1A6DF2ED1741173009579AD50A94434E54F56073/VC_redist.x64.exe"
RUN curl -o "C:/tmp.exe" -L "%VCREDIST_URL%" \
  && C:/tmp.exe /quiet /norestart \
  && del C:\tmp.exe

# Install 7-Zip
# Attention: I observed issues with version 2409, thus better keep the old version
ARG 7ZIP_URL="https://7-zip.org/a/7z2301-x64.exe"
RUN curl -o "C:/tmp.exe" -L "%7ZIP_URL%" \
  && C:/tmp.exe /S /D="C:/7zip" \
  && setx PATH "%PATH%;C:\7zip" \
  && del C:\tmp.exe

# Install Git
# Attention: Version 2.50 breaks our CI in a strange way!
ARG GIT_VERSION="2.44.0"
ARG GIT_URL="https://github.com/git-for-windows/git/releases/download/v$GIT_VERSION.windows.1/Git-$GIT_VERSION-64-bit.exe"
RUN curl -o "C:/tmp.exe" -L "%GIT_URL%" \
  && C:/tmp.exe /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS \
                /COMPONENTS="gitlfs" /o:PathOption="CmdTools" /o:CRLFOption="LFOnly" /DIR:"C:/git" \
  && del C:\tmp.exe

# Install UV
ARG UV_URL="https://github.com/astral-sh/uv/releases/download/0.7.13/uv-x86_64-pc-windows-msvc.zip"
RUN curl -o "C:/tmp.zip" -L "%UV_URL%" \
  && 7z x C:/tmp.zip -oC:/uv -bsp1 \
  && setx PYTHONIOENCODING "UTF-8" \
  && setx PATH "%PATH%;C:\uv" \
  && del C:\tmp.zip

# Install CMake
ARG CMAKE_VERSION="4.0.3"
ARG CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-windows-x86_64.zip"
RUN curl -o "C:/tmp.zip" -L "%CMAKE_URL%" \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && rename cmake-%CMAKE_VERSION%-windows-x86_64 cmake \
  && setx PATH "%PATH%;C:\cmake\bin" \
  && del C:\tmp.zip

# Install Ninja
ARG NINJA_URL="https://github.com/ninja-build/ninja/releases/download/v1.12.1/ninja-win.zip"
RUN curl -o "C:/tmp.zip" -L "%NINJA_URL%" \
  && 7z x C:/tmp.zip -oC:/ninja -bsp1 \
  && setx PATH "%PATH%;C:\ninja" \
  && del C:\tmp.zip

# Install CCache
ARG CCACHE_VERSION="4.11.3"
ARG CCACHE_URL="https://github.com/ccache/ccache/releases/download/v$CCACHE_VERSION/ccache-$CCACHE_VERSION-windows-x86_64.zip"
RUN curl -o "C:/tmp.zip" -L "%CCACHE_URL%" \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && rename ccache-%CCACHE_VERSION%-windows-x86_64 ccache \
  && setx PATH "%PATH%;C:\ccache" \
  && del C:\tmp.zip

# Install MinGW
ARG MINGW_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_mingw90/qt.tools.win64_mingw900/9.0.0-1-202203221220mingw-w64-x86_64-11.2.0-release-posix-seh-rt_v9-rev3.7z"
RUN powershell -Command Invoke-WebRequest $env:MINGW_URL -OutFile 'C:/tmp.7z' -UseBasicParsing ; \
  && 7z x C:/tmp.7z -oC:/Qt -bsp1 \
  && setx PATH "%PATH%;C:\Qt\Tools\mingw1120_64\bin" \
  && del C:\tmp.7z

# Install Rust
ARG RUST_VERSION="1.87.0"
ENV RUSTUP_HOME="C:\rustup" \
    CARGO_HOME="C:\cargo"
RUN curl -o "C:/rustup-init.exe" -L "https://win.rustup.rs/x86_64" \
  && C:/rustup-init.exe -y -v \
     --profile minimal \
     --default-host x86_64-pc-windows-gnu \
     --default-toolchain none \
  && C:\cargo\bin\rustup install %RUST_VERSION% \
  && del C:\rustup-init.exe

# Install ZLib
ARG ZLIB_VERSION="1.3.1"
ARG ZLIB_URL="https://github.com/madler/zlib/releases/download/v$ZLIB_VERSION/zlib131.zip"
RUN curl -o "C:/tmp.zip" -L "%ZLIB_URL%" \
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
ARG OCC_VERSION="7_9_1"
ARG OCC_URL="https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V$OCC_VERSION.zip"
RUN curl -o "C:/tmp.zip" -L "%OCC_URL%" \
  && 7z x C:/tmp.zip -oC:/ -bsp1 \
  && cd C:\OCCT-%OCC_VERSION% \
  && cmake . -G "Ninja" \
       -DCMAKE_BUILD_TYPE=Release \
       -DINSTALL_DIR=C:/OpenCascade \
       -DBUILD_LIBRARY_TYPE=Shared \
       -DBUILD_DOC_Overview=0 \
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

# Install Qt Runtime DLLs
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
# Note: 6.4.3 emits some warnings when generating the LibrePCB installer,
# should be reviewed when upgrading
ARG INNOSETUP_URL="https://files.jrsoftware.org/is/6/innosetup-6.2.2.exe"
RUN curl -o "C:/tmp.exe" -L "%INNOSETUP_URL%" \
  && C:/tmp.exe /NOICONS /VERYSILENT /DIR=C:\innosetup \
  && setx PATH "%PATH%;C:\innosetup" \
  && del C:\tmp.exe

# Pre-install a Python version
RUN uv python install 3.13

# Install OpenSSL (last one in Dockerfile because it should be updated regularly)
ARG OPENSSL_URL="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop/tools_opensslv3_x64/qt.tools.opensslv3.win_x64/3.0.16-1openssl_3.0.16_prebuild_x64.7z"
RUN curl -o "C:/tmp.7z" -L "%OPENSSL_URL%" \
  && 7z x C:/tmp.7z -oC:/Qt/Tools/OpenSSLv3 -bsp1 \
  && setx OPENSSL_ROOT "C:/Qt/Tools/OpenSSLv3/Win_x64" \
  && del C:\tmp.7z
