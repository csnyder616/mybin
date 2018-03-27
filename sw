#!/bin/bash

# sw: create/attach tmux session based on directory
# Directory heuristic:
# 1. No dir specified: current dir
# 2. Subdirectory of current directory
# 3. Subdirectory of dir list (defined in DIRS below)
#
# Special modes:
# --list-possibilities - Print all possible directories (used by bash-completion script)

set -euo pipefail

DIRS=(
    "./"
	"/home/csnyder"
	"/home/csnyder/git"
)

list_possibilities() {
	for dir in "${DIRS[@]}"; do
		for subdir in $dir/*; do
			[ -d $subdir ] && echo $(basename $subdir)
		done 
	done
}

look_for_directory() { # argument: directory
	for dir in "${DIRS[@]}"; do
		if [ -d "$dir/$1" ]; then
			readlink -f "$dir/$1"
			return
		fi
	done
	>&2 echo "Error: no directory found matching \"$1\""
	return 1
}

determine_directory() { # argument: directory (passed in on command-line)
	if [ -z $1 ]; then # no argument: current dir
		pwd
		return
	fi
	look_for_directory "$1"
}

open_tmux() { # argument: directory (also used as session name)
	dir="$1"
	session=$(echo $1 | sed 's/\./_/g')
	tmux new-session -A -c "$dir" -s "$session" $SHELL
}

if [ "--list-possibilities" == $1 ]; then
	list_possibilities
	exit 0
fi

dir="$(determine_directory "$1")"
open_tmux "$dir"
