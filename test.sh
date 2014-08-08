#!/bin/bash

source parse_args.sh

CONF='
    {
     "options":
      [
       {"opt":"o",
        "opt_long": "o-long",
        "arg": ":",
        "man": "This is manual for this option"
       }
     ]
    }'

ARGS=${@}

function parse_args {
    local _CONF=${1-$CONF}
    local _ARGS=${2-$ARGS}

    parse_default_args "$_CONF" "$_ARGS"

    eval set -- "$ARGS"

    while true ; do
        case "$1" in
            # Custom options
            -o|--o-long) echo "Option o, argument \`$2'" ; shift 2 ;;

            # Exit
            --) shift ; break ;;
            *) echo "Internal error!" ; exit 1 ;;
        esac
    done

    echo "Remaining arguments:"
    for arg do echo '--> '"\`$arg'" ; done
}

parse_args "$CONF" "$ARGS"
