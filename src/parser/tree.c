// Data structures for syntax trees.
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"
#include "fortran.h"
#include "jacobian.h"
#include "node.h"

void *emalloc(size_t nbytes) {
    void *p = malloc(nbytes);
    if (p == NULL) {
	perror("malloc");
	exit(1);
    }
    return p;
}

void fatalError(char *message) {
  fprintf(warn, "ERROR: %s\n", message);
  exit(1);
}

void depth(int d) {
  if (d == 0) 
    fprintf(warn, "\n");
  else
    fprintf(warn, "\n%*c", d, 32);
}

void print_tree(int d, struct Node *t) {
  struct Node *nd = t;
  while (nd != NULL) {
    depth(d);
    if (nd->tag == TNUM) {
      fprintf(warn, "%f", nd->ival);
    } else if (nd->tag == TVAR) {
      fprintf(warn, "%s", nd->iname);
    }else {
      switch (nd->tag) {
        case TPLUS : fprintf(warn, "+"); break;
        case TMINUS : fprintf(warn, "-"); break;
        case TMUL : fprintf(warn, "*"); break;
        case TDIV : fprintf(warn, "/"); break;
        case TPOW : fprintf(warn, "^"); break;
        case TFOR : fprintf(warn, "FOR[%s]", t->iname); break;
        case TWHILE : fprintf(warn, "WHILE"); break;
        case TASSIGN : fprintf(warn, "="); break;
        case TRANGE : fprintf(warn, ":"); break;
        case TOR : fprintf(warn, "|"); break;
        case TAND : fprintf(warn, "&"); break;
        case TIF : fprintf(warn, "IF"); break;
        case TIFELSE : fprintf(warn, "IFELSE"); break;
        case TIFELSEIF : fprintf(warn, "IFELSEIF"); break;
        case TIFELSEIFELSE : fprintf(warn, "IFELSEIFELSE"); break;
        case TELSEIF : fprintf(warn, "ELSEIF"); break;
        case TARRAYINDEX : fprintf(warn, "ARRAYINDEX: '%s'", nd->iname); break;
        case TEQ_OP : fprintf(warn, "=="); break;
        case TNE_OP : fprintf(warn, "!="); break;
        case TGT_OP : fprintf(warn, ">"); break;
        case TGE_OP : fprintf(warn, ">="); break;
        case TLT_OP : fprintf(warn, "<"); break;
        case TLE_OP : fprintf(warn, "<="); break;
        case TLIST : fprintf(warn, "LIST"); break;
        case TFUNCDEC : fprintf(warn, "FUNCDEC"); break;
        default: fprintf(warn, "???");
      }
      print_tree(d+1, nd->children);
    }
    nd = nd->next;
  }
}

struct Variable *registerVariable(char *s, enum VariableType tp) {
  if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0) {
    if (vars == NULL) {
      vars = emalloc(sizeof(*vars));
      vars->next = NULL;
      vars->previous = NULL;
      vars->iname = emalloc(sizeof(char) * strlen(s));
      vars->type = tp;
      vars->rel = NULL;
      vars->zero = -1;
      strcpy(vars->iname, s);
      return vars;
    } else {
      struct Variable *tmp = vars;
      while (1) {
        if (strcmp(tmp->iname, s) == 0) {
          if (tmp->type == TDOUBLE && tp == TINT) {
            tmp->type = TINT;
          } else if ((tmp->type == TDOUBLE || tmp->type == TINT) && tp == TDOUBLEARRAY) {
            tmp->type = TDOUBLEARRAY;
          }
          return tmp;
        }
        if (tmp->next == NULL)
          break;
        tmp = tmp->next;
      }
      tmp->next = emalloc(sizeof(*tmp->next));
      tmp->next->previous = tmp;
      
      tmp = tmp->next;
      tmp->next = NULL;
      
      tmp->iname = emalloc(sizeof(*tmp));
      strcpy(tmp->iname, s);
      tmp->type = tp;
      tmp->rel = NULL;
      tmp->zero = -1;
      return tmp;
    }
  }
  return NULL;
}

char *processIdentifier(char *nm, enum VariableType tp) {
  char *s;
  asprintf(&s, "%s", nm);
  registerVariable(nm, tp);
  return s;
}

void processFunctionHeader(struct Node* f) {
  func = emalloc(sizeof(*func));
  func->neq = "neq";
  func->np = "np";
  func->j = "j";
  
  struct Node *nodep = f->children->next->children;
  int count = 1;
  
  while (nodep != NULL) {
    switch (count) {
      case 1 : func->t = nodep->iname; break;
      case 2 : func->x = nodep->iname; break;
      case 3 : func->p = nodep->iname; break;
      case 4 : func->neq = nodep->iname; break;
      case 5 : func->np = nodep->iname; break;
      default : fatalError("Too many input arguments.");
    }
    
    nodep = nodep->next;
    count++;
  }
  if (count < 4) {
    fatalError("Too few input arguments.");
  }
  
  if (f->children->children != NULL) {
    func->dx = f->children->children->iname;
  }
}

void processDependentVectorIdentifier(char *s, struct Node *rel) {
  if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0) {
    if (vars == NULL) {
      fatalError("Internal error: No variables available.");
    } else {
      struct Variable *tmp = vars;
      while (1) {
        if (strcmp(tmp->iname, s) == 0) {
          if (tmp->rel == NULL) {
            tmp->rel = copyNode(rel);
            fprintf(warn, "Vector '%s' (%s) relative to Y.\n", s, toFortran(rel));
          } else {
            fprintf(warn, "Relative record of '%s' already exists, ignoring new one.\n", s);
          }
          return;
        }
        if (tmp->next == NULL)
          break;
        tmp = tmp->next;
      }
      fprintf(warn, "Trying to find '%s' (%s) relative to Y.\n", s, toFortran(rel));
      fatalError("Internal error: Variable not found.");
    }
  }
}

struct Node *getRelativeToY(char *s) {
  if (strcmp(s, func->t) != 0 != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0) {
    if (strcmp(s, func->x) == 0) {
      return createConstant(1.0);
    }
    if (vars == NULL) {
      fatalError("Internal error: No variables available.");
    } else {
      struct Variable *tmp = vars;
      while (tmp != NULL) {
        if (strcmp(tmp->iname, s) == 0) {
          return tmp->rel;
        }
        tmp = tmp->next;
      }
    }
  }
  return NULL;
}