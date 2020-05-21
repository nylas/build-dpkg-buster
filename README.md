# Build Debian Package: Buster

This is a [GitHub Action](https://github.com/features/actions) that will
build a [Debian package](https://en.wikipedia.org/wiki/Deb_%28file_format%29)
(`.deb` file) using the latest version of [Debian Buster](https://www.debian.org/releases/buster/).

## Usage

```yaml
on:
  push:
    branches:
      - master

jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: singingwolfboy/build-dpkg-buster@v1
        id: build
        with:
          args: --unsigned-source --unsigned-changes

      - uses: actions/upload-artifact@v1
        with:
          name: ${{ steps.build.outputs.filename }}
          path: ${{ steps.build.outputs.filename }}
```

This Action wraps the [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
command. To use it, you must have a `debian` directory at the top of
your repository, with all the files that `dpkg-buildpackage` expects.

This Action does the following things inside a Docker container:

1. Call [`mk-build-deps`](http://manpages.ubuntu.com/manpages/buster/man1/mk-build-deps.1.html)
   to ensure that the build dependencies defined the `debian/control` file
   are installed in the Docker image.
2. Call [`dpkg-buildpackage`](https://manpages.debian.org/buster/dpkg-dev/dpkg-buildpackage.1.en.html)
   with whatever arguments are passed to the
   [`args` input](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepswithargs) in the step definition.
3. Move the resulting `*.deb` files into the top level of your repository,
   so that other GitHub Actions steps can process them futher.
4. Set the `filename` and `filename-dbgsym`
   [outputs](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjobs_idoutputs),
   so that other GitHub Actions steps can easily reference
   the resulting files.

## Related

If you need to build Debian packages on a different release, check out the following:

- [singingwolfboy/build-dpkg-stretch](https://github.com/singingwolfboy/build-dpkg-stretch)

If you want to upload the package to [Amazon S3](https://aws.amazon.com/s3/)
instead of using
[`actions/upload-artifact`](https://github.com/actions/upload-artifact),
you may want to use
[the official Docker image for the AWS CLI](https://hub.docker.com/r/amazon/aws-cli),
like this:

```yaml
jobs:
  build-deb:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - uses: singingwolfboy/build-dpkg-buster@v1
        id: build
        with:
          args: --unsigned-source --unsigned-changes

      - uses: docker://amazon/aws-cli:latest
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        with:
          args: >-
            s3
            cp
            ${{ steps.build.outputs.filename }}
            s3://my-bucket-name/${{ steps.build.outputs.filename }}
            --content-type "application/vnd.debian.binary-package"
```
