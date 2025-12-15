#
# Zim initialization
#
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source $(brew --prefix zimfw)/share/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh

# Required for zsh-users/zsh-autosuggestions in Zimfw
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Ensure add-zsh-hook is available
autoload -Uz add-zsh-hook

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
# Starship initialization
#

eval "$(starship init zsh)"

#
# nvm initialization
#
source $(brew --prefix nvm)/nvm.sh

# Activate nvm
if test -f ".nvmrc"; then
    nvm use
fi

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
