FROM ubuntu:24.04

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bzip2 \
    ca-certificates \
    ccache \
    clang \
    cmake \
    curl \
    dbus \
    file \
    g++ \
    gettext \
    git \
    googletest \
    libc++-dev \
    libc++abi-dev \
    libdxflib-dev \
    libdxflib3 \
    libglu1-mesa-dev \
    libgmock-dev \
    libgtest-dev \
    libmuparser-dev \
    libmuparser2v5 \
    libocct-*-dev \
    libpolyclipping-dev \
    libpolyclipping22 \
    libqt6opengl6-dev \
    libqt6openglwidgets6 \
    libqt6sql6-sqlite \
    libqt6svg6-dev \
    libquazip1-qt6-1t64 \
    libquazip1-qt6-dev \
    libtbb-dev \
    libxi-dev \
    make \
    ninja-build \
    occt-misc \
    openssl \
    pkg-config \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    qt6-base-dev \
    qt6-image-formats-plugins \
    qt6-l10n-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    sccache \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Set Python3 as default Python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 100

# Allow installing pip packages system-wide since there's no risk in a container
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Install Rust
# Make .cargo/ writable for everyone to allow running the container as non-root.
ARG RUST_VERSION="1.85.1"
ENV RUSTUP_HOME="/.rustup" \
    CARGO_HOME="/.cargo" \
    PATH="/.cargo/bin:$PATH"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $RUST_VERSION --profile minimal --no-modify-path \
  && chmod 777 $RUSTUP_HOME \
  && chmod 777 $CARGO_HOME

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
