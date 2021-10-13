FROM ubuntu:16.04

# Install APT packages
ENV DEBIAN_FRONTEND=noninteractive
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
    libqt5opengl5 \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libqt5sql5-sqlite \
    make \
    openssl \
    qt5-default \
    qtdeclarative5-dev \
    qtdeclarative5-qtquick2-plugin \
    qttools5-dev \
    qttools5-dev-tools \
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

# Install OpenSSL 1.1 for Python/pip.
ARG OPENSSL_VERSION="1.1.1l"
RUN wget -c "https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz" -O /tmp.tar.gz \
  && tar -zxf /tmp.tar.gz \
  && cd "./openssl-$OPENSSL_VERSION" \
  && ./config --prefix=/usr --openssldir=/etc/ssl '-Wl,--enable-new-dtags,-rpath,$(LIBRPATH)' \
  && make -s -j8 \
  && make install > /dev/null \
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

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
