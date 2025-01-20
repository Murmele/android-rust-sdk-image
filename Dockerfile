FROM mobiledevops/android-sdk-image:34.0.1

USER root

# workaround for https://github.com/microsoft/WSL/discussions/11097
RUN mv /usr/sbin/telinit /usr/sbin/telinit.bak2
RUN ln -s /usr/bin/true /usr/sbin/telinit

RUN apt -qq update
RUN apt -qqy --no-install-recommends install cmake
RUN apt -y install ninja-build clang libgtk-3-dev
RUN apt -y install libudev-dev # serial usb
RUN apt -y install alsa-base alsa-utils libasound2-dev # sound
RUN apt -y install libsdl2-dev # display simulator

# use newer rust version
RUN apt -y remove cargo
RUN apt -y autoremove

USER mobiledevops

# ANDROID NDK
#RUN sdkmanager --sdk_root=$ANDROID_HOME "ndk;26.1.10909125"
ENV ANDROID_NDK $ANDROID_HOME/ndk

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH ~/.cargo/bin:$PATH
# nightly is required to use const generic expressions
RUN rustup default nightly-2024-10-01
RUN rustup override set nightly-2024-10-01
RUN rustup target install x86_64-linux-android
RUN rustup target add thumbv7em-none-eabihf # Embedded
RUN rustup target add aarch64-linux-android
RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add i686-linux-android
RUN rustup target add armv7-linux-androideabi
RUN rustup component add llvm-tools
RUN rustup component add rustfmt
RUN cargo install cargo-ndk # needed for the android build
RUN cargo install cargo-binutils # to check binary output size (used for small microcontrollers)


