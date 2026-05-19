#!/bin/bash

export ORACLE_HOME=/sw/oracle19c/install
export ORACLE_SID=herb
export PATH=${ORACLE_HOME}/bin:${PATH}

BASE_NAME=$(date +%Y-%m-%d)

BACKUP_ROOT="/sw/backup/oracle"
BAK_DIR="${BACKUP_ROOT}/${BASE_NAME}"

BAK_NAME="${BASE_NAME}_herb.dmp"
LOG_NAME="${BASE_NAME}_herb.log"

BAK_PATH="${BAK_DIR}/${BAK_NAME}"
LOG_PATH="${BAK_DIR}/${LOG_NAME}"

KEEP_DAYS=7
DELETE_BEFORE=$(date -d "${KEEP_DAYS} days ago" +%Y-%m-%d)

echo "start backup ${BAK_NAME}"

if [ ! -d "${BAK_DIR}" ]; then
  echo "make ${BAK_DIR}"
  mkdir -p "${BAK_DIR}"

  if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create backup directory: ${BAK_DIR}"
    exit 1
  fi

  echo "${BAK_DIR} is created!!!"
fi

echo "Try to backup herb(ISM) schema to ${BAK_PATH}"

exp userid=ism/ism.1205 file="${BAK_PATH}" log="${LOG_PATH}" owner=ism

EXP_RESULT=$?

if [ ${EXP_RESULT} -ne 0 ]; then
  echo "ERROR: Backup failed. exp exit code: ${EXP_RESULT}"
  echo "Check log file: ${LOG_PATH}"
  exit 1
fi

if [ ! -s "${BAK_PATH}" ]; then
  echo "ERROR: Backup dump file does not exist or is empty: ${BAK_PATH}"
  echo "Check log file: ${LOG_PATH}"
  exit 1
fi

echo "Back up complete to ${BAK_PATH}"
echo "Backup log: ${LOG_PATH}"

##############################################
# 최근 7일치 백업만 보관
##############################################

echo "Remove backup directories older than ${DELETE_BEFORE}"

for dir in "${BACKUP_ROOT}"/20*; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")

    # 날짜 형식(YYYY-MM-DD)이고 7일 보관 기준일보다 이전이면 삭제
    if [[ "$dirname" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      if [[ "$dirname" < "$DELETE_BEFORE" ]]; then
        echo "Deleting $dir"
        rm -rf "$dir"

        if [ $? -ne 0 ]; then
          echo "WARN: Failed to delete old backup directory: $dir"
        fi
      fi
    fi
  fi
done

echo "Old backup cleanup complete"
echo "end backup"