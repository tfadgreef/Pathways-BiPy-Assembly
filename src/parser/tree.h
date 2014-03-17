// Data structures for syntax trees.

#include "stdio.h"

#define MIN(x, y) (((x) < (y)) ? (x) : (y))

FILE * warn;
FILE * out;

int labelcount;

struct Node;

enum VariableType {
  TDOUBLE, TINT, TDOUBLEARRAY
};

struct Variable {
  enum VariableType type;
  struct Variable *next;
  struct Variable *previous;
  char *iname;
  struct Node *rel;
  int zero;
};

struct Func {
  char *t;
  char *x;
  char *p;
  char *dx;
  
  char *neq;
  char *np;
  
  char *j;
};

struct Func *func;

void *emalloc(size_t nbytes);

void fatalError(char *message);

void print_tree(int d, struct Node *t);

struct Variable *vars;
struct Variable *registerVariable(char *s, enum VariableType tp);
char *processIdentifier(char *nm, enum VariableType tp);

void processDependentVectorIdentifier(char *s, struct Node *rel);

void processFunctionHeader(struct Node* f);
struct Node *getRelativeToY(char *s);

