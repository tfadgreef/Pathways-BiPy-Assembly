#ifndef NODE_H
#define NODE_H

enum NodeTag {
  TPLUS, TMINUS, TMUL, TDIV, TPOW, TNUM, TVAR, TFOR, TWHILE, TASSIGN, 
  TRANGE, TOR, TAND, TEQ_OP, TNE_OP, TGT_OP, TLT_OP, TGE_OP, TLE_OP,
  TIF, TIFELSE, TIFELSEIF, TELSEIF, TIFELSEIFELSE, TARRAYINDEX, TLIST,
  TFUNCDEC, TMISC, TCOMBINE, TNOT, TNEGATIVE
};

struct Node {
  enum NodeTag tag;
  struct Node *next;
  struct Node *previous;
  struct Node *children;
  struct Node *parent;
  double ival;
  char *iname;
  int ignore;
};

struct Node *createOperation(enum NodeTag op);
void appendChild(struct Node *parent, struct Node *child);
void setIdentifier(struct Node *node, char *identifier);
struct Node *last(struct Node *t);

struct Node *createConstant(double num);
struct Node *createVariable(char *varname);
struct Node *appendStatement(struct Node *prevnodes, struct Node *newnode);

struct Node *copyNode(struct Node *n);
void removeNode(struct Node *n);
struct Node *findVariable(struct Node *n);

int compareNodes(struct Node *n1, struct Node *n2);

#endif // NODE_H