FROM librepcb/librepcb-dev:devtools-7

# Install APT packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get -y -q install --no-install-recommends \
    bash \
    bash-completion \
    ccache \
    cmake \
    curl \
    g++ \
    git \
    jq \
    less \
    libocct-*-dev \
    libqt6opengl6-dev \
    libqt6openglwidgets6 \
    libqt6sql6-sqlite \
    libqt6svg6-dev \
    libtbb-dev \
    libxi-dev \
    make \
    ninja-build \
    npm \
    occt-misc \
    qt6-base-dev \
    qt6-image-formats-plugins \
    qt6-l10n-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    ripgrep \
    socat \
    tree \
    xvfb \
  && rm -rf /var/lib/apt/lists/*

# Install Rust
# Make .cargo/ writable for everyone to allow running the container as non-root.
ARG RUST_VERSION="1.92.0"
ENV RUSTUP_HOME="/.rustup" \
    CARGO_HOME="/.cargo" \
    PATH="/.cargo/bin:$PATH"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $RUST_VERSION --profile minimal --no-modify-path \
  && chmod 777 $RUSTUP_HOME \
  && chmod 777 $CARGO_HOME

# Install UV
# Set its python directory to a known, user-writable path to allow accessing the
# python versions installed during docker build from within CI runs which are
# run as non-root.
ARG UV_VERSION="0.9.21"
ARG UV_URL="https://github.com/astral-sh/uv/releases/download/$UV_VERSION/uv-x86_64-unknown-linux-gnu.tar.gz"
ENV UV_PYTHON_INSTALL_DIR="/.uv/python"
RUN wget -c "${UV_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz --strip-components=1 -C /usr/local/bin/ \
  && rm /tmp.tar.gz \
  && mkdir -p $UV_PYTHON_INSTALL_DIR && chmod 777 $UV_PYTHON_INSTALL_DIR

# Install NPM packages
RUN npm install -g @github/copilot @anthropic-ai/claude-code

# Add xclip wrapper for copilot
ADD xclip /usr/local/bin/xclip

WORKDIR /work

#ENTRYPOINT ["copilot"]
