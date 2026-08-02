#!/usr/bin/env ksh93

# 1. THE DATA: What the lexer actually found in the source file
set -A TOKENS "int" "main" "(" ")" "{" "return" "2" ";" "}"
integer TOK_IDX=0

# Helper to verify that the DATA matches our RULES
expect() {
    typeset expected=$1
    if [[ ${TOKENS[TOK_IDX]} == "$expected" ]]; then
        (( TOK_IDX++ ))
    else
        print -u2 "Syntax Error: Expected '$expected' but found '${TOKENS[TOK_IDX]}'"
        exit 1
    fi
}

# 2. THE RULES (The Grammar)

# Grammar: exp -> <int>
parse_exp() {
    typeset val=${TOKENS[TOK_IDX]}
    
    if [[ $val == +([0-9]) ]]; then
        (( TOK_IDX++ ))
        
        # Build directly into the global AST tree using dot notation
        AST.body.exp.type="Constant"
        AST.body.exp.value=$val
    else
        print -u2 "Syntax Error: Expected integer, found '$val'"
        exit 1
    fi
}

# Grammar: statement -> "return" exp ";"
parse_statement() {
    expect "return"
    
    AST.body.type="Statement"
    AST.body.action="return"
    
    # Jump down into the expression rule
    parse_exp  
    
    expect ";"
}

# Grammar: program -> "int" "main" "(" ")" "{" statement "}"
parse_program() {
    expect "int"
    expect "main"
    expect "("
    expect ")"
    expect "{"
    
    AST.type="Program"
    
    # Jump down into the statement rule
    parse_statement 
    
    expect "}"
}

# 3. EXECUTION

# Explicitly declare AST as a compound variable
typeset -C AST

# Kick off the recursive descent
parse_program

# 4. TRAVERSAL (Reading the AST)
print "AST Built Successfully!"
print "The returned value is: ${AST.body.exp.value}"

