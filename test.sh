#!/bin/bash

source arg_parser.sh

CONF='
    {
     "option":
       {"name":"option",
        "short": "o",
        "default": "o",
        "help": "This is manual for this option"
       }
    }'

ARGS=${@}

arg_parser "${CONF}" "${ARGS}"

echo ${option}
