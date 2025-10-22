## tmux starter
#if command -v tmux &> /dev/null && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#  unattached_session=$(tmux ls -F '#{session_name} #{session_attached}' 2>/dev/null | grep -E '^[0-9]+ 0$' | head -1 | cut -d' ' -f1)
#  if [ -n "$unattached_session" ]; then
#    exec tmux attach -t "$unattached_session"
#  else
#    exec tmux
#  fi
#fi

# Theme
ZSH_THEMES_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/themes"
ZSH_THEME="oxide"
source "$ZSH_THEMES_DIR/$ZSH_THEME.zsh-theme"

# SetOpts
setopt completealiases
setopt inc_append_history
setopt share_history
setopt autocd
setopt autopushd
setopt completeinword
setopt correct
setopt histexpiredupsfirst
setopt histignorealldups
setopt histignorespace
setopt interactive

# Keyboard
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zkbd"

# History Setting
HISTFILE=~/.zsh_history
HISTSIZE=10010
SAVEHIST=10000

# Completions
zstyle ':completion:*' menu select
autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
autoload -Uz promptinit && promptinit
complete -o nospace -C /usr/bin/vault vault

# MAKE environment
MAKEFLAGS="-j$(nproc)"

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# Dotfiles stuffs
dotfiles_push() {
    local message="${1:-Update dotfiles: $(date '+%Y-%m-%d %H:%M')}"
    local dotfiles_dir=~/crud-salad

    if [[ ! -d "$dotfiles_dir" ]]; then
        echo "Error: Dotfiles directory not found: $dotfiles_dir"
        return 1
    fi

    cd "$dotfiles_dir" || return 1

    if [[ ! -d .git ]]; then
        echo "Error: Not a git repository: $dotfiles_dir"
        cd - > /dev/null
        return 1
    fi

    if ! git add .; then
        echo "Error: Failed to stage changes"
        cd - > /dev/null
        return 1
    fi

    if git diff --staged --quiet; then
        echo "No changes to commit"
        cd - > /dev/null
        return 0
    fi

    if ! git commit -m "$message"; then
        echo "Error: Commit failed"
        cd - > /dev/null
        return 1
    fi

    if ! git push; then
        echo "Error: Push failed"
        cd - > /dev/null
        return 1
    fi

    echo "✓ Dotfiles pushed successfully"
    cd - > /dev/null
}

dotfiles_pull() {
    local dotfiles_dir=~/crud-salad
    local stashed=0

    if [[ ! -d "$dotfiles_dir" ]]; then
        echo "Error: Dotfiles directory not found: $dotfiles_dir"
        return 1
    fi

    cd "$dotfiles_dir" || return 1

    if [[ ! -d .git ]]; then
        echo "Error: Not a git repository: $dotfiles_dir"
        cd - > /dev/null
        return 1
    fi

    if ! git diff --quiet || ! git diff --staged --quiet; then
        echo "Warning: Uncommitted changes detected. Stashing..."
        if ! git stash push -m "Auto-stash before pull $(date '+%Y-%m-%d %H:%M')"; then
            echo "Error: Failed to stash changes"
            cd - > /dev/null
            return 1
        fi
        stashed=1
    fi

    if ! git pull --rebase; then
        echo "Error: Pull failed"
        if [[ $stashed -eq 1 ]]; then
            echo "Attempting to restore stashed changes..."
            git stash pop
        fi
        cd - > /dev/null
        return 1
    fi

    if [[ $stashed -eq 1 ]]; then
        echo "Restoring stashed changes..."
        if ! git stash pop; then
            echo "Error: Conflict while restoring stash. Resolve manually with 'git stash pop'"
            cd - > /dev/null
            return 1
        fi
    fi

    echo "✓ Dotfiles pulled successfully"
    cd - > /dev/null
}

dotfiles_sync() {
    local message="${1:-Update dotfiles: $(date '+%Y-%m-%d %H:%M')}"

    echo "=== Pulling latest changes ==="
    dotfiles_pull || return 1

    echo -e "\n=== Pushing local changes ==="
    dotfiles_push "$message"
}

dotfiles_status() {
    local dotfiles_dir=~/crud-salad

    if [[ ! -d "$dotfiles_dir" ]]; then
        echo "Error: Dotfiles directory not found: $dotfiles_dir"
        return 1
    fi

    cd "$dotfiles_dir" || return 1

    if [[ ! -d .git ]]; then
        echo "Error: Not a git repository: $dotfiles_dir"
        cd - > /dev/null
        return 1
    fi

    git status
    cd - > /dev/null
}

# docker stuff
dockerrm() {
    docker container stop $1 && docker container rm $1
}

# Aliases
# env
alias sdl="env -u SDL_VIDEODRIVER"
alias xforce="SDL_VIDEODRIVER=x11"

# yay fixes
alias yay='MAKEFLAGS="-j$(nproc)" yay --sudoloop'
alias mirrorup='sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist -n 8 -c US --threads 8'

alias ls='ls --time-style=long-iso'

# Wine32 Default
alias wine32='WINEPREFIX=~/.local/share/wineprefixes/win32 WINEARCH="win32"'

# Text Editor of choice
alias vi='nvim'
alias vim='nvim'
alias ni='nvim'
alias nano='nvim'
export EDITOR=nvim
alias :q='exit'
alias e='nvim .'

# Python
alias venv='python -m venv'

# Other Stuff
alias s='source ${HOME}/.zshrc'
alias z='vim ${HOME}/.zshrc'
alias neofetch='neofetch --color_blocks off'
alias powershell=pwsh
alias pwsh=pwsh /nologo
function mc {
    mkdir $1
    cd $1
}
alias fucking='sudo'

function fuck() {
  local app_name=$1

  for i in $(ps aux | grep -i "$app_name" | grep -v grep | awk '{print $2}');do
    sudo kill -9 $i
  done
}

# I have never once used this after creation
function record() { 
  if [ ! -d "${HOME}/recording" ]; then mkdir "${HOME}/recording"; fi
  script -q "$HOME/recording/$(date +'%Y-%m-%d.%H-%M-%S')-session.log"
}

# PATH
if [ -d "${HOME}/.local/bin" ]; then path+=("${HOME}/.local/bin"); fi
export PATH

function set_terminal_title() {
    local user_host="%n@%m"
    local current_dir="%~"
    print -Pn "\e]0;$user_host\a"
}

# Add workstation specific things like WSL settings
if [ -d .config/zsh-includes ]; then
    for f in .config/zsh-includes/*; do 
        [ -f "$f" ] && source "$f"
    done
fi

precmd_functions+=(set_terminal_title)

