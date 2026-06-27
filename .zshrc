export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
ZSH_COMPDUMP="$HOME/.cache/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
plugins=(
  git
  brew
  bun
  history-substring-search
)

export COLORTERM=truecolor
export EDITOR=vim
export VISUAL=vim

typeset -U fpath path PATH

BUN_INSTALL="$HOME/.bun"
ANT_INSTALL="$HOME/.ant"
ZVM_INSTALL="$HOME/.zvm/self"
export BUN_INSTALL ANT_INSTALL ZVM_INSTALL

path=(${path:#$HOME/.nvm/*})
path=(${path:#$HOME/.zvm/self/})

path=(
  "$HOME/.config/bin"
  "$HOME/.local/bin"
  "$BUN_INSTALL/bin"
  "$ANT_INSTALL/bin"
  "$HOME/.cargo/bin"
  "$HOME/.zvm/bin"
  "$ZVM_INSTALL"
  "/Library/Frameworks/Python.framework/Versions/3.14/bin"
  /opt/homebrew/bin
  /usr/local/bin
  $path
)
export PATH

HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

fpath=("$HOME/.config/zsh/completions" $fpath)

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

source "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if [[ -t 0 && -r /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

if [[ -t 0 && -r /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

v() {
  if (( $# == 0 )); then
    vim .
  else
    vim "$@"
  fi
}

 zv() {
   local dir launcher_window
 
   if (( $# == 0 )); then
     dir="$(zoxide query -i)" || return
   else
     dir="$(zoxide query -- "$@")" || return
   fi
 
   launcher_window="$(yabai -m query --windows --window 2>/dev/null | jq -r 'select(.app == "Ghostty") | .id' 2>/dev/null)"
   (cd "$dir" && neovide .)
 
   if [[ -n "$launcher_window" ]]; then
     sleep 0.15
     yabai -m window "$launcher_window" --minimize >/dev/null 2>&1 || true
   fi
 }
 
 zvt() {
   local dir file file_arg selection relative_file ghostty_window ghostty_space
   local state_dir split_hint_file
   local sep_index i
   local -a args query_args typst_files
 
   if (( $# == 1 )) && [[ -f "$1" ]]; then
     file="${1:A}"
     dir="${file:h}"
   else
     args=("$@")
     sep_index=0
 
     for (( i = 1; i <= $#args; i++ )); do
       if [[ "${args[i]}" == "--" ]]; then
         sep_index=$i
         break
       fi
     done
 
     if (( sep_index > 0 )); then
       if (( sep_index > 1 )); then
         query_args=("${args[1,$(( sep_index - 1 ))]}")
       else
         query_args=()
       fi
 
       if (( sep_index < $#args )); then
         file_arg="${args[sep_index + 1]}"
       fi
     elif (( $#args > 1 )) && [[ "${args[-1]}" == *.typ ]]; then
       file_arg="${args[-1]}"
       query_args=("${args[1,$(( $#args - 1 ))]}")
     else
       query_args=("${args[@]}")
     fi
 
     if (( $#query_args == 0 )); then
       dir="$(zoxide query -i)" || return
     else
       dir="$(zoxide query -- "${query_args[@]}")" || return
     fi
     dir="${dir:A}"
 
     if [[ -n "$file_arg" ]]; then
       if [[ "$file_arg" = /* ]]; then
         file="${file_arg:A}"
       else
         file="${dir}/${file_arg}"
         file="${file:A}"
       fi
     else
       typst_files=("${(@f)$(cd "$dir" && rg --files -g '*.typ' 2>/dev/null)}")
       if (( $#typst_files == 0 )); then
         print -u2 "zvt: no .typ files under $dir"
         return 1
       fi
 
       if (( $#typst_files == 1 )); then
         selection="${typst_files[1]}"
       else
         selection="$(printf '%s\n' "${typst_files[@]}" | fzf --prompt='typst ❯ ' --select-1 --exit-0)" || return
       fi
 
       [[ -n "$selection" ]] || return 1
       file="${dir}/${selection}"
       file="${file:A}"
     fi
   fi
 
   if [[ ! -f "$file" ]]; then
     print -u2 "zvt: file not found: $file"
     return 1
   fi
 
   if [[ "$file" != *.typ ]]; then
     print -u2 "zvt: expected a .typ file, got: $file"
     return 1
   fi
 
   ghostty_window="$(yabai -m query --windows --window 2>/dev/null | jq -r 'select((.app | ascii_downcase) == "ghostty") | .id' 2>/dev/null)"
   ghostty_space="$(yabai -m query --windows --window 2>/dev/null | jq -r 'select((.app | ascii_downcase) == "ghostty") | .space' 2>/dev/null)"
   state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
   split_hint_file="$state_dir/typst-preview-split.json"
   mkdir -p "$state_dir"
 
   cd "${file:h}" || return
   relative_file="${file:t}"
   if [[ -n "$ghostty_window" && -n "$ghostty_space" ]]; then
     printf '{\"window\":%s,\"space\":%s,\"ts\":%s}\n' \
       "$ghostty_window" "$ghostty_space" "$(date +%s)" >| "$split_hint_file"
     ZVT_SPLIT_GHOSTTY_WINDOW="$ghostty_window" \
       ZVT_SPLIT_GHOSTTY_SPACE="$ghostty_space" \
       nvim -c 'silent! TypstPreviewStop' -c 'TypstPreview' "$relative_file"
     rm -f "$split_hint_file"
   else
     rm -f "$split_hint_file"
     nvim -c 'silent! TypstPreviewStop' -c 'TypstPreview' "$relative_file"
   fi
 }

alias c='clear'
alias reload='source ~/.zshrc'
alias ll='ls -lah'
alias gs='git status --short'
alias lg='git log --oneline --graph --decorate --all'

# bun completions
[ -s "/Users/hystericca/.bun/_bun" ] && source "/Users/hystericca/.bun/_bun"

[ -f "/Users/hystericca/.ghcup/env" ] && . "/Users/hystericca/.ghcup/env" # ghcup-envexport PATH="$HOME/Library/Python/3.*/bin:$PATH"

# Created by `pipx` on 2026-05-26 22:26:33
export PATH="$PATH:/Users/hystericca/Library/Python/3.14/bin"
export PATH="$HOME/Library/Python/3.14/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# Homebrew C/C++ paths
export CPATH="/opt/homebrew/include:/opt/homebrew/opt/raylib/include${CPATH:+:$CPATH}"
export LIBRARY_PATH="/opt/homebrew/lib:/opt/homebrew/opt/raylib/lib${LIBRARY_PATH:+:$LIBRARY_PATH}"
export PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:/opt/homebrew/opt/raylib/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"
export PATH="/opt/uxn/bin:$PATH"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

