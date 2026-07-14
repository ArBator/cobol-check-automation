#!/bin/bash
# zowe_operations.sh

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Közös csatlakozási paraméterek (így nem kell minden parancshoz kiírni)
ZOWE_PARAMS="--host YOUR_HOST --port YOUR_PORT --user $ZOWE_USERNAME --pass $ZOWE_PASSWORD --reject-unauthorized false"

# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $ZOWE_PARAMS &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" $ZOWE_PARAMS
else
  echo "Directory already exists."
fi

# Upload files (itt javítva lettek a hiányzó szóközök!)
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.9.jar" $ZOWE_PARAMS

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" $ZOWE_PARAMS
