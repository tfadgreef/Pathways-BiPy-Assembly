// Data structures for syntax trees.

#include "stdio.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

FILE * warn;
FILE * out;

int labelcount;

enum node_tag {
  TPLUS, TMINUS, TMUL, TDIV, TNUM, TVAR, TFOR, TWHILE, TASSIGN, TRANGE,
  TOR, TAND, TEQ_OP, TNE_OP, TGT_OP, TLT_OP, TGE_OP, TLE_OP, TSTUB,
  TIF, TIFELSE, TIFELSEIF, TELSEIF, TIFELSEIFELSE, TARRAYINDEX, TLIST,
  TFUNCDEC
};

enum VariableType {
  TDOUBLE, TINT
};

struct NumSpec {
  double value;
  int signif;
};

struct Node {
  enum node_tag tag;
  struct Node *next;
  struct Node *previous;
  struct Node *children;
  struct Node *parent;
  double ival;
  char *iname;
  int signif;
  int ignore;
};

struct Variable {
  enum VariableType type;
  struct Variable *next;
  struct Variable *previous;
  char *iname;
};

struct Func {
  char *t;
  char *x;
  char *p;
  char *dx;
};

struct Func *func;

void *emalloc(size_t nbytes);

void fatalError(char *message);

struct Node *addConstant(struct NumSpec *num);
struct Node *addVariable(char *varname);
struct Node *addStub();

struct Node *addOperation(enum node_tag op, struct Node *l, struct Node *r);
struct Node *addOperation3(enum node_tag op, struct Node *l, struct Node *m, struct Node *r);
struct Node *addOperation4(enum node_tag op, struct Node *l, struct Node *lm, struct Node *rm, struct Node *r);
struct Node *addOperationWithIdentifier(enum node_tag op, struct Node *l, struct Node *r, char *identifier);
struct Node *addStatement(struct Node *prevnodes, struct Node *newnode);

void print_tree(int d, struct Node *t);

char *line(int label, char *content);

double eval(struct Node *t);

struct Variable *vars;
void registerVariable(char *s, enum VariableType tp);
char *processIdentifier(char *nm, enum VariableType tp);

char *toFortran(struct Node *t);
void functionToFortran(struct Node *f, struct Node *t);
char *F_plus(char *s1, char *s2);
char *F_minus(char *s1, char *s2);
char *F_mul(char *s1, char *s2);
char *F_div(char *s1, char *s2);
char *F_eq_op(char *s1, char *s2);
char *F_ne_op(char *s1, char *s2);
char *F_gt_op(char *s1, char *s2);
char *F_ge_op(char *s1, char *s2);
char *F_lt_op(char *s1, char *s2);
char *F_le_op(char *s1, char *s2);
char *F_assign(char *s1, char *s2);
char *F_for(char *s1, char *s2, char *s3);
char *F_range(char *s1, char *s2, char *s3);
char *F_while(char *s1, char *s2);
char *F_and(char *s1, char *s2);
char *F_or(char *s1, char *s2);
char *F_if(char *s1, char *s2);
char *F_ifelse(char *s1, char *s2, char *s3);
char *F_ifelseif(char *s1, char *s2, char *s3);
char *F_elseif(char *s1, char *s2);
char *F_ifelseifelse(char *s1, char *s2, char *s3, char *s4);
char *F_arrayindex(char *s1, char *s2);
char *F_zeros(char *s1);
