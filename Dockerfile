FROM debian

RUN apt-get -y update
RUN apt-get -y install qemu-user-static binfmt-support multistrap wget
RUN apt-get -y install gnupg2

RUN mkdir -p /arm64_root
COPY ubports_arm64.multistrap /arm64_root

WORKDIR /arm64_root
RUN mkdir -p /arm64_root/etc/apt/trusted.gpg.d/
RUN wget -qO /arm64_root/etc/apt/trusted.gpg.d/ubuntu-archive-keyring.gpg http://ports.ubuntu.com/ubuntu-ports/project/ubuntu-archive-keyring.gpg
RUN multistrap -a arm64 -d . -f ubports_arm64.multistrap

# configura all
RUN cp /etc/resolv.conf etc/resolv.conf
RUN cp /usr/bin/qemu-aarch64-static usr/bin/qemu-aarch64-static
RUN chroot /arm64_root dpkg --configure -a || true

# Install python3 y pip
RUN chroot /arm64_root add-apt-repository ppa:deadsnakes/ppa -y
RUN chroot /arm64_root apt-get update -y
RUN chroot /arm64_root apt-get install -y python3.7
RUN chroot /arm64_root curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN chroot /arm64_root python3.7 /tmp/get-pip.py 


# Install libz 
RUN chroot /arm64_root apt-get install -y zlib1g
RUN chroot /arm64_root ln -s /lib/aarch64-linux-gnu/libz.so.1 /lib/aarch64-linux-gnu/libz.so
# Install appimagetool
COPY get-appimagetool.sh /arm64_root/tmp
RUN chroot /arm64_root /tmp/get-appimagetool.sh

# Install appimage-builder
RUN chroot /arm64_root pip install appimage-builder


CMD cp /etc/resolv.conf etc/resolv.conf
ENTRYPOINT "chroot" "/arm64_root" "/bin/bash"
