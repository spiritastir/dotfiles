# Initialize Homebrew (prefix differs on Apple Silicon / Intel / Linuxbrew).
# brew is not on PATH yet, so probe known locations; shellenv then exports it.
() {
  local -a brew_bins=(
    /opt/homebrew/bin/brew
    /usr/local/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew
  )
  local brew_bin
  for brew_bin in "${brew_bins[@]}"; do
    if [[ -x $brew_bin ]]; then
      eval "$("$brew_bin" shellenv)"
      return
    fi
  done
  print -u2 "homebrew: no brew binary found in (${brew_bins[*]})."
}
