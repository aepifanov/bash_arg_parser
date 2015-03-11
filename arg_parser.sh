#!/bin/bash

function arg_parser {
    local CONF=${1:?"CONF is mandatory argument"}
    local ARGS=${2}
    local DIR=${3:-$PWD}

    local FILENAME=$(mktemp)

    pushd ${DIR} &> /dev/null
    ./arg_parser.py --conf "${CONF}" --filename ${FILENAME} -- ${ARGS}
    popd         &> /dev/null

    if [ -s  ${FILENAME} ]
    then
        source ${FILENAME}
        rm ${FILENAME}
    else
        exit 0
    fi
}
