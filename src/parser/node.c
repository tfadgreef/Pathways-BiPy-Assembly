#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "node.h"
#include "tree.h"

struct Node *last(struct Node *t) {
  struct Node *tmp = t;
  while (tmp->next != NULL) {
    tmp = tmp->next;
  }
  return tmp;
}

struct Node *createOperation(enum NodeTag op) {
  struct Node *t = emalloc(sizeof(*t));
    
  t->tag = op;
  t->previous = NULL;
  t->next = NULL;
  t->ignore = 0;
  t->children = NULL;
  t->parent = NULL;

  return t;
}

void appendChild(struct Node *parent, struct Node *child) {
  if (parent == NULL || child == NULL)
    return;
  
  if (parent->children == NULL) {
    parent->children = child;
  } else {
    struct Node *l = last(parent->children);
    l->next = child;
    child->previous = l;
  }
  
  child->parent = parent;
  
  if (child->tag != TASSIGN && parent->ignore == 0 && child->ignore == 1) {
    parent->ignore = 1;
  }
}

struct Node *addOperation(enum NodeTag op, struct Node *l, struct Node *r) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = op;
    t->previous = NULL;
    t->next = NULL;
  
    if (l != NULL && r != NULL) {
      t->ignore = (((l->ignore == 0 || l->tag == TASSIGN) && (r->ignore == 0 || r->tag == TASSIGN)) ? 0 : 1);
    } else if (l == NULL && r != NULL) {
      t->ignore = ((r->ignore == 0 || r->tag == TASSIGN) ? 0 : 1);
    } else if (l != NULL && r == NULL) {
      t->ignore = ((l->ignore == 0 || l->tag == TASSIGN) ? 0 : 1);
    } else {
      t->ignore = 0;
    }
    
    if (l != NULL && r != NULL) {
      l->next = r;
      r->previous = l;
    }
    
    if (l == NULL) {
      t->children = r;
    } else {
      t->children = l;
    }
    
    t->children = l;
    return t;
}

struct Node *addOperation3(enum NodeTag op, struct Node *l, struct Node *m, struct Node *r) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = op;
    t->previous = NULL;
    t->next = NULL;
    
    t->ignore = (((l->ignore == 0 || l->tag == TASSIGN) && (m->ignore == 0 || m->tag == TASSIGN) && (r->ignore == 0 || r->tag == TASSIGN)) ? 0 : 1);
    
    l->next = m;
    m->next = r;
    r->previous = m;
    m->previous = l;
    
    l->parent = t;
    m->parent = t;
    r->parent = t;
    t->children = l;
    return t;
}

struct Node *addOperation4(enum NodeTag op, struct Node *l, struct Node *lm, struct Node *rm, struct Node *r) {
    struct Node *t = emalloc(sizeof(*t));
    struct Node *tmp;
    
    t->tag = op;
    t->previous = NULL;
    t->next = NULL;
    
    t->ignore = (((l->ignore == 0 || l->tag == TASSIGN) && (lm->ignore == 0 || lm->tag == TASSIGN) && (rm->ignore == 0 || rm->tag == TASSIGN) && (r->ignore == 0 || r->tag == TASSIGN)) ? 0 : 1);
    
    tmp = l;
    while (tmp->next != NULL) {
      tmp->parent = t;
      tmp = tmp->next;
    }
    tmp->next = lm;
    lm->previous = tmp;

    tmp = lm;
    while (tmp->next != NULL) {
      tmp->parent = t;
      tmp = tmp->next;
    }
    tmp->next = rm;
    rm->previous = tmp;
    
    tmp = rm;
    while (tmp->next != NULL) {
      tmp->parent = t;
      tmp = tmp->next;
    }
    tmp->next = r;
    r->previous = tmp;

    t->children = l;
    return t;
}

struct Node *addOperationWithIdentifier(enum NodeTag op, struct Node *l, struct Node *r, char *identifier) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = op;
    t->iname = identifier;
    t->previous = NULL;
    t->next = NULL;
    t->parent = NULL;
    
    if (l != NULL && r != NULL) {
      t->ignore = (((l->ignore == 0 || l->tag == TASSIGN) && (r->ignore == 0 || r->tag == TASSIGN)) ? 0 : 1);
    } else if (l == NULL && r != NULL) {
      t->ignore = ((r->ignore == 0 || r->tag == TASSIGN) ? 0 : 1);
    } else if (l != NULL && r == NULL) {
      t->ignore = ((l->ignore == 0 || l->tag == TASSIGN) ? 0 : 1);
    } else {
      t->ignore = 0;
    }
    
    if (l != NULL && r != NULL) {
      l->next = r;
      r->previous = l;
    }
    
    if (l != NULL) {
      l->parent = t;
    }
    if (r != NULL) {
      r->parent = t;
    }
    if (l == NULL) {
      t->children = r;
    } else {
      t->children = l;
    }
    return t;
}

struct Node *addConstant(struct NumSpec *num) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = TNUM;
    t->ival = num->value;
    t->signif = num->signif;
    t->previous = NULL;
    t->next = NULL;
    t->parent = NULL;
    t->children = NULL;
    t->ignore = 0;
    return t;
}

struct Node *addVariable(char *varname) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = TVAR;
//     t->iname = emalloc(sizeof(char) * strlen(varname));
//     strcpy(t->iname, varname);
    t->iname = varname;
    t->previous = NULL;
    t->next = NULL;
    t->parent = NULL;
    t->children = NULL;
    t->ignore = 0;
    return t;
}

struct Node *addStub() {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = TSTUB;
    t->previous = NULL;
    t->next = NULL;
    t->parent = NULL;
    t->children = NULL;
    return t;
}

struct Node *addStatement(struct Node *prevnodes, struct Node *newnode) {
    if (newnode != NULL && prevnodes != NULL && newnode != prevnodes) {
      struct Node *nd = prevnodes;
      while (nd->next != NULL) {
        nd = nd->next;
      }
      nd->next = newnode;
      newnode->previous = nd;
      newnode->parent = nd->parent;
    } else if (newnode != NULL) {
        return newnode;
    }
    return prevnodes;
}
