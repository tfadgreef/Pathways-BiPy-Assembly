#ifndef NODE_H
#define NODE_H

enum NodeTag {
  TPLUS, TMINUS, TMUL, TDIV, TNUM, TVAR, TFOR, TWHILE, TASSIGN, TRANGE,
  TOR, TAND, TEQ_OP, TNE_OP, TGT_OP, TLT_OP, TGE_OP, TLE_OP, TSTUB,
  TIF, TIFELSE, TIFELSEIF, TELSEIF, TIFELSEIFELSE, TARRAYINDEX, TLIST,
  TFUNCDEC
};

struct NumSpec {
  double value;
  int signif;
};

struct Node {
  enum NodeTag tag;
  struct Node *next;
  struct Node *previous;
  struct Node *children;
  struct Node *parent;
  double ival;
  char *iname;
  int signif;
  int ignore;
};

// NEW

struct Node *createOperation(enum NodeTag op);
void appendChild(struct Node *parent, struct Node *child);
void setIdentifier(struct Node *node, char *identifier);
struct Node *last(struct Node *t);

// ENDNEW

struct Node *addConstant(struct NumSpec *num);
struct Node *addVariable(char *varname);
struct Node *addStub();

struct Node *addOperation(enum NodeTag op, struct Node *l, struct Node *r);
struct Node *addOperation3(enum NodeTag op, struct Node *l, struct Node *m, struct Node *r);
struct Node *addOperation4(enum NodeTag op, struct Node *l, struct Node *lm, struct Node *rm, struct Node *r);
struct Node *addOperationWithIdentifier(enum NodeTag op, struct Node *l, struct Node *r, char *identifier);
struct Node *addStatement(struct Node *prevnodes, struct Node *newnode);

#endif // NODE_H