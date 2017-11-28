#!/bin/bash

source ./io.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd )"
USAGE=$( cat "${DIR}/doc" )

### Your defined arguments; Arguments that can be used:
OPTS=(a b c)
OPTS_EXT=(version foo bar config)
KEYWORDS=(status stat start stop)
# Add help options to option arrays
OPTS+=("${HELP}")
OPTS_EXT+=("${HELP_EXT}")

### If option at perspective position takes a value [yes/no]:
HASVAL=()
HASVAL_EXT=(no no no yes)
HASVAL_KEYWORD=()

getio $@

echo OPTS: ${ARGS_OPTS[@]}
echo VALS: ${VALS[@]}
echo OPTS_EXT: ${ARGS_OPTS_EXT[@]}
echo VALS_EXT: ${VALS_EXT[@]}
echo KW: ${ARGS_KEYWORDS[@]}
echo VALS_KW: ${VALS_KEYWORD[@]}

if [ $( has_opt? version ) ]; then
	echo "Version 0.0"
	exit
fi
if [ $( has_opt? a ) ]; then
	echo "AAAAAAAA"
fi
if [ $( has_opt? b c ) ]; then
	echo "BCBCBCBCBCB"
fi
if [ $( has_opt? foo bar ) ]; then
	echo "fooooobaaarr"
fi
if [ $( has_keyword? status stat ) ]; then
	echo "CURRENT STATUS: script is working nicely :)"
fi
if [ $( has_keyword? start ) ]; then
	echo "STARTING"
fi
if [ $( has_keyword? stop ) ]; then
	echo "STOPPING"
fi
if [ $( has_opt? config ) ]; then
	echo "config file: ${VALS_EXT[4]}"
fi

