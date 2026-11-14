#!/usr/bin/env bash
# Stow packages from this repo into $HOME, then wire up Omarchy's live Neovim theme link.
# Usage: ./install.sh [package...]   (default: nvim)
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
packages=("$@")
if ((${#packages[@]} == 0)); then
  packages=(nvim)
fi

if ! command -v stow >/dev/null 2>&1; then
  echo "error: GNU stow is not installed (Arch: sudo pacman -S stow)" >&2
  exit 1
fi

for pkg in "${packages[@]}"; do
  if [[ ! -d "$repo_dir/$pkg" ]]; then
    echo "error: unknown package '$pkg'" >&2
    exit 1
  fi
  echo "stowing $pkg"
  stow --no-folding --restow --target="$HOME" --dir="$repo_dir" "$pkg"
done

# Omarchy points ~/.config/nvim/lua/plugins/theme.lua at the active theme spec.
# The link is intentionally untracked (see .gitignore) because its relative
# target only resolves from ~/.config, not from the repo.
link_omarchy_theme() {
  local theme_link="$HOME/.config/nvim/lua/plugins/theme.lua"
  local omarchy_theme="$HOME/.local/state/omarchy/current/theme/neovim.lua"
  local plugins_dir
  plugins_dir="$(dirname -- "$theme_link")"

  [[ -d "$plugins_dir" ]] || return 0

  if [[ -L "$plugins_dir" ]]; then
    echo "warning: $plugins_dir is a symlink (stow folding?); skipping theme link" >&2
    return 0
  fi

  if [[ ! -e "$omarchy_theme" ]]; then
    echo "omarchy: no current theme at $omarchy_theme; skipping nvim theme link"
    return 0
  fi

  ln -sfn ../../../../.local/state/omarchy/current/theme/neovim.lua "$theme_link"
  echo "linked $theme_link -> $omarchy_theme"
}

for pkg in "${packages[@]}"; do
  if [[ "$pkg" == "nvim" ]]; then
    link_omarchy_theme
  fi
done
