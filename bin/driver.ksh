#!/usr/local/bin/ksh93

COM_HOME=$HOME/compiler
COM_BIN=$COM_HOME/bin
COM_SRC=$COM_HOME/src

lexer=$COM_BIN/lexer.ksh

if [[ -z $1 ]]; then
	print -u2 "Usage $0: file.c"
	exit 1
fi

only_lex=0

# Check what arguments were passed

if [[ $# -gt 1 ]]; then
	opt=$2
	case $opt in 
		--lex)
			only_lex=1
			;;
		*)
			print "some unknown option"
			;;
	esac
fi

FILE="$(basename $1 .c)"

# Preprocess using clang

# -E run the preprocessor stage only
# -P don't emit linemarkers
cc -E -P $1 -o $COM_SRC/$FILE.i

# Lex

$lexer $COM_SRC/$FILE.i

if [[ $? -ne 0 ]]; then
	rm $COM_SRC/$FILE.i
	exit 1
else
	rm $COM_SRC/$FILE.i
	exit 0
fi

# Compile
#mv $FILE.i > $FILE.s

# Assemble
#cc $FILE.s -o $FILE

