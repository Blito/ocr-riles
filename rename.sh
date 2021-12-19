#!/bin/bash

## This script will perform Optical Character Recognition on all 
## files in a given folder and change each file name with the 
## contents of said file.
##
## IMPORTANT ASSUMPTIONS:
##   * All files in the folder are images
##   * Every file has a single line of text written in English

print-usage() {
    echo "Usage: 
    rename.sh [--only-show] <directory with files to replace>"
}

print-requirements() {
    echo "This script requires tesseract to be installed and available in PATH."
    echo "See https://tesseract-ocr.github.io/tessdoc/Installation.html for instructions."
}

rename_all_files_in() {
    if [ "$#" -lt 1 ]; then
        echo "Incorrect number of arguments provided."
        print-usage
        return 1
    fi

    # Parse options
    only_show=false
    if [ "$#" -eq 2 ]; then
        case "${1}" in
            --only-show)
                only_show=true
                shift 1
            ;;
            *)
            echo "Invalid argument provided: ${1}"
            print-usage
            return 1
            ;;
        esac
    fi

    if $(which tesseract | grep "not found"); then
        print-requirements
        return 1
    fi

    local -r directory="${1%/}"

    files=(${directory}/*.*)

    echo "Found ${#files} files to rename."
    if [ ${only_show} = true ]; then
        echo "Not modifying any files."
    fi

    # Give some time to react and CTRL+C out of it.
    sleep 3

    for file in "${files[@]}"; do
        filename=$(basename -- "${file}")
        extension="${filename##*.}"

        text_in_file="$(tesseract "${file}" stdout -psm 7 -l eng 2> /dev/null)"
        text_in_file=$(echo "${text_in_file}" | sed "s/[\.,\'/-’—:]//g")
        echo "mv \""${file}"\" \""${directory}/${text_in_file}".${extension}\""

        if [ ${only_show} = false ]; then
            mv "${file}" "${directory}/${text_in_file}".${extension}
        fi
    done
}

rename_all_files_in "${@}"