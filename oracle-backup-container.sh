#!/bin/bash

DATE=$(date +%F)

CONTAINER_NAME="herb_oracle19c"

DB_USER="ism"
DB_PASS="ism.1205"
DB_SERVICE="localhost:1521/herb"

HOST_BACKUP_DIR="/sw/herb/backup_oracle"
CONTAINER_BACKUP_DIR="/tmp/herb_backup"

DUMP_FILE="${DATE}.dmp"
LOG_FILE="${DATE}.log"

KEEP_DAYS=7
DELETE_BEFORE=$(date -d "${KEEP_DAYS} days ago" +%Y-%m-%d)

echo "===================================="
echo "HERB Oracle backup start: ${DATE}"
echo "===================================="

podman ps --format "{{.Names}}" | grep -w "${CONTAINER_NAME}" > /dev/null
if [ $? -ne 0 ]; then
  echo "ERROR: container is not running: ${CONTAINER_NAME}"
  exit 1
fi


podman exec "${CONTAINER_NAME}" rm -f "${CONTAINER_BACKUP_DIR}/${DUMP_FILE}" "${CONTAINER_BACKUP_DIR}/${LOG_FILE}"

echo "Running exp..."
podman exec "${CONTAINER_NAME}" bash -c "
cd ${CONTAINER_BACKUP_DIR} && \
exp userid=${DB_USER}/${DB_PASS}@${DB_SERVICE} \
file=${DUMP_FILE} \
owner=${DB_USER} \
log=${LOG_FILE} \
statistics=none
"

if [ $? -ne 0 ]; then
  echo "ERROR: Oracle exp failed"
  podman cp "${CONTAINER_NAME}:${CONTAINER_BACKUP_DIR}/${LOG_FILE}" "${HOST_BACKUP_DIR}/${LOG_FILE}" 2>/dev/null
  exit 1
fi

echo "Copying backup files to host..."
podman cp "${CONTAINER_NAME}:${CONTAINER_BACKUP_DIR}/${DUMP_FILE}" "${HOST_BACKUP_DIR}/${DUMP_FILE}"
if [ $? -ne 0 ]; then
  echo "ERROR: dump file copy failed"
  exit 1
fi

echo "Copying log files to host..."
podman cp "${CONTAINER_NAME}:${CONTAINER_BACKUP_DIR}/${LOG_FILE}" "${HOST_BACKUP_DIR}/${LOG_FILE}"
if [ $? -ne 0 ]; then
  echo "WARN: log file copy failed"
fi

echo "Removing backup files from container..."
podman exec "${CONTAINER_NAME}" rm -f "${CONTAINER_BACKUP_DIR}/${DUMP_FILE}" "${CONTAINER_BACKUP_DIR}/${LOG_FILE}"

echo "Backup result:"
ls -lh "${HOST_BACKUP_DIR}"

echo "===================================="
echo "HERB Oracle backup completed"
echo "Dump: ${HOST_BACKUP_DIR}/${DUMP_FILE}"
echo "Log : ${HOST_BACKUP_DIR}/${LOG_FILE}"
echo "===================================="


##############################################
# 최근 7일치 백업만 보관
##############################################

echo "Remove backup files older than ${DELETE_BEFORE}"
for file in "${HOST_BACKUP_DIR}"/20*.dmp "${HOST_BACKUP_DIR}"/20*.log; do
  # 매칭되는 파일이 없을 때 문자열 그대로 들어오는 것 방지
  if [ ! -f "$file" ]; then
    continue
  fi

  filename=$(basename "$file")
  filedate="${filename:0:10}"

  # 파일명이 YYYY-MM-DD.dmp 또는 YYYY-MM-DD.log 형식인지 확인
  if [[ "$filedate" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    if [[ "$filedate" < "$DELETE_BEFORE" ]]; then
      echo "Deleting $file"
      rm -f "$file"
      if [ $? -ne 0 ]; then
        echo "WARN: Failed to delete old backup file: $file"
      fi
    fi
  fi
done

echo "Old backup cleanup complete"
echo "end backup"
exit 0
