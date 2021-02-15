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
    libglu1-mesa-dev \
    make \
    openssl \
    python \
    software-properties-common \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Install latest Qt
ARG QT_VERSION="514"
ARG QT_PPA="ppa:beineri/opt-qt-5.14.2-xenial"
RUN add-apt-repository "$QT_PPA" -y \
  && apt-get update -q \
  && apt-get install -qq "qt${QT_VERSION}base" "qt${QT_VERSION}tools" \
                         "qt${QT_VERSION}svg" "qt${QT_VERSION}translations" \
  && rm -rf /var/lib/apt/lists/*
ENV QTDIR="/opt/qt$QT_VERSION" \
    PATH="/opt/qt$QT_VERSION/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/qt$QT_VERSION/lib/x86_64-linux-gnu:/opt/qt$QT_VERSION/lib:$LD_LIBRARY_PATH"

# Install Qt Installer Framework
ARG QTIFW_VERSION="3.2.2"
ARG QTIFW_URL_BASE="https://download.qt.io/official_releases/qt-installer-framework/$QTIFW_VERSION"
COPY qtifw-installer-noninteractive.qs /qtifw-installer-noninteractive.qs
RUN wget -cq "$QTIFW_URL_BASE/QtInstallerFramework-linux-x64.run" -O ./QtIFW.run \
  && chmod a+x ./QtIFW.run \
  && ./QtIFW.run --script /qtifw-installer-noninteractive.qs --no-force-installations --platform minimal -v \
  && mv -fv ~/Qt/QtIFW-$QTIFW_VERSION/bin/* /usr/local/bin/

# Install linuxdeployqt
ARG LINUXDEPLOYQT_VERSION="6"
ARG LINUXDEPLOYQT_URL="https://github.com/probonopd/linuxdeployqt/releases/download/$LINUXDEPLOYQT_VERSION/linuxdeployqt-$LINUXDEPLOYQT_VERSION-x86_64.AppImage"
RUN wget -cq "$LINUXDEPLOYQT_URL" -O /linuxdeployqt.AppImage \
  && chmod a+x /linuxdeployqt.AppImage \
  && /linuxdeployqt.AppImage --appimage-extract \
  && chmod -R 755 /squashfs-root \
  && ln -s /squashfs-root/AppRun /usr/local/bin/linuxdeployqt \
  && rm /linuxdeployqt.AppImage

# Install PIP (the version from APT is not sufficient)
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o get-pip.py \
  && python get-pip.py

# Install Python packages
RUN pip install \
  "future==0.17.1" \
  "flake8==3.7.7"

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
