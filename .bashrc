# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export PYTHONPATH=/usr/local/lib/python2.6/dist-packages/:$PYTHONPATH

# If not running interactively, do not do anything
# If you don't do this, your (graphical) login sessions will hang
[[ $- != *i* ]] && return

# If we are not yet in a screen session
#if [[ $TERM != screen* ]]; then
  # Start tmux if there is no panicfile and tmux actually exists.
 # [ ! -f /tmp/panic -a -x /usr/bin/tmux ] && exec tmux
#fi
export EDITOR='nvim'
export LD_LIBRARY_PATH=/usr/local/lib
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'
complete -C '/home/ow/.local/bin/aws_completer' aws
export PATH=$PATH:~/.local/bin:~/src/cur-idea/bin:~/go/bin

# added by travis gem
[ -f /home/ow/.travis/travis.sh ] && source /home/ow/.travis/travis.sh
eval "$(hub alias -s)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /home/ow/.rvm/scripts/rvm

function vaultauth {
 vault login "$@" && \
 if [ -f ~/.vault-token ]; then
   token=$(cat ~/.vault-token)
   if [ ! -z $token ]; then
     export VAULT_TOKEN=$token
   fi
   rm ~/.vault-token
 fi
}
export VAULT_ADDR=https://vault.actyx.net
function vssh() {
  vault ssh ubuntu@$1.actyx.net
}
alias vauth='vaultauth -method=aws role=dev-ow'
source ~/.ipfs-autocomplete
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
function lb() { vim ~/Seafile/logbook/$(date '+%Y-%m-%d').md
}
function randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;}



# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/opt/mssql-tools/bin"
###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/src/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export ANDROID_HOME=~/Android/Sdk/

complete -C /usr/bin/vault vault

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias config='/usr/bin/git --git-dir=/home/ow/.cfg/ --work-tree=/home/ow'
