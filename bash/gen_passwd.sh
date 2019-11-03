#!/bin/bash

#final password infos (the one which will be generated)
PASSWD_LEN=8
FINAL_PASSWD=""

#alphabet used to generate th password
PASSWD_LETTERS=""
PASSWD_LETTERS_LEN=0

#binary mask used to construct alphabet (as binary mask is a better way to handle multiple possibilities)
BIN_MASK=2#0000

#list of all types of alphabets that can be used to generate password
UPPER_CHARS="AZERTYUIOPQSDFGHJKLMWXCVBN"
LOWER_CHARS="azertyuiopqsdfghjklmwxcvbn"
NUMBERS="0123456789"
SPECIAL_CHARS="&!\"'\\/:;.,?@{}()|-_^[]+=*~"


#function to describe script behaviour
function usage() {
	echo "USAGE : "
	echo "$0 [-c] [-C] [-s] [-n] [-l <passwd length>]"
	echo ""
	echo "DESCRIPTION : "
	echo "This script allow you to generate password with length (default 8) and differents complexity of letters (upper/lower cases, special chars and numbers)"
	echo ""
	echo "EXAMPLES : "
	echo "To generate password with all chars and length of 8"
	echo "$0"
	echo ""
	echo "To generate password with upper letters only and of length 8"
	echo "$0 -C"
	echo ""
	echo "To generate password with special chars, lower case and of length 16"
	echo "$0 -s -c -l 16"
}

#function to create alphabet which will be used to generate the password
function set_password_alphabet() {
	#verify first if the binary mask is empty and set to all characters
	if [[ $BIN_MASK -eq 2#0000 ]]; then
		BIN_MASK=$(( $BIN_MASK | 2#1111 ))
	fi
	if [[ $(( $BIN_MASK & 2#0001 )) -gt 0 ]]; then
		PASSWD_LETTERS="${PASSWD_LETTERS}${LOWER_CHARS}"
	fi
	if [[ $(( $BIN_MASK & 2#0010 )) -gt 0 ]]; then
		PASSWD_LETTERS="${PASSWD_LETTERS}${UPPER_CHARS}"
	fi
	if [[ $(( $BIN_MASK & 2#0100 )) -gt 0 ]]; then
		PASSWD_LETTERS="${PASSWD_LETTERS}${SPECIAL_CHARS}"
	fi
	if [[ $(( $BIN_MASK & 2#1000 )) -gt 0 ]]; then
		PASSWD_LETTERS="${PASSWD_LETTERS}${NUMBERS}"
	fi
	PASSWD_LETTERS_LEN=${#PASSWD_LETTERS}
}

#function to create the new password
function gen_passwd() {
	local i=0
	local n=0

	while [[ $i -lt "$PASSWD_LEN" ]]; do
		#random index of letter
		n=$((1+ ${RANDOM} % $(( PASSWD_LETTERS_LEN-1 )) ))
		#append only the randomized index of alphabet inside our generated password
		FINAL_PASSWD="${FINAL_PASSWD}${PASSWD_LETTERS:$n:1}"
		i=$((i+1))
	done
}


#main entrance of the script to parse user options
while [[ "$#" -ne 0 ]]; do
	case "$1" in
		-a )
			shift
			BIN_MASK=$(( $BIN_MASK | 2#1111 ));;
		-c )
			shift
			BIN_MASK=$(( $BIN_MASK | 2#0001 ));;
		-C )
			shift
			BIN_MASK=$(( $BIN_MASK | 2#0010 ));;
		-s )
			shift
			BIN_MASK=$(( $BIN_MASK | 2#0100 ));;
		-n )
			shift
			BIN_MASK=$(( $BIN_MASK | 2#1000 ));;
		-h )
			shift
			usage && exit 0;;
		-l )
			shift
			PASSWD_LEN="$1"
			shift;;
		*)
			echo "Unknown option $1"; usage && exit 2;;
	esac
done

set_password_alphabet
gen_passwd

echo "alphabet used : $PASSWD_LETTERS"
echo "password generated : $FINAL_PASSWD"

