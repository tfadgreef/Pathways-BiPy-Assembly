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
    #include "simplify.h"
    #include "tree.h"
    #include "node.h"
    void yyerror(char *);


/* Line 371 of yacc.c  */
#line 81 "y.tab.c"

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
#line 13 "matlab.y"
 double num; struct Node *node; char *iden; 

/* Line 387 of yacc.c  */
#line 181 "y.tab.c"
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
#line 209 "y.tab.c"

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
#define YYFINAL  94
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   545

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  47
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  34
/* YYNRULES -- Number of rules.  */
#define YYNRULES  95
/* YYNRULES -- Number of states.  */
#define YYNSTATES  181

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
      53,    56,    58,    62,    66,    70,    74,    78,    82,    86,
      90,    92,    96,   100,   102,   106,   110,   114,   118,   120,
     124,   128,   130,   135,   139,   141,   146,   150,   152,   156,
     160,   162,   165,   167,   169,   171,   173,   175,   177,   179,
     181,   183,   185,   188,   190,   193,   197,   201,   203,   206,
     209,   211,   213,   215,   218,   224,   232,   239,   248,   252,
     257,   263,   271,   281,   284,   287,   289,   294,   296,   300,
     302,   306,   308,   312,   317,   319
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      76,     0,    -1,     4,    -1,     3,    -1,     5,    -1,    28,
      60,    29,    -1,    30,    31,    -1,    30,    71,    31,    -1,
      48,    -1,    52,    -1,    49,    23,    -1,    49,    24,    -1,
      32,    -1,    60,    -1,    50,    -1,    51,    33,    50,    -1,
       4,    28,    51,    29,    -1,    49,    -1,    34,    49,    -1,
      35,    49,    -1,    36,    49,    -1,    53,    -1,    54,    37,
      53,    -1,    54,    38,    53,    -1,    54,    39,    53,    -1,
      54,    40,    53,    -1,    54,     6,    53,    -1,    54,     8,
      53,    -1,    54,     9,    53,    -1,    54,     7,    53,    -1,
      54,    -1,    55,    34,    54,    -1,    55,    35,    54,    -1,
      55,    -1,    56,    41,    55,    -1,    56,    42,    55,    -1,
      56,    10,    55,    -1,    56,    11,    55,    -1,    56,    -1,
      57,    12,    56,    -1,    57,    13,    56,    -1,    57,    -1,
      58,    43,    43,    57,    -1,    58,    43,    57,    -1,    58,
      -1,    59,    44,    44,    58,    -1,    59,    44,    58,    -1,
      59,    -1,    60,    32,    59,    -1,    49,    45,    60,    -1,
      33,    -1,    46,    25,    -1,    46,    -1,    25,    -1,    66,
      -1,    67,    -1,    69,    -1,    68,    -1,    72,    -1,    74,
      -1,    75,    -1,    63,    -1,    64,    63,    -1,     4,    -1,
      65,     4,    -1,    26,    65,    62,    -1,    27,    65,    62,
      -1,    62,    -1,    60,    62,    -1,    61,    62,    -1,    60,
      -1,    68,    -1,    70,    -1,    71,    70,    -1,    14,    60,
      64,    21,    62,    -1,    14,    60,    64,    15,    64,    21,
      62,    -1,    14,    60,    64,    73,    21,    62,    -1,    14,
      60,    64,    73,    15,    64,    21,    62,    -1,    16,    60,
      64,    -1,    73,    16,    60,    64,    -1,    17,    60,    64,
      21,    62,    -1,    18,     4,    45,    60,    64,    21,    62,
      -1,    18,    28,     4,    45,    60,    29,    64,    21,    62,
      -1,    19,    62,    -1,    20,    62,    -1,    64,    -1,    22,
      80,    62,    64,    -1,     4,    -1,    77,    33,     4,    -1,
       4,    -1,    30,    77,    31,    -1,     4,    -1,     4,    28,
      29,    -1,     4,    28,    77,    29,    -1,    79,    -1,    78,
      45,    79,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    42,    42,    44,    46,    48,    50,    52,    57,    59,
      61,    63,    68,    70,    75,    77,    81,    90,    92,    94,
      99,   116,   118,   124,   130,   132,   138,   140,   142,   144,
     149,   150,   156,   165,   167,   173,   179,   185,   194,   196,
     202,   211,   213,   219,   228,   230,   236,   245,   247,   256,
     265,   266,   267,   268,   272,   274,   276,   278,   280,   282,
     284,   289,   291,   296,   297,   301,   305,   310,   312,   317,
     322,   323,   327,   328,   332,   339,   348,   355,   367,   373,
     383,   389,   396,   406,   407,   411,   413,   425,   430,   438,
     443,   448,   450,   452,   457,   458
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
  "unary_expression", "multiplicative_expression", "additive_expression",
  "relational_expression", "equality_expression", "and_expression",
  "or_expression", "expression", "assignment_expression", "eostmt",
  "statement", "statement_list", "identifier_list", "global_statement",
  "clear_statement", "expression_statement", "assignment_statement",
  "array_element", "array_list", "selection_statement", "elseif_clause",
  "iteration_statement", "jump_statement", "translation_unit",
  "func_ident_list", "func_return_list", "function_declare_lhs",
  "function_declare", YY_NULL
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
      49,    49,    50,    50,    51,    51,    52,    53,    53,    53,
      53,    54,    54,    54,    54,    54,    54,    54,    54,    54,
      55,    55,    55,    56,    56,    56,    56,    56,    57,    57,
      57,    58,    58,    58,    59,    59,    59,    60,    60,    61,
      62,    62,    62,    62,    63,    63,    63,    63,    63,    63,
      63,    64,    64,    65,    65,    66,    67,    68,    68,    69,
      70,    70,    71,    71,    72,    72,    72,    72,    73,    73,
      74,    74,    74,    75,    75,    76,    76,    77,    77,    78,
      78,    79,    79,    79,    80,    80
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     1,     1,     3,     2,     3,     1,     1,
       2,     2,     1,     1,     1,     3,     4,     1,     2,     2,
       2,     1,     3,     3,     3,     3,     3,     3,     3,     3,
       1,     3,     3,     1,     3,     3,     3,     3,     1,     3,
       3,     1,     4,     3,     1,     4,     3,     1,     3,     3,
       1,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     1,     2,     3,     3,     1,     2,     2,
       1,     1,     1,     2,     5,     7,     6,     8,     3,     4,
       5,     7,     9,     2,     2,     1,     4,     1,     3,     1,
       3,     1,     3,     4,     1,     3
};

