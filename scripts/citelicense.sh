#!/bin/bash
# /qompasai/license/scripts/citelicense.sh
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
BASE_DIR="$HOME/.GH/Qompass"
TARGET_FILE="CITATION.cff"
LICENSE_URL="license-url: \"https://github.com/qompassai/license/blob/main/LICENSE\""
echo "Searching for $TARGET_FILE..."
added_count=0
skipped_count=0
error_count=0
while IFS= read -r -d '' cff_file; do
    if [ -f "$cff_file" ]; then
        if grep -q "^license-url:" "$cff_file"; then
            echo "⚠️  Skipped: $cff_file (license-url already exists)"
            ((skipped_count++))
            continue
        fi
        if [ ! -w "$cff_file" ]; then
            echo "❌ Error: $cff_file is not writable"
            ((error_count++))
            continue
        fi
        if sed -i.bak -e '/^license:/a\'$'\n'"$LICENSE_URL" "$cff_file"; then
            rm "${cff_file}.bak" 2>/dev/null
            echo "✅ Updated: $cff_file"
            ((added_count++))
        else
            echo "❌ Error: Failed to modify $cff_file"
            ((error_count++))
        fi
    fi
done < <(find "$BASE_DIR" -maxdepth 6 -type f -name "$TARGET_FILE" -print0 2>/dev/null)
echo ""
echo "Summary:"
echo "- Added license-url to $added_count files"
echo "- Skipped $skipped_count files (already contains license-url)"
echo "- Encountered errors with $error_count files"
echo "- Total $TARGET_FILE files processed: $((added_count + skipped_count + error_count))"
