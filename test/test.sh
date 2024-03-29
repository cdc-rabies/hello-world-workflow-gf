#!/bin/bash

# Simple hello world GeneFlow app test script


###############################################################################
#### Helper Functions ####
###############################################################################

## MODIFY >>> *****************************************************************
## Usage description should match command line arguments defined below
usage () {
    echo "Usage: $(basename "$0")"
    echo "  --exec_method => Execution method (environment, auto)"
    echo "  --help => Display this help message"
}
## ***************************************************************** <<< MODIFY

# report error code for command
safeRunCommand() {
    cmd="$@"
    eval "$cmd"
    ERROR_CODE=$?
    if [ ${ERROR_CODE} -ne 0 ]; then
        echo "Error when executing command '${cmd}'"
        exit ${ERROR_CODE}
    fi
}

# always report exit code
reportExit() {
    rv=$?
    echo "Exit code: ${rv}"
    exit $rv
}

trap "reportExit" EXIT



###############################################################################
#### Parse Command-Line Arguments ####
###############################################################################

getopt --test > /dev/null
if [ $? -ne 4 ]; then
    echo "`getopt --test` failed in this environment."
    exit 1
fi

## MODIFY >>> *****************************************************************
## Command line options should match usage description
OPTIONS=hx:
LONGOPTIONS=help,exec_method:
## ***************************************************************** <<< MODIFY

# -temporarily store output to be able to check for errors
# -e.g. use "--options" parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(\
    getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@"\
)
if [ $? -ne 0 ]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    usage
    exit 2
fi

# read getopt's output this way to handle the quoting right:
eval set -- "$PARSED"

## MODIFY >>> *****************************************************************
## Set any defaults for command line options
EXEC_METHOD=auto
## ***************************************************************** <<< MODIFY

## MODIFY >>> *****************************************************************
## Handle each command line option.
while true; do
    case "$1" in
        --help)
            usage
            exit 0
            ;;
        --exec_method)
            EXEC_METHOD=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid option"
            usage
            exit 3
            ;;
    esac
done
## ***************************************************************** <<< MODIFY



###############################################################################
#### Run Script ####
###############################################################################
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CMD="${SCRIPT_DIR}/../assets/hello-world-gf.sh"
    CMD="${CMD} --file=\"${SCRIPT_DIR}/data/file.txt\""
    CMD="${CMD} --output=\"output.txt\""
    CMD="${CMD} --exec_method=\"${EXEC_METHOD}\""
echo "CMD=${CMD}"
safeRunCommand "${CMD}"

