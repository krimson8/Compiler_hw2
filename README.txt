# Compiler_hw2

The advanced feature implemented as required:

--1: if...else if... else

The grammar to build the tree for 'if else' statement can
be found in the compiler_hw2.y file as shown below:

****
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
****

Using this grammar, one can write 'if else' stament with 0 or more
occurence of the 'else' block. Further evaluation of the 
non-terminal 'boolean' and 'block' can also be found in the file.

---------------------------------------------------------------
--2: scoping

If a '{' and '}' was scanned in a pair, which means that a new
scoping block were created, there is a global variable 
'current_scope' in my code to note down the current depth 
of the scope, and this variable will be manipulated using 
grammar as follow (LGB = '{', RGB = '}')  :

****
block
    : left_b program RGB    { 
        dump_symbol();
        current_scope--; // depth -1 when '}' encountered
    }
;

left_b
    : LGB   { current_scope++; } // add depth when '{' encountered
;
****

If a variable was created, its scope will be referred to the 
'current_scope'.

If a variable was used or referred in the test code, the scope of the variable will be shown.

The dump_symbol() is called whenever '}' was encountered indicating that the variable declared in that scope shall be deleted/dumped
from the symbol table.

In the end of every test case, only variable with depth '0' will
exist in the symbol table, and printed out.