/* YYDEFACT[STATE-NAME] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     3,     2,     4,     0,     0,     0,     0,     0,     0,
      53,     0,     0,     0,     0,    50,     0,     0,     0,    52,
       8,    17,     9,    21,    30,    33,    38,    41,    44,    47,
       0,     0,    67,    61,    85,    54,    55,    57,    56,    58,
      59,    60,     0,     0,    17,     0,     0,     0,     0,    83,
      84,    91,     0,     0,    94,     0,    63,     0,     0,     0,
       6,    70,    71,    72,     0,    18,    19,    20,    51,    10,
      11,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    68,    69,    62,     1,    12,    14,     0,    13,     0,
       0,     0,     0,     0,    87,     0,     0,     0,    64,    65,
      66,     5,     7,    73,    49,    26,    29,    27,    28,    22,
      23,    24,    25,    31,    32,    36,    37,    34,    35,    39,
      40,     0,    43,     0,    46,    48,    16,     0,     0,     0,
       0,     0,     0,     0,     0,    92,     0,    90,     0,    91,
      95,    86,    42,    45,    15,     0,     0,    74,     0,     0,
       0,    80,     0,     0,    93,    88,     0,    78,     0,     0,
      76,     0,     0,    75,     0,    79,    81,     0,    77,     0,
      82
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    20,    44,    96,    97,    22,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    33,    34,    57,    35,
      36,    37,    38,    63,    64,    39,   141,    40,    41,    42,
     105,    53,    54,    55
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -85
static const yytype_int16 yypact[] =
{
     176,   -85,   -18,   -85,     8,     8,    33,    79,    79,     5,
     -85,    29,    29,     8,   433,   -85,    20,    20,    20,    -4,
     -85,    58,   -85,   -85,   485,    97,    17,   137,    47,     9,
      77,    79,   -85,   -85,   414,   -85,   -85,   -85,   -85,   -85,
     -85,   -85,    83,   501,   129,   210,   210,    52,   102,   -85,
     -85,    43,   109,    72,   -85,    79,   -85,    22,    22,    40,
     -85,    77,   -85,   -85,   450,   129,   129,   129,   -85,   -85,
     -85,     8,     8,     8,     8,     8,     8,     8,     8,     8,
       8,     8,     8,     8,     8,     8,     8,     8,   484,   467,
       8,   -85,   -85,   -85,   -85,   -85,   -85,   -14,    76,    59,
     244,     8,    74,    10,   -85,   -11,   120,   414,   -85,   -85,
     -85,   -85,   -85,   -85,    76,   -85,   -85,   -85,   -85,   -85,
     -85,   -85,   -85,   485,   485,    97,    97,    97,    97,    17,
      17,     8,   137,     8,    47,     9,   -85,   501,   414,     8,
      79,   105,    79,   210,     8,   -85,    82,   -85,   133,   112,
     -85,   414,   137,    47,   -85,   278,   210,   -85,   414,     8,
      79,   -85,   312,   104,   -85,   -85,    79,   414,   346,   210,
     -85,    79,   414,   -85,    79,   414,   -85,   380,   -85,    79,
     -85
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -85,   -85,     0,    26,   -85,   -85,   466,    80,    63,    96,
     -80,   -84,    64,    27,   -85,    -1,   -33,   -42,   145,   -85,
     -85,   -12,   -85,   110,   -85,   -85,   -85,   -85,   -85,   -85,
      73,   -85,    78,   -85
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -90
static const yytype_int16 yytable[] =
{
      21,    93,    62,    99,   100,   134,    49,    50,   132,    51,
      43,     1,     2,     3,   104,   136,    65,    66,    67,   137,
     147,    68,   148,     1,     2,     3,   108,    82,    83,    91,
      92,    45,    46,    56,    21,    52,    13,    47,    14,   145,
      59,    61,    16,    17,    18,    21,    21,    10,    13,   153,
      14,   152,    62,    89,   107,    15,   109,   110,    84,    85,
      91,    48,     1,     2,     3,   151,    93,    93,    19,   111,
      98,   103,    90,     4,   138,   139,     5,     6,     7,     8,
     140,    69,    70,    94,    10,    11,    12,    13,   -89,    14,
      88,    61,    15,    16,    17,    18,   155,   101,   114,    21,
      21,   162,    10,    71,    10,    19,   102,    21,    90,    90,
      15,   164,    15,   104,   167,   148,   168,   106,    93,   144,
     158,   159,    93,    19,   149,    19,   160,   175,   143,    93,
     177,    80,    81,   172,    93,    93,    90,   165,    21,   157,
     103,   161,    93,    21,    93,   125,   126,   127,   128,    86,
      87,    21,    69,    70,   135,    21,    21,    58,    21,   170,
     123,   124,    21,   154,    98,   173,   156,    21,    21,    21,
     176,   163,    21,   178,   113,    21,   146,    21,   180,     1,
       2,     3,   129,   130,   150,     0,   169,     0,     0,     0,
       4,     0,     0,     5,     6,     7,     8,     0,     9,     0,
       0,    10,    11,    12,    13,     0,    14,     0,     0,    15,
      16,    17,    18,     1,     2,     3,     0,     0,     0,     0,
       0,     0,    19,     0,     4,     0,     0,     5,     6,     7,
       8,     0,     0,     0,     0,    10,    11,    12,    13,     0,
      14,     0,    90,    15,    16,    17,    18,     1,     2,     3,
       0,     0,     0,     0,     0,     0,    19,     0,     4,     0,
       0,     5,     6,     7,     8,   142,     0,     0,     0,    10,
      11,    12,    13,     0,    14,     0,     0,    15,    16,    17,
      18,     1,     2,     3,     0,     0,     0,     0,     0,     0,
      19,     0,     4,     0,     0,     5,     6,     7,     8,   166,
       0,     0,     0,    10,    11,    12,    13,     0,    14,     0,
       0,    15,    16,    17,    18,     1,     2,     3,     0,     0,
       0,     0,     0,     0,    19,     0,     4,     0,     0,     5,
       6,     7,     8,   171,     0,     0,     0,    10,    11,    12,
      13,     0,    14,     0,     0,    15,    16,    17,    18,     1,
       2,     3,     0,     0,     0,     0,     0,     0,    19,     0,
       4,     0,     0,     5,     6,     7,     8,   174,     0,     0,
       0,    10,    11,    12,    13,     0,    14,     0,     0,    15,
      16,    17,    18,     1,     2,     3,     0,     0,     0,     0,
       0,     0,    19,     0,     4,     0,     0,     5,     6,     7,
       8,   179,     0,     0,     0,    10,    11,    12,    13,     0,
      14,     0,     0,    15,    16,    17,    18,     1,     2,     3,
       0,     0,     0,     0,     0,     0,    19,     0,     4,     0,
       0,     5,     6,     7,     8,     0,     1,     2,     3,    10,
      11,    12,    13,     0,    14,     0,     0,    15,    16,    17,
      18,     0,     0,     1,     2,     3,     0,     0,    10,     0,
      19,    13,     0,    14,    60,     0,    15,    16,    17,    18,
       1,     2,     3,     0,     0,    10,     0,     0,    13,    19,
      14,   112,     0,    15,    16,    17,    18,     1,     2,     3,
       0,    72,    73,    74,    75,    13,    19,    14,     0,     0,
       0,    16,    17,    18,     1,     2,     3,     0,     0,     0,
       0,   133,    13,     0,    14,     0,     0,     0,    16,    17,
      18,     0,    76,    77,    78,    79,     0,   131,     0,    13,
       0,    14,     0,    95,     0,    16,    17,    18,   115,   116,
     117,   118,   119,   120,   121,   122
};

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-85)))

#define yytable_value_is_error(Yytable_value) \
  YYID (0)

static const yytype_int16 yycheck[] =
{
       0,    34,    14,    45,    46,    89,     7,     8,    88,     4,
      28,     3,     4,     5,     4,    29,    16,    17,    18,    33,
      31,    25,    33,     3,     4,     5,     4,    10,    11,    30,
      31,     4,     5,     4,    34,    30,    28,     4,    30,    29,
      13,    14,    34,    35,    36,    45,    46,    25,    28,   133,
      30,   131,    64,    44,    55,    33,    57,    58,    41,    42,
      61,    28,     3,     4,     5,   107,    99,   100,    46,    29,
      43,    28,    32,    14,    15,    16,    17,    18,    19,    20,
      21,    23,    24,     0,    25,    26,    27,    28,    45,    30,
      43,    64,    33,    34,    35,    36,   138,    45,    71,    99,
     100,   143,    25,    45,    25,    46,     4,   107,    32,    32,
      33,    29,    33,     4,   156,    33,   158,    45,   151,    45,
      15,    16,   155,    46,     4,    46,    21,   169,   101,   162,
     172,    34,    35,    29,   167,   168,    32,     4,   138,   140,
      28,   142,   175,   143,   177,    82,    83,    84,    85,    12,
      13,   151,    23,    24,    90,   155,   156,    12,   158,   160,
      80,    81,   162,   137,   137,   166,   139,   167,   168,   169,
     171,   144,   172,   174,    64,   175,   103,   177,   179,     3,
       4,     5,    86,    87,   106,    -1,   159,    -1,    -1,    -1,
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
      36,    -1,    -1,     3,     4,     5,    -1,    -1,    25,    -1,
      46,    28,    -1,    30,    31,    -1,    33,    34,    35,    36,
       3,     4,     5,    -1,    -1,    25,    -1,    -1,    28,    46,
      30,    31,    -1,    33,    34,    35,    36,     3,     4,     5,
      -1,     6,     7,     8,     9,    28,    46,    30,    -1,    -1,
      -1,    34,    35,    36,     3,     4,     5,    -1,    -1,    -1,
      -1,    44,    28,    -1,    30,    -1,    -1,    -1,    34,    35,
      36,    -1,    37,    38,    39,    40,    -1,    43,    -1,    28,
      -1,    30,    -1,    32,    -1,    34,    35,    36,    72,    73,
      74,    75,    76,    77,    78,    79
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     5,    14,    17,    18,    19,    20,    22,
      25,    26,    27,    28,    30,    33,    34,    35,    36,    46,
      48,    49,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    61,    62,    63,    64,    66,    67,    68,    69,    72,
      74,    75,    76,    28,    49,    60,    60,     4,    28,    62,
      62,     4,    30,    78,    79,    80,     4,    65,    65,    60,
      31,    60,    68,    70,    71,    49,    49,    49,    25,    23,
      24,    45,     6,     7,     8,     9,    37,    38,    39,    40,
      34,    35,    10,    11,    41,    42,    12,    13,    43,    44,
      32,    62,    62,    63,     0,    32,    50,    51,    60,    64,
      64,    45,     4,    28,     4,    77,    45,    62,     4,    62,
      62,    29,    31,    70,    60,    53,    53,    53,    53,    53,
      53,    53,    53,    54,    54,    55,    55,    55,    55,    56,
      56,    43,    57,    44,    58,    59,    29,    33,    15,    16,
      21,    73,    21,    60,    45,    29,    77,    31,    33,     4,
      79,    64,    57,    58,    50,    64,    60,    62,    15,    16,
      21,    62,    64,    60,    29,     4,    21,    64,    64,    60,
      62,    21,    29,    62,    21,    64,    62,    64,    62,    21,
      62
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
#line 43 "matlab.y"
    { (yyval.node) = createVariable((yyvsp[(1) - (1)].iden)); }
    break;

  case 3:
/* Line 1787 of yacc.c  */
#line 45 "matlab.y"
    { (yyval.node) = createConstant((yyvsp[(1) - (1)].num)); }
    break;

  case 4:
