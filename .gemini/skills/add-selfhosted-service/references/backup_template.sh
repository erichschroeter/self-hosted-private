#!/usr/bin/env bash

# Robust error handling
set -euo pipefail

# Print usage information
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -d, --dir DIR          Local directory to store backup files (default: ~/backups/SERVICE_NAME)"
    echo "  -r, --retention NUM    Number of compressed archives to keep (default: 7)"
    echo "  -a, --archive BOOL     Whether to create a compressed tarball archive: 'true' or 'false' (default: true)"
    echo "  -h, --help             Show this help message"
    exit 1
}

# Initialize variables with defaults
BACKUP_DIR="${HOME}/backups/SERVICE_NAME"
RETENTION_COUNT=7
CREATE_ARCHIVE="true"

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        -r|--retention)
            RETENTION_COUNT="$2"
            shift 2
            ;;
        -a|--archive)
            CREATE_ARCHIVE="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            echo "Error: Unknown argument '$1'" >&2
            show_usage
            ;;
    esac
done

# Ensure local backup directory exists
mkdir -p "${BACKUP_DIR}"

# Define the persistent log file path
LOG_FILE="${BACKUP_DIR}/backup.log"

# Initialize the log file for this run
echo "" >> "${LOG_FILE}"
echo "=================================================================" >> "${LOG_FILE}"
echo "Backup Run Started: $(date)" >> "${LOG_FILE}"
echo "=================================================================" >> "${LOG_FILE}"

# Helper function to print to terminal and write to log file
log_msg() {
    echo -e "$1" | tee -a "${LOG_FILE}"
}

log_err() {
    echo -e "ERROR: $1" | tee -a "${LOG_FILE}" >&2
}

log_msg "========================================="
log_msg "   SERVICE_NAME Backup Utility           "
log_msg "========================================="

# Create a temporary directory for raw backup state
TEMP_BACKUP_DIR="${BACKUP_DIR}/temp_data"
mkdir -p "${TEMP_BACKUP_DIR}"

# --- STATEFUL BACKUP TASK ---
# Standard backup operation (Modify based on database or directory structure):
log_msg "Performing data copy..."
# Example: If your database uses a standard file layout (such as sqlite or file mounts):
# cp -R /path/to/data "${TEMP_BACKUP_DIR}/"
# Example: If running docker container database dumps (e.g. Postgres):
# docker compose exec -T db pg_dumpall -U username > "${TEMP_BACKUP_DIR}/db_dump.sql"

# [CUSTOMIZE: Implement custom backup command here]
# echo "Simulated backup complete" > "${TEMP_BACKUP_DIR}/simulated_data.txt"

# --- COMPRESS AND ARCHIVE ---
archive_status="SKIPPED"
if [ "${CREATE_ARCHIVE}" = "true" ]; then
    log_msg "Creating compressed tarball..."
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    ARCHIVE_FILE="${BACKUP_DIR}/SERVICE_NAME-backup-${TIMESTAMP}.tar.gz"
    
    if (cd "${TEMP_BACKUP_DIR}" && tar -czf "${ARCHIVE_FILE}" .); then
        log_msg "Backup archived successfully to: ${ARCHIVE_FILE}"
        archive_status="SUCCESS"
        
        # Clean up temp data
        rm -rf "${TEMP_BACKUP_DIR}"
        
        # Rotate old archives
        log_msg "Applying rotation policy (keeping last ${RETENTION_COUNT} archives)..."
        find "${BACKUP_DIR}" -name "SERVICE_NAME-backup-*.tar.gz" -type f -printf '%T@ %p\n' \
            | sort -n \
            | cut -d' ' -f2- \
            | head -n -"${RETENTION_COUNT}" \
            | while read -r old_archive; do
                if [ -n "${old_archive}" ] && [ -f "${old_archive}" ]; then
                    log_msg "Removing old backup: $(basename "${old_archive}")"
                    rm "${old_archive}"
                fi
            done
    else
        log_err "Failed to create compressed backup archive."
        archive_status="FAILED"
        exit 1
    fi
else
    archive_status="SKIPPED (no-archive requested)"
fi

log_msg ""
log_msg "========================================="
log_msg "            Backup Summary               "
log_msg "========================================="
log_msg "Archive Creation Status:      ${archive_status}"
log_msg "Backup directory:             ${BACKUP_DIR}"
log_msg "========================================="
log_msg "Backup run completed successfully!"
exit 0
