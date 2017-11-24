#!/bin/bash
########################################
###
### io.sh
### Template for conventional usage,
### arguments/options
###
########################################

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd )"
USAGE=$( cat "${DIR}/doc" )

HELP="h"          # -h
HELP_EXT="help"   # --help

### Your defined arguments; Arguments that can be used:
# WIP TODO
OPTS=()
OPTS_EXT=()
ALL_OPTS=()
KEYWORDS=()

### Following are arguments from command line:
ARGS_OPTS=()           # ex: -v -a
ARGS_OPTS_EXT=()       # ex: --verbose --all
ARGS_ALL_OPTS=()       # $ARGS_OPTS and $ARGS_OPTS_EXT
ARGS_KEYWORDS=()       # ex: status enable


function getio {

	for arg in $@; do
		if [[ $arg =~ ^-[[:alnum:]]+$ ]]; then
			for (( i=1; i < ${#arg}; i++ )); do
				ARGS_OPTS+=("${arg:$i:1}")
			done
		elif [[ "$arg" =~ ^--[[:alnum:]][[:alnum:]]+$ ]]; then
			ARGS_OPTS_EXT+=("${arg:2}")
		elif [[ "$arg" =~ ^[[:alnum:]]+$ ]]; then
			ARGS_KEYWORDS+=("$arg")
		fi
	done

	### ARGS_ALL_OPTS
	ARGS_ALL_OPTS=($( echo "${ARGS_OPTS} ${ARGS_OPTS_EXT}" ))

	### Print usage / help_text and exit
	if [[ " ${ARGS_OPTS[@]} " =~ " ${HELP} " || " ${ARGS_OPTS_EXT[@]} " =~ " ${HELP_EXT} " ]]; then
		echo "$USAGE"
		exit
	fi

}

function has_x? {
	IFS_DEF=$IFS
	IFS=','
	to_check=($1)
	inputs=($2)
	IFS=$IFS_DEF

	for input in ${inputs[@]}; do
		if [[ " ${to_check[@]} " =~ " $input " ]]; then
			echo -n "true"
			return
		fi
	done
	echo -n "false"

}

function has_opt? {
	echo -n $( has_x? "$( echo ${ARGS_OPTS[@]} ${ARGS_OPTS_EXT[@]} | tr ' ' ',' )" "$( echo $@ | tr ' ' ',' )" )
}

function has_keyword? {
	echo -n $( has_x? "$( echo ${ARGS_KEYWORDS[@]} | tr ' ' ',' )" "$( echo $@ | tr ' ' ',' )" )
}


### Get options and keywords from command line, fill variables above
getio $@

### Check if -a or --test were given
## return "true"  if any option WASN'T given
## return "false" if any option  WAS   given
# has_opt? a test

#echo "KWS: ${ARGS_KEYWORDS[@]}"
#echo "ARGS_OPTS: ${ARGS_OPTS[@]}"
#echo "ARGS_OPTS_EXT: ${ARGS_OPTS_EXT[@]}"

#if [[ "$( has_opt? verbose )" =~ "true" ]]; then
#	echo "OPT"
#fi
#
#if [[ "$( has_keyword? status )" =~ "true" ]]; then
#	echo "KEYWORD"
#else
#	echo "NO KW"
#fi

#case $( has_opt ) in

