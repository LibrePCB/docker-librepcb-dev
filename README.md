# LibrePCB CI/Development Docker Images

[![Docker Stars](https://img.shields.io/docker/stars/librepcb/librepcb-dev.svg)](https://hub.docker.com/r/librepcb/librepcb-dev/)
[![Docker Pulls](https://img.shields.io/docker/pulls/librepcb/librepcb-dev.svg)](https://hub.docker.com/r/librepcb/librepcb-dev/)

This repository contains the Dockerfiles to build the images used for
continuous integration of [LibrePCB](https://github.com/LibrePCB/LibrePCB).

The built images are hosted at
[Docker Hub](https://hub.docker.com/r/librepcb/librepcb-dev/).


## Available Tags

### `ubuntu-20.04-qt6.6`

Based on Ubuntu 20.04, containing Qt 6.6.x from
[download.qt.io](https://download.qt.io) and OpenCascade OCCT from
[github/Open-Cascade-SAS/OCCT](https://github.com/Open-Cascade-SAS/OCCT).
This image is intended for deployment of official binary releases of LibrePCB,
which should be linked against an old version of `glibc` (for maximum
compatibility) but still using a recent Qt version (to get the latest
features/bugfixes of Qt).

In addition, this image contains
[`linuxdeployqt`](https://github.com/probonopd/linuxdeployqt) to build the
AppImage.

### `ubuntu-20.04`

Based on Ubuntu 20.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 20.04.

In addition, this image contains necessary tools for dynamic linking of
LibrePCB (pkg-config, libdxflib, libmuparser, libquazip5, libpolyclipping,
googletest).

### `ubuntu-22.04`

Based on Ubuntu 22.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 22.04.

In addition, this image contains necessary tools for dynamic linking of
LibrePCB (pkg-config, libdxflib, libmuparser, libquazip, libpolyclipping,
googletest).

### `windowsservercore-ltsc2019-qt6.6-64bit`

Based on Windows Server Core LTSC2019 with Qt6.6.x, MinGW 11.2.0 64-bit
and OpenCascade OCCT 7.7.2. This image is intended for deployment of official
64-bit binary releases of LibrePCB for Windows.

### `webtools`

An image providing all the web tools we need for
[`librepcb-doc`](https://github.com/LibrePCB/librepcb-doc) and
[`librepcb-website`](https://github.com/LibrePCB/librepcb-website):

* [Antora](https://antora.org/)
* [Asciidoctor](https://asciidoctor.org/)
* [Hugo](https://gohugo.io)

### `devtools`

An image used by the `dev/format_code.sh` script in the LibrePCB repository,
providing various tools to format code. In addition, it is used on CI to
check the coding style. Generally you never need to use this image directly.


## Updating Images

**Important: On Linux, use the helper script `./build.sh` since it makes the
procedure less error prone!**

1. Add/modify the Dockerfiles, update this README and commit all changes.
2. Run `./build.sh <image-name> <version> --push` to build and push the image.
   Use the next unused version number, i.e. the previous image version plus one.
   Use just a single number as version identifier, e.g. `1`, `2`, `3`. Semantic
   versioning is not needed since CI always links to one specific version.
3. Test the new image by pushing the LibrePCB repository to trigger the CI.
4. If everything was successful, merge the changes into `master`.
5. On the `master` branch (merge commit checked out!), create the corresponding
   Git tag by running `./build.sh <image-name> <version> --tag` (can also be
   combined with `--push` to push the image again).


## Using Images Locally

To compile LibrePCB locally using these images, run the container like this:

```bash
docker run -it --rm \
  --user "$(id -u):$(id -g)" \
  -v "$(pwd):/code" -w "/code" \
  -e OS=linux -e ARCH=x86_64 \
  librepcb/librepcb-dev:<tag>
```


## License

The content in this repository is published under the
[GNU GPLv3](http://www.gnu.org/licenses/gpl-3.0.html) license.
