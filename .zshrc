PROMPT='%m%~ '

setopt histignorealldups sharehistory inc_append_history hist_ignore_space
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
eval "$(zoxide init zsh)"

# Use emacs keybindings even if our EDITOR is set to vi
# bindkey -e
set -o vi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
