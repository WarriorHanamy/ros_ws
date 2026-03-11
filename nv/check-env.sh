#!/usr/bin/bash
set -euo pipefail

SSH_HOST=${SSH_HOST:-192.168.55.1}
SSH_USER=${SSH_USER:-nv}
SSH_KEY=${SSH_KEY:-${HOME}/.ssh/id_ed25519.pub}
PYTHON=${PYTHON:-python3}

if [[ -z "$SSH_HOST" ]]; then
  echo "Usage: SSH_HOST=<ip> [SSH_USER=user] [SSH_KEY=path] $0"
  exit 1
fi

SSH_CMD="ssh"
[[ -n "$SSH_KEY" ]] && SSH_CMD="$SSH_CMD -i $SSH_KEY"
SSH_CMD="$SSH_CMD ${SSH_USER}@${SSH_HOST}"

$SSH_CMD "PYTHON=$PYTHON /usr/bin/bash --norc --noprofile -c '
set -e

check_os() {
  echo \"=== OS ===\"
  cat /etc/os-release | grep -E \"^(NAME|VERSION)=\"
  echo
}

check_python() {
  echo \"=== Python/PyTorch ===\"
  \$PYTHON --version 2>/dev/null || echo \"Python: not found\"
  \$PYTHON -c \"import torch; print(\\\"PyTorch:\\\", torch.__version__)\" 2>/dev/null || echo \"PyTorch: not found\"
  \$PYTHON -c \"import torch; print(\\\"CMake prefix:\\\", torch.utils.cmake_prefix_path)\" 2>/dev/null || echo \"CMake prefix: not found\"
  echo
}

check_cuda() {
  echo \"=== CUDA ===\"
  found=0
  for nvcc in \$(find /usr/local -name nvcc 2>/dev/null); do
    ver=\$(echo \"\$nvcc\" | sed -n \"s|.*/cuda-\\([0-9.]*\\)/.*|\\1|p\")
    echo \"CUDA \${ver:-unknown}: \$nvcc\"
    found=1
  done
  [[ \$found -eq 0 ]] && echo \"CUDA: not found\"
  echo
}

check_jetson() {
  echo \"=== L4T / JetPack ===\"

  if [ -f /etc/nv_tegra_release ]; then
    RAW=\$(cat /etc/nv_tegra_release)
    echo \"nv_tegra_release: \$RAW\"

    L4T_MAJOR=\$(echo \"\$RAW\" | sed -n \"s/^# R\\([0-9]*\\).*/\\1/p\")
    L4T_MINOR=\$(echo \"\$RAW\" | sed -n \"s/.*REVISION: \\([0-9]*\\)\\.\\([0-9]*\\).*/\\1/p\")
    L4T_PATCH=\$(echo \"\$RAW\" | sed -n \"s/.*REVISION: \\([0-9]*\\)\\.\\([0-9]*\\).*/\\2/p\")

    if [ -n \"\$L4T_MAJOR\" ] && [ -n \"\$L4T_MINOR\" ] && [ -n \"\$L4T_PATCH\" ]; then
      echo \"L4T: R\$L4T_MAJOR.\$L4T_MINOR.\$L4T_PATCH\"
    else
      echo \"L4T: unable to parse /etc/nv_tegra_release\"
    fi
  else
    echo \"/etc/nv_tegra_release not found\"
  fi

  if command -v dpkg-query >/dev/null 2>&1; then
    JP_PKG=\$(dpkg-query --show nvidia-jetpack 2>/dev/null || true)
    L4T_CORE=\$(dpkg-query --show nvidia-l4t-core 2>/dev/null || true)

    if [ -n \"\$JP_PKG\" ]; then
      echo \"JetPack package: \$JP_PKG\"
    else
      echo \"JetPack package: not found\"
    fi

    if [ -n \"\$L4T_CORE\" ]; then
      echo \"nvidia-l4t-core: \$L4T_CORE\"
    else
      echo \"nvidia-l4t-core: not found\"
    fi
  else
    echo \"dpkg-query: not available\"
  fi
  echo

  echo \"=== JetPack guess from L4T ===\"
  if [ -f /etc/nv_tegra_release ]; then
    L4T_VER=\"R\${L4T_MAJOR}.\${L4T_MINOR}.\${L4T_PATCH}\"
    case \"\$L4T_VER\" in
      R38.4.0)   echo \"JetPack: 7.1\" ;;
      R38.2.0|R38.2.1) echo \"JetPack: 7.0\" ;;
      R36.5.0)   echo \"JetPack: 6.2.2\" ;;
      R36.4.4)   echo \"JetPack: 6.2.1\" ;;
      R36.4.3)   echo \"JetPack: 6.2\" ;;
      R36.4.0)   echo \"JetPack: 6.1\" ;;
      R36.3.0)   echo \"JetPack: 6.0\" ;;
      R36.2.0)   echo \"JetPack: 6.0 DP\" ;;
      R35.6.4)   echo \"JetPack: 5.1.6\" ;;
      R35.6.1|R35.6.2) echo \"JetPack: 5.1.5\" ;;
      R35.6.0)   echo \"JetPack: 5.1.4\" ;;
      R35.5.0)   echo \"JetPack: 5.1.3\" ;;
      R35.4.1)   echo \"JetPack: 5.1.2\" ;;
      R35.3.1)   echo \"JetPack: 5.1.1\" ;;
      R35.2.1)   echo \"JetPack: 5.1\" ;;
      R35.1.0)   echo \"JetPack: 5.0.2\" ;;
      R34.1.1)   echo \"JetPack: 5.0.1 DP\" ;;
      R34.1.0)   echo \"JetPack: 5.0 DP\" ;;
      R32.7.1)   echo \"JetPack: 4.6.1\" ;;
      R32.7.2)   echo \"JetPack: 4.6.2\" ;;
      R32.7.3)   echo \"JetPack: 4.6.3\" ;;
      R32.7.4)   echo \"JetPack: 4.6.4\" ;;
      *) echo \"JetPack: unknown (L4T \$L4T_VER, need updated mapping)\" ;;
    esac
  else
    echo \"JetPack: unknown (/etc/nv_tegra_release missing)\"
  fi
  echo
}

check_os
check_python
check_cuda
check_jetson
'"
