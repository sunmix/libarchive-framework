#!/bin/bash
set -e

XZ_URL="http://tukaani.org/xz/${XZ_TARBALL}"
XZ_DIR=${PROJECT_DIR}/_xz_
LZMA_VERSION_FILE=${XZ_DIR}/src/liblzma/api/lzma/version.h
LZMA_VERSION_ARRAY=( ${XZ_VERSION//./ } )
LZMA_VERSION_MAJOR=${LZMA_VERSION_ARRAY[0]}
LZMA_VERSION_MINOR=${LZMA_VERSION_ARRAY[1]}
LZMA_VERSION_PATCH=${LZMA_VERSION_ARRAY[2]}

if [ -f "${LZMA_VERSION_FILE}" ]; then
  echo "note: XZ(LZMA) exists in the project folder."
  for x in MAJOR MINOR PATCH; do
    version_name=LZMA_VERSION_${x}
    grep "${version_name} ${!version_name}" ${LZMA_VERSION_FILE} >/dev/null || {
      printf "%s %s\n" \
      "warning: XZ(LZMA)'s version is NOT ${XZ_VERSION}!" \
      "Make sure you know what is going on."
    }
  done
  # Exit, since XZ(LZMA) exists.
  exit 0
fi

cd ${TEMP_ROOT}

if [ ! -f "${XZ_TARBALL}" ] || [ "${XZ_MD5}" != "$( md5 -q ${XZ_TARBALL} )" ]; then
  [ -e "${XZ_TARBALL}" ] && rm "${XZ_TARBALL}"
  echo "note: Download ${XZ_URL}"
  /usr/bin/curl -s -O ${XZ_URL} && echo "note: Downloaded!"
  [ "${XZ_MD5}" != "$( md5 -q ${XZ_TARBALL} )" ] && { echo "error: MD5 NOT matches!"; exit 1; }
fi

echo "note: Unarchive ${XZ_TARBALL}"
tar xjf ${XZ_TARBALL}

echo "note: Move LZMA to workspace folder."
mv ${XZ_TARBALL%.tar.bz2} ${XZ_DIR}

echo "note: Bootstrap LZMA done!"

exit 0
