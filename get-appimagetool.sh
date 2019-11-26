/bin/bash
set -ex

HOST_ARCH=aarch64

curl -o /tmp/appimagetool-${HOST_ARCH}.AppImage -L https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${HOST_ARCH}.AppImage
chmod +x /tmp/appimagetool-${HOST_ARCH}.AppImage

cd /opt && qemu-aarch64-static /tmp/appimagetool-${HOST_ARCH}.AppImage --appimage-extract
mv /opt/squashfs-root /opt/appimagetool.AppDir

ln -s /opt/appimagetool.AppDir/AppRun /usr/bin/appimagetool
rm /tmp/appimagetool-${HOST_ARCH}.AppImage
