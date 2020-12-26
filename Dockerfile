FROM bash:5.0.17
LABEL maintainer="Aditya Kresna <aditya.kresna@outlook.co.id>"

ENV CXX=clang++ \
    CC=clang \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.46.0

RUN apk --no-cache add ca-certificates gcc autoconf automake \
    cmake freetype-dev g++ gcc libxml2-dev linux-headers \
    make musl-dev ncurses-dev python3 wget curl openssl \
    openssl-libs-static openssl-dev libelf-static libelf \
    elfutils-dev python3-dev git pkgconf samurai libtool \
    gettext libpcap-dev zlib-dev zlib-static lz4-dev lz4-libs \
    lz4-static lz4 zlib snappy snappy-dev snappy-static \
    bzip2-dev bzip2 bzip2-static gflags-dev gflags zstd \
    zstd-static zstd-dev zstd-libs clang clang-analyzer \
    clang-extra-tools clang-libs clang-dev clang-static \
    llvm10 llvm10-static llvm-libunwind llvm-libunwind-dev \
    llvm10-libs llvm-libunwind-static llvm10-dev libgcc

RUN set -eux; \
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
    x86_64) rustArch='x86_64-unknown-linux-musl'; rustupSha256='8ab4f7759e22c308b49d737b5dc055c0d334f730632fdc6a169eda033983b846' ;; \
    aarch64) rustArch='aarch64-unknown-linux-musl'; rustupSha256='b3f15d01db21e4e9f192a81bfcbbb72e9055f6b01b4d0893b24f9f6c9f9d2b92' ;; \
    *) echo >&2 "unsupported architecture: $apkArch"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.23.0/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile default --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;
