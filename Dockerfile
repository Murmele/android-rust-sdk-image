FROM mobiledevops/flutter-sdk-image:3.16.4

USER root
RUN apt -qq update
RUN apt -qqy --no-install-recommends install cmake
RUN apt -y install ninja-build clang libgtk-3-dev

# use newer rust version
RUN apt -y remove cargo
RUN apt -y autoremove

USER mobiledevops

# ANDROID NKD
#RUN sdkmanager --sdk_root=$ANDROID_HOME "ndk;26.1.10909125"
# https://github.com/bbqsrc/cargo-ndk/issues/77
RUN sdkmanager --sdk_root=$ANDROID_HOME "ndk;23.2.8568313"
ENV ANDROID_NDK $ANDROID_HOME/ndk

# Required for Flutter Rust Bridge
RUN mkdir -p ~/.gradle
RUN echo "ANDROID_NDK=$ANDROID_NDK" > ~/.gradle/gradle.properties

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH ~/.cargo/bin:$PATH
RUN rustup target install x86_64-linux-android
RUN rustup target add thumbv7em-none-eabihf # Embedded
RUN rustup target add aarch64-linux-android
RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add i686-linux-android
RUN rustup target add armv7-linux-androideabi
RUN rustup component add rustfmt
RUN rustup component add llvm-tools-preview
RUN cargo install cargo-ndk # needed for the android build
RUN cargo install cargo-binutils # to check binary output size (used for small microcontrollers)


