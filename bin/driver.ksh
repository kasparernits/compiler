#!/usr/local/bin/ksh93

COM_HOME=$HOME/compiler
COM_BIN=$COM_HOME/bin
lexer=$COM_BIN/lexer.ksh

only_lex=0
target_file=""

# Parse options dynamically
while [[ $# -gt 0 ]]; do
    case "$1" in
        --lex|--stage)
            if [[ "$1" == "--stage" ]]; then
                shift # Skip the argument after --stage if it's "lex"
            fi
            only_lex=1
            shift
            ;;
        --chapter)
            shift 2 # Skip --chapter and its number
            ;;
        -*)
            # Ignore or handle other runner flags safely
            shift
            ;;
        *)
            target_file="$1"
            shift
            ;;
    esac
done

if [[ -z "$target_file" ]]; then
    print -u2 "Usage: $0 [--lex] file.c"
    exit 1
fi

# Get the base filename safely
filename=$(basename "$target_file")
base_name="${filename%.c}"
i_file="${base_name}.i"

# 1. Preprocess using clang (cc)
cc -E -P "$target_file" -o "$i_file"
if [[ $? -ne 0 ]]; then
    rm -f "$i_file"
    exit 1
fi

# 2. Lex stage
$lexer "$i_file"
lex_status=$?

# Cleanup preprocessed file
rm -f "$i_file"

if [[ $lex_status -ne 0 ]]; then
    exit 1
fi

# If test framework only requested lexing, stop here
if [[ $only_lex -eq 1 ]]; then
    exit 0
fi

# (Future parser/compiler stages go here...)

