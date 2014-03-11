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

void setIdentifier(struct Node *node, char *identifier) {
  node->iname = identifier;
}

struct Node *createConstant(struct NumSpec *num) {
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

struct Node *createVariable(char *varname) {
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

struct Node *appendStatement(struct Node *prevnodes, struct Node *newnode) {
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
