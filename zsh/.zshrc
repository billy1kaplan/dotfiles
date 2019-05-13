export TERM="xterm-256color"

POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  vcs
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
  root_indicator
  background_jobs
  history
)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

source ~/Public/antigen.zsh
. /Users/billy/.nix-profile/etc/profile.d/nix.sh

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle pip
antigen theme bhilburn/powerlevel9k powerlevel9k

antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

eval "$(rbenv init -)"
eval $(ssh-agent)
# ssh-add

# Aliases
alias python="python3"
alias pip="pip3"

# Path magic
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"
export PATH="/Users/billy/Library/geckodriver:$PATH"
export PATH="/Users/billy/Tools/sonar-scanner-3.3.0.1492-macosx/bin:$PATH"
export PATH="/Users/billy/.nix-profile/bin/cabal:$PATH"
export PATH="/nix/store/smf6dvcjjwy5pwc34r97gc8ccacadc84-ghc-8.6.4/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/billy/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/billy/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/billy/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/billy/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
