#!/bin/bash
########################################
###
### io.sh
### Template for conventional usage,
### arguments/options
###
########################################

##################################### TODO #####################################
### Fix storing of values/arguments given to options that take arguments     ###
### Maybe create object-like storing system ->                               ###
### object=(key1 val1 key2 val2 key3 val3 ...)                               ###
################################################################################


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd )"
USAGE=$( cat "${DIR}/doc" )

HELP="h"          # -h
HELP_EXT="help"   # --help


### Following are arguments from command line:
ARGS_OPTS=()           # ex: -v -a
ARGS_OPTS_EXT=()       # ex: --verbose --all
ARGS_ALL_OPTS=()       # $ARGS_OPTS and $ARGS_OPTS_EXT
ARGS_KEYWORDS=()       # ex: status enable


### Your defined arguments; Arguments that can be used:
OPTS=()
OPTS_EXT=()
KEYWORDS=()

# Add help options to option arrays
OPTS+=("${HELP}")
OPTS_EXT+=("${HELP_EXT}")

### If option at perspective position takes a value [yes/no]:
HASVAL=()
HASVAL_EXT=()
HASVAL_KEYWORD=()

### Values given by user from command line to options that accept values:
VALS=()
VALS_EXT=()
VALS_KEYWORD=()


function getio {

	args=($@)
	SKIP=false
	count_opt=0
	count_opt_ext=0
	count_keyword=0
	unrecognized=()
	# for arg in $@; do
	for (( count=0; count < ${#args[@]}; count++ )); do
		if [[ $SKIP == true ]]; then
			SKIP=false
			continue
		fi
		arg="${args[$count]}"
		if [[ "$arg" =~ ^-[[:alnum:]]+$ ]]; then
			for (( i=1; i < ${#arg}; i++ )); do
				if [[ " ${OPTS[@]} " =~ " ${arg:$i:1} " ]]; then
					ARGS_OPTS+=("${arg:$i:1}")
					if [[ ${HASVAL[$count_opt]} == yes ]]; then
						VALS+=("${args[$count+1]}")
						SKIP=true
					else
						VALS+=(NIL)
					fi
					((count_opt++))
				else  # option not recognized, not valid option
					unrecognized+=("-${arg:$i:1}")
				fi
			done
		elif [[ "$arg" =~ ^--[[:alnum:]][[:alnum:]]+$ ]]; then
			if [[ " ${OPTS_EXT[@]} " =~ " ${arg:2} " ]]; then
				ARGS_OPTS_EXT+=("${arg:2}")
				if [[ ${HASVAL_EXT[$count_opt_ext]} == yes ]]; then
					VALS_EXT+=("${args[$count+1]}")
					SKIP=true
				else
					VALS_EXT+=(NIL)
				fi
				((count_opt_ext++))
			else  # option not recognized, not valid option
				unrecognized+=("--${arg:2}")
			fi
		elif [[ "$arg" =~ ^[[:alnum:]]+$ ]]; then
			if [[ " ${KEYWORDS[@]} " =~ " ${arg} " ]]; then
				ARGS_KEYWORDS+=("${arg}")
				if [[ ${HASVAL_KEYWORD[$count_keyword]} == yes ]]; then
					VALS_KEYWORD+=("${args[$count+1]}")
					SKIP=true
				else
					VALS_KEYWORD+=(NIL)
				fi
				((count_keyword++))
			else  # option not recognized, not valid option
				unrecognized+=("$arg")
			fi
		fi
	done

	### All options
	ARGS_ALL_OPTS=($( echo "${ARGS_OPTS} ${ARGS_OPTS_EXT}" ))

	### Print usage / help_text and exit
	if [[ " ${ARGS_OPTS[@]} " =~ " ${HELP} " || " ${ARGS_OPTS_EXT[@]} " =~ " ${HELP_EXT} " || ${#unrecognized[@]} > 0 ]]; then
		for unrec in ${unrecognized[@]}; do
			str="Option or keyword"
			if [[ "${unrec:0:2}" == "--" ]]; then   str="Extended option"
			elif [[ "${unrec:0:1}" == "-" ]]; then  str="Option"
			else                                    str="Keyword"
			fi
			echo "${str} not recognized: '${unrec}'"
		done
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

}

function has_opt? {
	echo -n $( has_x? "$( echo ${ARGS_OPTS[@]} ${ARGS_OPTS_EXT[@]} | tr ' ' ',' )" "$( echo $@ | tr ' ' ',' )" )
}

function has_keyword? {
	echo -n $( has_x? "$( echo ${ARGS_KEYWORDS[@]} | tr ' ' ',' )" "$( echo $@ | tr ' ' ',' )" )
}


### Get options and keywords from command line, fill variables above
## getio $@

## echo OPTS: ${ARGS_OPTS[@]}
## echo VALS: ${VALS[@]}
## echo OPTS_EXT: ${ARGS_OPTS_EXT[@]}
## echo VALS_EXT: ${VALS_EXT[@]}
## echo KW: ${ARGS_KEYWORDS[@]}
## echo VALS_KW: ${VALS_KEYWORD[@]}

