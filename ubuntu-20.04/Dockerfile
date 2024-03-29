FROM ubuntu:20.04

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
    googletest \
    googletest-tools \
    graphviz \
    libc++-dev \
    libc++abi-dev \
    libdxflib-dev \
    libdxflib3 \
    libglu1-mesa-dev \
    libgmock-dev \
    libgtest-dev \
    libmuparser-dev \
    libmuparser2v5 \
    libpolyclipping-dev \
    libpolyclipping22 \
    libqt5opengl5 \
    libqt5opengl5-dev \
    libqt5sql5-sqlite \
    libqt5svg5-dev \
    libquazip5-1 \
    libquazip5-dev \
    make \
    ninja-build \
    openssl \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    qt5-default \
    qt5-image-formats-plugins \
    qtdeclarative5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    qttranslations5-l10n \
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

# Install Python packages
RUN pip install \
  "future==0.17.1" \
  "flake8==3.7.7"

# Add missing pkg-config files
ADD quazip.pc /usr/lib/pkgconfig/

# Fix broken GTest/GMock pkg-config files, see
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=958099
RUN sed -i -e 's/prefix=.*/prefix=\/usr/g' \
  /usr/lib/x86_64-linux-gnu/pkgconfig/gtest*.pc \
  /usr/lib/x86_64-linux-gnu/pkgconfig/gmock*.pc

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
