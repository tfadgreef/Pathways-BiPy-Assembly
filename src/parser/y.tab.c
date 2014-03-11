/* A Bison parser, made by GNU Bison 2.7.12-4996.  */

/* Bison implementation for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.
   
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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.7.12-4996"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
/* Line 371 of yacc.c  */
#line 1 "matlab.y"

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #include "fortran.h"
    #include "tree.h"
    #include "node.h"
    void yyerror(char *);


/* Line 371 of yacc.c  */
#line 80 "y.tab.c"

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     CONSTANT = 258,
     IDENTIFIER = 259,
     STRING_LITERAL = 260,
     ARRAYMUL = 261,
     ARRAYPOW = 262,
     ARRAYDIV = 263,
     ARRAYRDIV = 264,
     LE_OP = 265,
     GE_OP = 266,
     EQ_OP = 267,
     NE_OP = 268,
     IF = 269,
     ELSE = 270,
     ELSEIF = 271,
     WHILE = 272,
     FOR = 273,
     BREAK = 274,
     RETURN = 275,
     END = 276,
     FUNCTION = 277,
     TRANSPOSE = 278,
     NCTRANSPOSE = 279,
     CR = 280,
     GLOBAL = 281,
     CLEAR = 282
   };
#endif
/* Tokens.  */
#define CONSTANT 258
#define IDENTIFIER 259
#define STRING_LITERAL 260
#define ARRAYMUL 261
#define ARRAYPOW 262
#define ARRAYDIV 263
#define ARRAYRDIV 264
#define LE_OP 265
#define GE_OP 266
#define EQ_OP 267
#define NE_OP 268
#define IF 269
#define ELSE 270
#define ELSEIF 271
#define WHILE 272
#define FOR 273
#define BREAK 274
#define RETURN 275
#define END 276
#define FUNCTION 277
#define TRANSPOSE 278
#define NCTRANSPOSE 279
#define CR 280
#define GLOBAL 281
#define CLEAR 282



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 387 of yacc.c  */
#line 12 "matlab.y"
 struct NumSpec *num; struct Node *node; char *iden; 

/* Line 387 of yacc.c  */
#line 180 "y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

/* Line 390 of yacc.c  */
#line 208 "y.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if (! defined __GNUC__ || __GNUC__ < 2 \
      || (__GNUC__ == 2 && __GNUC_MINOR__ < 5))
#  define __attribute__(Spec) /* empty */
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif


