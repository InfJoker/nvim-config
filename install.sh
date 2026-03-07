#!/usr/bin/env bash
set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { printf "${BLUE}[info]${RESET}  %s\n" "$*"; }
ok()    { printf "${GREEN}[ok]${RESET}    %s\n" "$*"; }
warn()  { printf "${YELLOW}[warn]${RESET}  %s\n" "$*"; }
err()   { printf "${RED}[error]${RESET} %s\n" "$*"; }

# ── Detect package manager ───────────────────────────────────────────────────
PM=""
detect_pm() {
  if command -v brew &>/dev/null; then
    PM=brew
  elif command -v apt &>/dev/null; then
    PM=apt
  elif command -v dnf &>/dev/null; then
    PM=dnf
  elif command -v pacman &>/dev/null; then
    PM=pacman
  fi
}

pm_install() {
  local pkg="$1"
  case "$PM" in
    brew)   brew install "$pkg" ;;
    apt)    sudo apt install -y "$pkg" ;;
    dnf)    sudo dnf install -y "$pkg" ;;
    pacman) sudo pacman -S --noconfirm "$pkg" ;;
    *)      err "No supported package manager found. Install '$pkg' manually."; return 1 ;;
  esac
}

# ── Helpers ──────────────────────────────────────────────────────────────────
has() { command -v "$1" &>/dev/null; }

check_nvim_version() {
  if ! has nvim; then return 1; fi
  local ver major minor
  ver=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+')
  major=${ver%%.*}
  minor=${ver#*.}
  (( major > 0 || minor >= 9 ))
}

get_field() {
  echo "$1" | cut -d'|' -f"$2"
}

pm_index() {
  case "$PM" in
    brew)   echo 3 ;;
    apt)    echo 4 ;;
    dnf)    echo 5 ;;
    pacman) echo 6 ;;
    *)      echo 3 ;;
  esac
}

# Dependency entries: "display_name|test_cmd|brew_pkg|apt_pkg|dnf_pkg|pacman_pkg"
REQUIRED=(
  "neovim (>= 0.9)|nvim|neovim|neovim|neovim|neovim"
  "git|git|git|git|git|git"
)

RECOMMENDED=(
  "ripgrep|rg|ripgrep|ripgrep|ripgrep|ripgrep"
  "fd|fd|fd|fd-find|fd-find|fd"
  "C compiler|cc|gcc|gcc|gcc|gcc"
  "node|node|node|nodejs|nodejs|nodejs"
  "npm|npm|npm|npm|npm|npm"
  "python3|python3|python3|python3|python3|python"
  "pip|pip3|python3|python3-pip|python3-pip|python-pip"
)

OPTIONAL=(
  "stylua|stylua|stylua|stylua|stylua|stylua"
  "prettier|prettier|prettier|prettier|prettier|prettier"
  "black|black|black|black|black|python-black"
  "flake8|flake8|flake8|flake8|flake8|flake8"
)

# ── Check a list, print status, echo missing packages to stdout ──────────────
check_deps() {
  local idx
  idx=$(pm_index)
  for entry in "$@"; do
    local name cmd pkg
    name=$(get_field "$entry" 1)
    cmd=$(get_field "$entry" 2)
    pkg=$(get_field "$entry" "$idx")
    if has "$cmd"; then
      ok "$name" >&2
    else
      warn "$name — missing" >&2
      echo "$pkg"
    fi
  done
}

prompt_install() {
  local label="$1"
  shift
  local pkgs=("$@")

  if (( ${#pkgs[@]} == 0 )); then return; fi

  echo ""
  printf "${BOLD}Install %s? [%s]${RESET}\n" "$label" "${pkgs[*]}"
  read -rp "(y/N) " answer
  if [[ "$answer" =~ ^[Yy]$ ]]; then
    for pkg in "${pkgs[@]}"; do
      info "Installing $pkg …"
      pm_install "$pkg" || warn "Failed to install $pkg"
    done
  else
    info "Skipping $label."
  fi
}

# ── Neovim version gate ─────────────────────────────────────────────────────
check_nvim_or_exit() {
  if check_nvim_version; then
    ok "neovim $(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
  else
    if has nvim; then
      err "Neovim >= 0.9 is required (found $(nvim --version | head -1))"
    else
      err "Neovim is not installed."
    fi
    echo ""
    info "Install neovim >= 0.9 and re-run this script."
    exit 1
  fi
}

# ── Clone / backup ──────────────────────────────────────────────────────────
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
REPO_URL="https://github.com/george/nvim.git"

clone_config() {
  if [[ -d "$CONFIG_DIR/.git" ]]; then
    ok "Config already cloned at $CONFIG_DIR"
    return
  fi

  if [[ -d "$CONFIG_DIR" ]]; then
    local backup="$CONFIG_DIR.bak.$(date +%s)"
    warn "Existing config found — backing up to $backup"
    mv "$CONFIG_DIR" "$backup"
  fi

  info "Cloning config into $CONFIG_DIR …"
  git clone "$REPO_URL" "$CONFIG_DIR"
  ok "Config cloned."
}

# ── Main ─────────────────────────────────────────────────────────────────────
main() {
  echo ""
  printf "${BOLD}Neovim Config Installer${RESET}\n"
  echo "─────────────────────────────────"
  echo ""

  detect_pm
  if [[ -n "$PM" ]]; then
    ok "Package manager: $PM"
  else
    warn "No supported package manager detected. You'll need to install dependencies manually."
  fi
  echo ""

  # ── Check dependencies (collect missing packages via stdout capture) ──
  printf "${BOLD}Required${RESET}\n"
  IFS=$'\n' read -r -d '' -a missing_required < <(check_deps "${REQUIRED[@]}" && printf '\0') || true

  echo ""
  printf "${BOLD}Recommended${RESET}\n"
  IFS=$'\n' read -r -d '' -a missing_recommended < <(check_deps "${RECOMMENDED[@]}" && printf '\0') || true

  echo ""
  printf "${BOLD}Optional formatters${RESET}\n"
  IFS=$'\n' read -r -d '' -a missing_optional < <(check_deps "${OPTIONAL[@]}" && printf '\0') || true

  # ── Install prompts ──
  if [[ -n "$PM" ]]; then
    [[ ${#missing_required[@]} -gt 0 ]] && prompt_install "required dependencies" "${missing_required[@]}"
    [[ ${#missing_recommended[@]} -gt 0 ]] && prompt_install "recommended dependencies" "${missing_recommended[@]}"
    [[ ${#missing_optional[@]} -gt 0 ]] && prompt_install "optional formatters" "${missing_optional[@]}"
  fi

  # ── Gate on neovim ──
  echo ""
  check_nvim_or_exit

  # ── Clone ──
  clone_config

  echo ""
  printf "${GREEN}${BOLD}Done!${RESET} Launch Neovim:\n"
  echo ""
  echo "  nvim"
  echo ""
  info "lazy.nvim will install plugins on first launch."
  info "Mason will install LSP servers automatically."
  echo ""
}

main
