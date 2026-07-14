#!/usr/bin/env bash
# mystow - a minimal stow-like script
# Supports: -S (stow), -D (delete), -R (restow), --dotfiles, -v, -t, -d

set -euo pipefail

# ── Defaults (mirrors your .stowrc) ─────────────────────────────────────────
DIR="${HOME}/dotfiles"
TARGET="${HOME}"
VERBOSE=0
DOTFILES=1   # --dotfiles is on by default (as in your .stowrc)
MODE=""      # S, D, or R

# ── Helpers ──────────────────────────────────────────────────────────────────
log()  { [[ $VERBOSE -ge 1 ]] && echo "$*"; }
log2() { [[ $VERBOSE -ge 2 ]] && echo "$*"; }
err()  { echo "ERROR: $*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: mystow [-S|-D|-R] [-d DIR] [-t TARGET] [-v] [--dotfiles] <pkg> [pkg...]

  -S          Stow (create symlinks)
  -D          Delete (remove symlinks)
  -R          Restow (delete then stow)
  -d DIR      Source dotfiles dir   (default: ~/dotfiles)
  -t TARGET   Target dir            (default: ~)
  -v          Verbose (repeat for more: -v -v)
  --dotfiles  Translate dot- prefix to .  (default: on)
  --no-dotfiles  Disable dot- translation
EOF
  exit 1
}

# Translate "dot-foo" → ".foo" if --dotfiles is active
maybe_dot() {
  local name="$1"
  if [[ $DOTFILES -eq 1 && "$name" == dot-* ]]; then
    echo ".${name#dot-}"
  else
    echo "$name"
  fi
}

# ── Core: walk a package dir and stow/unstow ─────────────────────────────────
process_package() {
  local pkg="$1"
  local pkg_path="${DIR}/${pkg}"

  echo "DEBUG: pkg_path=$pkg_path"
  echo "DEBUG: TARGET=$TARGET"
  [[ -d "$pkg_path" ]] || err "Package '$pkg' not found in '$DIR'"

  # Walk every file/dir inside the package recursively
  while IFS= read -r -d '' src; do
    local rel="${src#"$pkg_path"/}"   # path relative to pkg root

    # Rebuild the target path applying dot- translation segment by segment
    local translated_rel=""
    local IFS_backup="$IFS"
    IFS='/' read -ra parts <<< "$rel"
    IFS="$IFS_backup"
    for part in "${parts[@]}"; do
      local tpart
      tpart=$(maybe_dot "$part")
      translated_rel="${translated_rel:+${translated_rel}/}${tpart}"
    done

    local dest="${TARGET}/${translated_rel}"

    if [[ -d "$src" ]]; then
      # Directory: just ensure the target dir exists (when stowing)
      if [[ "$MODE" == "S" || "$MODE" == "R" ]]; then
        [[ -d "$dest" ]] || { log "  MKDIR $dest"; mkdir -p "$dest"; }
      fi
      continue
    fi

    # It's a file — handle symlink
    case "$MODE" in
      S)  do_stow   "$src" "$dest" ;;
      D)  do_delete "$src" "$dest" ;;
    esac

  done < <(find "$pkg_path" -mindepth 1 -not -path "*/.git/*" -not -name ".git" -print0 | sort -z)
}

do_stow() {
  local src="$1" dest="$2"

  if [[ -L "$dest" ]]; then
    local cur_target
    cur_target=$(readlink "$dest")
    if [[ "$cur_target" == "$src" ]]; then
      log2 "  SKIP (already linked) $dest → $src"
      return
    else
      err "Conflict: '$dest' already points to '$cur_target' (expected '$src')"
    fi
  fi

  if [[ -e "$dest" ]]; then
    err "Conflict: '$dest' exists and is not a symlink"
  fi

  local dest_dir
  dest_dir=$(dirname "$dest")
  [[ -d "$dest_dir" ]] || { log "  MKDIR $dest_dir"; mkdir -p "$dest_dir"; }

  log "  LINK $dest → $src"
  ln -s "$src" "$dest"
}

do_delete() {
  local src="$1" dest="$2"

  if [[ -L "$dest" ]]; then
    local cur_target
    cur_target=$(readlink "$dest")
    if [[ "$cur_target" == "$src" ]]; then
      log "  UNLINK $dest"
      rm "$dest"
    else
      log2 "  SKIP (points elsewhere) $dest"
    fi
  else
    log2 "  SKIP (not a symlink) $dest"
  fi
}

# ── Argument parsing ──────────────────────────────────────────────────────────
[[ $# -eq 0 ]] && usage

PACKAGES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -S) MODE="S" ;;
    -D) MODE="D" ;;
    -R) MODE="R" ;;
    -d) shift; DIR="$1" ;;
    -t) shift; TARGET="$1" ;;
    -v) (( VERBOSE++ )) ;;
    --dotfiles)    DOTFILES=1 ;;
    --no-dotfiles) DOTFILES=0 ;;
    --help|-h) usage ;;
    -*) err "Unknown flag: $1" ;;
    *)  PACKAGES+=("$1") ;;
  esac
  shift
done

[[ -z "$MODE" ]]         && err "Specify one of -S, -D, -R"
[[ ${#PACKAGES[@]} -eq 0 ]] && err "Specify at least one package"

# ── Main ──────────────────────────────────────────────────────────────────────
for pkg in "${PACKAGES[@]}"; do
  echo "Processing package: $pkg  [mode=$MODE]"
  if [[ "$MODE" == "R" ]]; then
    MODE="D" process_package "$pkg"
    MODE="S" process_package "$pkg"
    MODE="R"   # restore for next package
  else
    process_package "$pkg"
  fi
done

echo "Done."
