#!/usr/local/bin/ksh93
#
# txt2md - Fast, native ksh93 plain text to Markdown converter
# Target: OpenBSD with ksh93 installed via packages

set -o errexit
set -o nounset

# Prerequisite check
if (( $# < 1 )); then
    print -u2 "Usage: ${0##*/} input.txt [output.md]"
    exit 1
fi

input_file="$1"
# If no output file is provided, change extension from .txt to .md
output_file="${2:-${input_file%.txt}.md}"

if [[ ! -f "$input_file" ]]; then
    print -u2 "Error: File '$input_file' not found."
    exit 1
fi

# Extended Regular Expressions (ERE) for pattern matching
date_regex='^[[:alpha:]]+ [[:digit:]]{1,2}, [[:digit:]]{4}$'
command_regex='^(man [0-9] [[:alpha:]]+|:[%]*s\/.*\/.*\/g)$'
shortcut_regex='^[\[\]\|\{\}\~\\][[:space:]]+.*$'

# File descriptor allocations
exec 3< "$input_file"
exec 4> "$output_file"

in_code_block=false
first_date=true

while IFS= read -r line <&3; do
    # Strip carriage returns if file has DOS line endings
    line="${line%$'\r'}"

    # Native ksh93 whitespace stripping (avoids external sed fork)
    trimmed="${line##*([[:space:]])}"
    trimmed="${trimmed%%*([[:space:]])}"

    # Handle empty lines
    if [[ -z "$trimmed" ]]; then
        if [[ "$in_code_block" == "true" ]]; then
            print -u4 "\`\`\`"
            in_code_block=false
        fi
        print -u4 ""
        continue
    fi

    # 1. Detect Dates -> Turn into Section Headers
    if [[ "$trimmed" =~ $date_regex ]]; then
        if [[ "$first_date" == "true" ]]; then
            first_date=false
            print -u4 "## $trimmed\n---"
        else
            print -u4 "\n---\n\n## $trimmed\n---"
        fi

    # 2. Detect Commands/Vi modes -> Turn into Code Blocks
    elif [[ "$trimmed" =~ $command_regex ]]; then
        if [[ "$in_code_block" == "false" ]]; then
            print -u4 "\`\`\`sh"
            in_code_block=true
        fi
        print -u4 "$line"

    # 3. Detect Magic Keyboard Layout Shortcuts -> Turn into Quoted Lists
    elif [[ "$trimmed" =~ $shortcut_regex ]]; then
        char="${trimmed:0:1}"
        desc="${trimmed:1}"
        desc="${desc##*([[:space:]])}" # Trim inner spaces
        print -u4 "* \`$char\` : $desc"

    # 4. Standard text formatting
    else
        if [[ "$in_code_block" == "true" ]]; then
            print -u4 "\`\`\`"
            in_code_block=false
        fi
        print -u4 "$line"
    fi
done

# Close remaining open code block if file ends abruptly
if [[ "$in_code_block" == "true" ]]; then
    print -u4 "\`\`\`"
fi

# Close file descriptors cleanly
exec 3<&-
exec 4>&-

print "Successfully converted '$input_file' -> '$output_file'"
