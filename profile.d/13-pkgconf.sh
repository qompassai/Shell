#!/usr/bin/env sh
# /qompassai/Shell/.profile.d/13-pkgconf.sh
# -----------------------------
# Copyright (C) 2025 Qompass AI, All rights reserved
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}/usr/lib/pkgconfig:/usr/share/pkgconfig:/opt/QAI/liboqs/lib/pkgconfig:/opt/cuda/lib64/pkgconfig"
export CMAKE_PRESET_FILE="$HOME/CMakePresets.json"
