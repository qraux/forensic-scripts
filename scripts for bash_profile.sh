#!/bin/sh

## -----------------------------------------------------------------------------------------
## USEFUL BASH SCRIPTS FOR .bash_profile (md5deep on fedora, md5 on mac)
## -----------------------------------------------------------------------------------------

alias lshash='func_lshash'  	 # Hashing for provided args
alias lsmime='func_lsmime' 		 # Find files by file sign in hex
alias lsmdls='func_lsmdls'		 # Find files by metadata
alias signcheck='func_signcheck' # Signature check for provided args (inc dirs) and signature to match.
alias mimecheck='func_mimecheck' # Mime type check for provided args (inc dirs) and mime type to match.
alias hashcheck='func_hashcheck' # md5 hash check for provided args (inc dirs) and hash to match.

## -----------------------------------------------------------------------------------------
# List files and hash for provided arg (incl dirs)
# Usage: lshash file_or_folder
## -----------------------------------------------------------------------------------------
function func_lshash(){
	for i in "$@"; do
		if [ -f "${i}" ]; then
			md5deep "${i}"
        fi
		if [ -d "${i}" ]; then
            find "${i}" -type f -exec md5deep {} \;
        fi
	done
}

## -----------------------------------------------------------------------------------------
# List files by file sign in text
# Usage: lsmime file_or_folder
## -----------------------------------------------------------------------------------------
function func_lsmime(){
	for i in "$@"; do
		if [ -f "${i}" ]; then
            find "${i}" -type f -exec file --mime-type {} \;
        fi
		if [ -d "${i}" ]; then
            find "${i}" -type d -exec file --mime-type {} \;
        fi
	done
}

## -----------------------------------------------------------------------------------------
# List files by mdls
# Usage: lsmdls
## -----------------------------------------------------------------------------------------
function func_lsmdls(){
	for i in "$@"; do
		if [ -f "${i}" ]; then
            mdls "${i}"
        fi
		if [ -d "${i}" ]; then
            mdls "${i}"
        fi
	done
}

## -----------------------------------------------------------------------------------------
# Signature check for provided arguments (including directories) and signature to match.
# Usage: signcheck file_or_folder signature_in_hex
# Example: signcheck . 89504e
## -----------------------------------------------------------------------------------------
function func_signcheck(){
	signatutre_to_match="${2}"
	# echo $signatutre_to_match

    prepend_str="0000000 "
    # Make the comparison hash to look similar to hexdump output
    signature_with_spaces=$(echo $signatutre_to_match | fold -w2 | paste -sd' ' -);
    signature_with_spaces="$prepend_str$signature_with_spaces"
    # echo $signature_with_spaces

    if [ -f "${1}" ]; then
		sig_t="$(hexdump -n 32  "${1}")"
		echo $sig_t
		echo $signature_with_spaces
       if [[ "${sig_t}" == "${signature_with_spaces}"* ]]; then
           echo "${1}"
       fi
    fi
    if [ -d "${1}" ]; then
        find "${1}" -type f -print0 | while read -d $'\0' file
	do
         signatutre_t="$(hexdump -n 32  "$file")"
         if [[ "${signatutre_t}" == "${signature_with_spaces}"* ]]; then
           echo $file
         fi
       done
    fi
}

## -----------------------------------------------------------------------------------------
# Mime type check for provided arguments (including directories) and mime type to match.
# Usage: mimecheck file_or_folder mime_type
## -----------------------------------------------------------------------------------------
function func_mimecheck(){
	mime_to_match="${2}"
    echo $mime_to_match

    if [ -f "${1}" ]; then
       mime_type="$(file --mime-type -b  "${1}")"

       if [[ "${mime_type}" == "${mime_to_match}"* ]]; then
           echo "${1}"
       fi
    fi

    if [ -d "${1}" ]; then
		find "${1}" -print0 | while read -d $'\0' file
		do
			#echo -v "$file"
			mime_type="$(file --mime-type -b  "$file")"
			if [[ "${mime_type}" == "${mime_to_match}"* ]]; then
				echo $file
			fi
		done		
   fi	
}

## -----------------------------------------------------------------------------------------
# md5 hash check for provided arguments (including directories) and hash to match.
# Usage: hashcheck file_or_folder hash_value_to_match
## -----------------------------------------------------------------------------------------
function func_hashcheck(){
    md5_hash_to_match="${2}"
    echo $md5_hash_to_match

    if [ -f "${1}" ]; then
       md5_hash="$(md5deep -q  "${1}")"

       if [[ "${md5_hash}" == "${md5_hash_to_match}" ]]; then
           echo "${1}"
       fi
    fi
    if [ -d "${1}" ]; then
        find "${1}" -type f -print0 | while read -d $'\0' file
		do
			md5_hash="$(md5deep -q  "$file")"
			if [[ "${md5_hash}" == "${md5_hash_to_match}" ]]; then
				echo $file	# will just print hash val not path ?
			fi
		done
    fi
}
