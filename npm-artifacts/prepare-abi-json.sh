#!/usr/bin/env bash

# Exit on error
set -e

# Constants
CONTRACTS_FOLDER="../src"
BUILD_OUT_FOLDER="../out"
TARGET_ABI_FILE="./src/abi.json"

# Build contracts
cd "$CONTRACTS_FOLDER"
forge build

# Move to artifacts folder
cd ../npm-artifacts

# Start JSON object
echo "{" > "$TARGET_ABI_FILE"

FIRST=true
for SRC_CONTRACT_FILE in $(ls $CONTRACTS_FOLDER/{,erc20,condition}/*.sol); do
    SRC_FILE_NAME=$(basename "$SRC_CONTRACT_FILE")
    CONTRACT_NAME=${SRC_FILE_NAME%".sol"}
    SRC_FILE_PATH="$BUILD_OUT_FOLDER/$SRC_FILE_NAME/$CONTRACT_NAME.json"

    # Extract ABI using node
    ABI=$(node -e "const fs = require('fs'); console.log(JSON.stringify(JSON.parse(fs.readFileSync('$SRC_FILE_PATH')).abi));")

    # Add comma between entries
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$TARGET_ABI_FILE"
    fi

    # Write contract ABI
    echo "  \"$CONTRACT_NAME\": $ABI" >> "$TARGET_ABI_FILE"
done

# Close JSON object
echo "" >> "$TARGET_ABI_FILE"
echo "}" >> "$TARGET_ABI_FILE"

echo "ABI JSON prepared: $TARGET_ABI_FILE"
