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
  printLine();
  fprintf(warn, "ERROR: %s\n", message);
  printLine();
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
      fprintf(warn, "%g", nd->ival);
    } else if (nd->tag == TVAR) {
      fprintf(warn, "%s", nd->iname);
    }else {
      switch (nd->tag) {
        case TPLUS : fprintf(warn, "+"); break;
        case TMINUS : fprintf(warn, "-"); break;
        case TMUL : fprintf(warn, "*"); break;
        case TDIV : fprintf(warn, "/"); break;
        case TPOW : fprintf(warn, "^"); break;
        case TFOR : fprintf(warn, "for (%s = ...)", nd->iname); break;
        case TWHILE : fprintf(warn, "while"); break;
        case TASSIGN : fprintf(warn, "="); break;
        case TRANGE : fprintf(warn, ":"); break;
        case TOR : fprintf(warn, "|"); break;
        case TAND : fprintf(warn, "&"); break;
        case TIF : fprintf(warn, "if"); break;
        case TIFELSE : fprintf(warn, "if-else"); break;
        case TIFELSEIF : fprintf(warn, "if-else-if"); break;
        case TIFELSEIFELSE : fprintf(warn, "if-else-if-else"); break;
        case TELSEIF : fprintf(warn, "else-if"); break;
        case TARRAYINDEX : fprintf(warn, "%s[...]", nd->iname); break;
        case TEQ_OP : fprintf(warn, "=="); break;
        case TNE_OP : fprintf(warn, "!="); break;
        case TGT_OP : fprintf(warn, ">"); break;
        case TGE_OP : fprintf(warn, ">="); break;
        case TLT_OP : fprintf(warn, "<"); break;
        case TLE_OP : fprintf(warn, "<="); break;
        case TLIST : fprintf(warn, "..., ..., ..."); break;
        case TFUNCDEC : fprintf(warn, "FUNCDEC"); break;
        case TFUNCTION : fprintf(warn, "%s(...)", nd->iname); break;
        case TNEGATIVE : fprintf(warn, "-(...)"); break;
        case TIFBODY : fprintf(warn, "if () ... end"); break;
        case TCOMBINE : fprintf(warn, "...; ...; ..."); break;
        case TMISC : fprintf(warn, "Undefined"); break;
        default: fprintf(warn, "???");
      }
      print_tree(d+1, nd->children);
    }
    nd = nd->next;
  }
}

struct Variable *registerVariable(char *s, enum VariableType tp) {
  if (strcmp(s, func->t) != 0 && strcmp(s, func->x) != 0 && strcmp(s, func->p) != 0 && strcmp(s, func->dx) != 0 && strcmp(s, D(func->dx)) && strcmp(s, func->neq) != 0 && strcmp(s, func->np) != 0 && strcmp(s, func->j) && strcmp(s, "zeros") != 0 && strcmp(s, D(func->x)) != 0) {
    if (vars == NULL) {
      vars = emalloc(sizeof(*vars));
      vars->next = NULL;
      vars->previous = NULL;
      vars->iname = emalloc(sizeof(char) * strlen(s));
      vars->type = tp;
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

void initializeKnownFunctions() {
  struct MatlabFunction *tmp = emalloc(sizeof(*knownFunctions));
  tmp->name = "sin";
  tmp->fname = "dsin";
  tmp->fder = "dcos";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  knownFunctions = tmp;
  tmp = tmp->next;
  
  tmp->name = "cos";
  tmp->fname = "dcos";
  tmp->fder = "d01cos";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "tan";
  tmp->fname = "dtan";
  tmp->fder = "d01tan";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "cot";
  tmp->fname = "dcot";
  tmp->fder = "d01cot";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "sec";
  tmp->fname = "dsec";
  tmp->fder = "d01sec";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "csc";
  tmp->fname = "dcsc";
  tmp->fder = "d01csc";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "arcsin";
  tmp->fname = "dasin";
  tmp->fder = "d01asin";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "arccos";
  tmp->fname = "dacos";
  tmp->fder = "d01acos";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "arctan";
  tmp->fname = "datan";
  tmp->fder = "d01atan";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "exp";
  tmp->fname = "dexp";
  tmp->fder = "dexp";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "ln";
  tmp->fname = "dlog";
  tmp->fder = "d01log";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "sqrt";
  tmp->fname = "dsqrt";
  tmp->fder = "d01sqrt";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "abs";
  tmp->fname = "dabs";
  tmp->fder = "d01abs";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "sinh";
  tmp->fname = "dsinh";
  tmp->fder = "dcosh";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "cosh";
  tmp->fname = "dcosh";
  tmp->fder = "d01cosh";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "tanh";
  tmp->fname = "dtanh";
  tmp->fder = "d01tanh";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "sech";
  tmp->fname = "dsech";
  tmp->fder = "d01sech";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "round";
  tmp->fname = "dround";
  tmp->fder = "dzero";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "ceil";
  tmp->fname = "dceiling";
  tmp->fder = "dzero";
  
  tmp->next = emalloc(sizeof(*tmp->next));
  tmp = tmp->next;
  
  tmp->name = "floor";
  tmp->fname = "dfloor";
  tmp->fder = "dzero";
  
  tmp->next = NULL;
}

enum NodeTag getIdentifierType(char *s){
  struct MatlabFunction *tmp = knownFunctions;
  while (tmp != NULL) {
    if (strcmp(tmp->name, s) == 0) {
      return TFUNCTION;
    }
    tmp = tmp->next;
  }
  return TARRAYINDEX;
}

struct MatlabFunction *getFunctionInformation(char *s){
  struct MatlabFunction *tmp = knownFunctions;
  while (tmp != NULL) {
    if (strcmp(tmp->name, s) == 0) {
      return tmp;
    }
    tmp = tmp->next;
  }
  return NULL;
}

void removeVariable(struct Variable *v) {
  if (v == NULL) {
    return;
  }
  
  if (v->previous != NULL) {
    v->previous->next = v->next;
  } else {
    vars = v->next;
  }
  if (v->next != NULL) {
    v->next->previous = v->previous;
  }
  
  if (v->iname != NULL) {
    free(v->iname);
  }
  free(v);
}

void printLine() {
	fprintf(warn, "-------------------------------------------------------------------\n");
}