#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.claude"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

mkdir -p "${DEST_DIR}"

backup_if_exists() {
  local target="$1"
  if [ -e "${target}" ] || [ -L "${target}" ]; then
    local backup="${target}.bak.${TIMESTAMP}"
    mv "${target}" "${backup}"
    echo "backup: ${target} -> ${backup}"
  fi
}

install_path() {
  local name="$1"
  local src="${SRC_DIR}/${name}"
  local dest="${DEST_DIR}/${name}"

  if [ ! -e "${src}" ]; then
    echo "skip: ${src} not found"
    return
  fi

  backup_if_exists "${dest}"
  cp -R "${src}" "${dest}"
  echo "install: ${src} -> ${dest}"
}

install_path "CLAUDE.md"
install_path "skills"

echo "done."
