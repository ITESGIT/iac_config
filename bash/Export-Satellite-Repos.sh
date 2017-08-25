#!/bin/bash

# DEFINE ENVIRONMENT VARIABLES
ORG="SATELLITE_REGISTERED_ORGANIZATION"
TEMPORARY_EXPORT_DIR="/mnt/nfs"
PROCESS_LIMIT=3
SLEEP_INTERVAL=30 # seconds

# BEGIN SCRIPT
# DO NOT MODIFY BELOW
# ----------------------------------------------------
PERMANENT_EXPORT_DIR="/var/lib/pulp/katello-export"
IDS=$( hammer repository list --organization ${ORG} | grep '^[[:digit:]]' | cut -d '|' -f 1 | sort -n )

# Ensure the Temporary export dir is group owned by foreman, and has write access
chgrp foreman "${TEMPORARY_EXPORT_DIR}" && chmod 0775 "${TEMPORARY_EXPORT_DIR}"

# Set the pulp export directory to the new temporary location
hammer settings set --name "pulp_export_destination" --value "${PERMANENT_EXPORT_DIR}"

# Export all Satellite repositories to the defined temporary export directory.
# Only export the number of repositories defined in the PROCESS_LIMIT variable at a time
for ID in ${IDS}; do
  echo "Repository ID ${ID} is now being exported..."
  hammer repository export --id "${ID}" > /dev/null 2>&1 &
  
  # Determine how many repositories are being exported
  PROCESSES=$(pgrep hammer | wc -l)
  
  # Sleep until the number of running repository exports is below the PROCESS_LIMIT
  while [ ${PROCESSES} -ge "${PROCESS_LIMIT}" ]; do
    sleep "${SLEEP_INTERVAL}"
    PROCESSES=$(pgrep hammer | wc -l)
  done
done

# Set the export dirback to the original value
hammer settings set --name "pulp_export_destination" --value "${PERMANENT_EXPORT_DIR}"
