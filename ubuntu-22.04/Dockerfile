FROM ubuntu:22.04

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
    libqt5opengl5 \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libqt5sql5-sqlite \
    make \
    ninja-build \
    openssl \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    qtbase5-dev \
    qtdeclarative5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"