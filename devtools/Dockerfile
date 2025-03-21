FROM ubuntu:24.04

# Install APT packages
RUN apt-get -q update \
 && apt-get -qy install \
  # Documentation tools: Doxygen, Graphviz, qhelpgenerator
  doxygen \
  graphviz \
  qt6-documentation-tools \
  # Formatting tools: clang-format, qmlformat, xmlsort
  clang-format-15 \
  libxml-filter-sort-perl \
  qt6-declarative-dev-tools \
  # Stylecheck tools: git, appstream-util
  appstream-util \
  git \
  # Python for custom formatting scripts, flake8 etc.
  python3 \
  python3-debian \
  python3-pip \
  # Translation tools
  python3-defusedxml \
  qt6-l10n-tools \
  # Tools used on CI
  curl \
  file \
  openssl \
  wget \
 && apt-get clean

# Configure default clang-format
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 50

# Put Qt tools in PATH (lupdate, qhelpgenerator, ...)
ENV PATH="$PATH:/usr/lib/qt6/bin:/usr/lib/qt6/libexec"

# Install Rust, including rustdoc, rustfmt, rust-clippy
# Make .cargo/ writable for everyone to allow running the container as non-root.
ARG RUST_VERSION="1.85.0"
ENV RUSTUP_HOME="/.rustup" \
    CARGO_HOME="/.cargo" \
    PATH="/.cargo/bin:$PATH"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain $RUST_VERSION --no-modify-path \
  && chmod 777 $RUSTUP_HOME \
  && chmod 777 $CARGO_HOME

# Install slint-tr-extractor for usage on LibrePCB server
ARG SLINT_TR_EXTRACTOR_VERSION="1.10.0"
RUN cargo install --version $SLINT_TR_EXTRACTOR_VERSION slint-tr-extractor \
  && rm -rf $CARGO_HOME/registry \
  && slint-tr-extractor --version

# Install slint-lsp for its formatter
ARG SLINT_LSP_VERSION="1.10.0"
ARG SLINT_LSP_URL="https://github.com/slint-ui/slint/releases/download/v${SLINT_LSP_VERSION}/slint-lsp-linux.tar.gz"
RUN wget -c "${SLINT_LSP_URL}" -O /tmp.tar.gz \
  && tar -xzf /tmp.tar.gz -C /usr/local/bin --strip-components 1 slint-lsp/slint-lsp \
  && rm /tmp.tar.gz \
  && slint-lsp --version

# Install Python packages
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip3 install \
  cmakelang==0.6.13 \
  flake8==7.1.1 \
  reuse==5.0.2

# Install debian-copyright-sorter from
# https://salsa.debian.org/debian/debian-copyright-sorter
ARG DCS_URL="https://salsa.debian.org/debian/debian-copyright-sorter/-/raw/46a40920761e738b79658ebe8f2ea6eb8e5aabd0/debian_copyright_sorter.py"
RUN wget -c "${DCS_URL}" -O /usr/local/bin/debian-copyright-sorter \
  && chmod a+x /usr/local/bin/debian-copyright-sorter
