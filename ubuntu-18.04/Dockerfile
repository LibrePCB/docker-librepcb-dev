FROM ubuntu:18.04

# Install APT packages
ENV DEBIAN_FRONTEND=noninteractive
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
    libglu1-mesa-dev \
    libqt5opengl5 \
    libqt5opengl5-dev \
    libqt5sql5-sqlite \
    make \
    openssl \
    python \
    python-pip \
    python-setuptools \
    python-wheel \
    qt5-default \
    qtdeclarative5-dev \
    qtdeclarative5-qtquick2-plugin \
    qttools5-dev-tools \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install \
  "future==0.17.1" \
  "flake8==3.7.7"

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
