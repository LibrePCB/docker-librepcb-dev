FROM ubuntu:26.04

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bzip2 \
    ca-certificates \
    ccache \
    clang \
    clang-tidy \
    # For clang-apply-replacements, required by run-clang-tidy
    clang-tools \
    clazy \
    cmake \
    curl \
    dbus \
    file \
    g++ \
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
    # Note: Actually we want libocct-data-exchange-dev, but this pulls in tons
    # of bloated dependencies (Java?!?!), thus we do in in a complicated way
    # (see also the apt-get download below).
    libocct-data-exchange-7.9 \
    libpolyclipping-dev \
    libpolyclipping22 \
    libqt6opengl6-dev \
    libqt6openglwidgets6 \
    libqt6sql6-sqlite \
    libqt6svg6-dev \
    # https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg6249494.html
    libstdc++-16-dev \
    libtbb-dev \
    libxi-dev \
    make \
    ninja-build \
    occt-misc \
    openssl \
    pkg-config \
    qt6-base-dev \
    qt6-image-formats-plugins \
    qt6-l10n-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    wget \
    xvfb \
    zlib1g \
    zlib1g-dev \
  # Extract OCCT dev package files (headers, cmake configs, .so symlinks)
  # without using apt-get install as it would pull in tons of dependencies.
  && cd /tmp \
  && apt-get download \
    libocct-foundation-dev \
    libocct-modeling-data-dev \
    libocct-modeling-algorithms-dev \
    libocct-ocaf-dev \
    libocct-visualization-dev \
    libocct-data-exchange-dev \
    libocct-ivtk-7.9 \
  && for f in /tmp/libocct-*.deb; do dpkg-deb -x "$f" /; done \
  && rm -f /tmp/libocct-*.deb \
  && rm -rf /var/lib/apt/lists/*

# Install Rust
# Make .cargo/ writable for everyone to allow running the container as non-root.
ARG RUST_VERSION="1.95.0"
ENV RUSTUP_HOME="/.rustup" \
    CARGO_HOME="/.cargo" \
    PATH="/.cargo/bin:$PATH"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $RUST_VERSION --profile minimal --no-modify-path \
  && cargo install cargo-llvm-cov \
  && rm -rf $CARGO_HOME/registry $CARGO_HOME/git \
  && chmod -R 777 $RUSTUP_HOME \
  && chmod -R 777 $CARGO_HOME

# Install UV
# Set its python directory to a known, user-writable path to allow accessing the
# python versions installed during docker build from within CI runs which are
# run as non-root.
ARG UV_VERSION="0.11.8"
ARG UV_URL="https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-x86_64-unknown-linux-gnu.tar.gz"
ENV UV_PYTHON_INSTALL_DIR="/.uv/python"
RUN wget -c "${UV_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz --strip-components=1 -C /usr/local/bin/ \
  && rm /tmp.tar.gz \
  && mkdir -p $UV_PYTHON_INSTALL_DIR && chmod 777 $UV_PYTHON_INSTALL_DIR

# Pre-install a Python version
ARG PYTHON_VERSION="3.14"
RUN uv python install $PYTHON_VERSION

# Install ctcache (clang-tidy-cache)
ARG CTCACHE_URL="https://github.com/matus-chochlik/ctcache/raw/0c7fee26e09ae8a393ed7d56164102da118ab23a/src/ctcache/clang_tidy_cache.py"
ENV CTCACHE_CLANG_TIDY="/usr/bin/clang-tidy" \
    CTCACHE_DIR="/.ctcache" \
    CTCACHE_KEEP_COMMENTS=1
RUN wget -c "${CTCACHE_URL}" -O /usr/local/bin/ctcache.py \
  && printf '#!/bin/bash\n/usr/local/bin/ctcache.py "${CTCACHE_CLANG_TIDY}" "${@}"\n' > /usr/local/bin/ctcache \
  && chmod +x /usr/local/bin/ctcache.py /usr/local/bin/ctcache \
  && mkdir "$CTCACHE_DIR" && chmod -R 777 "$CTCACHE_DIR"

# Make ccache directory writable for everyone to allow running the container
# as non-root.
ENV CCACHE_DIR="/.ccache"
RUN mkdir $CCACHE_DIR && chmod -R 777 $CCACHE_DIR

# LibrePCB's unittests expect that there is a USERNAME environment variable
ENV USERNAME="root"
