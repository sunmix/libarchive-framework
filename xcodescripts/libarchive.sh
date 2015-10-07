#!/bin/bash

LIBARCHIVE_TARBALL=libarchive-${LIBARCHIVE_VERSION}.tar.gz
libarchive_url="http://www.libarchive.org/downloads/${LIBARCHIVE_TARBALL}"
libarchive_dir=${PROJECT_DIR}/_libarchive_
libarchive_version_file=${libarchive_dir}/build/version

if [ -f "${libarchive_version_file}" ]; then
  echo "note: Libarchive exists in the project folder."
  [ "${LIBARCHIVE_VERSION_NUMBER}" != "$( cat ${libarchive_version_file} )" ] && {
    printf "%s %s\n" \
    "warning: Libarchive's version is NOT ${LIBARCHIVE_VERSION}!" \
    "Make sure you know what is going on."
  }
  # Exit, since Libarchive exists.
  exit 0
fi

cd ${TEMP_ROOT}

if [ ! -f "${LIBARCHIVE_TARBALL}" ] || [ "${LIBARCHIVE_MD5}" != "$( md5 -q ${LIBARCHIVE_TARBALL} )" ]; then
  [ -e ${LIBARCHIVE_TARBALL} ] && rm ${LIBARCHIVE_TARBALL}
  echo "note: Download ${libarchive_url}"
  /usr/bin/curl -# -O ${libarchive_url} && echo "note: Downloaded!"
  [ "${LIBARCHIVE_MD5}" != "$( md5 -q ${LIBARCHIVE_TARBALL} )" ] && { echo "error: MD5 NOT matches!"; exit 1; }
fi

echo "note: Unarchive ${LIBARCHIVE_TARBALL}"
tar xzf ${LIBARCHIVE_TARBALL}

echo "note: Move libarchive to workspace folder."
mv ${LIBARCHIVE_TARBALL%.tar.gz} ${libarchive_dir}

# cd ${libarchive_dir}
# echo "note: Generate config.h"
# ./configure --disable-bsdcpio --disable-bsdtar

echo "note: Bootstrap Libarchive done!"
exit
