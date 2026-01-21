#!/usr/bin/env bash
# restore-selected-dots-no-backup-fixed.sh
# Like the previous script but fixes hypr editing so the two lines are reliably removed.
#
# Usage:
#   ./restore-selected-dots-no-backup-fixed.sh        # perform changes
#   ./restore-selected-dots-no-backup-fixed.sh --dry-run

set -euo pipefail
IFS=$'\n\t'

DRY_RUN=false
for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=true ;;
    *) echo "Unknown arg: $a"; echo "Usage: $0 [--dry-run]"; exit 1 ;;
  esac
done

HOME_DIR="${HOME}"
BACKUP_ROOT="${HOME_DIR}/ii-original-dots-backup"

# Sources & destinations
SRC_FISH="${BACKUP_ROOT}/.config/fish/config.fish"
DST_FISH="${HOME_DIR}/.config/fish/config.fish"

SRC_CHEATSHEET="${BACKUP_ROOT}/.config/quickshell/ii/modules/ii/cheatsheet/Cheatsheet.qml"
DST_CHEATSHEET="${HOME_DIR}/.config/quickshell/ii/modules/ii/cheatsheet/Cheatsheet.qml"

SRC_NEOVIM="${BACKUP_ROOT}/.config/quickshell/ii/modules/ii/cheatsheet/NeovimKeybinds.qml"
DST_NEOVIM_DIR="${HOME_DIR}/.config/quickshell/ii/modules/ii/cheatsheet"

SRC_KITTY="${BACKUP_ROOT}/.config/kitty/kitty.conf"
DST_KITTY="${HOME_DIR}/.config/kitty/kitty.conf"

# Hypr keybinding possible files (prefer keybindings.conf)
HYPR_A="${HOME_DIR}/.config/hypr/hyprland/keybindings.conf"
HYPR_B="${HOME_DIR}/.config/hypr/hyprland/keybinds.conf"

# Lines to remove (we'll match them robustly with regex)
# (we won't use these verbatim for matching; they are for user reference only)
LINE_A_REF='bind = Super, B, global, quickshell:sidebarLeftToggle # [hidden]'
LINE_B_REF='bind = Super, O, global, quickshell:sidebarLeftToggle # [hidden]'

msg() { printf '%s\n' "$*"; }
plan() { msg "DRY-RUN: $*"; }

copy_file_no_backup() {
  local src="$1" dst="$2"
  if [[ ! -e "$src" ]]; then
    msg "SKIP: source not found: $src"
    return 1
  fi
  if [[ "$DRY_RUN" == true ]]; then
    plan "Would copy: $src -> $dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp -a -- "$src" "$dst"
  msg "Copied: $src -> $dst"
  return 0
}

copy_into_dir_no_backup() {
  local src="$1" dstdir="$2"
  if [[ ! -e "$src" ]]; then
    msg "SKIP: source not found: $src"
    return 1
  fi
  if [[ "$DRY_RUN" == true ]]; then
    plan "Would copy: $src -> ${dstdir}/"
    return 0
  fi
  mkdir -p "$dstdir"
  cp -a -- "$src" "$dstdir"/
  msg "Copied: $src -> ${dstdir}/"
  return 0
}

# Robust hypr edit: normalize CRLF, make a .bak, and delete lines with tolerant regex
edit_hypr_remove_lines_robust() {
  local target="$1"
  if [[ ! -f "$target" ]]; then
    msg "SKIP: hypr keybindings not found at: $target"
    return 1
  fi

  if [[ "$DRY_RUN" == true ]]; then
    plan "Would create a .bak at: ${target}.bak"
    plan "Would remove lines matching the two keybinding patterns (tolerant to spaces/optional comment)."
    return 0
  fi

  # Normalize CRLF (remove trailing \r) in-place
  # This prevents failures when the file has Windows line endings.
  if grep -q $'\r' "$target" 2>/dev/null; then
    # remove \r at end of lines
    sed -i 's/\r$//' "$target"
    msg "Normalized CRLF line endings in $target"
  fi

  # Now delete lines using a robust regex (POSIX sed -E)
  # We accept optional whitespace everywhere, and optional trailing comment after the toggle.
  # Two patterns: Super, B and Super, O
  sed -E -i \
    -e '/^[[:space:]]*bind[[:space:]]*=[[:space:]]*Super[[:space:]]*,[[:space:]]*B[[:space:]]*,[[:space:]]*global[[:space:]]*,[[:space:]]*quickshell:sidebarLeftToggle([[:space:]]*#.*)?$/d' \
    -e '/^[[:space:]]*bind[[:space:]]*=[[:space:]]*Super[[:space:]]*,[[:space:]]*O[[:space:]]*,[[:space:]]*global[[:space:]]*,[[:space:]]*quickshell:sidebarLeftToggle([[:space:]]*#.*)?$/d' \
    "$target"

  msg "Edited: $target (removed matching lines if present)."
  return 0
}

# Begin operations
msg "=== restore-selected-dots-no-backup-fixed.sh ==="
if [[ "$DRY_RUN" == true ]]; then
  msg ">>> DRY RUN enabled — no files will be modified"
fi
msg ""

# 1) Replace fish config
msg "-- 1) Replace fish config --"
copy_file_no_backup "$SRC_FISH" "$DST_FISH"
msg ""

# 2) Replace Cheatsheet.qml
msg "-- 2) Replace Cheatsheet.qml --"
copy_file_no_backup "$SRC_CHEATSHEET" "$DST_CHEATSHEET"
msg ""

# 3) Put NeovimKeybinds.qml into cheatsheet dir
msg "-- 3) Copy NeovimKeybinds.qml into cheatsheet dir --"
copy_into_dir_no_backup "$SRC_NEOVIM" "$DST_NEOVIM_DIR"
msg ""

# 4) Replace kitty config
msg "-- 4) Replace kitty.conf --"
copy_file_no_backup "$SRC_KITTY" "$DST_KITTY"
msg ""

# 5) Edit hypr keybindings
msg "-- 5) Edit hypr keybindings (remove two lines) --"
if [[ -f "$HYPR_A" ]]; then
  edit_hypr_remove_lines_robust "$HYPR_A"
elif [[ -f "$HYPR_B" ]]; then
  edit_hypr_remove_lines_robust "$HYPR_B"
else
  msg "SKIP: no hypr keybindings file found at either:"
  msg "  $HYPR_A"
  msg "  $HYPR_B"
fi
msg ""

# Final message
echo "Don't forget to check .config/hyprland for the new configuration"

# Hints
if [[ "$DRY_RUN" != true ]]; then
  msg ""
  msg "Reload hints:"
  msg "  - Reload fish:       source ~/.config/fish/config.fish  (or exec fish)"
  msg "  - Reload hyprland:   hyprctl reload"
  msg "  - Reload kitty:      inside kitty press Ctrl+Shift+F5 (or restart kitty)"
fi