/* Line 1787 of yacc.c  */
#line 47 "matlab.y"
    { (yyval.node) = NULL; fatalError("Strings not supported.\n"); }
    break;

  case 5:
/* Line 1787 of yacc.c  */
#line 49 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (3)].node); }
    break;

  case 6:
/* Line 1787 of yacc.c  */
#line 51 "matlab.y"
    { (yyval.node) = createVariable("[]"); (yyval.node)->ignore = 1; fprintf(warn, "Statement using '[]' ignored, please avoid using this expression."); }
    break;

  case 7:
/* Line 1787 of yacc.c  */
#line 53 "matlab.y"
    { (yyval.node) = NULL; fatalError("Concatenation of arrays not suppored, since all array sizes are static."); }
    break;

  case 8:
/* Line 1787 of yacc.c  */
#line 58 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 9:
/* Line 1787 of yacc.c  */
#line 60 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 10:
/* Line 1787 of yacc.c  */
#line 62 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (2)].node); fprintf(warn,"Transpose ignored, only one-dimensional structures are supported.\n"); }
    break;

  case 11:
/* Line 1787 of yacc.c  */
#line 64 "matlab.y"
    { (yyval.node) = NULL; fatalError("Transpose not supported."); }
    break;

  case 12:
/* Line 1787 of yacc.c  */
#line 69 "matlab.y"
    { (yyval.node) = createVariable(":"); (yyval.node)->ignore = 1; }
    break;

  case 13:
