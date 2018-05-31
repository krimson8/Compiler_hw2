/*	Definition section */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylineno;
extern int yylex();

/* Symbol table function - you can add new function if need. */
int lookup_symbol(char id[1000], int mode);
void create_symbol();
int insert_symbol(char id[1000], char type[1000]);
void dump_symbol();
void assign(char id[1000], int mode, double value, int is_declare);
void yyerror (char *s);

int count = 0;
int float_flag = 0;
struct symbol{
    char type[100];
    int int_val;
    double double_val;
    
    char id[2];
    int scope;
} table[1000];

int current_scope = 0;

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
%token GT LT GE LE EQUAL NOTEQ
%token AS INCAS DECAS MULAS DIVAS MODAS
%token AND OR NOT
%token LB RB LGB RGB

/* Token with precedence */
%left ADD SUB 
%left MUL DIV MOD 
%left INC DEC 

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
%type <f_val> expression_stat
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
    | block             {}
    | compound_stat     {}
    | expression_stat   {}
    | print_func        {}
    | relation          {}
    | NEWLINE           { float_flag = 0; }
    | if_stat           {}
    | for_stat          {}
;

block
    : left_b program RGB    { 
        dump_symbol();
        current_scope--;
    }
;

left_b
    : LGB   { current_scope++; }
;

for_stat
    : FOR boolean block  {
        printf("FOR\n");
    }
;

if_stat
    : IF boolean block  {
        // printf("IF\n");
    }
    | IF boolean block ELSE if_stat {
        // printf("IF ELSE_IF\n");
    }
    | IF boolean block ELSE block  {
        // printf("IF ELSE\n");
    }
;

boolean 
    : LB relation RB    {} 
;

declaration
    : VAR ID type AS expression_stat    {
        if(insert_symbol($2, $3)) {
            count++;
            assign($2, 1, $5, 1);
        }
        printf("declare %s in block of depth %d\n", $2, current_scope);
    }
    | VAR ID type                   {
        if(insert_symbol($2, $3)) {
            count++;
            assign($2, 1, 0, 1);
        }
        printf("declare %s in block of depth %d\n", $2, current_scope);
    }
;

compound_stat
    : ID AS expression_stat     { 
        printf("ASSIGN\n");
        assign($1, 1, $3, 2); 
    }
    | ID INCAS expression_stat  { 
        printf("INCREMENT ASSIGN\n");
        assign($1, 2, $3, 2); 
    }
    | ID DECAS expression_stat  { 
        printf("DECREMENT ASSIGN\n");
        assign($1, 3, $3, 2); 
    }
    | ID MULAS expression_stat  { 
        printf("MULTIPLY ASSIGN\n");
        assign($1, 4, $3, 2); 
    }
    | ID DIVAS expression_stat  { 
        printf("DIVIDE ASSIGN\n");
        assign($1, 5, $3, 2); 
    }
    | ID MODAS expression_stat  { 
        printf("MODULO ASSIGN\n");
        assign($1, 6, $3, 2); 
    }
;

expression_stat
    : LB expression_stat RB             {$$ = $2;}
    | initializer
    | ID INC    { 
        assign($1, 7, 0, 2);
        printf("INC\n"); 
    }
    | ID DEC    { 
        assign($1, 8, 0, 2); 
        printf("DEC\n"); 
    }
    | expression_stat MUL expression_stat   { 
        $$ = $1 * $3; 
        printf("MUL\n"); 
        // printf("%lf\n", $$);
    }
    | expression_stat DIV expression_stat   { 
        if($3 == 0) {
            printf("<ERROR> Divide by zero (line %d)\n", yylineno);
        } else 
            $$ = $1 / $3; 
        printf("DIV\n");
        // printf("%lf\n", $$);
    }
    | expression_stat MOD expression_stat   { 
        int x = $1;
        int y = $3;
        if(x == $1 || y == $3){
            $$ = x % y; 

            // printf("%lf\n", $$);
        }
        printf("MOD\n"); 
    }
    | expression_stat ADD expression_stat   { 
        $$ = $1 + $3; 
        printf("ADD\n"); 
        // printf("%lf\n", $$);
    }
    | expression_stat SUB expression_stat   {
        $$ = $1 - $3; 
        printf("SUB\n"); 
        // printf("%lf\n", $$);
    }
;

