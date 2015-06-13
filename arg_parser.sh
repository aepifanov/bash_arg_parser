
function arg_parser {
    local CONF=${1:?"Please specify CONF"}
    local ARGS=${2:-""}
    local WORKDIR=${WORKDIR?"Please specify WORKDIR"}

    local FILENAME=$(mktemp)

    pushd "${WORKDIR}" &> /dev/null
    ./arg_parser.py --conf "${CONF}" --filename "${FILENAME}" -- ${ARGS}
    popd         &> /dev/null

    if [[   -s "${FILENAME}" ]]
    then
        source "${FILENAME}"
        rm     "${FILENAME}"
    else
        exit 0
    fi
}
