FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y gpg curl wget software-properties-common && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    apt-get update && \
    apt-get install -y cmake llvm-9 clang-9 autoconf automake libtool build-essential python curl git lldb-6.0 liblldb-6.0-dev libunwind8 libunwind8-dev gettext libicu-dev liblttng-ust-dev libssl-dev libnuma-dev libkrb5-dev zlib1g-dev debootstrap qemu-user-static locales && \
    locale-gen "en_US.UTF-8"

RUN mkdir /tmp/x86 /crossrootfs && \
    curl -s -o /tmp/build-rootfs.sh https://raw.githubusercontent.com/dotnet/runtime/main/eng/common/cross/build-rootfs.sh && \
    curl -s -o /tmp/x86/sources.list.xenial https://raw.githubusercontent.com/dotnet/runtime/main/eng/common/cross/x86/sources.list.xenial && \
    chmod a+x /tmp/build-rootfs.sh && \
    /tmp/build-rootfs.sh x86 --skipunmount --rootfsdir /crossrootfs

ENV ROOTFS_DIR=/crossrootfs
