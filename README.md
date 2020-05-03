# Build Debian Package: Buster

This is a [GitHub Action](https://github.com/features/actions) that will
build a [Debian package](https://en.wikipedia.org/wiki/Deb_%28file_format%29)
(`.deb` file) using the latest version of [Debian Buster](https://www.debian.org/releases/buster/).

## Usage

```
on:
  push:
    branches:
      - master

jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: singingwolfboy/build-dpkg-buster@master
        id: build
        with:
          args: --unsigned-source --unsigned-changes

      - uses: actions/upload-artifact@v1
        with:
          name: ${{ steps.build.outputs.filename }}
          path: ${{ steps.build.outputs.filename }}
```
