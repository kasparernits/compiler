#!/usr/local/bin/ksh93

if [[ -z $1 ]]; then
    print -u2 "Usage: $0 file.c"
    exit 1
fi

set -A tokens
t_idx=0

while read -r line || [[ -n $line ]]; do
    while [[ $line == [[:space:]]* ]]; do
        line="${line#?}"
    done

    while [[ -n $line ]]; do
        case "$line" in
            # Keywords - matched individually for pdksh compatibility
            int*|char*|return*|if*|else*|void*)
                token=${line%%[!a-z]*}
                tokens[$t_idx]="KEYWORD:$token"
                ((t_idx++))
                line="${line#$token}"
                ;;

            # Identifiers
            [a-zA-Z_]*)
                token=${line%%[!a-zA-Z0-9_]*}
                tokens[$t_idx]="ID:$token"
                ((t_idx++))
                line="${line#$token}"
                ;;

            # Numbers
            [0-9]*)
                token=${line%%[!0-9]*}
                # Check for invalid identifier trailing a number (e.g., 123alpha)
                # If the character following the digits is a valid identifier letter, it's a lex error
                rest="${line#$token}"
                if [[ $rest == [a-zA-Z_]* ]]; then
                    print -u2 "Lexer error: Invalid identifier or suffix near '$token${rest%%[!a-zA-Z_]*}'"
                    exit 1
                fi
                
                tokens[$t_idx]="NUM:$token"
                ((t_idx++))
                line="$rest"
                ;;

            # Operators (Check 2-chars first)
            "=="*|"!="*|"<="*|">="*)
                # Manually grab first two chars
                tmp=$line
                token="${tmp%${tmp#??}}"
                tokens[$t_idx]="OP:$token"
                ((t_idx++))
                line="${line#??}"
                ;;

            # Single-char Symbols
            [\+\-\*\/\=\;\{\}\(\)]*)
                # Manually grab first char
                tmp=$line
                token="${tmp%${tmp#?}}"
                tokens[$t_idx]="SYM:$token"
                ((t_idx++))
                line="${line#?}"
                ;;

            # Fallback for genuinely unknown characters
            *)
                char="${line%${line#?}}"
                print -u2 "Lexer error: Unexpected character '$char'"
                exit 1
                ;;
        esac

        # Trim leading whitespace for next pass
        while [[ $line == [[:space:]]* ]]; do
            line="${line#?}"
        done
    done
done < "$1"

# Print the tokens
i=0
while [[ $i -lt t_idx ]]; do
    print "${tokens[$i]}"
    ((i++))
done
