#!/bin/bash
# Author: Luke Pafford
# Created: 1/29/2016
# Purpose: this script is fairly useless.
# The intended goal is to practice with 
# more advanced BASH features, 
# such as functions, case, and getopts


# Define Variables
CAPS=false
f_FLAG=false
MESSAGE="test"
FILEPATH=

# Define Functions
function usage() {
    echo "$0 [-c] [-m STRING] [-f FILE]"
    echo "Try $0 -h for more information."
}

function extended_usage() {
    echo "$0 [-c] [-m STRING] -f FILE"
    echo "This script will append a message to a specified files."
    echo "The message can be user defined, or 'test' by default"

    echo "OPTIONS:"
    echo "-c Append message in all caps to file"
    echo "-m User defined message to append to file"
    echo "-f single file to append message to"
} 

function convert_upper() {
    if [[ "$1" = true ]]; then
        MESSAGE="${2^^}"
    fi
}

function verify_file() {
    if [ "$f_FLAG" = false ]; then
       echo "Mandatory switch '-f' requries a file path."
       exit 1
    elif [[ ! -f "$1" ]]; then
        echo "Filepath $1 does not exist!"
        exit 1
    fi    
}

function append_message(){
    if [[ -w "$2" ]]; then 
        echo  "$1" >> "$2"
    else
        echo "You do not have write permissions to file $2"
        exit 1
    fi
}
    
# Show usage
if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

# Parse parameters
while getopts ":f:m:ch" opt; do
    case "$opt" in
        f )
            f_FLAG=true
            FILEPATH="$OPTARG"
            ;;
        m )
            MESSAGE="$OPTARG"
            ;;
        c )
            CAPS=true
            ;;
        h )
            extended_usage
            exit 1
            ;;
        \? )
            echo "Invalid option: $OPTARG" >&2
            exit 1
            ;;
    esac
done
        
# Allow positional parameters to now be parsed
shift "$((OPTIND-1))"


# MAIN 
# -------------------------------------------
# -------------------------------------------

# Test if message needs to be converted to upper case
convert_upper "$CAPS" "$MESSAGE"
    
# Test if a file has been provided, or the file exists
verify_file "$FILEPATH"

# append message to file if user has write permission
append_message "$MESSAGE" "$FILEPATH"
