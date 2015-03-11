#!/bin/bash

source arg_parser.sh

CONF='
    {
     "name":
       {"name":"name",
        "short": "n",
        "required": "True",
        "help": "Name of the something"
       },
     "option":
       {"name":"option",
        "short": "o",
        "default": "default_o",
        "help": "This is manual for this option"
       }
    }'

ARGS=${@}

arg_parser "${CONF}" "${ARGS}"

echo ${name}
echo ${option}
