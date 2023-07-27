# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	debian
	python
	sudo
	z
)

source $ZSH/oh-my-zsh.sh

# User configuration

setopt nohup
setopt no_bg_nice
setopt no_clobber       # For > --> >|   &| means disowned
setopt nobeep
setopt multios          # echo foo > file1 | command instead of tee
setopt rcquotes		# Elegant inclusion of quotes in quotes.
setopt promptsubst
# watch="notme"
# logcheck=60

# Jumping/removing words
WORDCHARS='*?_-[]~=!#$%^(){}<>'

# History basic
setopt HIST_IGNORE_SPACE
HISTFILE=~/.history
HISTSIZE=20000
SAVEHIST=20000

##
# ZAW
# Emacs-helm like searching of branches, recent directories and command history
source /etc/zsh_zaw/zaw.zsh
zstyle ':filter-select' max-lines 10
zstyle ':filter-select' hist-find-no-dups yes

function zaw-src-z() {
    : ${(A)candidates::=`z 2>&1 | sed -n -e '2,$p' | sed 's/^[0-9\\. ]*//' | tac`}
    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
}

# Prevent not necessary error message.
touch $HOME/.z
zaw-register-src -n z zaw-src-z

bindkey '^R' zaw-history
bindkey '^xb' zaw-git-branches
bindkey '^xz' zaw-z
bindkey '^x^z' zaw-z

# Fix alt-f, alt-b - broken by dirhistory plugin since 215e43aa8a (Jan 23)
bindkey '\ef' emacs-forward-word
bindkey '\eb' emacs-backward-word

##
# Handy functions and template switching
##
j3x-copy() {
    # Disable RPROMPT to easy copying contents of the shell.
    unset RPROMPT
    unset RPS1
}

j3x-set-theme() {
    # Switch theme.
    export PROMPT="% "
    unset RPROMPT RPS1
    name=${1/.zsh-theme//}
    source $ZSH/themes/${name}.zsh-theme
}

j3x-long() {
    # Default, long-line theme.
    PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%~ %(?,%{$fg_bold[blue]%},%{$fg_bold[red]%})%(!.#.\$) %{$reset_color%}'
    RPS1='► $(git_prompt_info)%{$fg_bold[grey]%}%D{%m-%d %H:%M}%{$reset_color%}' 

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_CLEAN=""
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$fg[yellow]%}"
}

j3x-short() {
    # Short version of the theme.
    # Useful: ▧ □ ▢⬜■ ▮ ▶ ► ●
    PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%20<…<%~%<< %(?,%{$fg_bold[blue]%},%{$fg_bold[red]%})%(!.#.λ) %{$reset_color%}'
    RPS1='► %25>… >$(git_prompt_info)%<<%{$fg_bold[grey]%}%D{%m-%d %H:%M}%{$reset_color%}' 

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_CLEAN=""
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$fg[yellow]%}"
}

if [[ $TERM == "dumb" ]]; then
	# For non-interactive terminals, emacs-tramp, etc.
	unsetopt zle
	PS1='$ '
	RPS1=''
else
	# Default theme
	j3x-short
	j3x-copy
fi

# Auto-refresh the prompt every minute.
TRAPALRM() {
    zle reset-prompt
}
TMOUT=60


# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
export EDITOR='vim'
#else
#   export EDITOR='mvim'
#fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias vpn="sudo openfortivpn -o"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


