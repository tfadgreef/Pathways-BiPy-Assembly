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

%type <node> additive_expression
%type <node> multiplicative_expression
%type <node> assignment_expression
%type <node> postfix_expression
%type <node> iteration_statement
%type <node> statement
%type <node> statement_list
%type <node> assignment_statement
%type <node> expression_statement
%type <node> selection_statement

%type <node> expression
%type <node> unary_expression
%type <node> or_expression
%type <node> and_expression
%type <node> equality_expression
%type <node> relational_expression
%type <node> array_expression
%type <node> primary_expression
%type <node> elseif_clause
%type <node> index_expression
%type <node> index_expression_list
%type <node> func_ident_list
%type <node> func_return_list
%type <node> function_declare_lhs
%type <node> function_declare
%type <num> CONSTANT
%type <iden> IDENTIFIER

%verbose

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
        { $$ = addVariable($1); }
        | CONSTANT
        { $$ = addConstant($1); }
        | STRING_LITERAL
        { fprintf(warn, "String Literal\n"); }
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
        { $$ = addVariable(":"); $$->ignore = 1; }
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
        { $$ = addOperationWithIdentifier(TARRAYINDEX, $3, NULL, $1); }
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
        { $$ = addOperation(TMUL, $1, $3); }
        | multiplicative_expression '/' unary_expression
        { $$ = addOperation(TDIV, $1, $3); }
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
        { $$ = addOperation(TPLUS, $1, $3); }
        | additive_expression '-' multiplicative_expression
        { $$ = addOperation(TMINUS, $1, $3); }
        ;

relational_expression
        : additive_expression
        { $$ = $1; }
        | relational_expression '<' additive_expression
        { $$ = addOperation(TLT_OP, $1, $3); }
        | relational_expression '>' additive_expression
        { $$ = addOperation(TGT_OP, $1, $3); }
        | relational_expression LE_OP additive_expression
        { $$ = addOperation(TLE_OP, $1, $3); }
        | relational_expression GE_OP additive_expression
        { $$ = addOperation(TGE_OP, $1, $3); }
        ;

equality_expression
        : relational_expression
        { $$ = $1; }
        | equality_expression EQ_OP relational_expression
        { $$ = addOperation(TEQ_OP, $1, $3); }
        | equality_expression NE_OP relational_expression
        { $$ = addOperation(TNE_OP, $1, $3); }
        ;

and_expression
        : equality_expression
        { $$ = $1; }
        | and_expression '&' equality_expression
        { $$ = addOperation(TAND, $1, $3); }
        ;

or_expression
        : and_expression
        { $$ = $1; }
        | or_expression '|' and_expression
        { $$ = addOperation(TOR, $1, $3); }
        ;

expression
        : or_expression
        { $$ = $1; }
        | expression ':' or_expression
        { $$ = addOperation(TRANGE, $1, $3); }
        ;

assignment_expression
        : postfix_expression '=' expression
        { $$ = addOperation(TASSIGN, $1, $3); }
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
        { $$ = addStatement($1, $2); }
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
        { $$ = NULL; /*$$ = addStub();*/ }
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
        { $$ = addOperation(TIF, $2, $3); }
        | IF expression statement_list ELSE statement_list END eostmt
        { $$ = addOperation3(TIFELSE, $2, $3, $5); }
        | IF expression statement_list elseif_clause END eostmt
        { $$ = addOperation3(TIFELSEIF, $2, $3, $4); }
        | IF expression statement_list elseif_clause
          ELSE statement_list END eostmt
        { $$ = addOperation4(TIFELSEIFELSE, $2, $3, $4, $6); }
        ;

elseif_clause
        : ELSEIF expression statement_list
        { $$ = addOperation(TELSEIF, $2, $3); }
        | elseif_clause ELSEIF expression statement_list
        { $$ = addStatement($1, addOperation(TELSEIF, $3, $4)); }
        ;

iteration_statement
        : WHILE expression statement_list END eostmt
        { $$ = addOperation(TWHILE, $2, $3); }
        | FOR IDENTIFIER '=' expression statement_list END eostmt
        { $$ = addOperationWithIdentifier(TFOR, $4, $5, $2); }
        | FOR '(' IDENTIFIER '=' expression ')' statement_list END eostmt 
        { $$ = addOperationWithIdentifier(TFOR, $5, $7, $3); }
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
        { $$ = addOperation(TLIST, addVariable($1), NULL); }
        | func_ident_list ',' IDENTIFIER
        { $$ = $1; addStatement($1->children, addVariable($3)); }
        ;

func_return_list
        : IDENTIFIER
        { $$ = addOperation(TLIST, addVariable($1), NULL); }
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
        { $$ = addOperation(TFUNCDEC, $1, $3); }
        ;
      
%%

int yydebug=1;

//extern char yytext[];
//extern int column;

void yyerror(char *s)
{
    fprintf(stderr,"ERROR: %s\n",s);
    return;
}

//yyerror(s)
//char *s;
//{
//        fflush(stdout);
//        printf("\n%*s\n%*s\n", column, "^", column, s);
//}
int main(void) {
    warn = stderr;
    out = stdout;
    labelcount = 10;
    func = emalloc(sizeof(*func));
    vars = NULL;
    yyparse();
    return 0;
}
