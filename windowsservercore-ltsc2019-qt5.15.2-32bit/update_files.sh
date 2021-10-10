#!/usr/bin/env bash

# set shell settings (see https://sipb.mit.edu/doc/safe-shell/)
set -eu -o pipefail

# Configuration
QT_VERSION="5.15.2"
QT_IFW_VERSION="3.2.2"
QT_URL_BASE="https://download.qt.io/online/qtsdkrepository/windows_x86/desktop"
QT_URL="$QT_URL_BASE/qt5_5152/qt.qt5.5152.win32_mingw81/5.15.2-0-202011130602"

# Cleanup
rm -rf ./files
mkdir ./files

# OpenSSL
OPENSSL_URL="$QT_URL_BASE/tools_openssl_x86/qt.tools.openssl.win_x86/1.1.1-10openssl_1.1.1j_prebuild_x86.7z"
wget -c "$OPENSSL_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z
rm -r ./files/Qt/Tools/OpenSSL/Win_x86/html

# MinGW
MINGW_URL="$QT_URL_BASE/tools_mingw/qt.tools.win32_mingw810/8.1.0-1-202004170606i686-8.1.0-release-posix-dwarf-rt_v6-rev0.7z"
wget -c "$MINGW_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Runtime
QT_DLLS_URL="${QT_URL}i686-8.1.0-release-posix-dwarf-rt_v6-rev0-runtime.7z"
wget -c "$QT_DLLS_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Tools
QT_TOOLS_URL="${QT_URL}qttools-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
wget -c "$QT_TOOLS_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Base
QT_BASE_URL="${QT_URL}qtbase-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
wget -c "$QT_BASE_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Set license information
QT_PRI="./files/Qt/$QT_VERSION/mingw81_32/mkspecs/qconfig.pri"
sed -i 's/Enterprise/OpenSource/' "$QT_PRI"
sed -i 's/licheck.exe//' "$QT_PRI"

# Qt SVG
QT_SVG_URL="${QT_URL}qtsvg-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
wget -c "$QT_SVG_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Declarative
QT_DECLARATIVE_URL="${QT_URL}qtdeclarative-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
wget -c "$QT_DECLARATIVE_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Translations
QT_TRANSLATIONS_URL="${QT_URL}qttranslations-Windows-Windows_7-Mingw-Windows-Windows_7-X86.7z"
wget -c "$QT_TRANSLATIONS_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt
rm ./tmp.7z

# Qt Installer Framework
QT_IFW_URL="https://download.qt.io/official_releases/qt-installer-framework/$QT_IFW_VERSION/QtInstallerFramework-win-x86.exe"
wget -c "$QT_IFW_URL" -O ./tmp.7z
7z x ./tmp.7z -o./files/Qt/QtIFW
rm ./tmp.7z
rm -r ./files/Qt/QtIFW/doc
rm -r ./files/Qt/QtIFW/examples
rm ./files/Qt/QtIFW/README

# Create files.tar.gz
tar -C ./files -czf files.tar.gz .
