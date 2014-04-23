#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "node.h"
#include "tree.h"
#include "fortran.h"

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
  t->iname = NULL;
  t->ival = 0;

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
  node->iname = emalloc(sizeof(char) * strlen(identifier));
  strcpy(node->iname, identifier);
//  node->iname = identifier;
}

struct Node *createConstant(double num) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = TNUM;
    t->ival = num;
    t->iname = NULL;
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
//    t->iname = varname;
    setIdentifier(t, varname);
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

struct Node *copyNode(struct Node *n) {
  struct Node *r = emalloc(sizeof(*r));
  r->tag = n->tag;
  r->ival = n->ival;
  if (n->iname == NULL) {
    r->iname = NULL;
  }else {
    r->iname = emalloc(sizeof(char) * strlen(n->iname));
    strcpy(r->iname, n->iname);
  }
  r->ignore = n->ignore;
  
  r->next = NULL;
  r->previous = NULL;
  r->children = NULL;
  r->parent = NULL;
  
  struct Node *tmp = n->children;
  while (tmp != NULL) {
    appendChild(r, copyNode(tmp));
    tmp = tmp->next;
  }
  
  return r;
}

struct Node *findVariable(struct Node *n) {
  struct Node *occ = NULL;
  struct Node *tmp = n;
  
  
    if (n->tag == TARRAYINDEX || n->tag == TVAR) {
      if (strcmp(n->iname, func->x) == 0 ) { //|| strcmp(n->iname, func->dx) == 0
        struct Node *pntr = createOperation(TMISC);
        pntr->children = n;
        occ = appendStatement(occ, pntr);
      }
//       else {
//         struct Variable *tmpvar = vars;
//         while (tmpvar != NULL) {
//           if (tmpvar->rel != NULL) {
//             if (strcmp(n->iname, tmpvar->iname) == 0) {
//               struct Node *pntr = createOperation(TMISC);
//               pntr->children = n;
//               occ = appendStatement(occ, pntr);
//             }
//           }
//           tmpvar = tmpvar->next;
//         }
//       }
    } else {
      tmp = n->children;
      while (tmp != NULL) {
        occ = appendStatement(occ, findVariable(tmp));
        tmp = tmp->next;
      }
    }
  
  return occ;
}

int compareNodes(struct Node *n1, struct Node *n2) {
  if (n1 != n2 && (n1 == NULL || n2 == NULL))
      return 0;
  
  if (n1->tag != n2->tag)
    return 0;
  if (n1->tag == TNUM && n1->ival != n2->ival)
    return 0;
  if (n1->ignore != n2->ignore)
    return 0;

  if (n1->iname != n2->iname && (n1->iname == NULL || n2->iname == NULL))
    return 0;
  if (n1->iname != NULL && n2->iname != NULL) {
    if (strcmp(n1->iname, n2->iname) != 0) {
      return 0;
    }
  }
  struct Node *tmpn1 = n1->children;
  struct Node *tmpn2 = n2->children;
  if (tmpn1 != tmpn2 && (tmpn1 == NULL || tmpn2 == NULL))
      return 0;
  
  while (tmpn1 != NULL && tmpn2 != NULL) {
    if (compareNodes(tmpn1, tmpn2) == 0)
      return 0;
    tmpn1 = tmpn1->next;
    tmpn2 = tmpn2->next;
    if (tmpn1 != tmpn2 && (tmpn1 == NULL || tmpn2 == NULL))
      return 0;
  }
  return 1;
}

void removeNode(struct Node *n) {
  if (n == NULL)
    return;
  
  if (n->previous != NULL) {
    n->previous->next = n->next;
  }
  if (n->next != NULL) {
    n->next->previous = n->previous;
  }
  
  struct Node *tmp;
  while(n->children != NULL) {
    tmp = n->children;
    n->children = n->children->next;
    removeNode(tmp);
  }
  
  free(n->iname);
  free(n);
}
