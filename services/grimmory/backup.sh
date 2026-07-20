#!/usr/bin/env bash

# Robust error handling
set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-/home/erich/backups/grimmory}"
RETENTION_COUNT="${RETENTION_COUNT:-7}"

# Initialize log file
mkdir -p "${BACKUP_DIR}"
LOG_FILE="${BACKUP_DIR}/backup.log"
echo "=========================================" >> "${LOG_FILE}"
echo "Grimmory Backup Started: $(date)" >> "${LOG_FILE}"
echo "=========================================" >> "${LOG_FILE}"

log_msg() {
    echo -e "$1" | tee -a "${LOG_FILE}"
}

log_err() {
    echo -e "ERROR: $1" | tee -a "${LOG_FILE}" >&2
}

# 1. Load environment variables safely
load_env_file() {
    local env_file="$1"
    if [ -f "$env_file" ]; then
        log_msg "Loading environment variables from: $env_file"
        while IFS= read -r line || [[ -n "$line" ]]; do
            # Skip comments and empty lines
            if [[ ! "$line" =~ ^[[:space:]]*# ]] && [[ -n "${line//[[:space:]]/}" ]]; then
                # Handle potential windows line endings
                line="${line%$'\r'}"
                export "$line"
            fi
        done < "$env_file"
    fi
}

cd "${SCRIPT_DIR}"
if [ -f .env ]; then
    load_env_file .env
else
    log_err "Missing .env file in ${SCRIPT_DIR}."
    exit 1
fi

if [ -f secrets.env ]; then
    load_env_file secrets.env
fi

# 2. Check if MariaDB is running
# Using docker compose ps to verify container status
if ! docker compose ps mariadb --format json 2>/dev/null | grep -q '"State":"running"\|"running"'; then
    # Fallback check if --format json is older or different
    if ! docker compose ps mariadb | grep -q "Up"; then
        log_err "MariaDB container is not running or not found. Cannot take a database dump."
        exit 1
    fi
fi

# Create a temporary working directory for this run
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TEMP_WORK_DIR="${BACKUP_DIR}/temp_${TIMESTAMP}"
mkdir -p "${TEMP_WORK_DIR}"

log_msg "Initiating backup for Grimmory..."

# 3. Perform database dump
log_msg "Dumping MariaDB database..."
# Use -T to disable pseudo-TTY allocation (critical for non-interactive scripts/cron)
if ! docker compose exec -T mariadb mariadb-dump \
    -u"${DB_USER}" \
    -p"${DB_PASSWORD}" \
    "${MYSQL_DATABASE}" > "${TEMP_WORK_DIR}/database.sql"; then
    log_err "Database dump failed!"
    rm -rf "${TEMP_WORK_DIR}"
    exit 1
fi

# 4. Copy app configurations (.env and secrets.env)
log_msg "Copying environment configuration files..."
cp .env "${TEMP_WORK_DIR}/.env"
if [ -f secrets.env ]; then
    cp secrets.env "${TEMP_WORK_DIR}/secrets.env"
fi

# 5. Archive app state (./data)
log_msg "Archiving app state data folder..."
if [ -d "./data" ] && [ "$(ls -A ./data)" ]; then
    tar -czf "${TEMP_WORK_DIR}/app_data.tar.gz" -C "./data" .
else
    log_msg "Warning: './data' directory is empty or does not exist yet."
fi

# 6. Package everything into a single compressed archive
log_msg "Packaging files into final archive..."
ARCHIVE_PATH="${BACKUP_DIR}/grimmory_backup_${TIMESTAMP}.tar.gz"
tar -czf "${ARCHIVE_PATH}" -C "${TEMP_WORK_DIR}" .

# Clean up temp folder
rm -rf "${TEMP_WORK_DIR}"
log_msg "Backup successfully created at: ${ARCHIVE_PATH}"

# 7. Apply Retention Policy
log_msg "Applying backup retention (keeping last ${RETENTION_COUNT} archives)..."
cd "${BACKUP_DIR}"
# List all grimmory backup tar.gz files sorted by time, skip the newest N, and delete the rest
ls -tp grimmory_backup_*.tar.gz 2>/dev/null | grep -v '/$' | tail -n +"$((RETENTION_COUNT + 1))" | while read -r old_backup; do
    log_msg "Deleting expired backup: ${old_backup}"
    rm -f "${old_backup}"
done

log_msg "Grimmory Backup Completed Successfully!"
