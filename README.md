# LibrePCB CI/Development Docker Images

[![Docker Stars](https://img.shields.io/docker/stars/librepcb/librepcb-dev.svg)](https://hub.docker.com/r/librepcb/librepcb-dev/)
[![Docker Pulls](https://img.shields.io/docker/pulls/librepcb/librepcb-dev.svg)](https://hub.docker.com/r/librepcb/librepcb-dev/)

This repository contains the Dockerfiles to build the images used for
continuous integration of [LibrePCB](https://github.com/LibrePCB/LibrePCB).

The built images are hosted at
[Docker Hub](https://hub.docker.com/r/librepcb/librepcb-dev/).


## Available Tags

### `debian-8`

Based on Debian 8 (Jessie), containing Qt from the official Debian package
repository. This image is intended to check if LibrePCB compiles on a standard
Debian 8.

### `ubuntu-14.04`

Based on Ubuntu 14.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 14.04.

### `ubuntu-16.04`

Based on Ubuntu 16.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 16.04.

### `ubuntu-16.04-qt5.12.3`

Based on Ubuntu 16.04, containing Qt 5.12.3 from
[this PPA](https://launchpad.net/~beineri). This image is intended for
deployment of official binary releases of LibrePCB (installer and AppImage),
which should be linked against an old version of `glibc` (for maximum
compatibility) but still using a recent Qt version (to get the latest features
of Qt).

In addition, this image contains
[`linuxdeployqt`](https://github.com/probonopd/linuxdeployqt) and the
[Qt Installer Framework](https://doc.qt.io/qtinstallerframework/) to build the
official binary releases.

### `ubuntu-16.04-qt5.14.2`

Same purpose as `ubuntu-16.04-qt5.12.3`, but with Qt 5.14.2.

### `ubuntu-16.04-qt5.15.2`

Same purpose as `ubuntu-16.04-qt5.12.3`, but with Qt 5.15.2.

### `ubuntu-18.04`

Based on Ubuntu 18.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 18.04.

### `ubuntu-19.04`

Based on Ubuntu 19.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 19.04.

In addition, this image contains GCC 9 to check if LibrePCB can be built with
a recent compiler.

### `ubuntu-20.04`

Based on Ubuntu 20.04, containing Qt from the official Ubuntu package
repository. This image is intended to check if LibrePCB compiles on a standard
Ubuntu 20.04.

In addition, this image contains necessary tools for dynamic linking of
LibrePCB (pkg-config, libdxflib, libmuparser, libquazip5, libpolyclipping,
googletest).

### `windowsservercore-ltsc2019-qt5.15.0-32bit`

Based on Windows Server Core LTSC2019 with Qt5.15.0 and MinGW 8.1 32-bit. This
image is intended for deployment of official binary releases of LibrePCB for
Windows.

### `windowsservercore-ltsc2019-qt5.15.2-32bit`

Same purpose as `windowsservercore-ltsc2019-qt5.15.0-32bit`, but with Qt 5.15.2.

### `webtools`

An image providing all the web tools we need for
[`librepcb-doc`](https://github.com/LibrePCB/librepcb-doc) and
[`librepcb-website`](https://github.com/LibrePCB/librepcb-website):

* [Antora](https://antora.org/)
* [Asciidoctor](https://asciidoctor.org/)
* [Hugo](https://gohugo.io)


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
