#!/usr/bin/env sh
# /qompassai/Shell/.profile.d/56-python.sh
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################

export PIP_NO_CACHE_DIR="false"
export PIP_USER="1"
export PYTHON="python3"
export PYTHONBREAKPOINT="pdb.set_trace"
export PYTHONFAULTHANDLER="1"
export PYTHONHASHSEED="random"
export PYTHONIOENCODING="utf-8"
export PYTHONPATH="$HOME/.local/lib/python3.13/site-packages:$PYTHONPATH"
export PYTHONSTARTUP="$HOME/.config/pythonrc.py"
export PYTHONWARNINGS="ignore::DeprecationWarning"
export VIRTUAL_ENV_DISABLE_PROMPT="1"
export WORKON_HOME="$HOME/.virtualenvs"

