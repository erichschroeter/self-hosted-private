#!/usr/bin/env bash

# Robust error handling
set -euo pipefail

# Print usage information
show_usage() {
    echo "Usage: $0 -f BACKUP_FILE [options]"
    echo ""
    echo "Options:"
    echo "  -f, --file FILE        Path to backup archive (.tar.gz) (Required)"
    echo "  -d, --dest DIR         Target extraction/restore folder (default: local data folder)"
    echo "  -h, --help             Show this help message"
    exit 1
}

BACKUP_FILE=""
RESTORE_DEST="./data"

# Parse options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            BACKUP_FILE="$2"
            shift 2
            ;;
        -d|--dest)
            RESTORE_DEST="$2"
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

# Validate required inputs
if [ -z "${BACKUP_FILE}" ]; then
    echo "Error: Backup file (-f or --file) is required." >&2
    show_usage
fi

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "Error: Backup file '${BACKUP_FILE}' does not exist or is not a regular file." >&2
    exit 1
fi

echo "========================================="
echo "   SERVICE_NAME Restore Utility          "
echo "========================================="
echo "Backup File: ${BACKUP_FILE}"
echo "Restore Destination: ${RESTORE_DEST}"
echo "========================================="

# Ask for confirmation
read -p "WARNING: This will overwrite data in '${RESTORE_DEST}'. Are you sure? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Restore cancelled by user."
    exit 1
fi

# Ensure restore destination folder exists
mkdir -p "${RESTORE_DEST}"

# 1. Stop the running service container to avoid write conflicts
echo "Stopping SERVICE_NAME container stack..."
docker compose down || echo "Warning: Could not down stack, continuing..."

# 2. Extract and restore archive
echo "Extracting archive to ${RESTORE_DEST}..."
if tar -xzf "${BACKUP_FILE}" -C "${RESTORE_DEST}"; then
    echo "Data extraction completed successfully!"
else
    echo "Error: Extraction failed!" >&2
    exit 1
fi

# [CUSTOMIZE: Implement any custom restoration commands or database imports here]
# Example: docker compose exec -T db psql -U username < "${RESTORE_DEST}/db_dump.sql"

# 3. Bring the container stack back up
echo "Restarting SERVICE_NAME container stack..."
docker compose up -d

echo "========================================="
echo "SERVICE_NAME Restore Completed Successfully!"
echo "========================================="
exit 0
