FROM mobiledevops/flutter-sdk-image:3.16.4

USER root
RUN apt -qq update
RUN apt -qqy --no-install-recommends install cmake

USER mobiledevops
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH ~/.cargo/bin:$PATH

RUN rustup target add thumbv7em-none-eabihf # Embedded
RUN rustup target add aarch64-linux-android
RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add i686-linux-android
RUN rustup target add armv7-linux-androideabi
RUN rustup component add rustfmt


