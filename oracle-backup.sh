#!/bin/bash

export ORACLE_HOME=/sw/oracle19c/install
export ORACLE_SID=herb
export PATH=${ORACLE_HOME}/bin:${PATH}

BASE_NAME=$(date +%Y-%m-%d)
BAK_DIR="/sw/backup/oracle/${BASE_NAME}"
BAK_NAME="${BASE_NAME}_herb.dmp"
BAK_PATH="${BAK_DIR}/${BAK_NAME}"

echo "start backup ${BAK_NAME}"

if [ ! -d "${BAK_DIR}" ]; then
  echo "make ${BAK_DIR}"
  mkdir "${BAK_DIR}"
  echo "${BAK_DIR} is created!!!"
fi

echo "Try to backup herb(ISM) schema to ${BAK_PATH}"
exp userid=ism/ism.1205 file="${BAK_PATH}" owner=ism
echo "Back up complete to ${BAK_PATH}"
echo "end backup"

##############################################
# 오늘 날짜 이전의 YYYY-MM-DD 디렉터리 삭제
##############################################

BACKUP_ROOT="/sw/backup/oracle"
TODAY=$(date +%Y-%m-%d)

echo "Remove old backup directories older than ${TODAY}"

for dir in "${BACKUP_ROOT}"/20*; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")

    # 날짜 형식(YYYY-MM-DD)이고 오늘보다 이전이면 삭제
    if [[ "$dirname" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      if [[ "$dirname" < "$TODAY" ]]; then
        echo "Deleting $dir"
        rm -rf "$dir"
      fi
    fi
  fi
done

echo "Old backup cleanup complete"
