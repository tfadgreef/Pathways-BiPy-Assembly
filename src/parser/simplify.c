#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "simplify.h"
#include "jacobian.h"
#include "fortran.h"
#include "tree.h"
#include "node.h"

void simplifyStructure(struct Node *t) {
  enum SimplifyState i;
  for (i = 0; i < simplifyStateSize; i = i + 1) {
    struct Node *pntr = t;
    while (pntr != NULL) {
      switch (i) {
        case ZeroAssignments:
          S_zeroAssignments(pntr);
          pntr = pntr->next;
          break;
        case ReplaceZeroAssignments:
          if (S_replaceZeroAssignments(pntr) == 0) {
            pntr = pntr->next;
          }
          break;
        case RemovePlusZero:
          S_removePlusZero(pntr);
          pntr = pntr->next;
          break;
        default:
          pntr = pntr->next;
          break;
      }
    }
  }
}

void S_zeroAssignments(struct Node *t) {
  if (t == NULL)
    return;
  
  if (t->tag == TASSIGN) {
    char *name = t->children->iname;
    int zero = 0;
    if (t->children->next->tag == TNUM) {
      if (t->children->next->ival == 0.0) {
        zero = 1;
      }
    }
    registerVariable(name, TDOUBLE);
    registerZeroVar(name, zero);
  } else if (t->tag == TFOR) {
    struct Node *pntr = t->children->next;
    while (pntr != NULL) {
      S_zeroAssignments(pntr);
      pntr = pntr->next;
    }
  } else if (t->tag == TIF) {
    S_zeroAssignments(t->children->next);
  } else if (t->tag == TIFELSE) {
    S_zeroAssignments(t->children->next->next);
  } else if (t->tag == TCOMBINE) {
    struct Node *pntr = t->children;
    while (pntr != NULL) {
      S_zeroAssignments(pntr);
      pntr = pntr->next;
    }
  }
}

void registerZeroVar(char *s, int zero) {
    if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0) {
    if (vars == NULL) {
      return;
    } else {
      struct Variable *tmp = vars;
      while (tmp != NULL) {
        if (strcmp(tmp->iname, s) == 0) {
          if (tmp->zero == -1) {
            tmp->zero = zero;
          } else if (tmp->zero == 1 && zero == 0) {
            tmp->zero = 0;
          }
          return;
        }
        tmp = tmp->next;
      }
      fprintf(warn, "VARIABLE: %s\n", s);
      fatalError("Internal error: Variable not found.");
    }
  }
}

int getVariableZero(char *s) {
    if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0) {
    if (vars == NULL) {
      return 0;
    } else {
      struct Variable *tmp = vars;
      while (tmp != NULL) {
        if (strcmp(tmp->iname, s) == 0) {
          return tmp->zero;
        }
        tmp = tmp->next;
      }
      //fprintf(warn, "VARIABLE: %s\n", s);
      return -1;
    }
  }
  return 0;
}

int S_replaceZeroAssignments(struct Node *t) {
  if (t == NULL)
    return 0;
  
  if (t->tag == TASSIGN) {
    char *name = t->children->iname;
    if (getVariableZero(name) == 1) {
      removeNode(t);
      return 1;
    }
  } else if (t->tag == TVAR) {
    char *name = t->iname;
    if (getVariableZero(name) == 1) {
      
      free(t->iname);
      t->iname = NULL;
      
      t->tag = TNUM;
      t->ival = 0.0;
      
      return 1;
    }
  }
  struct Node *pntr = t->children;
  while (pntr != NULL) {
    if (S_replaceZeroAssignments(pntr) == 0) {
      pntr = pntr->next;
    }
  }
  return 0;
}

void S_removePlusZero(struct Node *t) {
  if (t == NULL)
    return;
  
  struct Node *pntr = t->children;
  while (pntr != NULL) {
    S_removePlusZero(pntr);
    pntr = pntr->next;
  }
  
  if (t->tag == TPLUS || t->tag == TMUL || t->tag == TMINUS || t->tag == TNEGATIVE) {
    if (
      (
        (t->tag == TPLUS || t->tag == TMUL)
        &&
        ((t->children->tag == TNUM && t->children->ival == 0.0) || (t->children->next->tag == TNUM && t->children->next->ival == 0.0))
      )
      ||
      (
        t->tag == TMINUS
        && 
        (t->children->next->tag == TNUM && t->children->next->ival == 0.0)
      )
      ||
      (
        (t->tag == TMUL)
        &&
        ((t->children->tag == TNUM && t->children->ival == 1.0) || (t->children->next->tag == TNUM && t->children->next->ival == 1.0))
      )
      ||
      (
        (t->tag == TNEGATIVE)
        &&
        (t->children->tag == TNUM && t->children->ival == 0.0)
      )
    ) {
      struct Node *obs;
      struct Node *nod;
      
      if (t->tag == TPLUS && t->children->tag == TNUM && t->children->ival == 0.0) {
        obs = t->children;
        nod = t->children->next;
      } else if (t->tag == TPLUS && t->children->next->tag == TNUM && t->children->next->ival == 0.0) {
        nod = t->children;
        obs = t->children->next;
      } else if (t->tag == TMUL && t->children->tag == TNUM && t->children->ival == 0.0) {
        nod = t->children;
        obs = t->children->next;
      } else if (t->tag == TMUL && t->children->next->tag == TNUM && t->children->next->ival == 0.0) {
        obs = t->children;
        nod = t->children->next;
      } else if (t->tag == TMINUS && (t->children->next->tag == TNUM && t->children->next->ival == 0.0)) {
        nod = t->children;
        obs = t->children->next;
      } else if ((t->tag == TMUL) && (t->children->tag == TNUM && t->children->ival == 1.0)) {
        obs = t->children;
        nod = t->children->next;
      } else if ((t->tag == TMUL) && (t->children->next->tag == TNUM && t->children->next->ival == 1.0)) {
        nod = t->children;
        obs = t->children->next;
      } else if ((t->tag == TNEGATIVE) && (t->children->tag == TNUM && t->children->ival == 0.0)) {
        nod = t->children;
        obs = NULL;
      }
      
      struct Node *parent = t->parent;
      
      nod->parent = parent;
      if (t->previous != NULL) {
        t->previous->next = nod;
      }
      nod->previous = t->previous;
      if (t->next != NULL) {
        t->next->previous = nod;
      }
      nod->next = t->next;
      
      if (parent->children == t) {
        parent->children = nod;
      }
      
      if (obs != NULL) {
        free(obs->iname);
        free(obs);
      }
      free(t);
    }
  }
}
