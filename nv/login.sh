#!/usr/bin/bash
set -euo pipefail

SSH_HOST=${SSH_HOST:-192.168.55.1}
SSH_USER=${SSH_USER:-nv}
SSH_KEY=${SSH_KEY:-${HOME}/.ssh/id_ed25519.pub}

SSH_CMD="ssh -t"
[[ -n "$SSH_KEY" ]] && SSH_CMD="$SSH_CMD -i $SSH_KEY"
SSH_CMD="$SSH_CMD ${SSH_USER}@${SSH_HOST}"

exec $SSH_CMD "/usr/bin/bash"
