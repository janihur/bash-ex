#!/bin/bash

# https://stackoverflow.com/a/14203146/272735

# -----------------------------------------------------------------------------
# strict mode
# http://www.binaryphile.com/bash/2018/08/09/approach-bash-like-a-developer-part-11-strict-mode.html
set -o errexit -o nounset -o pipefail
set -o | grep errexit # demonstrate that errexit is on

# -----------------------------------------------------------------------------
# standard help and command line argument processing

function help() {
	local -r self=$(basename "$0")

	echo "Usage: ${self} [OPTION] INPUT"
	echo "Convert INPUT to upper case (default) or lower case."
	echo
	echo "  -h, --help   display this help and exit"
	echo "  -l, --lower  convert INPUT to lower case"
}

declare -a POSITIONAL_ARGS=()
declare IS_LOWER=false

while (( $# )); do
	case "$1" in
		-h|--help)
			help
			exit 0
			;;
		-l|--lower)
			IS_LOWER=true
			shift
			;;
		-*|--*)
			echo "ERROR: unknown option $1"
			exit 1
			;;
		*)
			POSITIONAL_ARGS+=("$1")
			shift
			;;
	esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional arguments
unset -v POSITIONAL_ARGS

if (( $# != 1 )); then
	help
	exit 1
fi

# -----------------------------------------------------------------------------
# functions

function main () {
	# shell options local to the function
	# remember dymamic scoping!
	local -
	set +o errexit # disable errexit on this (dynamic) scope

	local -r input="$@"
	local retval=0
	local output=unset
	local side_effect=unset

	if [[ "${IS_LOWER}" == true ]]; then
		output=$(lower "${input}") # runs in a subshell, no side effects
		retval=$?
	else
		upper "${input}"
		retval=$?
	fi

	echo "retval: ${retval}"
	echo "output: ${output}"
	echo "side_effect: ${side_effect}"
}

function upper() {
	output="${1@U}" # uppercase
	side_effect=${output}
	return 1
}

function lower() {
	echo "${1@L}" # lowercase
	side_effect=${output}
	return 2
}

# -----------------------------------------------------------------------------
main "$@"
set -o | grep errexit # demonstrate that errexit is on