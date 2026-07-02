#!/usr/local/bin/ksh93

if [[ -z $1 ]]; then
    print -u2 "Usage: $0 file.c"
    exit 1
fi

set -A tokens
idx=0

while read -r line || [[ -n $line ]]; do

	# Strip one or more leading spaces.
    if [[ $line =~ ^[[:space:]]+ ]]; then
        line="${line#${.sh.match[0]}}"
    fi

    while [[ -n $line ]]; do
        
        # Keywords (word boundary \b ensures 'int_var' isn't matched as 'int').
        if [[ $line =~ ^(int|char|return|if|else|void)\b ]]; then
            token="${.sh.match[0]}"
            tokens[$idx]="KEYWORD:$token"
            ((idx++))
            line="${line#$token}"

        # Identifiers (starts with letter/underscore, followed by letters/digits/underscores).
        elif [[ $line =~ ^[a-zA-Z_][a-zA-Z0-9_]* ]]; then
            token="${.sh.match[0]}"
            tokens[$idx]="ID:$token"
            ((idx++))
            line="${line#$token}"

        # Numbers & suffix error check.
        elif [[ $line =~ ^[0-9]+ ]]; then
            token="${.sh.match[0]}"
            rest="${line#$token}"
            
            # Lookahead check: If a number is immediately followed by an identifier character.
            if [[ $rest =~ ^[a-zA-Z_] ]]; then
                # Grab the bad suffix to print a great error message
                [[ $rest =~ ^[a-zA-Z_]+ ]]
                print -u2 "Lexer error: Invalid identifier or suffix near '$token${.sh.match[0]}'"
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
        # (We must escape special regex characters like +, -, *, / with backslashes)
        elif [[ $line =~ ^([\+\-\*\/\=\;\{\}\(\)]) ]]; then
            token="${.sh.match[0]}"
            tokens[$idx]="SYM:$token"
            ((idx++))
            line="${line#$token}"

        # Fallback Error Handler.
        else
            # Grab just the first character using regex dot.
            [[ $line =~ ^. ]]
            print -u2 "Lexer error: Unexpected character '${.sh.match[0]}'"
            exit 1
        fi

        # Strip trailing spaces between tokens.
        if [[ $line =~ ^[[:space:]]+ ]]; then
            line="${line#${.sh.match[0]}}"
        fi
    done
done < "$1"

i=0
while [[ $i -lt idx ]]; do
    print "${tokens[$i]}"
    ((i++))
done