/* Line 1787 of yacc.c  */
#line 71 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 14:
/* Line 1787 of yacc.c  */
#line 76 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 16:
/* Line 1787 of yacc.c  */
#line 82 "matlab.y"
    { 
          (yyval.node) = createOperation(getIdentifierType((yyvsp[(1) - (4)].iden)));
          appendChild((yyval.node), (yyvsp[(3) - (4)].node));
          setIdentifier((yyval.node), (yyvsp[(1) - (4)].iden));
        }
    break;

  case 17:
/* Line 1787 of yacc.c  */
#line 91 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 18:
/* Line 1787 of yacc.c  */
#line 93 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (2)].node); }
    break;

  case 19:
/* Line 1787 of yacc.c  */
#line 95 "matlab.y"
    {
          (yyval.node) = createOperation(TNEGATIVE);
          appendChild((yyval.node), (yyvsp[(2) - (2)].node));
        }
    break;

  case 20:
/* Line 1787 of yacc.c  */
#line 100 "matlab.y"
    {
          (yyval.node) = createOperation(TNOT);
          appendChild((yyval.node), (yyvsp[(2) - (2)].node));
        }
    break;

  case 21:
/* Line 1787 of yacc.c  */
#line 117 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 22:
/* Line 1787 of yacc.c  */
#line 119 "matlab.y"
    { 
          (yyval.node) = createOperation(TMUL);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 23:
/* Line 1787 of yacc.c  */
#line 125 "matlab.y"
    { 
          (yyval.node) = createOperation(TDIV);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 24:
/* Line 1787 of yacc.c  */
#line 131 "matlab.y"
    { (yyval.node) = NULL; fatalError("Backslash operator not supported."); }
    break;

  case 25:
/* Line 1787 of yacc.c  */
#line 133 "matlab.y"
    { 
          (yyval.node) = createOperation(TPOW);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 26:
/* Line 1787 of yacc.c  */
#line 139 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array multiplication not supported."); }
    break;

  case 27:
/* Line 1787 of yacc.c  */
#line 141 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array division not supported."); }
    break;

  case 28:
/* Line 1787 of yacc.c  */
#line 143 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array division not supported."); }
    break;

  case 29:
/* Line 1787 of yacc.c  */
#line 145 "matlab.y"
    { (yyval.node) = NULL; fatalError("Array power not supported."); }
    break;

  case 31:
/* Line 1787 of yacc.c  */
#line 151 "matlab.y"
    { 
          (yyval.node) = createOperation(TPLUS);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 32:
/* Line 1787 of yacc.c  */
#line 157 "matlab.y"
    { 
          (yyval.node) = createOperation(TMINUS);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 33:
/* Line 1787 of yacc.c  */
#line 166 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 34:
/* Line 1787 of yacc.c  */
#line 168 "matlab.y"
    { 
          (yyval.node) = createOperation(TLT_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 35:
/* Line 1787 of yacc.c  */
#line 174 "matlab.y"
    { 
          (yyval.node) = createOperation(TGT_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 36:
/* Line 1787 of yacc.c  */
#line 180 "matlab.y"
    { 
          (yyval.node) = createOperation(TLE_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 37:
/* Line 1787 of yacc.c  */
#line 186 "matlab.y"
    { 
          (yyval.node) = createOperation(TGE_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 38:
/* Line 1787 of yacc.c  */
#line 195 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 39:
/* Line 1787 of yacc.c  */
#line 197 "matlab.y"
    { 
          (yyval.node) = createOperation(TEQ_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 40:
/* Line 1787 of yacc.c  */
#line 203 "matlab.y"
    { 
          (yyval.node) = createOperation(TNE_OP);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 41:
/* Line 1787 of yacc.c  */
#line 212 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 42:
/* Line 1787 of yacc.c  */
#line 214 "matlab.y"
    { 
          (yyval.node) = createOperation(TAND);
          appendChild((yyval.node), (yyvsp[(1) - (4)].node));
          appendChild((yyval.node), (yyvsp[(4) - (4)].node));
        }
    break;

  case 43:
/* Line 1787 of yacc.c  */
#line 220 "matlab.y"
    { 
          (yyval.node) = createOperation(TAND);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 44:
/* Line 1787 of yacc.c  */
#line 229 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 45:
/* Line 1787 of yacc.c  */
#line 231 "matlab.y"
    { 
          (yyval.node) = createOperation(TOR);
          appendChild((yyval.node), (yyvsp[(1) - (4)].node));
          appendChild((yyval.node), (yyvsp[(4) - (4)].node));
        }
    break;

  case 46:
/* Line 1787 of yacc.c  */
#line 237 "matlab.y"
    { 
          (yyval.node) = createOperation(TOR);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 47:
/* Line 1787 of yacc.c  */
#line 246 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 48:
/* Line 1787 of yacc.c  */
#line 248 "matlab.y"
    { 
          (yyval.node) = createOperation(TRANGE);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 49:
/* Line 1787 of yacc.c  */
#line 257 "matlab.y"
    { 
          (yyval.node) = createOperation(TASSIGN);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 54:
/* Line 1787 of yacc.c  */
#line 273 "matlab.y"
    { fprintf(warn, "Global Statement not supported.\n"); }
    break;

  case 55:
/* Line 1787 of yacc.c  */
#line 275 "matlab.y"
    { fprintf(warn, "Clear Statement not supported.\n"); }
    break;

  case 56:
/* Line 1787 of yacc.c  */
#line 277 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 57:
/* Line 1787 of yacc.c  */
#line 279 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 58:
/* Line 1787 of yacc.c  */
#line 281 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 59:
/* Line 1787 of yacc.c  */
#line 283 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 60:
/* Line 1787 of yacc.c  */
#line 285 "matlab.y"
    { fprintf(warn, "Jump Statement not supported.\n"); }
    break;

  case 61:
/* Line 1787 of yacc.c  */
#line 290 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (1)].node); }
    break;

  case 62:
/* Line 1787 of yacc.c  */
#line 292 "matlab.y"
    { (yyval.node) = appendStatement((yyvsp[(1) - (2)].node), (yyvsp[(2) - (2)].node)); }
    break;

  case 66:
/* Line 1787 of yacc.c  */
#line 306 "matlab.y"
    { fprintf(warn, "Warning: Clear statement ignored.\n"); }
    break;

  case 67:
/* Line 1787 of yacc.c  */
#line 311 "matlab.y"
    { (yyval.node) = NULL; }
    break;

  case 68:
/* Line 1787 of yacc.c  */
#line 313 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (2)].node); }
    break;

  case 69:
/* Line 1787 of yacc.c  */
#line 318 "matlab.y"
    { (yyval.node) = (yyvsp[(1) - (2)].node); }
    break;

  case 74:
/* Line 1787 of yacc.c  */
#line 333 "matlab.y"
    { 
          (yyval.node) = createOperation(TIF);
          appendChild((yyval.node), (yyvsp[(2) - (5)].node));
          appendChild((yyval.node), createOperation(TIFBODY));
          appendChild((yyval.node)->children->next, (yyvsp[(3) - (5)].node));
        }
    break;

  case 75:
/* Line 1787 of yacc.c  */
#line 340 "matlab.y"
    { 
          (yyval.node) = createOperation(TIFELSE);
          appendChild((yyval.node), (yyvsp[(2) - (7)].node));
          appendChild((yyval.node), createOperation(TIFBODY));
          appendChild((yyval.node)->children->next, (yyvsp[(3) - (7)].node));
          appendChild((yyval.node), createOperation(TIFBODY));
          appendChild((yyval.node)->children->next->next, (yyvsp[(5) - (7)].node));
        }
    break;

  case 76:
/* Line 1787 of yacc.c  */
#line 349 "matlab.y"
    { 
          (yyval.node) = createOperation(TIFELSEIF);
          appendChild((yyval.node), (yyvsp[(2) - (6)].node));
          appendChild((yyval.node), (yyvsp[(3) - (6)].node));
          appendChild((yyval.node), (yyvsp[(4) - (6)].node));
        }
    break;

  case 77:
/* Line 1787 of yacc.c  */
#line 357 "matlab.y"
    { 
          (yyval.node) = createOperation(TIFELSEIFELSE);
          appendChild((yyval.node), (yyvsp[(2) - (8)].node));
          appendChild((yyval.node), (yyvsp[(3) - (8)].node));
          appendChild((yyval.node), (yyvsp[(4) - (8)].node));
          appendChild((yyval.node), (yyvsp[(6) - (8)].node));
        }
    break;

  case 78:
/* Line 1787 of yacc.c  */
#line 368 "matlab.y"
    { 
          (yyval.node) = createOperation(TELSEIF);
          appendChild((yyval.node), (yyvsp[(2) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;

  case 79:
/* Line 1787 of yacc.c  */
#line 374 "matlab.y"
    {
          struct Node *n = createOperation(TELSEIF);
          appendChild((yyval.node), (yyvsp[(3) - (4)].node));
          appendChild((yyval.node), (yyvsp[(4) - (4)].node));
          (yyval.node) = appendStatement((yyvsp[(1) - (4)].node), n);
        }
    break;

  case 80:
/* Line 1787 of yacc.c  */
#line 384 "matlab.y"
    { 
          (yyval.node) = createOperation(TWHILE);
          appendChild((yyval.node), (yyvsp[(2) - (5)].node));
          appendChild((yyval.node), (yyvsp[(3) - (5)].node));
        }
    break;

  case 81:
/* Line 1787 of yacc.c  */
#line 390 "matlab.y"
    {
          (yyval.node) = createOperation(TFOR);
          appendChild((yyval.node), (yyvsp[(4) - (7)].node));
          appendChild((yyval.node), (yyvsp[(5) - (7)].node));
          setIdentifier((yyval.node), (yyvsp[(2) - (7)].iden));
        }
    break;

  case 82:
/* Line 1787 of yacc.c  */
#line 397 "matlab.y"
    {
          (yyval.node) = createOperation(TFOR);
          appendChild((yyval.node), (yyvsp[(5) - (9)].node));
          appendChild((yyval.node), (yyvsp[(7) - (9)].node));
          setIdentifier((yyval.node), (yyvsp[(3) - (9)].iden));
        }
    break;

  case 85:
/* Line 1787 of yacc.c  */
#line 412 "matlab.y"
    { fatalError("The file should provide a function, not a script."); }
    break;

  case 86:
/* Line 1787 of yacc.c  */
#line 414 "matlab.y"
    { 
          processFunctionHeader((yyvsp[(2) - (4)].node));
          functionToFortran((yyvsp[(4) - (4)].node));
          if (createJac == 1) {
            functionToJacobian((yyvsp[(4) - (4)].node));
          }
          /*fprintf(warn, "\n"); print_tree(0, $4); fprintf(warn, "\n");*/
        }
    break;

  case 87:
/* Line 1787 of yacc.c  */
#line 426 "matlab.y"
    { 
          (yyval.node) = createOperation(TLIST);
          appendChild((yyval.node), createVariable((yyvsp[(1) - (1)].iden)));
        }
    break;

  case 88:
/* Line 1787 of yacc.c  */
#line 431 "matlab.y"
    {
          (yyval.node) = (yyvsp[(1) - (3)].node);
          appendChild((yyvsp[(1) - (3)].node), createVariable((yyvsp[(3) - (3)].iden)));
        }
    break;

  case 89:
/* Line 1787 of yacc.c  */
#line 439 "matlab.y"
    {
          (yyval.node) = createOperation(TLIST);
          appendChild((yyval.node), createVariable((yyvsp[(1) - (1)].iden)));
        }
    break;

  case 90:
/* Line 1787 of yacc.c  */
#line 444 "matlab.y"
    { (yyval.node) = (yyvsp[(2) - (3)].node); }
    break;

  case 91:
/* Line 1787 of yacc.c  */
#line 449 "matlab.y"
    { fatalError("Incorrect number of input arguments."); }
    break;

  case 92:
/* Line 1787 of yacc.c  */
#line 451 "matlab.y"
    { fatalError("Incorrect number of input arguments."); }
    break;

  case 93:
/* Line 1787 of yacc.c  */
#line 453 "matlab.y"
    { (yyval.node) = (yyvsp[(3) - (4)].node); }
    break;

  case 95:
/* Line 1787 of yacc.c  */
#line 459 "matlab.y"
    {
          (yyval.node) = createOperation(TFUNCDEC);
          appendChild((yyval.node), (yyvsp[(1) - (3)].node));
          appendChild((yyval.node), (yyvsp[(3) - (3)].node));
        }
    break;


/* Line 1787 of yacc.c  */
#line 2254 "y.tab.c"
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
#line 466 "matlab.y"


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

int main(unsigned int argc, unsigned char *argv[]) {
  warn = stderr;
  out = stdout;
  labelcount = 10;
  func = emalloc(sizeof(*func));
  func->neq = "neq";
  func->np = "np";
  func->j = "j";
  vars = NULL;
  simplifyStateSize = 3;
  knownFunctions = NULL;
  initializeKnownFunctions();

  createJac = 1;
  if (argc > 1) {
    if (strcmp(argv[1], "0") == 0) {
      createJac = 0;
    }
  }

  yyparse();
  return 0;
}
