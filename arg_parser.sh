#!/bin/bash

function arg_parser {
    local CONF=${1:?"CONF is mandatory argument"}
    local ARGS=${2}

    local FILENAME=$(mktemp)

    ./arg_parser.py --conf "${CONF}" --filename ${FILENAME} -- ${ARGS}

    source ${FILENAME}

    rm ${FILENAME}
}