relation
    : expression_stat GT expression_stat {
        if($1 > $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat LT expression_stat {
        if($1 < $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat GE expression_stat {
        if($1 >= $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat LE expression_stat {
        if($1 <= $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat EQUAL expression_stat {
        if($1 == $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat NOTEQ expression_stat {
        if($1 != $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat AND expression_stat {
        if($1 && $3) printf("true\n");
        else printf("false\n");
    }
    | expression_stat OR expression_stat {
        if($1 || $3) printf("true\n");
        else printf("false\n");
    }
;

print_func
    : PRINT LB expression_stat RB {
        if(float_flag == 0) {
            printf("%d", (int)$3);
        }
        else {
            printf("%lf", $3);
        }
    }
    | PRINTLN LB expression_stat RB {
        if(float_flag == 0) {
            printf("%d\n", (int)$3);
        }
        else {
            printf("%lf\n", $3);
        }
    }
    | PRINT LB STRING RB {
        printf("%s", $3);
    }
    | PRINTLN LB STRING RB {
        printf("%s\n", $3);
    }
;

initializer
    : I_CONST { $$ = $1; }
    | F_CONST { $$ = $1; float_flag = 1; printf("sohai\n"); }
    | ID      {
        int n = lookup_symbol($1, 2);
        if(n != -1){
            if(strcmp(table[n].type, "int") == 0){
                $$ = table[n].int_val;
            }
            else if(strcmp(table[n].type, "float32") == 0){
                float_flag = 1;
                $$ = table[n].double_val;
            }
            printf("variable %s is in block of depth %d\n", table[n].id, table[n].scope);
        }
        else if(n == -1) {
            printf("<ERROR>Undefined variable %s\n", $1);
        }
    }
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
    
    printf("\nTotal lines: %d\n\n", yylineno);
    printf("The symbol table:\n\nID\ttype\tData\n");
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

void assign(char id[1000], int mode, double value, int is_declare) {
    int n = lookup_symbol(id, 2);
    if(n != -1){
        if(is_declare != 1) printf("variable %s is in block of depth %d\n", table[n].id, table[n].scope);
        if(strcmp(table[n].type, "int") == 0){
            if(mode == 1) table[n].int_val = value;
            else if(mode == 2) table[n].int_val += value;
            else if(mode == 3) table[n].int_val -= value;
            else if(mode == 4) table[n].int_val *= value;
            else if(mode == 5) table[n].int_val /= value;
            else if(mode == 6) {
                int x = value;
                if(x == value)
                    table[n].int_val = value;
            }
            else if(mode == 7) table[n].int_val++;
            else if(mode == 8) table[n].int_val--;
            // printf("%s = %d\n", table[n].id, table[n].int_val);
        }
        else if(strcmp(table[n].type, "float32") == 0){
            if(mode == 1) table[n].double_val = value;
            else if(mode == 2) table[n].double_val += value;
            else if(mode == 3) table[n].double_val -= value;
            else if(mode == 4) table[n].double_val *= value;
            else if(mode == 5) table[n].double_val /= value;
            else if(mode == 7) table[n].double_val ++;
            else if(mode == 8) table[n].double_val --;
            // else if(mode == 6) table[n].double_val = value;
            // printf("%s = %lf\n", table[n].id, table[n].double_val);
        }
    }
    else if(n == -1) {
        printf("<ERROR>Undefined variable %s (line %d)\n", id, yylineno);
    }
}

void create_symbol() {
    if(count == 0) {
        printf("Creating symbol table\n");
    }
}

int insert_symbol(char id[1000], char type[1000]) {
    if(lookup_symbol(id, 1)) {
        printf("Insert symbol %s\n", id);
        strcpy(table[count].id, id);
        strcpy(table[count].type, type);
        table[count].scope = current_scope;
        return 1;
    }
    else {
        printf("<ERROR> re-declaration for variable %s(line %d)\n", id, yylineno);
        return 0;
    }
}

int lookup_symbol(char id[1000], int mode) {
    int i;
    if(mode == 1) {
        for(i = 0; i < count; i++) {
            if(strcmp(table[i].id, id) == 0 && table[i].scope == current_scope)
                return 0;
        }
        return 1;
    }
    else if(mode == 2){
        int position = -1; // return value, in case multiple same variable name
        for(i = 0; i < count; i++) {
            if(strcmp(table[i].id, id) == 0)
                position = i;
            else if(strcmp(table[i].id, id) == 0 && table[i].scope == current_scope) {
                position = i;
                break;
            }
                
        }
        return position;
    }
}

void dump_symbol() {
    int temp = 0;
    printf("\nSymbol table dump\n");
    printf("ID\ttype\tData\n");
    if(count != 0) {
        int i = 0;
        for(i = 0; i < count; i++) {
            if(table[i].scope == current_scope) {
                if(strcmp(table[i].type, "int") == 0)
                    printf("%s\t%s\t%d\n", table[i].id, table[i].type, table[i].int_val);
                else if(strcmp(table[i].type, "float32") == 0)
                    printf("%s\t%s\t%lf\n", table[i].id, table[i].type, table[i].double_val);
                strcpy(table[i].type, "");
                strcpy(table[i].id, "");
                table[i].int_val = 0;
                table[i].double_val = 0.0;
                temp++;
            }
        }
        
        if(temp == 0) 
            printf("No symbol to be dumped\n\n");
        else
            printf("\n");
        count -= temp;
    }
}
void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 