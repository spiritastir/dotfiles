#
# Zim initialization
#

# zsh-users/zsh-autosuggestions (zim module): skip rebinding widgets on every
# precmd (faster). Checked at runtime; must be set in .zshrc (not .zimrc).
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Install missing modules / rebuild init.zsh when .zimrc is newer.
# Only call brew --prefix when a rebuild is needed (avoids a brew fork every shell).
# brew --prefix prints nothing on failure — guard before source.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  () {
    local zimfw_prefix zimfw_zsh
    if (( ! $+commands[brew] )); then
      print -u2 "zimfw: brew not on PATH (is .zprofile loaded?)."
      return
    fi
    zimfw_prefix="$(brew --prefix zimfw 2>/dev/null)" || true
    zimfw_zsh="${zimfw_prefix:+$zimfw_prefix/share/zimfw.zsh}"
    if [[ -r $zimfw_zsh ]]; then
      source "$zimfw_zsh" init
    else
      print -u2 "zimfw: missing (brew --prefix zimfw failed or formula not installed)."
    fi
  }
fi
[[ -r ${ZIM_HOME}/init.zsh ]] && source "${ZIM_HOME}/init.zsh"


#
# Completion
#

# Include hidden files in filename completion
_comp_options+=(globdots)

setopt AUTO_LIST
setopt COMPLETE_IN_WORD

# Use completion menu with arrow-key navigation
zstyle ':completion:*' menu select

#
# History
#

# Storage location
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# More metadata: timestamps, elapsed time
setopt EXTENDED_HISTORY

# Keep history clean: keep newer entries, expire older duplicates first
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_REDUCE_BLANKS

# Ignore duplicate matches & prevent saving duplicates
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Safety: on history expansion, reload expanded line for verification
setopt HIST_VERIFY

# Sharing: real-time shared history across terminals
setopt SHARE_HISTORY

# fzf-tab
# zstyle ':fzf-tab:*' fzf-flags '--preview-window=hidden,<9999(hidden)'
# zstyle ':fzf-tab:*' fzf-preview 'echo Preview is not available!'
# zstyle ':fzf-tab:*' fzf-pad 4

# fzf
# source "$HOME/.config/fzf/fzf-config"

#
# nvm (Homebrew formula)
#
# Official order: set NVM_DIR first (outside Cellar), then source nvm.sh.
# https://github.com/nvm-sh/nvm#installing-and-updating
# Homebrew caveat: https://formulae.brew.sh/formula/nvm
export NVM_DIR="$HOME/.nvm"
() {
  local nvm_prefix nvm_sh
  if (( ! $+commands[brew] )); then
    print -u2 "nvm: brew not on PATH (is .zprofile loaded?)."
    return
  fi
  nvm_prefix="$(brew --prefix nvm 2>/dev/null)" || true
  nvm_sh="${nvm_prefix:+$nvm_prefix/nvm.sh}"
  if [[ ! -r $nvm_sh ]]; then
    print -u2 "nvm: missing (brew --prefix nvm failed or formula not installed)."
    return
  fi
  source "$nvm_sh"

  # Auto-switch Node when entering a directory with .nvmrc (upstream zsh recipe).
  # Better than startup-only `nvm use`: follows `cd`, skips work if version matches.
  autoload -Uz add-zsh-hook
  load-nvmrc() {
    local nvmrc_path nvmrc_node_version
    nvmrc_path="$(nvm_find_nvmrc)"

    if [[ -n $nvmrc_path ]]; then
      nvmrc_node_version="$(nvm version "$(cat "${nvmrc_path}")")"

      if [[ $nvmrc_node_version == N/A ]]; then
        nvm install
      elif [[ $nvmrc_node_version != "$(nvm version)" ]]; then
        nvm use
      fi
    elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" && "$(nvm version)" != "$(nvm version default)" ]]; then
      print -r -- "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
}


#
# pnpm initialization
#
# export PNPM_HOME="$(brew --prefix pnpm)"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac

source "$ZDOTDIR/env"
source "$ZDOTDIR/keybindings"
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/utils"
