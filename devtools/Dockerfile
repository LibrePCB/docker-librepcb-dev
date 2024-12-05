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
  # Stylecheck tools: git
  git \
  # Python for custom formatting scripts, flake8 etc.
  python3 \
  python3-pip \
  # Tools used on CI
  curl \
  file \
  openssl \
 && apt-get clean

# Configure default clang-format
RUN update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-15 50

# Put qhelpgenerator in PATH
RUN ln -s /usr/lib/qt6/libexec/qhelpgenerator /usr/local/bin/qhelpgenerator

# Install Python packages
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip3 install \
  cmakelang==0.6.13 \
  flake8==7.0.0 \
  reuse==3.0.2