/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(N) (N)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (YYID (0))
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  93
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   533

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  47
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  35
/* YYNRULES -- Number of rules.  */
#define YYNRULES  94
/* YYNRULES -- Number of states.  */
#define YYNSTATES  176

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   282

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    43,     2,
      28,    29,    37,    34,    33,    35,     2,    38,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    32,    46,
      41,    45,    42,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    30,    39,    31,    40,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    44,     2,    36,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     7,     9,    13,    16,    20,    22,
      24,    27,    30,    32,    34,    36,    40,    45,    47,    50,
      52,    54,    56,    58,    62,    66,    70,    74,    78,    82,
      86,    90,    92,    96,   100,   102,   106,   110,   114,   118,
     120,   124,   128,   130,   134,   136,   140,   142,   146,   150,
     152,   155,   157,   159,   161,   163,   165,   167,   169,   171,
     173,   175,   178,   180,   183,   187,   191,   193,   196,   199,
     201,   203,   205,   208,   214,   222,   229,   238,   242,   247,
     253,   261,   271,   274,   277,   279,   284,   286,   290,   292,
     296,   298,   302,   307,   309
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      77,     0,    -1,     4,    -1,     3,    -1,     5,    -1,    28,
      61,    29,    -1,    30,    31,    -1,    30,    72,    31,    -1,
      48,    -1,    52,    -1,    49,    23,    -1,    49,    24,    -1,
      32,    -1,    61,    -1,    50,    -1,    51,    33,    50,    -1,
       4,    28,    51,    29,    -1,    49,    -1,    54,    49,    -1,
      34,    -1,    35,    -1,    36,    -1,    53,    -1,    55,    37,
      53,    -1,    55,    38,    53,    -1,    55,    39,    53,    -1,
      55,    40,    53,    -1,    55,     6,    53,    -1,    55,     8,
      53,    -1,    55,     9,    53,    -1,    55,     7,    53,    -1,
      55,    -1,    56,    34,    55,    -1,    56,    35,    55,    -1,
      56,    -1,    57,    41,    56,    -1,    57,    42,    56,    -1,
      57,    10,    56,    -1,    57,    11,    56,    -1,    57,    -1,
      58,    12,    57,    -1,    58,    13,    57,    -1,    58,    -1,
      59,    43,    58,    -1,    59,    -1,    60,    44,    59,    -1,
      60,    -1,    61,    32,    60,    -1,    49,    45,    61,    -1,
      33,    -1,    46,    25,    -1,    46,    -1,    25,    -1,    67,
      -1,    68,    -1,    70,    -1,    69,    -1,    73,    -1,    75,
      -1,    76,    -1,    64,    -1,    65,    64,    -1,     4,    -1,
      66,     4,    -1,    26,    66,    63,    -1,    27,    66,    63,
      -1,    63,    -1,    61,    63,    -1,    62,    63,    -1,    61,
      -1,    69,    -1,    71,    -1,    72,    71,    -1,    14,    61,
      65,    21,    63,    -1,    14,    61,    65,    15,    65,    21,
      63,    -1,    14,    61,    65,    74,    21,    63,    -1,    14,
      61,    65,    74,    15,    65,    21,    63,    -1,    16,    61,
      65,    -1,    74,    16,    61,    65,    -1,    17,    61,    65,
      21,    63,    -1,    18,     4,    45,    61,    65,    21,    63,
      -1,    18,    28,     4,    45,    61,    29,    65,    21,    63,
      -1,    19,    63,    -1,    20,    63,    -1,    65,    -1,    22,
      81,    63,    65,    -1,     4,    -1,    78,    33,     4,    -1,
       4,    -1,    30,    78,    31,    -1,     4,    -1,     4,    28,
      29,    -1,     4,    28,    78,    29,    -1,    80,    -1,    79,
      45,    80,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    63,    63,    65,    67,    69,    71,    73,    78,    80,
      82,    84,    89,    91,    96,    98,   102,   107,   109,   114,
     115,   116,   120,   122,   124,   126,   127,   128,   130,   132,
     134,   139,   140,   142,   147,   149,   151,   153,   155,   160,
     162,   164,   169,   171,   176,   178,   183,   185,   190,   195,
     196,   197,   198,   202,   204,   206,   208,   210,   212,   214,
     219,   221,   226,   227,   231,   235,   240,   242,   247,   252,
     253,   257,   258,   262,   264,   266,   268,   274,   276,   281,
     283,   285,   290,   291,   295,   297,   302,   304,   309,   311,
     316,   318,   320,   325,   326
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "CONSTANT", "IDENTIFIER",
  "STRING_LITERAL", "ARRAYMUL", "ARRAYPOW", "ARRAYDIV", "ARRAYRDIV",
  "LE_OP", "GE_OP", "EQ_OP", "NE_OP", "IF", "ELSE", "ELSEIF", "WHILE",
  "FOR", "BREAK", "RETURN", "END", "FUNCTION", "TRANSPOSE", "NCTRANSPOSE",
  "CR", "GLOBAL", "CLEAR", "'('", "')'", "'['", "']'", "':'", "','", "'+'",
  "'-'", "'~'", "'*'", "'/'", "'\\\\'", "'^'", "'<'", "'>'", "'&'", "'|'",
  "'='", "';'", "$accept", "primary_expression", "postfix_expression",
  "index_expression", "index_expression_list", "array_expression",
  "unary_expression", "unary_operator", "multiplicative_expression",
  "additive_expression", "relational_expression", "equality_expression",
  "and_expression", "or_expression", "expression", "assignment_expression",
  "eostmt", "statement", "statement_list", "identifier_list",
  "global_statement", "clear_statement", "expression_statement",
  "assignment_statement", "array_element", "array_list",
  "selection_statement", "elseif_clause", "iteration_statement",
  "jump_statement", "translation_unit", "func_ident_list",
  "func_return_list", "function_declare_lhs", "function_declare", YY_NULL
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,    40,    41,
      91,    93,    58,    44,    43,    45,   126,    42,    47,    92,
      94,    60,    62,    38,   124,    61,    59
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    47,    48,    48,    48,    48,    48,    48,    49,    49,
      49,    49,    50,    50,    51,    51,    52,    53,    53,    54,
      54,    54,    55,    55,    55,    55,    55,    55,    55,    55,
      55,    56,    56,    56,    57,    57,    57,    57,    57,    58,
      58,    58,    59,    59,    60,    60,    61,    61,    62,    63,
      63,    63,    63,    64,    64,    64,    64,    64,    64,    64,
      65,    65,    66,    66,    67,    68,    69,    69,    70,    71,
      71,    72,    72,    73,    73,    73,    73,    74,    74,    75,
      75,    75,    76,    76,    77,    77,    78,    78,    79,    79,
      80,    80,    80,    81,    81
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     1,     3,     2,     3,     1,     1,
       2,     2,     1,     1,     1,     3,     4,     1,     2,     1,
       1,     1,     1,     3,     3,     3,     3,     3,     3,     3,
       3,     1,     3,     3,     1,     3,     3,     3,     3,     1,
       3,     3,     1,     3,     1,     3,     1,     3,     3,     1,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     2,     1,     2,     3,     3,     1,     2,     2,     1,
       1,     1,     2,     5,     7,     6,     8,     3,     4,     5,
       7,     9,     2,     2,     1,     4,     1,     3,     1,     3,
       1,     3,     4,     1,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     3,     2,     4,     0,     0,     0,     0,     0,     0,
      52,     0,     0,     0,     0,    49,    19,    20,    21,    51,
       8,    17,     9,    22,     0,    31,    34,    39,    42,    44,
      46,     0,     0,    66,    60,    84,    53,    54,    56,    55,
      57,    58,    59,     0,     0,    17,     0,     0,     0,     0,
      82,    83,    90,     0,     0,    93,     0,    62,     0,     0,
       0,     6,    69,    70,    71,     0,    50,    10,    11,     0,
      18,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      67,    68,    61,     1,    12,    14,     0,    13,     0,     0,
       0,     0,     0,    86,     0,     0,     0,    63,    64,    65,
       5,     7,    72,    48,    27,    30,    28,    29,    23,    24,
      25,    26,    32,    33,    37,    38,    35,    36,    40,    41,
      43,    45,    47,    16,     0,     0,     0,     0,     0,     0,
       0,     0,    91,     0,    89,     0,    90,    94,    85,    15,
       0,     0,    73,     0,     0,     0,    79,     0,     0,    92,
      87,     0,    77,     0,     0,    75,     0,     0,    74,     0,
      78,    80,     0,    76,     0,    81
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    20,    45,    95,    96,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    35,    58,
      36,    37,    38,    39,    64,    65,    40,   138,    41,    42,
      43,   104,    54,    55,    56
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -44
static const yytype_int16 yypact[] =
{
     216,   -44,   -26,   -44,   488,   488,    44,    63,    63,    10,
     -44,    28,    28,   488,     8,   -44,   -44,   -44,   -44,     9,
     -44,    41,   -44,   -44,    23,    74,   -19,    49,    65,    24,
      25,    43,    63,   -44,   -44,   454,   -44,   -44,   -44,   -44,
     -44,   -44,   -44,    71,   473,    70,   250,   250,    34,    69,
     -44,   -44,   -23,    81,    50,   -44,    63,   -44,     4,     4,
      55,   -44,    43,   -44,   -44,    97,   -44,   -44,   -44,   488,
      70,   488,   488,   488,   488,   488,   488,   488,   488,   488,
     488,   488,   488,   488,   488,   488,   488,   488,   488,   488,
     -44,   -44,   -44,   -44,   -44,   -44,   -12,    94,   182,   284,
     488,    58,    16,   -44,    -8,   125,   454,   -44,   -44,   -44,
     -44,   -44,   -44,    94,   -44,   -44,   -44,   -44,   -44,   -44,
     -44,   -44,    74,    74,   -19,   -19,   -19,   -19,    49,    49,
      65,    24,    25,   -44,   473,   454,   488,    63,   102,    63,
     250,   488,   -44,    33,   -44,   130,   109,   -44,   454,   -44,
     318,   250,   -44,   454,   488,    63,   -44,   352,    75,   -44,
     -44,    63,   454,   386,   250,   -44,    63,   454,   -44,    63,
     454,   -44,   420,   -44,    63,   -44
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -44,   -44,     0,    13,   -44,   -44,   455,   -44,    36,    93,
      59,    62,    54,    66,     5,   -44,    -1,    21,   -43,   140,
     -44,   -44,   -13,   -44,    91,   -44,   -44,   -44,   -44,   -44,
     -44,    56,   -44,    61,   -44
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -89
static const yytype_int16 yytable[] =
{
      21,    63,    44,    98,    99,   102,    50,    51,   107,    46,
      47,     1,     2,     3,    52,    79,    80,   133,    60,    62,
     103,   134,   -88,   144,    70,   145,     1,     2,     3,    10,
      90,    91,    57,    10,    66,    21,    13,    15,    14,    61,
      53,    15,    16,    17,    18,   142,    21,    21,    48,    97,
      19,    13,    63,    14,    19,   106,    92,   108,   109,    81,
      82,    90,   159,   148,    67,    68,   145,    87,    10,    88,
      62,    93,    49,   101,   113,    89,    15,    85,    86,   100,
      71,    72,    73,    74,   110,   103,    69,    89,    10,    19,
      83,    84,   150,    67,    68,   105,    15,   157,    21,    21,
       1,     2,     3,   141,   167,   140,    21,    89,   162,    19,
     163,    75,    76,    77,    78,   122,   123,   153,   154,    92,
      92,   170,    10,   155,   172,    13,    89,    14,   111,   146,
      15,    16,    17,    18,   160,    21,   152,   102,   156,    97,
      21,   151,   131,    19,   128,   129,   158,   149,    21,   130,
      21,    21,    59,    21,   165,   132,   112,    21,   143,   164,
     168,     0,    21,    21,    21,   171,   147,    21,   173,    92,
      21,    92,    21,   175,   124,   125,   126,   127,    92,     0,
       0,     0,     0,    92,    92,     1,     2,     3,     0,     0,
       0,    92,     0,    92,     0,     0,     4,   135,   136,     5,
       6,     7,     8,   137,     0,     0,     0,    10,    11,    12,
      13,     0,    14,     0,     0,    15,    16,    17,    18,     1,
       2,     3,     0,     0,     0,     0,     0,     0,    19,     0,
       4,     0,     0,     5,     6,     7,     8,     0,     9,     0,
       0,    10,    11,    12,    13,     0,    14,     0,     0,    15,
      16,    17,    18,     1,     2,     3,     0,     0,     0,     0,
       0,     0,    19,     0,     4,     0,     0,     5,     6,     7,
       8,     0,     0,     0,     0,    10,    11,    12,    13,     0,
      14,     0,    89,    15,    16,    17,    18,     1,     2,     3,
       0,     0,     0,     0,     0,     0,    19,     0,     4,     0,
       0,     5,     6,     7,     8,   139,     0,     0,     0,    10,
      11,    12,    13,     0,    14,     0,     0,    15,    16,    17,
      18,     1,     2,     3,     0,     0,     0,     0,     0,     0,
      19,     0,     4,     0,     0,     5,     6,     7,     8,   161,
       0,     0,     0,    10,    11,    12,    13,     0,    14,     0,
       0,    15,    16,    17,    18,     1,     2,     3,     0,     0,
       0,     0,     0,     0,    19,     0,     4,     0,     0,     5,
       6,     7,     8,   166,     0,     0,     0,    10,    11,    12,
      13,     0,    14,     0,     0,    15,    16,    17,    18,     1,
       2,     3,     0,     0,     0,     0,     0,     0,    19,     0,
       4,     0,     0,     5,     6,     7,     8,   169,     0,     0,
       0,    10,    11,    12,    13,     0,    14,     0,     0,    15,
      16,    17,    18,     1,     2,     3,     0,     0,     0,     0,
       0,     0,    19,     0,     4,     0,     0,     5,     6,     7,
       8,   174,     0,     0,     0,    10,    11,    12,    13,     0,
      14,     0,     0,    15,    16,    17,    18,     1,     2,     3,
       0,     0,     0,     0,     0,     0,    19,     0,     4,     0,
       0,     5,     6,     7,     8,     0,     1,     2,     3,    10,
      11,    12,    13,     0,    14,     0,     0,    15,    16,    17,
      18,     1,     2,     3,     0,     0,     0,     0,     0,     0,
      19,    13,     0,    14,     0,    94,     0,    16,    17,    18,
       0,     0,     0,     0,     0,     0,    13,     0,    14,     0,
       0,     0,    16,    17,    18,     0,   114,   115,   116,   117,
     118,   119,   120,   121
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-44)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
       0,    14,    28,    46,    47,    28,     7,     8,     4,     4,
       5,     3,     4,     5,     4,    34,    35,    29,    13,    14,
       4,    33,    45,    31,    24,    33,     3,     4,     5,    25,
      31,    32,     4,    25,    25,    35,    28,    33,    30,    31,
      30,    33,    34,    35,    36,    29,    46,    47,     4,    44,
      46,    28,    65,    30,    46,    56,    35,    58,    59,    10,
      11,    62,    29,   106,    23,    24,    33,    43,    25,    44,
      65,     0,    28,     4,    69,    32,    33,    12,    13,    45,
       6,     7,     8,     9,    29,     4,    45,    32,    25,    46,
      41,    42,   135,    23,    24,    45,    33,   140,    98,    99,
       3,     4,     5,    45,    29,   100,   106,    32,   151,    46,
     153,    37,    38,    39,    40,    79,    80,    15,    16,    98,
      99,   164,    25,    21,   167,    28,    32,    30,    31,     4,
      33,    34,    35,    36,     4,   135,   137,    28,   139,   134,
     140,   136,    88,    46,    85,    86,   141,   134,   148,    87,
     150,   151,    12,   153,   155,    89,    65,   157,   102,   154,
     161,    -1,   162,   163,   164,   166,   105,   167,   169,   148,
     170,   150,   172,   174,    81,    82,    83,    84,   157,    -1,
      -1,    -1,    -1,   162,   163,     3,     4,     5,    -1,    -1,
      -1,   170,    -1,   172,    -1,    -1,    14,    15,    16,    17,
      18,    19,    20,    21,    -1,    -1,    -1,    25,    26,    27,
      28,    -1,    30,    -1,    -1,    33,    34,    35,    36,     3,
       4,     5,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,
      14,    -1,    -1,    17,    18,    19,    20,    -1,    22,    -1,
      -1,    25,    26,    27,    28,    -1,    30,    -1,    -1,    33,
      34,    35,    36,     3,     4,     5,    -1,    -1,    -1,    -1,
      -1,    -1,    46,    -1,    14,    -1,    -1,    17,    18,    19,
      20,    -1,    -1,    -1,    -1,    25,    26,    27,    28,    -1,
      30,    -1,    32,    33,    34,    35,    36,     3,     4,     5,
      -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    14,    -1,
      -1,    17,    18,    19,    20,    21,    -1,    -1,    -1,    25,
      26,    27,    28,    -1,    30,    -1,    -1,    33,    34,    35,
      36,     3,     4,     5,    -1,    -1,    -1,    -1,    -1,    -1,
      46,    -1,    14,    -1,    -1,    17,    18,    19,    20,    21,
      -1,    -1,    -1,    25,    26,    27,    28,    -1,    30,    -1,
      -1,    33,    34,    35,    36,     3,     4,     5,    -1,    -1,
      -1,    -1,    -1,    -1,    46,    -1,    14,    -1,    -1,    17,
      18,    19,    20,    21,    -1,    -1,    -1,    25,    26,    27,
      28,    -1,    30,    -1,    -1,    33,    34,    35,    36,     3,
       4,     5,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,
      14,    -1,    -1,    17,    18,    19,    20,    21,    -1,    -1,
      -1,    25,    26,    27,    28,    -1,    30,    -1,    -1,    33,
      34,    35,    36,     3,     4,     5,    -1,    -1,    -1,    -1,
      -1,    -1,    46,    -1,    14,    -1,    -1,    17,    18,    19,
      20,    21,    -1,    -1,    -1,    25,    26,    27,    28,    -1,
      30,    -1,    -1,    33,    34,    35,    36,     3,     4,     5,
      -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    14,    -1,
      -1,    17,    18,    19,    20,    -1,     3,     4,     5,    25,
      26,    27,    28,    -1,    30,    -1,    -1,    33,    34,    35,
      36,     3,     4,     5,    -1,    -1,    -1,    -1,    -1,    -1,
      46,    28,    -1,    30,    -1,    32,    -1,    34,    35,    36,
      -1,    -1,    -1,    -1,    -1,    -1,    28,    -1,    30,    -1,
      -1,    -1,    34,    35,    36,    -1,    71,    72,    73,    74,
      75,    76,    77,    78
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,    14,    17,    18,    19,    20,    22,
      25,    26,    27,    28,    30,    33,    34,    35,    36,    46,
      48,    49,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    65,    67,    68,    69,    70,
      73,    75,    76,    77,    28,    49,    61,    61,     4,    28,
      63,    63,     4,    30,    79,    80,    81,     4,    66,    66,
      61,    31,    61,    69,    71,    72,    25,    23,    24,    45,
      49,     6,     7,     8,     9,    37,    38,    39,    40,    34,
      35,    10,    11,    41,    42,    12,    13,    43,    44,    32,
      63,    63,    64,     0,    32,    50,    51,    61,    65,    65,
      45,     4,    28,     4,    78,    45,    63,     4,    63,    63,
      29,    31,    71,    61,    53,    53,    53,    53,    53,    53,
      53,    53,    55,    55,    56,    56,    56,    56,    57,    57,
      58,    59,    60,    29,    33,    15,    16,    21,    74,    21,
      61,    45,    29,    78,    31,    33,     4,    80,    65,    50,
      65,    61,    63,    15,    16,    21,    63,    65,    61,    29,
       4,    21,    65,    65,    61,    63,    21,    29,    63,    21,
      65,    63,    65,    63,    21,    63
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  However,
   YYFAIL appears to be in use.  Nevertheless, it is formally deprecated
   in Bison 2.4.2's NEWS entry, where a plan to phase it out is
   discussed.  */

#define YYFAIL		goto yyerrlab
#if defined YYFAIL
  /* This is here to suppress warnings from the GCC cpp's
     -Wunused-macros.  Normally we don't worry about that warning, but
     some users do, and we want to make it easy for users to remove
     YYFAIL uses, which will produce warnings from Bison 2.5.  */
#endif

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))

