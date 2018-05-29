/*	Definition section */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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
    char type[100];
    int int_val;
    double double_val;
    
    char id[2];
    int scope;
} table[1000];

int current_scope = 1;

%}

/* Using union to define nonterminal and token type */
%union {
    int i_val;
    double f_val;
    char string[1000];
}

/* Token without return */
%token PRINT PRINTLN 
%token IF ELSE FOR
%token VAR NEWLINE
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
%token <string> INT
%token <string> FLOAT
%token <string> VOID

/* Nonterminal with return, which need to sepcify type */
%type <f_val> stat
%type <f_val> initializer
%type <string> type

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
        insert_symbol($2, $3);
        if(strcmp($3, "int") == 0) 
            table[count].int_val = $5;
        else if(strcmp($3, "float32") == 0) 
            table[count].double_val = $5;
        count++;
    }
    | VAR ID type NEWLINE                   {
        insert_symbol($2, $3);
        if(strcmp($3, "int") == 0) 
            table[count].int_val = 0;
        else if(strcmp($3, "float32") == 0) 
            table[count].double_val = 0.0;
        count++;
    }
;

compound_stat
    : compound_stat {}
;

expression_stat
    : arithmetic    {}
    | boolean       {}
;

arithmetic
    : print_func    {}
;

boolean
    : ID true 

print_func
    : print_func {}
;

initializer
    : I_CONST { $$ = $1; }
    | F_CONST { $$ = $1; }
;

type
    : INT 
    | FLOAT 
    | VOID 
;

%%

/* C code section */
int main(int argc, char** argv)
{
    yylineno = 0;
    
    yyparse();
    
    printf("Total lines: %d\n", yylineno);
    printf("The symbol table:\nID\ttype\tData\n");
    if(count != 0) {
        int i = 0;
        for(i = 0; i < count; i++) {
            if(strcmp(table[i].type, "int") == 0)
                printf("%s\t%s\t%d\n", table[i].id, table[i].type, table[i].int_val);
            else if(strcmp(table[i].type, "float32") == 0)
                printf("%s\t%s\t%lf\n", table[i].id, table[i].type, table[i].double_val);
        }
    }
    return 0;
}

void create_symbol() {
    if(count == 0) {
        printf("Creating symbol table\n");
    }
}

void insert_symbol(char id[1000], char type[1000]) {
    if(lookup_symbol(id)) {
        printf("Insert symbol %s\n", id);
        strcpy(table[count].id, id);
        strcpy(table[count].type, type);
        table[count].scope = current_scope;
    }
    else {
        printf("<ERROR> re-declaration for variable %s(line %d)\n", id, yylineno);
    }
}

int lookup_symbol(char id[1000]) {
    int i;
    for(i = 0; i < count; i++) {
        if(strcmp(table[i].id, id) == 0 && table[i].scope == current_scope)
            return 0;
    }
    return 1;
}

void dump_symbol() {}
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 