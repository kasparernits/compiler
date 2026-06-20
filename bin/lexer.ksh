#!/usr/local/bin/ksh93

if [[ -z $1 ]]; then
    print -u2 "Usage: $0 file.c"
    exit 1
fi

typeset -a tokens
idx=0

#tokens[0]="cats"
#echo ${tokens[0]}

while read -r line || [[ -n $line ]]; do

	while [[ $line == [[:space:]]* ]]; do
        line="${line#?}"
    done

    while [[ -n $line ]]; do
		echo $line
	done

	#while [[ $line == [[:space:]]* ]]; do
    #	line="${line#?}"
    #done
done < $1


# While input isnt empty
# If input starts with whitespace
	# Trim whitespace from start of input
# Else
	# Find longest match at start of input for any match in the known regex table
	# If no match is found, raise error
	# Convert match intto token
	# Remove match from start of input

