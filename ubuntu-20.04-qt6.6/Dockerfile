FROM ubuntu:20.04

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bzip2 \
    ca-certificates \
    clang \
    curl \
    dbus \
    doxygen \
    file \
    g++ \
    git \
    graphviz \
    libc++-dev \
    libc++abi-dev \
    libcups2 \
    libegl1-mesa \
    libffi-dev \
    libfontconfig1 \
    libfreetype6 \
    libglu1-mesa-dev \
    libodbc1 \
    libpq5 \
    libssl-dev \
    libxcb-cursor0 \
    libxcb-glx0 \
    libxcb-icccm4 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxcb1 \
    libxkbcommon-x11-0 \
    make \
    ninja-build \
    p7zip-full \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    software-properties-common \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Set Python3 as default Python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 100
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 100

# Allow installing pip packages system-wide since there's no risk in a container
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install CMake
ARG CMAKE_VERSION="3.31.1"
ARG CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz"
RUN wget -c "${CMAKE_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz -C /opt \
  && rm /tmp.tar.gz \
  && cd "/opt/cmake-$CMAKE_VERSION" \
  && ./bootstrap --parallel=`nproc` \
  && make -j`nproc` \
  && make install \
  && cd / && rm -rf "/opt/cmake-$CMAKE_VERSION"

# Install OpenCascade
ARG OCC_VERSION="7_7_2"
ARG OCC_URL="https://github.com/Open-Cascade-SAS/OCCT/archive/refs/tags/V$OCC_VERSION.tar.gz"
RUN wget -c "${OCC_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz -C /opt \
  && rm /tmp.tar.gz \
  && cd "/opt/OCCT-$OCC_VERSION" \
  && cmake . -G "Ninja" \
       -DCMAKE_BUILD_TYPE=Release \
       -DINSTALL_DIR=/usr \
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
  && ninja && ninja install \
  && cd / && rm -rf "/opt/OCCT-$OCC_VERSION"

# Install Qt Tools
ARG QT_VERSION="6.6.2"
ARG QT_BASEURL="https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt6_662"
ARG QT_URL="$QT_BASEURL/qt.qt6.662.gcc_64/6.6.2-0-202402121133"
ENV QTDIR="/opt/qt/$QT_VERSION/gcc_64" \
    PATH="/opt/qt/$QT_VERSION/gcc_64/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/qt/$QT_VERSION/gcc_64/lib:$LD_LIBRARY_PATH" \
    PKG_CONFIG_PATH="/opt/qt/$QT_VERSION/gcc_64/lib/pkgconfig:$PKG_CONFIG_PATH"
RUN mkdir /opt/qt \
  && wget -c "${QT_URL}qttools-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z \
  # The AppImage deployment tools might read some paths from the Qt libraries,
  # but they are wrong so let's create a symlink to make them working anyway:
  && mkdir -p "/home/qt/work" \
  && ln -s "/opt/qt/$QT_VERSION/gcc_64" "/home/qt/work/install"

# Install Qt Base
ARG QT_PRI="/opt/qt/$QT_VERSION/gcc_64/mkspecs/qconfig.pri"
RUN wget -c "${QT_URL}qtbase-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && sed -i 's/Enterprise/OpenSource/' "$QT_PRI" \
  && sed -i 's/licheck64//' "$QT_PRI" \
  # Allow removing unneeded SQL plugins during CI job to fix deployment issue:
  # https://forum.qt.io/topic/151452/what-qt-specific-files-exactly-do-i-need-to-add-when-deploying
  && chmod 777 $QTDIR/plugins/sqldrivers \
  && rm /tmp.7z

# Install Qt SVG
RUN wget -c "${QT_URL}qtsvg-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Declarative
RUN wget -c "${QT_URL}qtdeclarative-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Translations
RUN wget -c "${QT_URL}qttranslations-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt5 Compat
RUN wget -c "${QT_BASEURL}/qt.qt6.662.qt5compat.gcc_64/6.6.2-0-202402121133qt5compat-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Image Formats Plugin
RUN wget -c "${QT_BASEURL}/qt.qt6.662.addons.qtimageformats.gcc_64/6.6.2-0-202402121133qtimageformats-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install libicu
RUN wget -c "${QT_URL}icu-linux-Rhel7.2-x64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install linuxdeployqt
ARG LINUXDEPLOYQT_URL="https://github.com/probonopd/linuxdeployqt/releases/download/10/linuxdeployqt-continuous-x86_64.AppImage"
RUN wget -c "$LINUXDEPLOYQT_URL" -O /linuxdeployqt.AppImage \
  && chmod a+x /linuxdeployqt.AppImage \
  && /linuxdeployqt.AppImage --appimage-extract \
  && chmod -R 755 /squashfs-root \
  && mv /squashfs-root /opt/linuxdeployqt \
  && ln -s /opt/linuxdeployqt/AppRun /usr/local/bin/linuxdeployqt \
  && rm /linuxdeployqt.AppImage

# Install beta appimagetool which should not depend on any system libraries
# anymore, and should therefore run on Ubuntu 22.04 which doesn't provide
# libfuse2 anymore (see https://github.com/LibrePCB/LibrePCB/issues/980).
# However, since there are no official releases yet, the binary is downloaded
# from the nightly build and added to the repository. Download URL:
# https://github.com/probonopd/go-appimage/releases/download/continuous/appimagetool-765-x86_64.AppImage
COPY appimagetool-x86_64.AppImage /appimagetool-x86_64.AppImage
RUN /appimagetool-x86_64.AppImage --appimage-extract \
  && chmod -R 755 /squashfs-root \
  && mv /squashfs-root /opt/appimagetool \
  && ln -s /opt/appimagetool/AppRun /usr/local/bin/appimagetool \
  && rm /appimagetool-x86_64.AppImage

# Install latest OpenSSL to avoid possible issues if servers some day stop
# working with an old OpenSSL library (as already happened in the past).
ARG OPENSSL_VERSION="3.4.0"
RUN wget -c "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -O /tmp.tar.gz \
  && tar -zxf /tmp.tar.gz \
  && cd "./openssl-$OPENSSL_VERSION" \
  && ./config --prefix=/usr --libdir=lib --openssldir=/etc/ssl '-Wl,--enable-new-dtags,-rpath,$(LIBRPATH)' \
  && make -s -j8 \
  && make install \
  && ldconfig \
  && cd .. \
  && rm -rf "./openssl-$OPENSSL_VERSION" \
  && rm /tmp.tar.gz

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
