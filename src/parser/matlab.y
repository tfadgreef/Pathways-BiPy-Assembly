%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #include "fortran.h"
    #include "tree.h"
    #include "node.h"
    void yyerror(char *);

%}
%union{ struct NumSpec *num; struct Node *node; char *iden; }

%token CONSTANT IDENTIFIER STRING_LITERAL
%token ARRAYMUL ARRAYPOW ARRAYDIV ARRAYRDIV 
%token LE_OP GE_OP EQ_OP NE_OP

%token IF ELSE ELSEIF WHILE FOR BREAK RETURN END 
%token FUNCTION TRANSPOSE NCTRANSPOSE CR GLOBAL CLEAR

%type <node> iteration_statement statement statement_list assignment_statement expression_statement selection_statement

%type <node> expression additive_expression multiplicative_expression assignment_expression postfix_expression unary_expression or_expression and_expression equality_expression relational_expression array_expression primary_expression index_expression

%type <node> elseif_clause index_expression_list func_ident_list func_return_list function_declare_lhs function_declare

%type <num> CONSTANT
%type <iden> IDENTIFIER

%start translation_unit
%%
/* 
  known bugs:
  (1) Cannot distinguish 'function' from 'array' (need symbol table)
  (2) Multidimentional array accepted, i.e., a(:,:,:) (ver. 5.0 support :-)
  (3) Some commands, such as 'hold on', 'load m.txt' cannot be checked.
      (need symbol table to identify functions)
*/

primary_expression
        : IDENTIFIER
        { $$ = createVariable($1); }
        | CONSTANT
        { $$ = createConstant($1); }
        | STRING_LITERAL
        { $$ = NULL; fatalError("Strings not supported.\n"); }
        | '(' expression ')'
        { $$ = $2; }
        | '[' ']'
        { $$ = NULL; fatalError("Arrays not supported."); }
        | '[' array_list ']'
        { $$ = NULL; fatalError("Arrays not supported."); }
        ;

postfix_expression
        : primary_expression
        { $$ = $1; }
        | array_expression
        { $$ = $1; }
        | postfix_expression TRANSPOSE
        { $$ = NULL; fatalError("Transpose not supported."); }
        | postfix_expression NCTRANSPOSE
        { $$ = NULL; fatalError("Transpose not supported."); }
        ;

index_expression
        : ':'
        { $$ = createVariable(":"); $$->ignore = 1; }
        | expression
        { $$ = $1; }
        ;

index_expression_list
        : index_expression
        { $$ = $1; }
        | index_expression_list ',' index_expression
        ;

array_expression
        : IDENTIFIER '(' index_expression_list ')'
        { 
          $$ = createOperation(TARRAYINDEX);
          appendChild($$, $3);
          setIdentifier($$, $1);
        }
        ;

unary_expression
        : postfix_expression
        { $$ = $1; }
        | unary_operator postfix_expression
        { $$ = $2; }
        ;

unary_operator
        : '+'
        | '-'
        | '~'
        ;

