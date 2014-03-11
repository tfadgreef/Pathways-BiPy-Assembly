// Data structures for syntax trees.
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"
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
    } else if (nd->tag == TSTUB) {
      fprintf(warn, "STUB");
    }else {
      switch (nd->tag) {
        case TPLUS : fprintf(warn, "+"); break;
        case TMINUS : fprintf(warn, "-"); break;
        case TMUL : fprintf(warn, "*"); break;
        case TDIV : fprintf(warn, "/"); break;
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

void registerVariable(char *s, enum VariableType tp) {
  if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, "zeros") != 0) {
    if (vars == NULL) {
      vars = emalloc(sizeof(*vars));
      vars->next = NULL;
      vars->previous = NULL;
      vars->iname = emalloc(sizeof(char) * strlen(s));
      vars->type = tp;
      strcpy(vars->iname, s);
    } else {
      struct Variable *tmp = vars;
      while (1) {
        if (strcmp(tmp->iname, s) == 0) {
          if (tmp->type == TDOUBLE && tp == TINT) {
            tmp->type = TINT;
          }
          return;
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
    }
  }
}

char *processIdentifier(char *nm, enum VariableType tp) {
  char *s;
  if (strcmp(nm, func->t) == 0) {
    asprintf(&s, "t");
  } else if (strcmp(nm, func->x) == 0) {
    asprintf(&s, "y");
  } else if (strcmp(nm, func->p) == 0) {
    asprintf(&s, "p");
  } else if (strcmp(nm, func->dx) == 0) {
    asprintf(&s, "ydot");
  } else {
    asprintf(&s, "%s", nm);
  }
  registerVariable(nm, tp);
  return s;
}

