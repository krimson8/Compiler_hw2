/*	Definition section */
%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno;
extern int yylex();

/* Symbol table function - you can add new function if need. */
int lookup_symbol();
void create_symbol();
void insert_symbol();
void dump_symbol();

void yyerror (char *s);

int count = 0;
struct symbol{
    
    int int_val;
    double double_val;
    
    char id;
    int scope;
} table[1000];

%}

/* Using union to define nonterminal and token type */
%union {
    int i_val;
    double f_val;
    char* string;
}

/* Token without return */
%token PRINT PRINTLN 
%token IF ELSE FOR
%token VAR NEWLINE
%token INT FLOAT VOID
%token ADD SUB MUL DIV MOD INC DEC 
%token GT LT GE LE EQUAL NOTEQ
%token AS INCAS DECAS MULAS DIVAS MODAS
%token AND OR NOT
%token LB RB LGB RGB

/* Token with return, which need to sepcify type */
%token <i_val> I_CONST
%token <f_val> F_CONST
%token <string> STRING
%token <string> ID

/* Nonterminal with return, which need to sepcify type */
%type <f_val> stat
%type <i_val> initializer

/* Yacc will start at this nonterminal */
%start program

/* Grammar section */
%%

program
    : program stat
    |
;

stat
    : declaration       { create_symbol(); }
    | compound_stat     {}
    | expression_stat   {}
    | print_func        {}
;

declaration
    : VAR ID type AS initializer NEWLINE   {
        printf("sohai GG\n");
        table[count].int_val = $5;
        table[count].id = $2;
        count++;
    }
    | VAR ID type NEWLINE                   {}
;

compound_stat
    : compound_stat {}
;

expression_stat
    : expression_stat{}
;

print_func
    : print_func {}
;

initializer
    : I_CONST { $$ = (double)$1; }
    | F_CONST { $$ = $1; }
;

type
    : INT {} 
    | FLOAT {}
    | VOID {}
;

%%

/* C code section */
int main(int argc, char** argv)
{
    yylineno = 0;
    
    yyparse();
    
    if(count != 0) {
        int i = 0;
        for(i = 0; i < count; i++) {
            printf("%c: %d\n", table[i].id, table[i].int_val);
        }
    }
    return 0;
}

void create_symbol() {
    if(count == 0) {
        printf("Creating symbol table\n");
    }
}
void insert_symbol() {}
int lookup_symbol() {}
void dump_symbol() {}
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 