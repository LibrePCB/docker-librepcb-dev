FROM ubuntu:20.04

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bzip2 \
    ca-certificates \
    ccache \
    clang \
    curl \
    dbus \
    doxygen \
    file \
    g++-10 \
    gettext \
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
    software-properties-common \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Activate g++-10
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100

# Install Rust
# Make .cargo/ writable for everyone to allow running the container as non-root.
ARG RUST_VERSION="1.87.0"
ENV RUSTUP_HOME="/.rustup" \
    CARGO_HOME="/.cargo" \
    PATH="/.cargo/bin:$PATH"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $RUST_VERSION --profile minimal --no-modify-path \
  && chmod 777 $RUSTUP_HOME \
  && chmod 777 $CARGO_HOME

# Install CMake
ARG CMAKE_VERSION="4.0.3"
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
ARG OCC_VERSION="7_9_1"
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

# Install Qt Translations
RUN wget -c "${QT_URL}qttranslations-Linux-RHEL_8_8-GCC-Linux-RHEL_8_8-X86_64.7z" -O /tmp.7z \
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

# Install linuxdeploy
ARG LINUXDEPLOY_URL="https://github.com/linuxdeploy/linuxdeploy/releases/download/1-alpha-20250213-2/linuxdeploy-x86_64.AppImage"
ARG LINUXDEPLOY_PLUGIN_APPIMAGE_URL="https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases/download/1-alpha-20250213-1/linuxdeploy-plugin-appimage-x86_64.AppImage"
ARG LINUXDEPLOY_PLUGIN_QT_URL="https://github.com/linuxdeploy/linuxdeploy-plugin-qt/releases/download/1-alpha-20250213-1/linuxdeploy-plugin-qt-x86_64.AppImage"
ENV APPIMAGE_EXTRACT_AND_RUN=1
RUN wget -c "$LINUXDEPLOY_URL" -O /usr/local/bin/linuxdeploy-x86_64.AppImage \
  && chmod a+x /usr/local/bin/linuxdeploy-x86_64.AppImage \
  && wget -c "$LINUXDEPLOY_PLUGIN_APPIMAGE_URL" -O /usr/local/bin/linuxdeploy-plugin-appimage-x86_64.AppImage \
  && chmod a+x /usr/local/bin/linuxdeploy-plugin-appimage-x86_64.AppImage \
  && wget -c "$LINUXDEPLOY_PLUGIN_QT_URL" -O /usr/local/bin/linuxdeploy-plugin-qt-x86_64.AppImage \
  && chmod a+x /usr/local/bin/linuxdeploy-plugin-qt-x86_64.AppImage \
  && linuxdeploy-x86_64.AppImage --list-plugins

# Install UV
# Set its python directory to a known, user-writable path to allow accessing the
# python versions installed during docker build from within CI runs which are
# run as non-root.
ARG UV_VERSION="0.7.13"
ARG UV_URL="https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-x86_64-unknown-linux-gnu.tar.gz"
ENV UV_PYTHON_INSTALL_DIR="/.uv/python"
RUN wget -c "${UV_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz --strip-components=1 -C /usr/local/bin/ \
  && rm /tmp.tar.gz \
  && mkdir -p $UV_PYTHON_INSTALL_DIR && chmod 777 $UV_PYTHON_INSTALL_DIR

# Pre-install a Python version
ARG PYTHON_VERSION="3.13"
RUN uv python install $PYTHON_VERSION

# Install latest OpenSSL to avoid possible issues if servers some day stop
# working with an old OpenSSL library (as already happened in the past).
ARG OPENSSL_VERSION="3.5.0"
ENV LD_LIBRARY_PATH="/opt/openssl/lib:$LD_LIBRARY_PATH"
RUN apt-get remove -y libssl-dev \
  && wget -c "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -O /tmp.tar.gz \
  && tar -zxf /tmp.tar.gz \
  && cd "./openssl-$OPENSSL_VERSION" \
  && ./config --prefix=/opt/openssl --libdir=lib --openssldir=/opt/openssl/etc/ssl \
  && make -j8 \
  && make install_sw \
  && cd .. \
  && rm -rf "./openssl-$OPENSSL_VERSION" \
  && rm /tmp.tar.gz

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
