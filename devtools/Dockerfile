FROM ubuntu:24.04

# Install APT packages
RUN apt-get -q update \
 && apt-get -qy install \
  # Documentation tools: Doxygen, Graphviz, qhelpgenerator, rustdoc
  doxygen \
  graphviz \
  qt6-documentation-tools \
  rustc \
  # Formatting tools: clang-format, qmlformat, rustfmt, xmlsort
  clang-format-15 \
  libxml-filter-sort-perl \
  rustfmt \
  qt6-declarative-dev-tools \
  # Stylecheck tools: git, rust-clippy
  git \
  rust-clippy \
  # Python for custom formatting scripts, flake8 etc.
  python3 \
  python3-debian \
  python3-pip \
  # Tools used on CI
  curl \
  file \
  openssl \
  wget \
 && apt-get clean

# Configure default clang-format
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 50

# Put qhelpgenerator in PATH
RUN ln -s /usr/lib/qt6/libexec/qhelpgenerator /usr/local/bin/qhelpgenerator

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
