#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "用法：$0 <volume名称> [挂载路径]"
  echo "示例：$0 proj_phs_workspace_rk /data"
  exit 1
fi

VOL="$1"
MOUNT_PATH="${2:-/data}"

docker run --rm -it -v "${VOL}:${MOUNT_PATH}" alpine sh
