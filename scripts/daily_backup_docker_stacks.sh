#!/bin/bash
# filepath: /opt/scripts/daily_backup_docker_stacks.sh

set -e

# Configuration
## dockge stack directory
COMPOSE_ROOT="/opt/stacks"
## persistent data directory
PERSIST_ROOT="/opt/persist"
## local backup directory root
BACKUP_HOME="/opt/backups"
## daily backup directory
BACKUP_ROOT="/opt/backups/daily"
## weekly backup directory
WEEKLY_BACKUP_ROOT="/opt/backups/weekly"
## mount point for remote backup storage
BACKUP_MOUNT="/opt/netbackup"
DATE_FORMAT=$(date +"%Y-%m-%d_%H-%M-%S")
LOG_FILE="${BACKUP_ROOT}/backup_log_${DATE_FORMAT}.log"

# Ensure backup root exists
mkdir -p "${BACKUP_ROOT}"

# Setup logging
exec > >(tee -a "${LOG_FILE}") 2>&1
echo "===== Starting backup at $(date) ====="

# Check if directories exist
if [ ! -d "$COMPOSE_ROOT" ]; then
  echo "ERROR: COMPOSE_ROOT directory does not exist: $COMPOSE_ROOT"
  exit 1
fi

if [ ! -d "$PERSIST_ROOT" ]; then
  echo "ERROR: PERSIST_ROOT directory does not exist: $PERSIST_ROOT"
  exit 1
fi

# Make a backup of the docker stacks directory
if [ ! -d "$BACKUP_ROOT" ]; then
  echo "Creating backup root directory: $BACKUP_ROOT"
  mkdir -p "$BACKUP_ROOT"
fi
echo "Backup root directory is set to: $BACKUP_ROOT"

# Create backup directory for the stacks
stack_backup_dir="${BACKUP_ROOT}/stacks"
mkdir -p "$stack_backup_dir"
echo "Backup directory for stacks is set to: $stack_backup_dir"

# Ensure the backup directory exists
if [ ! -d "$stack_backup_dir" ]; then
  echo "ERROR: Failed to create backup directory: $stack_backup_dir"
  exit 1
fi

# Log the start of the backup process
echo "Starting backup process for Docker stacks at $(date)"
echo "Creating backup of $COMPOSE_ROOT to $stack_backup_dir"
stack_backup_file="${stack_backup_dir}/stacks_${DATE_FORMAT}.tar.gz"
if ! tar -czf "$stack_backup_file" -C "$COMPOSE_ROOT" .; then
  echo "ERROR: Failed to create backup of Docker stacks"
  exit 1
fi

# Process each stack
for stack_dir in "${COMPOSE_ROOT}"/*; do
  if [ -d "$stack_dir" ]; then
    stack_name=$(basename "$stack_dir")
    echo "Processing stack: $stack_name"

    # Check if corresponding persist directory exists
    persist_dir="${PERSIST_ROOT}/${stack_name}"
    if [ ! -d "$persist_dir" ]; then
      echo "WARNING: No persistence directory found for $stack_name at $persist_dir. Skipping."
      continue
    fi

    # Create backup directory for this stack
    backup_dir="${BACKUP_ROOT}/${stack_name}"
    mkdir -p "$backup_dir"

    # Set backup filename
    backup_file="${backup_dir}/${stack_name}_${DATE_FORMAT}.tar.gz"

    echo "Stopping stack: $stack_name"
    cd "$stack_dir"
    if ! docker compose down; then
      echo "ERROR: Failed to stop $stack_name stack"
      continue
    fi

    echo "Creating backup of $persist_dir to $backup_file"
    if ! tar -czf "$backup_file" -C "$(dirname "$persist_dir")" "$(basename "$persist_dir")"; then
      echo "ERROR: Backup failed for $stack_name"
      # Restart the stack even if backup failed
      docker compose up -d
      continue
    fi

    echo "Restarting stack: $stack_name"
    if ! docker compose up -d; then
      echo "ERROR: Failed to restart $stack_name stack"
      continue
    fi

    echo "Backup complete for $stack_name: $backup_file"

    # If it's a sunday, copy to weekly backup directory
    if [ "$(date +%u)" -eq 7 ]; then
      weekly_backup_dir="${WEEKLY_BACKUP_ROOT}/${stack_name}"
      mkdir -p "$weekly_backup_dir"
      cp "$backup_file" "${weekly_backup_dir}/"
      echo "Weekly backup created for $stack_name at ${weekly_backup_dir}/"
    fi

    # Optional: Remove backups older than X days
    find "$backup_dir" -name "${stack_name}_*.tar.gz" -type f -mtime +7 -delete
  fi
done

# rsync the backup directory to the mounted backup drive
# quiet so it doesn't touch the log file
# --remove-source-files to clean up the local backup directory after copying
if [ -d "$BACKUP_MOUNT" ]; then
  echo "Moving backups to mounted backup drive: $BACKUP_MOUNT"
  rsync -av --quiet --remove-source-files "$BACKUP_HOME/" "$BACKUP_MOUNT/" --dry-run
else
  echo "WARNING: Backup mount directory does not exist: $BACKUP_MOUNT. Skipping rsync."
fi

echo "===== Backup completed at $(date) ====="
