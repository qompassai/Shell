#!/bin/bash
TITLE=$(grep -E "^# " README.md | head -n 1 | sed 's/^# //')

SECTION_NAME="Description"
SECTION_START=$(grep -n "^## $SECTION_NAME" README.md | cut -d: -f1)
SECTION_END=$(grep -n "^## " README.md | awk -v start=$SECTION_START '$1 > start {print $1; exit}' | cut -d: -f1)
if [ -z "$SECTION_END" ]; then SECTION_END=$(wc -l README.md | cut -d' ' -f1); fi
sed -n "$((SECTION_START+1)),$((SECTION_END-1))p" README.md > description.md
pandoc -f markdown -t html description.md -o description.html

jq -n --arg title "$TITLE" --rawfile desc description.html '{
  "title": $title,
  "description": $desc,
  "license": ["AGPL-3.0", "Q-CDA-1.0"],
  "upload_type": "software",
  "access_right": "open",
  "version": "1.0.0",
  "creators": [{"name": "Porter, Matthew A.", "affiliation": "Qompass AI", "orcid": "0000-0002-0302-4812"}],
  "keywords": ["AI", "Quantum", "Post-Quantum Cryptography", "Healthcare", "Education"],
  "related_identifiers": [{"identifier": "https://github.com/qompassai/", "relation": "isSupplementTo", "resource_type": "software"}],
  "communities": [{"identifier": "qompass"}]
}' > .zenodo.json
rm description.md description.html