multiplicative_expression
        : unary_expression
        { $$ = $1; }
        | multiplicative_expression '*' unary_expression
        { 
          $$ = createOperation(TMUL);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | multiplicative_expression '/' unary_expression
        { 
          $$ = createOperation(TDIV);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | multiplicative_expression '\\' unary_expression
        | multiplicative_expression '^' unary_expression
        | multiplicative_expression ARRAYMUL unary_expression
        { $$ = NULL; fatalError("Array multiplication not supported."); }
        | multiplicative_expression ARRAYDIV unary_expression
        { $$ = NULL; fatalError("Array division not supported."); }
        | multiplicative_expression ARRAYRDIV unary_expression
        { $$ = NULL; fatalError("Array division not supported."); }
        | multiplicative_expression ARRAYPOW unary_expression
        { $$ = NULL; fatalError("Array power not supported."); }
        ;

additive_expression
        : multiplicative_expression
        | additive_expression '+' multiplicative_expression
        { 
          $$ = createOperation(TPLUS);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | additive_expression '-' multiplicative_expression
        { 
          $$ = createOperation(TMINUS);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

relational_expression
        : additive_expression
        { $$ = $1; }
        | relational_expression '<' additive_expression
        { 
          $$ = createOperation(TLT_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | relational_expression '>' additive_expression
        { 
          $$ = createOperation(TGT_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | relational_expression LE_OP additive_expression
        { 
          $$ = createOperation(TLE_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | relational_expression GE_OP additive_expression
        { 
          $$ = createOperation(TGE_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

equality_expression
        : relational_expression
        { $$ = $1; }
        | equality_expression EQ_OP relational_expression
        { 
          $$ = createOperation(TEQ_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        | equality_expression NE_OP relational_expression
        { 
          $$ = createOperation(TNE_OP);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

and_expression
        : equality_expression
        { $$ = $1; }
        | and_expression '&' equality_expression
        { 
          $$ = createOperation(TAND);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

or_expression
        : and_expression
        { $$ = $1; }
        | or_expression '|' and_expression
        { 
          $$ = createOperation(TOR);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

expression
        : or_expression
        { $$ = $1; }
        | expression ':' or_expression
        { 
          $$ = createOperation(TRANGE);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

assignment_expression
        : postfix_expression '=' expression
        { 
          $$ = createOperation(TASSIGN);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;

eostmt
        :  ','
        |  ';' CR
        |  ';'
        |  CR
        ;

statement
        : global_statement
        { fprintf(warn, "Global Statement not supported.\n"); }
        | clear_statement
        { fprintf(warn, "Clear Statement not supported.\n"); }
        | assignment_statement
        { $$ = $1; }
        | expression_statement
        { $$ = $1; }
        | selection_statement
        { $$ = $1; }
        | iteration_statement
        { $$ = $1; }
        | jump_statement
        { fprintf(warn, "Jump Statement not supported.\n"); }
        ;

statement_list
        : statement
        { $$ = $1; }
        | statement_list statement
        { $$ = appendStatement($1, $2); }
        ;
	
identifier_list
        : IDENTIFIER
        | identifier_list IDENTIFIER
        ;

global_statement
        : GLOBAL identifier_list eostmt
        ;

clear_statement
        : CLEAR identifier_list eostmt
        { fprintf(warn, "Warning: Clear statement ignored.\n"); }
        ;

expression_statement
        : eostmt
        { $$ = NULL; }
        | expression eostmt
        { $$ = $1; }
        ;

assignment_statement
        : assignment_expression eostmt
        { $$ = $1; }
        ;

array_element
        : expression
        | expression_statement
        ;

array_list
        : array_element
        | array_list array_element
        ;
 
selection_statement
        : IF expression statement_list END eostmt
        { 
          $$ = createOperation(TIF);
          appendChild($$, $2);
          appendChild($$, $3);
        }
        | IF expression statement_list ELSE statement_list END eostmt
        { 
          $$ = createOperation(TIFELSE);
          appendChild($$, $2);
          appendChild($$, $3);
          appendChild($$, $5);
        }
        | IF expression statement_list elseif_clause END eostmt
        { 
          $$ = createOperation(TIFELSEIF);
          appendChild($$, $2);
          appendChild($$, $3);
          appendChild($$, $4);
        }
        | IF expression statement_list elseif_clause
          ELSE statement_list END eostmt
        { 
          $$ = createOperation(TIFELSEIFELSE);
          appendChild($$, $2);
          appendChild($$, $3);
          appendChild($$, $4);
          appendChild($$, $6);
        }
        ;

elseif_clause
        : ELSEIF expression statement_list
        { 
          $$ = createOperation(TELSEIF);
          appendChild($$, $2);
          appendChild($$, $3);
        }
        | elseif_clause ELSEIF expression statement_list
        {
          struct Node *n = createOperation(TELSEIF);
          appendChild($$, $3);
          appendChild($$, $4);
          $$ = appendStatement($1, n);
        }
        ;

iteration_statement
        : WHILE expression statement_list END eostmt
        { 
          $$ = createOperation(TWHILE);
          appendChild($$, $2);
          appendChild($$, $3);
        }
        | FOR IDENTIFIER '=' expression statement_list END eostmt
        {
          $$ = createOperation(TFOR);
          appendChild($$, $4);
          appendChild($$, $5);
          setIdentifier($$, $2);
        }
        | FOR '(' IDENTIFIER '=' expression ')' statement_list END eostmt 
        {
          $$ = createOperation(TFOR);
          appendChild($$, $5);
          appendChild($$, $7);
          setIdentifier($$, $3);
        }
        ;

jump_statement
        : BREAK eostmt
        | RETURN eostmt
        ;

translation_unit
        : statement_list
        { fatalError("The file should provide a function, not a script."); }
        | FUNCTION function_declare eostmt statement_list
        { functionToFortran($2, $4); /*fprintf(warn, "\n"); print_tree(0, $4); fprintf(warn, "\n");*/ }
        ;

func_ident_list
        : IDENTIFIER
        { 
          $$ = createOperation(TLIST);
          appendChild($$, createVariable($1));
        }
        | func_ident_list ',' IDENTIFIER
        {
          $$ = $1;
          appendChild($1, createVariable($3));
        }
        ;

func_return_list
        : IDENTIFIER
        {
          $$ = createOperation(TLIST);
          appendChild($$, createVariable($1));
        }
        | '[' func_ident_list ']'
        { $$ = $2; }
        ;

function_declare_lhs
        : IDENTIFIER
        { fatalError("Incorrect number of input arguments."); }
        | IDENTIFIER '(' ')'
        { fatalError("Incorrect number of input arguments."); }
        | IDENTIFIER '(' func_ident_list ')'
        { $$ = $3; }
        ;

function_declare
        : function_declare_lhs
        | func_return_list '=' function_declare_lhs
        {
          $$ = createOperation(TFUNCDEC);
          appendChild($$, $1);
          appendChild($$, $3);
        }
        ;
      
%%

int yydebug=1;

extern char yytext[];
extern int column;

//void yyerror(char *s)
//{
//    fprintf(stderr,"ERROR: %s\n",s);
//    return;
//}

void yyerror(char *s)
{
  fflush(stderr);
  fprintf(stderr, "\n%*s\n%*s\n", column, "^", column, s);
}

int main(void) {
  warn = stderr;
  out = stdout;
  labelcount = 10;
  func = emalloc(sizeof(*func));
  func->neq = "neq";
  func->np = "np";
  vars = NULL;
  yyparse();
  return 0;
}
