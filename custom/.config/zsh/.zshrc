# Initialize zim
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source $(brew --prefix zimfw)/share/zimfw.zsh init
fi
source ${ZIM_HOME}/init.zsh

# Comment out when not using the zsh-users/zsh-autosuggestions module in Zimfw
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Initialize completion for current ZSH session
# (commented out when using the zsh-autocomplete plugin or Zimfw completion module)
# autoload -Uz compinit
# compinit

# Allow hidden files/directories to be shown/included in completions
_comp_options+=(globdots)

# Ignore duplicated commands in history
setopt HIST_IGNORE_ALL_DUPS
# Set general completion settings
setopt MENU_COMPLETE     
# Automatically highlight first element of completion menu
setopt AUTO_LIST
# Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD

# Enables menu selection, allowing to scroll through options with arrow keys
zstyle ':completion:*' menu select

# fzf-tab
# zstyle ':fzf-tab:*' fzf-flags '--preview-window=hidden,<9999(hidden)'
# zstyle ':fzf-tab:*' fzf-preview 'echo Preview is not available!'
# zstyle ':fzf-tab:*' fzf-pad 4

ZSH_THEME="eastwood"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Ensure add-zsh-hook is available
autoload -Uz add-zsh-hook

plugins=(git)

source $ZSH/oh-my-zsh.sh

# fzf
# source "$HOME/.config/fzf/fzf-config"

# Initialize nvm
# source $(brew --prefix nvm)/nvm.sh

# Activate nvm
# if test -f ".nvmrc"; then
#     nvm use
# fi

# Initialize pnpm
# export PNPM_HOME="$(brew --prefix pnpm)"
# case ":$PATH:" in
#   *":$PNPM_HOME:"*) ;;
#   *) export PATH="$PNPM_HOME:$PATH" ;;
# esac

source "$ZDOTDIR/env"
source "$ZDOTDIR/keybindings"
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/utils"
