<!-- /qompassai/Shell/scripts/dependabot/README.md -->
<!-- ------------------------------------------------ -->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->

# From pass
./dependabot.sh --repo youruserororg/current --token-source pass

# From GitHub CLI
./dependabot.sh --repo youruserororg/private --token-source gh

# From sops
./dependabot.sh --repo youruserororg/infra --token-source sops

# With hardcoded token (not recommended)
./dependabot.sh --repo youruserororg/current --token "$MY_GITHUB_PAT"

