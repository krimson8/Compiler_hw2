/* Definition section */
%{
#include "y.tab.h"	/* header file generated by bison */
extern YYSTYPE yylval; //YYSTYPE
%}

/* Define regular expression label */
newline		[\n]
digit		[0-9]
letter		[a-zA-Z]
integer     {digit}+
double      {digit}+"."{digit}+
id			{letter}+({letter}|{digit})*

%option yylineno

%x COMMENT STRING_STATE

/* Rules section */
%%

 /* Arithmetic */
"+"     { return ADD; }
"-" 	{ return SUB; }
"*" 	{ return MUL; }
"/" 	{ return DIV; }
"%"     { return MOD; }
"++"    { return INC; }
"--"    { return DEC; }

 /* Relational */
">"		{ return GT; }
"<"		{ return LT; }
">="	{ return GE; }
"<="	{ return LE; }
"=="	{ return EQUAL; }
"!="	{ return NOTEQ; }

 /* Assignment */
"="		{ return AS; }
"+="	{ return INCAS; }
"-="	{ return DECAS; }
"*="	{ return MULAS; }
"/="	{ return DIVAS; }
"%="	{ return MODAS; }

 /* Logical */
"&&"	{ return AND; }
"||"	{ return OR; }
"!"		{ return NOT; }

 /* Delimiters */
"("		{ return LB; }
")"		{ return RB; }
"{"		{ return LGB; }
"}"		{ return RGB; }

 /* Print Keywords */	
"print"		{ return PRINT; }
"println"	{ return PRINTLN; }

 /* Condition and Loop Keywords */
"if"		{ return IF; }
"else"		{ return ELSE; }
"for"		{ return FOR; }

 /* Declaration Keywords */
"var"		{ strcpy(yylval.string, yytext); return VAR; }
"void"		{ strcpy(yylval.string, yytext); return VOID; }
"int"		{ strcpy(yylval.string, yytext); return INT; }
"float32"	{ strcpy(yylval.string, yytext); return FLOAT; }

 /* String Constant */
\"				        { BEGIN STRING_STATE;}
<STRING_STATE>\"		{ BEGIN INITIAL;}
<STRING_STATE>[^"]*		{ strcpy(yylval.string, yytext); return STRING; }

 /* Number Constant */
{integer}	{ yylval.i_val = atoi(yytext); return I_CONST; }
{double}	{ yylval.f_val = atof(yytext); return F_CONST; }

 /* C type Comment */
"/*"				{ BEGIN COMMENT; }
<COMMENT>[^*\n]+	{ }
<COMMENT>\n			{ }
<COMMENT>"*"		{ }
<COMMENT>"*/"		{ BEGIN INITIAL; }

 /* C++ type Comment */
\/\/.*	{ }

 /* Variable ID */
 {id}       { strcpy(yylval.string, yytext); return ID; }

 /* others */

[\n]		{ return NEWLINE; }
[ \t]		{ } /* Ignore */
[^; \t] 	{ } /* Ignore other charactor sets */
<<EOF>>     { return 0; }

%%

int yywrap()
{
    return 1;
}