/* Error token number */
#define YYTERROR	1
#define YYERRCODE	256


/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */
#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULL, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULL;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - Assume YYFAIL is not used.  It's too flawed to consider.  See
       <http://lists.gnu.org/archive/html/bison-patches/2009-12/msg00024.html>
       for details.  YYERROR is fine as it does not invoke this
       function.
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULL, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YYUSE (yytype);
}




/* The lookahead symbol.  */
int yychar;


#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval YY_INITIAL_VALUE(yyval_default);

/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;

	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),
		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss_alloc, yyss);
	YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
/* Line 1787 of yacc.c  */
#line 64 "matlab.y"
    { (yyval.node) = addVariable((yyvsp[(1) - (1)].iden)); }
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 66 "matlab.y"
    { (yyval.node) = addConstant((yyvsp[(1) - (1)].num)); }
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 68 "matlab.y"
    { fprintf(warn, "String Literal\n"); }
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 70 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (3)].node); }
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 72 "matlab.y"
    { (yyval.node) = NULL; fatalError("Arrays not supported."); }
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 74 "matlab.y"
    { (yyval.node) = NULL; fatalError("Arrays not supported."); }
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 79 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 9:
/* Line 1787 of yacc.c  */
#line 81 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 83 "matlab.y"
    { (yyval.node) = NULL; fatalError("Transpose not supported."); }
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 85 "matlab.y"
    { (yyval.node) = NULL; fatalError("Transpose not supported."); }
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 90 "matlab.y"
    { (yyval.node) = addVariable(":"); (yyval.node)->ignore = 1; }
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 92 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 97 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 16:
/* Line 1787 of yacc.c  */
#line 103 "matlab.y"
    { (yyval.node) = addOperationWithIdentifier(TARRAYINDEX, (yyvsp[(3) - (4)].node), NULL, (yyvsp[(1) - (4)].iden)); }
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 108 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 18:
/* Line 1787 of yacc.c  */
#line 110 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (2)].node); }
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 121 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 123 "matlab.y"
    { (yyval.node) = addOperation(TMUL, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 24:
/* Line 1787 of yacc.c  */
#line 125 "matlab.y"
    { (yyval.node) = addOperation(TDIV, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 129 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array multiplication not supported."); }
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 131 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array division not supported."); }
    break;

  case 29:
/* Line 1787 of yacc.c  */
#line 133 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array division not supported."); }
    break;

  case 30:
/* Line 1787 of yacc.c  */
#line 135 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array power not supported."); }
    break;

  case 32:
/* Line 1787 of yacc.c  */
#line 141 "matlab.y"
    { (yyval.node) = addOperation(TPLUS, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 143 "matlab.y"
    { (yyval.node) = addOperation(TMINUS, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 148 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 150 "matlab.y"
    { (yyval.node) = addOperation(TLT_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 152 "matlab.y"
    { (yyval.node) = addOperation(TGT_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 154 "matlab.y"
    { (yyval.node) = addOperation(TLE_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 38:
/* Line 1787 of yacc.c  */
#line 156 "matlab.y"
    { (yyval.node) = addOperation(TGE_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 161 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 163 "matlab.y"
    { (yyval.node) = addOperation(TEQ_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 165 "matlab.y"
    { (yyval.node) = addOperation(TNE_OP, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 170 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 43:
/* Line 1787 of yacc.c  */
#line 172 "matlab.y"
    { (yyval.node) = addOperation(TAND, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 177 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 179 "matlab.y"
    { (yyval.node) = addOperation(TOR, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 184 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 186 "matlab.y"
    { (yyval.node) = addOperation(TRANGE, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 191 "matlab.y"
    { (yyval.node) = addOperation(TASSIGN, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 53:
/* Line 1787 of yacc.c  */
#line 203 "matlab.y"
    { fprintf(warn, "Global Statement not supported.\n"); }
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 205 "matlab.y"
    { fprintf(warn, "Clear Statement not supported.\n"); }
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 207 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 209 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 211 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 213 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 215 "matlab.y"
    { fprintf(warn, "Jump Statement not supported.\n"); }
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 220 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 222 "matlab.y"
    { (yyval.node) = addStatement((yyvsp[(1) - (2)].node), (yyvsp[(2) - (2)].node)); }
    break;

  case 65:
/* Line 1787 of yacc.c  */
#line 236 "matlab.y"
    { fprintf(warn, "Warning: Clear statement ignored.\n"); }
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 241 "matlab.y"
    { (yyval.node) = NULL; /*$$ = addStub();*/ }
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 243 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (2)].node); }
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 248 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (2)].node); }
    break;

  case 73:
/* Line 1787 of yacc.c  */
#line 263 "matlab.y"
    { (yyval.node) = addOperation(TIF, (yyvsp[(2) - (5)].node), (yyvsp[(3) - (5)].node)); }
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 265 "matlab.y"
    { (yyval.node) = addOperation3(TIFELSE, (yyvsp[(2) - (7)].node), (yyvsp[(3) - (7)].node), (yyvsp[(5) - (7)].node)); }
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 267 "matlab.y"
    { (yyval.node) = addOperation3(TIFELSEIF, (yyvsp[(2) - (6)].node), (yyvsp[(3) - (6)].node), (yyvsp[(4) - (6)].node)); }
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 270 "matlab.y"
    { (yyval.node) = addOperation4(TIFELSEIFELSE, (yyvsp[(2) - (8)].node), (yyvsp[(3) - (8)].node), (yyvsp[(4) - (8)].node), (yyvsp[(6) - (8)].node)); }
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 275 "matlab.y"
    { (yyval.node) = addOperation(TELSEIF, (yyvsp[(2) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 277 "matlab.y"
    { (yyval.node) = addStatement((yyvsp[(1) - (4)].node), addOperation(TELSEIF, (yyvsp[(3) - (4)].node), (yyvsp[(4) - (4)].node))); }
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 282 "matlab.y"
    { (yyval.node) = addOperation(TWHILE, (yyvsp[(2) - (5)].node), (yyvsp[(3) - (5)].node)); }
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 284 "matlab.y"
    { (yyval.node) = addOperationWithIdentifier(TFOR, (yyvsp[(4) - (7)].node), (yyvsp[(5) - (7)].node), (yyvsp[(2) - (7)].iden)); }
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 286 "matlab.y"
    { (yyval.node) = addOperationWithIdentifier(TFOR, (yyvsp[(5) - (9)].node), (yyvsp[(7) - (9)].node), (yyvsp[(3) - (9)].iden)); }
    break;

  case 84:
/* Line 1787 of yacc.c  */
#line 296 "matlab.y"
    { fatalError("The file should provide a function, not a script."); }
    break;

  case 85:
/* Line 1787 of yacc.c  */
#line 298 "matlab.y"
    { functionToFortran((yyvsp[(2) - (4)].node), (yyvsp[(4) - (4)].node)); /*fprintf(warn, "\n"); print_tree(0, $4); fprintf(warn, "\n");*/ }
    break;

  case 86:
/* Line 1787 of yacc.c  */
#line 303 "matlab.y"
    { (yyval.node) = addOperation(TLIST, addVariable((yyvsp[(1) - (1)].iden)), NULL); }
    break;

  case 87:
/* Line 1787 of yacc.c  */
#line 305 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (3)].node); addStatement((yyvsp[(1) - (3)].node)->children, addVariable((yyvsp[(3) - (3)].iden))); }
    break;

  case 88:
/* Line 1787 of yacc.c  */
#line 310 "matlab.y"
    { (yyval.node) = addOperation(TLIST, addVariable((yyvsp[(1) - (1)].iden)), NULL); }
    break;

  case 89:
/* Line 1787 of yacc.c  */
#line 312 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (3)].node); }
    break;

  case 90:
/* Line 1787 of yacc.c  */
#line 317 "matlab.y"
    { fatalError("Incorrect number of input arguments."); }
    break;

  case 91:
/* Line 1787 of yacc.c  */
#line 319 "matlab.y"
    { fatalError("Incorrect number of input arguments."); }
    break;

  case 92:
/* Line 1787 of yacc.c  */
#line 321 "matlab.y"
    { (yyval.node) = (yyvsp[(3) - (4)].node); }
    break;

  case 94:
/* Line 1787 of yacc.c  */
#line 327 "matlab.y"
    { (yyval.node) = addOperation(TFUNCDEC, (yyvsp[(1) - (3)].node), (yyvsp[(3) - (3)].node)); }
    break;


/* Line 1787 of yacc.c  */
#line 2067 "y.tab.c"
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


/* Line 2050 of yacc.c  */
#line 330 "matlab.y"


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
