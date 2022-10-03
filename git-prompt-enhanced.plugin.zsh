# Zsh standards for handling $0
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

## Functions to update Git Variables
function update_git_branch_variables() {
    GIT_BRANCH="${$(git branch --show-current):-"$(git rev-parse --short HEAD)"}"
    GIT_AHEAD=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    GIT_BEHIND=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

    GIT_STASHED=0
    if $(git rev-parse --verify refs/stash &>/dev/null); then
        GIT_STASHED=1
    fi

    GIT_NO_UPSTREAM=1
    if $(git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null); then
        GIT_NO_UPSTREAM=0
    fi
}

function update_git_status_varaibles() {
    GIT_MODIFIED=0
    GIT_DELETED=0
    GIT_STAGED=0
    GIT_UNTRACKED=0
    GIT_CONFLICTS=0

    GIT_STATUS=$(git status --porcelain -uall 2>/dev/null)

    while IFS= read -r line; do
        if [[ "$line" =~ '^\?\?.*' ]]; then
            GIT_UNTRACKED=$(($GIT_UNTRACKED+1))
        else
            if [[ "$line" =~ ^U.* ]]; then
                GIT_CONFLICTS=$(($GIT_CONFLICTS+1))
            elif [[ "$line" =~ ^[MRAD].* ]]; then
                GIT_STAGED=$(($GIT_STAGED+1))
            fi

            if [[ "$line" =~ ^.M.* ]]; then
                GIT_MODIFIED=$(($GIT_MODIFIED+1))
            elif [[ "$line" =~ ^.D.* ]]; then
                GIT_DELETED=$(($GIT_DELETED+1))
            fi
        fi
    done <<< "$GIT_STATUS"
}

function update_git_variables() {
    update_git_status_varaibles
    update_git_branch_variables
}

function compose_git_prompt_string() {
    STATUS_SEPARATOR=$ZSH_THEME_GIT_PROMPT_STATUS_SEPARATOR

    GIT_PROMPT="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH%{${reset_color}%}"

    if [ "$GIT_NO_UPSTREAM" -eq "1" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_NO_UPSTREAM%{${reset_color}%}"
    fi
    if [ "$GIT_AHEAD" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
    fi
    if [ "$GIT_BEHIND" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
    fi
    if [ "$GIT_STASHED" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_STASHED%{${reset_color}%}"
    fi

    GIT_PROMPT+="$ZSH_THEME_GIT_PROMPT_SEPARATOR"
    if [ "$GIT_MODIFIED" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_MODIFIED$GIT_MODIFIED%{${reset_color}%}"
    fi
    if [ "$GIT_DELETED" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED%{${reset_color}%}"
    fi
    if [ "$GIT_STAGED" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
    fi
    if [ "$GIT_UNTRACKED" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED%{${reset_color}%}"
    fi
    if [ "$GIT_CONFLICTS" -ne "0" ]; then
        GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
    fi

    if [ "$GIT_MODIFIED" -eq "0" ] \
        && [ "$GIT_DELETED" -eq "0" ] \
        && [ "$GIT_STAGED" -eq "0" ] \
        && [ "$GIT_UNTRACKED" -eq "0" ] \
        && [ "$GIT_CONFLICTS" -eq "0" ]
        then
            GIT_PROMPT+="$STATUS_SEPARATOR$ZSH_THEME_GIT_PROMPT_CLEAN%{${reset_color}%}"
    fi

    GIT_PROMPT+="%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX%{${reset_color}%}"
    echo "$GIT_PROMPT"
}

function git_prompt_enhanced_status() {
    if git rev-parse --git-dir &> /dev/null; then
        update_git_variables
        compose_git_prompt_string
    fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" |"
ZSH_THEME_GIT_PROMPT_STATUS_SEPARATOR=" "

ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_NO_UPSTREAM="%{$fg_bold[red]%}✗"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%}%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}%{↑%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[yellow]%}⚑"

ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[yellow]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{!%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"

# Set the prompt.
RPROMPT='$(git_prompt_enhanced_status)'
