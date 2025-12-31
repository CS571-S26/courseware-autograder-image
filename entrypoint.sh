#!/bin/bash
set -euo pipefail

# Safer wrapper entrypoint: always create a writable temp copy of the mounted script
# to avoid in-place edits or chmod on potentially read-only mounts/Windows-backed filesystems.
SCRIPT=/cs571/script.sh

if [ ! -f "$SCRIPT" ]; then
  echo "ERROR: $SCRIPT not found; nothing to run." >&2
  exit 2
fi

# Create a temp file under /tmp and copy the script there, stripping CRLF safely.
TMP_SCRIPT="/tmp/$(basename "$SCRIPT").$$"
trap 'rm -f "$TMP_SCRIPT"' EXIT

# Use a streaming transform that doesn't rely on sed -i rename semantics.
if ! (tr -d '\r' < "$SCRIPT" > "$TMP_SCRIPT"); then
  echo "ERROR: failed to copy and normalize $SCRIPT" >&2
  exit 3
fi

chmod +x "$TMP_SCRIPT" || true

exec /bin/bash "$TMP_SCRIPT" "$@"
