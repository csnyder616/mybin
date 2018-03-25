#!/bin/bash

# sw: create/attach tmux session based on directory
# Directory heuristic:
# 1. No dir specified: current dir
# 2. Subdirectory of current directory
# 3. Subdirectory of dir list (defined in DIRS below)

set -euo pipefail

DIRS=(
	"/home/csnyder"
	"/home/csnyder/git"
)

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
	if [ -d "./$1" ]; then # subdirectory exists in current directory
		readlink -f "./$1"
		return
	fi
	look_for_directory "$1"
}

open_tmux() { # argument: directory (also used as session name)
	dir="$1"
	session=$(echo $1 | sed 's/\./_/g')
	tmux new-session -A -c "$dir" -s "$session" $SHELL
}

dir="$(determine_directory "$1")"
open_tmux "$dir"
