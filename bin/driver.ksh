#!/usr/local/bin/ksh93

if [[ -z $1 ]]; then
	print -u2 "Usage $0: file.c"
	exit 1
fi

echo "Running C compiler"

NAME="$(basename $1 .c)"

# Preprocess

cc -E -P $1 -o $NAME.i

# Compile

#cat $NAME.i > $NAME.s
rm $NAME.i

# Assemble

#cc $NAME.s -o $NAME

