#!/bin/bash
########################################
###
### io.sh
### Template for conventional usage,
### arguments/options
###
########################################

function getio {

	for arg in $@; do
		if [[ $arg =~ ^-[[:alnum:]]+$ ]]; then
			for (( i=1; i < ${#arg}; i++ )); do
				OPTS+=("${arg:$i:1}")
			done
		elif [[ "$arg" =~ ^--[[:alnum:]][[:alnum:]]+$ ]]; then
			OPTS_EXT+=("${arg:2}")
		elif [[ "$arg" =~ ^[[:alnum:]]+$ ]]; then
			KEYWORDS+=("$arg")
		fi
	done

	### Print usage / help_text and exit
	if [[ " ${OPTS[@]} " =~ " ${HELP} " || " ${OPTS_EXT[@]} " =~ " ${HELP_EXT} " ]]; then
		echo "$USAGE"
		exit
	fi

}

function has_x? {
	### $1 -> to check against
	### $@ -> check any (except first)
	skip=false
	for O in $@; do
		if [ $skip == false ]; then
			skip=true
			continue
		fi
		if [[ " $1 " =~ " $O " ]]; then
			echo -n "true"
			return
		fi
	done
	echo -n "false"
}

function has_opt? {
	echo -n $( has_x? "${OPTS[@]} ${OPTS_EXT[@]}" $@ )
}

function has_keyword? {
	echo -n $( has_x? "${KEYWORDS[@]}" $@ )
}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd )"
USAGE=$( cat "${DIR}/doc" )

HELP="h"          # -h
HELP_EXT="help"   # --help

OPTS=()
OPTS_EXT=()
KEYWORDS=()

### Get options and keywords from command line, fill variables above
getio $@

### Check if -a or --test were given
## return "true"  if any option WASN'T given
## return "false" if any option  WAS   given
# has_opt? a test

echo "KWS: ${KEYWORDS[@]}"
echo "OPTS: ${OPTS[@]}"
echo "OPTS_EXT: ${OPTS_EXT[@]}"

if [[ "$( has_opt? verbose )" =~ "true" ]]; then
	echo "OPT"
fi

has_keyword? "status"
exit
if [[ "$( has_keyword? status )" =~ "true" ]]; then
	echo "KEYWORD"
else
	echo "NO KW"
fi

#case $( has_opt ) in

