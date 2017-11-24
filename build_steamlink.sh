#!/bin/bash
#

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi
cd "${TOP}"

BUILD="${PWD}"
SRC="${PWD}/crt-src"

#
# Download the source
#

if [ ! -d "${SRC}" ]; then
        git clone --recursive https://github.com/Swordfish90/cool-retro-term.git "${SRC}"
fi

#
# Apply any patches
#
if [ "${TOP}/crt.patch" -nt "${BUILD}/.patch-applied" ]; then
        pushd "${SRC}"
        patch -p1 -i "${TOP}/crt.patch" || exit 1
        popd
        touch "${BUILD}/.patch-applied"
fi

#
# Build
#

cd "${SRC}"
qmake
make $MAKE_J || exit 2
cd ../

export DESTDIR="${PWD}/steamlink/apps/crt"

# Copy the files to the app directory
mkdir -p "${DESTDIR}"
cp -v "${SRC}"/cool-retro-term "${DESTDIR}"
cp -R "${SRC}"/qmltermwidget/QMLTermWidget "${DESTDIR}"
cp -v icon.png "${DESTDIR}"
# Grab bash static from debian repo
mkdir dl
cd ./dl
wget http://ftp.us.debian.org/debian/pool/main/b/bash/bash-static_4.4-5_armhf.deb
ar x bash-static_4.4-5_armhf.deb data.tar.xz
tar -xf data.tar.xz "./bin/bash-static"
mkdir -p "${DESTDIR}/.home/bin"
cp -v "./bin/bash-static" "${DESTDIR}/.home/bin/bash"
cd "${DESTDIR}/.home/bin"
ln -s bash sh
cd "${TOP}"
rm -rf ./dl
mkdir -p "${DESTDIR}/.home/lib"
# Copy terminfo from rootfs
cp -R "${MARVELL_ROOTFS}/usr/share/terminfo" "${DESTDIR}/.home/"
mv "${DESTDIR}/.home/terminfo" "${DESTDIR}/.home/.terminfo"
# Copy .bashrc to .home
cp -v .bashrc "${DESTDIR}/.home"

# Create the table of contents and icon
cat >"${DESTDIR}/toc.txt" <<__EOF__
name=Cool Retro Term
icon=icon.png
run=cool-retro-term
__EOF__

# Pack it up
name=$(basename ${DESTDIR})
pushd "$(dirname ${DESTDIR})"
tar zcvf $name.tgz $name || exit 3
rm -rf $name
popd

# All done!
echo "Build complete!"
echo
echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install."
