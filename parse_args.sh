#!/bin/bash

DEFAULT_CONF='
    {"cmd": "'${0:2}'",
     "options":
      [
       {"opt":"h",
        "opt_long": "help",
        "arg": "",
        "man": "Print this message"
       },
       {"opt":"v",
        "opt_long": "verbose",
        "arg": "",
        "man": "Verbose"
       }
     ]
    }'

function usage {

    CMD=`echo "${DEFAULT_CONF}" | jq -r '.cmd'`
    HELP_MSG="Usage: ${CMD} [OPTION...]\n\nOptions:"

    MANS=`echo "${DEFAULT_CONF}" | jq -r '.options[] | "\t-\(.opt), --\(.opt_long)\t\(.man)"'`
    MANS+="\n"
    MANS+=`echo "${CONF}" | jq -r '.options[] | "\t-\(.opt), --\(.opt_long)\t\(.man)"'`

    echo -e ${HELP_MSG}
    echo -e "${MANS}"
}


function prepare_args {
    local _CONF=${1-$CONF}
    local _ARGS=${2-$ARGS}

    CMD=`echo "${DEFAULT_CONF}" | jq -r '.cmd'`

    OPTS=`echo "${DEFAULT_CONF}" | jq -r '.options[] | "\(.opt)\(.arg)"'`
    OPTS+=`echo "${_CONF}" | jq -r '.options[] | "\(.opt)\(.arg)"'`
    OPTS=`echo ${OPTS} | tr -d ' '`

    OPTS_LONG=`echo "${DEFAULT_CONF}" | jq -r '.options[] | "\(.opt_long)\(.arg),"'`
    OPTS_LONG+=`echo "${_CONF}" | jq -r '.options[] | "\(.opt_long)\(.arg),"'`
    OPTS_LONG=`echo ${OPTS_LONG%?} | tr -d ' '`

    TEMP=`getopt -o ${OPTS} --long ${OPTS_LONG} -n ${CMD} -- ${_ARGS}`

    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"
    ARGS=$@
}

function parse_default_args {
    local _CONF=${1-$CONF}
    local _ARGS=${2-$ARGS}

    prepare_args "$_CONF" "$_ARGS"

    eval set -- "$ARGS"

    for true ; do
        case $1 in
            # Default options
            -h|--help) usage ; exit 1 ;;
            -v|--verbose) set -o xtrace; shift 1;;

            # Exit
            --) shift ; break ;;
            *)  break ;;
        esac
    done

    ARGS=$@

#    echo "Remaining arguments:"
#    for arg do echo '--> '"\`$arg'" ; done
}


