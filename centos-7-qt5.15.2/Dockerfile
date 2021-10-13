FROM centos:7

# Install packages
RUN yum -y update \
  && yum install -y \
    # Software Collections for recent build tools (e.g. GCC)
    centos-release-scl \
    # ELRepo for recent kernel headers (required by OpenSSL)
    elrepo-release \
    # Extra Packages required to get p7zip
    epel-release \
  && yum -y update \
  && yum --enablerepo=elrepo-kernel install -y \
    bzip2 \
    ca-certificates \
    ccache \
    cups-libs \
    curl-devel \
    dbus-devel \
    devtoolset-9-gcc-c++ \
    devtoolset-9-make \
    file \
    fontconfig \
    fontconfig-devel \
    kernel-lt-headers \
    libGL-devel \
    libpqxx \
    libX11-devel \
    libxcb-devel \
    libXext-devel \
    libXfixes \
    libXinerama \
    libxkbcommon-x11-devel \
    libXrandr \
    libXrender-devel \
    mesa-libEGL \
    p7zip \
    pcre-devel \
    perl-core \
    python3 \
    unixODBC \
    wget \
    which \
    xcb-util-image \
    xcb-util-keysyms \
    xcb-util-renderutil \
    xcb-util-wm \
    xorg-x11-server-Xvfb \
    zlib-devel \
  && yum clean all

# Make devtoolset available
ENV PATH="/opt/rh/devtoolset-9/root/usr/bin:$PATH"

# Make python3 and pip3 the default
RUN ln -fs /usr/bin/python3.6 /usr/local/bin/python
RUN ln -fs /usr/bin/pip3 /usr/local/bin/pip

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

# Install Git (the version from official repo is not sufficient)
ARG GIT_VERSION="2.33.0"
RUN wget -c "https://github.com/git/git/archive/v$GIT_VERSION.tar.gz" -O /tmp.tar.gz  \
  && tar -zxf /tmp.tar.gz \
  && cd "./git-$GIT_VERSION" \
  && make prefix=/usr -j8 \
  && make prefix=/usr install \
  && cd .. \
  && rm -rf "./git-$GIT_VERSION" \
  && rm /tmp.tar.gz

# Install CMake (the version from official repo is not sufficient)
RUN pip install cmake==3.21.3

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
