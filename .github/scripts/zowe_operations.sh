#!/bin/bash

# zowe_operations.sh

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
ZOWE_OPTS="--user $ZOWE_USERNAME --password $ZOWE_PASSWORD --host $ZOWE_HOST --port $ZOWE_PORT --reject-unauthorized false"

# Check if directory exists , create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $ZOWE_OPTS &>/dev/null; then
  echo "Directory does not exist. Creating it ..."
  zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck $ZOWE_OPTS
else
  echo "Directory already exists."
fi

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.19.jar" $ZOWE_OPTS

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $ZOWE_OPTS
