#!/bin/bash

# https://stackoverflow.com/a/14203146/272735

# -----------------------------------------------------------------------------
# strict mode
# http://www.binaryphile.com/bash/2018/08/09/approach-bash-like-a-developer-part-11-strict-mode.html
set -o errexit -o nounset -o pipefail

# -----------------------------------------------------------------------------
# standard help and command line argument processing

function help() {
	local -r self=$(basename "$0")

	echo "# ${self}"
	echo "# Convert INPUT to all upper case."
	echo "#"
	echo "# Usage: ${self} [-h|--help] INPUT"
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
	local -r input="$@"
	local output=unset

	if [[ "${IS_LOWER}" == true ]]; then
		lower $input
	else
		upper $input
	fi

	echo "${output}"
}

function upper() {
	output="${@@U}" # uppercase
}

function lower() {
	output="${@@L}" # lowercase
}

# -----------------------------------------------------------------------------
main "$@"
