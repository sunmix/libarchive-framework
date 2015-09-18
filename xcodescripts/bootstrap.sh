#!/bin/bash

LIBARCHIVE_FILE=libarchive-${LIBARCHIVE_VERSION}.tar.gz
LIBARCHIVE_URL="http://www.libarchive.org/downloads/${LIBARCHIVE_FILE}"
LIBARCHIVE_DIR=${PROJECT_DIR}/_libarchive_
LIBARCHIVE_VERSION_FILE=${LIBARCHIVE_DIR}/build/version

if [ -f "${LIBARCHIVE_VERSION_FILE}" ]; then
  echo "note: Libarchive exists!"
  if [ "${LIBARCHIVE_VERSION_NUMBER}" != "$( cat ${LIBARCHIVE_VERSION_FILE} )" ]; then
    echo "warning: Libarchive exists. But its version is NOT ${LIBARCHIVE_VERSION}!
    Please make sure you know what is going on."
  fi
  exit
fi

cd ${TEMP_ROOT}

if [ ! -f "${LIBARCHIVE_FILE}" ] || [ "${LIBARCHIVE_FILE_MD5}" != "$( md5 -q ${LIBARCHIVE_FILE} )" ]; then
  [ -f ${LIBARCHIVE_FILE} ] && rm ${LIBARCHIVE_FILE}
  echo "note: Downloading libarchive from ${LIBARCHIVE_URL}"
  /usr/bin/curl -# -O ${LIBARCHIVE_URL} && echo "note: Downloaded!"
  if [ "${LIBARCHIVE_FILE_MD5}" != "$( md5 -q ${LIBARCHIVE_FILE} )" ]; then
    echo "error: MD5 NOT matches!"
    exit 1
  fi
fi

echo "note: Unarchive ${LIBARCHIVE_FILE}"
tar xzf ${LIBARCHIVE_FILE}

echo "note: Move libarchive to workspace folder."
mv libarchive-${LIBARCHIVE_VERSION} ${LIBARCHIVE_DIR}

cd ${LIBARCHIVE_DIR}
echo "note: Generate config.h"
./configure --disable-bsdcpio --disable-bsdtar

echo "note: Bootstrap done!"
exit
