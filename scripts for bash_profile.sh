#!/bin/sh
# Aliases for multiple hashing/mime/mdls of file or folder. Check files against hex, mime and hash.
# Tips: add this to .bash_profile 
alias lshash='func_lshash'	# Hashing for provided args
alias lsmime='func_lsmime'	# Find files by file sign in hex (macOS only)
alias lsmdls='func_lsmdls'	# Find files by metadata
alias signcheck='func_signcheck' # Sign check for provided args (inc dirs) and sign to match.
alias mimecheck='func_mimecheck' # Mime type check for provided args (inc dirs) and mime type to match.
alias hashcheck='func_hashcheck' # md5 hash check for provided args (inc dirs) and hash to match.

# List files and hash for provided arg
# Usage: lshash file_or_folder
# (md5deep on fedora, md5 on macOS)
function func_lshash(){
	for i in "$@"; do
		if [ -f "${i}" ]; then
			md5deep "${i}" #fedora
			#md5 "${i}" #mac
		fi
		if [ -d "${i}" ]; then
			find "${i}" -type f -exec md5deep {} \; #fedora
			#find "${i}" -type f -exec md5 {} \; #mac
		fi
	done
}

# List files by file sign in text
# Usage: lsmime file_or_folder
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

# List files by mdls (macOS only)
# Usage: lsmdls
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

# Signature check for provided args and sign to match.
# Usage: signcheck file_or_folder sign_in_hex
# Example: signcheck . 39604a
function func_signcheck(){
	sign_to_match="${2}"
	prep_str="0000000 "
	sign_with_spaces=$(echo $sign_to_match | fold -w2 | paste -sd' ' -);
	sign_with_spaces="$prep_str$sign_with_spaces"

	if [ -f "${1}" ]; then
		sig_t="$(hexdump -n 32  "${1}")"
		echo $sig_t
		echo $sign_with_spaces
		if [[ "${sig_t}" == "${sign_with_spaces}"* ]]; then
			echo "${1}"
		fi
	fi
	if [ -d "${1}" ]; then
		find "${1}" -type f -print0 | while read -d $'\0' file
		do
			sign_t="$(hexdump -n 32  "$file")"
			if [[ "${sign_t}" == "${sign_with_spaces}"* ]]; then
				echo $file
			fi
		done
	fi
}

# Mime type check for provided args and mime type to match.
# Usage: mimecheck file_or_folder mime_type
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
			mime_type="$(file --mime-type -b  "$file")"
			if [[ "${mime_type}" == "${mime_to_match}"* ]]; then
				echo $file
			fi
		done		
	fi	
}

# md5 hash check for provided args and hash to match.
# Usage: hashcheck file_or_folder hash_value_to_match
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
				echo $file
			fi
		done
	fi
}
