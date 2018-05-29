/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    PRINT = 258,
    PRINTLN = 259,
    IF = 260,
    ELSE = 261,
    FOR = 262,
    VAR = 263,
    NEWLINE = 264,
    ADD = 265,
    SUB = 266,
    MUL = 267,
    DIV = 268,
    MOD = 269,
    INC = 270,
    DEC = 271,
    GT = 272,
    LT = 273,
    GE = 274,
    LE = 275,
    EQUAL = 276,
    NOTEQ = 277,
    AS = 278,
    INCAS = 279,
    DECAS = 280,
    MULAS = 281,
    DIVAS = 282,
    MODAS = 283,
    AND = 284,
    OR = 285,
    NOT = 286,
    LB = 287,
    RB = 288,
    LGB = 289,
    RGB = 290,
    I_CONST = 291,
    F_CONST = 292,
    STRING = 293,
    ID = 294,
    INT = 295,
    FLOAT = 296,
    VOID = 297
  };
#endif
/* Tokens.  */
#define PRINT 258
#define PRINTLN 259
#define IF 260
#define ELSE 261
#define FOR 262
#define VAR 263
#define NEWLINE 264
#define ADD 265
#define SUB 266
#define MUL 267
#define DIV 268
#define MOD 269
#define INC 270
#define DEC 271
#define GT 272
#define LT 273
#define GE 274
#define LE 275
#define EQUAL 276
#define NOTEQ 277
#define AS 278
#define INCAS 279
#define DECAS 280
#define MULAS 281
#define DIVAS 282
#define MODAS 283
#define AND 284
#define OR 285
#define NOT 286
#define LB 287
#define RB 288
#define LGB 289
#define RGB 290
#define I_CONST 291
#define F_CONST 292
#define STRING 293
#define ID 294
#define INT 295
#define FLOAT 296
#define VOID 297

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 32 "compiler_hw2.y" /* yacc.c:1909  */

    int i_val;
    double f_val;
    char string[1000];

#line 144 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
