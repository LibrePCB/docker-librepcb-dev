FROM ubuntu:16.04

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bzip2 \
    ca-certificates \
    clang \
    cmake \
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
    p7zip-full \
    software-properties-common \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Remove DST root certificate since it is not compatible with OpenSSL 1.0. This
# is only needed for building the Docker image, afterwards we will have a newer
# OpenSSL library.
# See https://medium.com/geekculture/will-you-be-impacted-by-letsencrypt-dst-root-ca-x3-expiration-d54a018df257
RUN sed -i 's/mozilla\/DST_Root_CA_X3.crt/!mozilla\/DST_Root_CA_X3.crt/g' \
  /etc/ca-certificates.conf && update-ca-certificates

# Install OpenSSL 1.1 since Qt 5.15 does not work with OpenSSL 1.0
ARG OPENSSL_VERSION="1.1.1l"
RUN wget -c "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -O /tmp.tar.gz \
  && tar -zxf /tmp.tar.gz \
  && cd "./openssl-$OPENSSL_VERSION" \
  && ./config --prefix=/usr --openssldir=/etc/ssl '-Wl,--enable-new-dtags,-rpath,$(LIBRPATH)' \
  && make -s -j8 \
  && make install > /dev/null \
  && ldconfig \
  && cd .. \
  && rm -rf "./openssl-$OPENSSL_VERSION" \
  && rm /tmp.tar.gz

# Install Python & pip
# Note: Actually Python 3.5 from the official Ubuntu repositories is
# sufficient for us, but having a more recent version simplifies dependency
# management since then we can drop support for Python 3.5.
ARG PYTHON_VERSION="3.10.0"
RUN wget "https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz" \
  && tar xzvf "./Python-$PYTHON_VERSION.tgz" \
  && cd "./Python-$PYTHON_VERSION" \
  && ./configure \
  && make -j8 \
  && make install \
  && cd .. \
  && rm -rf "./Python-$PYTHON_VERSION" \
  && rm "./Python-$PYTHON_VERSION.tgz" \
  && update-alternatives --install /usr/bin/python python /usr/local/bin/python3.10 100 \
  && curl "https://bootstrap.pypa.io/pip/get-pip.py" -o get-pip.py \
  && python get-pip.py \
  && rm get-pip.py

# Install Qt Tools
ARG QT_VERSION="5.15.2"
ARG QT_URL="https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt5_5152/qt.qt5.5152.gcc_64/5.15.2-0-202011130601"
ENV QTDIR="/opt/qt/$QT_VERSION/gcc_64" \
    PATH="/opt/qt/$QT_VERSION/gcc_64/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/qt/$QT_VERSION/lib:$LD_LIBRARY_PATH" \
    PKG_CONFIG_PATH="/opt/qt/$QT_VERSION/lib/pkgconfig:$PKG_CONFIG_PATH"
RUN mkdir /opt/qt \
  && wget -c "${QT_URL}qttools-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Base
ARG QT_PRI="/opt/qt/$QT_VERSION/gcc_64/mkspecs/qconfig.pri"
RUN wget -c "${QT_URL}qtbase-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && sed -i 's/Enterprise/OpenSource/' "$QT_PRI" \
  && sed -i 's/licheck64//' "$QT_PRI" \
  && rm /tmp.7z

# Install Qt SVG
RUN wget -c "${QT_URL}qtsvg-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Declarative
RUN wget -c "${QT_URL}qtdeclarative-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Translations
RUN wget -c "${QT_URL}qttranslations-Linux-RHEL_7_6-GCC-Linux-RHEL_7_6-X86_64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install libicu
RUN wget -c "${QT_URL}icu-linux-Rhel7.2-x64.7z" -O /tmp.7z \
  && 7za x /tmp.7z -o/opt/qt \
  && rm /tmp.7z

# Install Qt Installer Framework
ARG QTIFW_VERSION="3.2.2"
ARG QTIFW_URL_BASE="https://download.qt.io/official_releases/qt-installer-framework/$QTIFW_VERSION"
COPY qtifw-installer-noninteractive.qs /qtifw-installer-noninteractive.qs
RUN wget -cq "$QTIFW_URL_BASE/QtInstallerFramework-linux-x64.run" -O /QtIFW.run \
  && chmod a+x /QtIFW.run \
  && /QtIFW.run --script /qtifw-installer-noninteractive.qs --no-force-installations --platform minimal -v \
  && mv -fv ~/Qt/QtIFW-$QTIFW_VERSION/bin/* /usr/local/bin/ \
  && rm /QtIFW.run

# Install linuxdeployqt
ARG LINUXDEPLOYQT_VERSION="6"
ARG LINUXDEPLOYQT_URL="https://github.com/probonopd/linuxdeployqt/releases/download/$LINUXDEPLOYQT_VERSION/linuxdeployqt-$LINUXDEPLOYQT_VERSION-x86_64.AppImage"
RUN wget -c "$LINUXDEPLOYQT_URL" -O /linuxdeployqt.AppImage \
  && chmod a+x /linuxdeployqt.AppImage \
  && /linuxdeployqt.AppImage --appimage-extract \
  && chmod -R 755 /squashfs-root \
  && ln -s /squashfs-root/AppRun /usr/local/bin/linuxdeployqt \
  && rm /linuxdeployqt.AppImage

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
