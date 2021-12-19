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
    rename.sh <directory with files to replace>"
}

print-requirements() {
    echo "This script requires tesseract to be installed and available in PATH."
    echo "See https://tesseract-ocr.github.io/tessdoc/Installation.html for instructions."
}

rename_all_files_in() {
    if [ "$#" -ne 1 ]; then
        echo "Incorrect number of arguments provided."
        print-usage
        return 1
    fi

    if $(which tesseract | grep "not found"); then
        print-requirements
        return 1
    fi

    local -r directory="${1%/}"

    files=(${directory}/*)

    echo "Found ${#files} files to rename."

    for file in "${files[@]}"; do
        filename=$(basename -- "${file}")
        extension="${filename##*.}"

        text_in_file="$(tesseract "${file}" stdout -psm 7 -l eng 2> /dev/null)"
        text_in_file=$(echo "${text_in_file}" | sed "s/[\.,\'/-’—:]//g")
        echo "mv \""${file}"\" \""${directory}/${text_in_file}".${extension}\""
        mv "${file}" "${directory}/${text_in_file}".${extension}
    done
}

rename_all_files_in $1