
#!/bin/bash
# /qompassai/Shell/scripts/github/topics.sh
#########################################
# Copyright (C) 2025 Qompass AI, All rights reserved
cd ~/.GH/Qompass/JS

for repo in */; do
    if [ -d "$repo/.git" ]; then
        echo "Adding topics to $repo"
        cd "$repo"
        gh repo edit --add-topic javascript frontend typescript
        cd ..
    fi
done
