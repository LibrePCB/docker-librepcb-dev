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
    libffi-dev \
    libglu1-mesa-dev \
    make \
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

# Install latest Qt
ARG QT_VERSION="515"
ARG QT_PPA="ppa:beineri/opt-qt-5.15.2-xenial"
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

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
