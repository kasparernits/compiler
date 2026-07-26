#!/usr/local/bin/ksh93

set -euo pipefail

if [[ $# -eq 0 || -z $1 ]]; then
	print -u2 "Usage: $0 file.c"
	exit 1
fi

set -A tokens
idx=0

lex_line() {
	typeset line="$1"
	typeset token rest

	# Strip one or more leading spaces.
	if [[ $line =~ ^[[:space:]]+ ]]; then
		line="${line#${.sh.match[0]}}"
	fi

	while [[ -n $line ]]; do
		# Keywords.
		if [[ $line =~ ^(int|char|return|if|else|void)\b ]]; then
			token="${.sh.match[0]}"
			tokens[$idx]="KEYWORD:$token"
			((idx++))
			line="${line#$token}"

		# Identifiers.
		elif [[ $line =~ ^[a-zA-Z_][a-zA-Z0-9_]* ]]; then
			token="${.sh.match[0]}"
			tokens[$idx]="ID:$token"
			((idx++))
			line="${line#$token}"

		# Numbers & suffix error check.
		elif [[ $line =~ ^[0-9]+ ]]; then
			token="${.sh.match[0]}"
			rest="${line#$token}"

			# Lookahead check for invalid identifier suffix.
			if [[ $rest =~ ^[a-zA-Z_] ]]; then
				[[ $rest =~ ^[a-zA-Z_]+ ]]
				print -u2 "Lexer error: Invalid identifier" \
				    "or suffix near '$token${.sh.match[0]}'"
				exit 1
			fi

			tokens[$idx]="NUM:$token"
			((idx++))
			line="$rest"

		# Multi-character Operators (==, !=, <=, >=).
		elif [[ $line =~ ^(==|!=|<=|>=) ]]; then
			token="${.sh.match[0]}"
			tokens[$idx]="OP:$token"
			((idx++))
			line="${line#$token}"

		# Single-character Symbols.
		elif [[ $line =~ ^[-+*/=;{}()] ]]; then
			token="${.sh.match[0]}"
			tokens[$idx]="SYM:$token"
			((idx++))
			line="${line#$token}"

		# Fallback Error Handler.
		else
			# Grab just the first character using regex dot.
			[[ $line =~ ^. ]] || [[ $line =~ '\' ]]
			#print -u2 "Lexer error: Unexpected character" \
			#    "'${.sh.match[0]}'"
			exit 1
		fi

		# Strip trailing spaces between tokens.
		if [[ $line =~ ^[[:space:]]+ ]]; then
			line="${line#${.sh.match[0]}}"
		fi
	done
}

while read -r line || [[ -n $line ]]; do
	lex_line "$line"
done < "$1"

