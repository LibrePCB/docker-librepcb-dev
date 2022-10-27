# Get Antora by using it as the base image.
FROM antora/antora:3.1.1

# Install system packages.
RUN apk add --no-cache \
  gifsicle \
  git \
  imagemagick \
  openssl \
  pngcrush \
  python3 \
  py3-pillow \
  ruby

# Install the Antora PDF extension
# See https://gitlab.com/antora/antora-assembler
RUN yarn global add "@antora/pdf-extension@1.0.0-alpha.6" \
  && rm -rf $(yarn cache dir)/* \
  && gem install asciidoctor-pdf -v 2.3.2 \
  && gem install rouge -v 4.0.0 \
  && gem install pygments.rb -v 2.3.0

# Install Hugo.
ARG HUGO_VERSION=0.104.2
ARG HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz"
RUN mkdir ./hugo \
  && cd ./hugo \
  && wget -O "./hugo.tar.gz" "$HUGO_URL" \
  && tar -xvzf ./hugo.tar.gz \
  && mv ./hugo /usr/local/bin/hugo \
  && cd .. \
  && rm -rf ./hugo
