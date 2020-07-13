#!/usr/bin/env bash

# Original author : Brian Beffa <brbsix@gmail.com>
# Original version: https://brbsix.github.io/2015/11/29/accessing-tab-completion-programmatically-in-bash/
#                   https://github.com/rantasub/vim-bash-completion

spaceend=$1
shift

if [[ $# == 1 && $spaceend -eq 0 ]]; then
	# complete command
	printf '%s\n' $(compgen -acdf $1)
	exit 0
fi

# load bash-completion
completionDir="${BASH_COMPLETION_DIR:-/usr/share/bash-completion}"
. "${completionDir}/bash_completion"


COMP_LINE=$*
COMP_POINT=${#COMP_LINE}
COMP_WORDS=("$@")
if [[ $spaceend -eq 1 ]]; then
	COMP_WORDS+=('')
fi
# index of the last word
COMP_CWORD=$(( ${#COMP_WORDS[@]} - 1 ))

completion=$(complete -p "$1" 2>/dev/null | awk '{print $(NF-1)}')

if [[ -z ${completion} ]]; then
	# some complicated completions are loaded on demand
	_completion_loader "$1"
	completion=$(complete -p "$1" 2>/dev/null | awk '{print $(NF-1)}')
fi

# exit when not found
if [[ -z ${completion} ]]; then
	exit 1
fi

wordBeforeCompletion=''
if [[ ${#COMP_WORDS[@]} -gt 1 ]]; then
	wordBeforeCompletion=${COMP_WORDS[-2]}
fi

"$completion" "${COMP_WORDS[0]}" "${COMP_WORDS[-1]}" "${wordBeforeCompletion}" 2>/dev/null

printf '%s\n' "${COMPREPLY[@]}"
