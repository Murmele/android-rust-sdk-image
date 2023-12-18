# Docker image for Flutter SDK with Rust packages

Docker image to build a Flutter app `*.apk` for Android and Linux with Rust support. The latest image contains always the latest stable version of the Flutter SDK: https://flutter.dev/docs/development/tools/sdk/releases?tab=linux

This is a fork of MobileDevOps/flutter-sdk-image with extended rust support.

Currently:

| Version  | Ref | Release Date |
|---|---|---|


## Releases

| Tag | Flutter Version | Flutter Channel |
|---|---|---|


## Usage

The image can be used on different cloud build services or own hosted pipeline solutions like Travis CI, CircleCI or GitLab CI/CD.

### CircleCI

CircleCI supports the direct specification of a Docker image and checks out the source code in it: https://circleci.com/docs/2.0/circleci-images/

Therefore you execute your CI script directly in the container.

Example:

```
# .circleci/config.yml
version: 2.1
jobs:
  build:
    docker: 
      - image: murmele/flutter-rust-sdk-image:1.0.0
    steps:
      - checkout
      - run:
          name: Flutter Build
          command: flutter build apk
```

### Travis CI 

To use a Docker container on Travis CI, you have to pull, run and execute it manually because Travis CI has no Docker executor: https://docs.travis-ci.com/user/docker/

And to prevent to do a new checkout of the source code in the Docker image, you can copy the code into the container via `tar` (see https://docs.docker.com/engine/reference/commandline/cp/).
To execute your CI script, use `docker exec` with the container name.

Example:

```
# .travis.yml
dist: bionic

services:
  - docker

env:
  - DOCKER_IMAGE=murmele/flutter-rust-sdk-image:1.0.0

before_install:
  - docker pull $DOCKER_IMAGE
  - docker run --name android_ci -t -d $DOCKER_IMAGE /bin/sh
  - tar Ccf . - . | docker exec -i android_ci tar Cxf /app -

script:
  - docker exec android_ci flutter build apk
```
Example Project: https://github.com/mobiledevops/flutter-ci-demo

### GitLab CI

GitLab CI/CD supports to run jobs on provided Docker images: https://docs.gitlab.com/runner/executors/docker.html

Therefore you execute your CI script directly in the container.

Example:

```
# .gitlab-ci.yml
image: murmele/flutter-rust-sdk-image:1.0.0

stages:
    - build

release_build:
    stage: build
    tags:
      - shared
    script:
        - flutter build apk
```

---

[Contributing](.github/CONTRIBUTING.md)

[Code of Conduct](.github/CODE_OF_CONDUCT.md)
