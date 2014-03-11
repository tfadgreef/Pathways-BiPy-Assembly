// Data structures for syntax trees.
#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"

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


struct Node *addOperation(enum node_tag op, struct Node *l, struct Node *r) {
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

struct Node *addOperation3(enum node_tag op, struct Node *l, struct Node *m, struct Node *r) {
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

struct Node *addOperation4(enum node_tag op, struct Node *l, struct Node *lm, struct Node *rm, struct Node *r) {
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

struct Node *addOperationWithIdentifier(enum node_tag op, struct Node *l, struct Node *r, char *identifier) {
    struct Node *t = emalloc(sizeof(*t));
    
    t->tag = op;
//     t->iname = emalloc(sizeof(char) * strlen(identifier));
//     strcpy(t->iname, identifier);
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

void functionToFortran(struct Node *f, struct Node *t) {
  func = emalloc(sizeof(*func));
  
  if (f->children->next->children != NULL) {
    func->t = f->children->next->children->iname;
    if (f->children->next->children->next != NULL) {
      func->x = f->children->next->children->next->iname;
      if (f->children->next->children->next->next != NULL) {
        func->p = f->children->next->children->next->next->iname;
      } else {
        fatalError("No parameter input argument.");
      }
    } else {
      fatalError("No state input argument.");
    }
  } else {
    fatalError("No time input argument.");
  }
  if (f->children->next->children->next->next->next != NULL) {
    fatalError("Too many input arguments.");
  }
  
  if (f->children->children != NULL) {
    func->dx = f->children->children->iname;
  }
  
  char *cont = "";
  struct Node *nd = t;
  while (nd != NULL) {
    asprintf(&cont, "%s%s", cont, toFortran(nd));
    nd = nd->next;
  }
  
  fprintf(out, "%s", line(0, "subroutine func (neq, t, y, ydot)"));
  fprintf(out, "%s", line(0, "integer neq, np"));
  fprintf(out, "%s", line(0, "double precision t, y, ydot"));
  fprintf(out, "%s", line(0, "double precision, pointer :: p(:)"));
  
  struct Variable *tmp = vars;
  char *l = "double precision";
  int first = 1;
  while (tmp != NULL) {
    if (tmp->type == TDOUBLE) {
      if (first == 1) {
        asprintf(&l, "%s %s", l, tmp->iname);
        first = 0;
      } else {
        asprintf(&l, "%s, %s", l, tmp->iname);
      }
    }
    tmp = tmp->next;
  }
  fprintf(out, "%s", line(0, l));
  
  l = "integer";
  tmp = vars;
  first = 1;
  while (tmp != NULL) {
    if (tmp->type == TINT) {
      if (first == 1) {
        asprintf(&l, "%s %s", l, tmp->iname);
        first = 0;
      } else {
        asprintf(&l, "%s, %s", l, tmp->iname);
      }
    }
    tmp = tmp->next;
  }
  fprintf(out, "%s", line(0, l));
  free(l);
  
  fprintf(out, "%s", line(0, "dimension y(neq), ydot(neq)"));
  fprintf(out, "%s", line(0, "common  /funcpar/ np, p"));
  fprintf(out, "\n");
  
  fprintf(out, "%s", cont);
  
  fprintf(out, "%s", line(0, "return"));
  fprintf(out, "%s", line(0, "end"));
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

char *toFortran(struct Node *t) {
  struct Node *nd = t;
  if (nd->ignore == 1) {
    return "";
  }
  if (nd->tag == TNUM) {
    char *s;
    asprintf(&s, "%0.*f", nd->signif-1, nd->ival);
    return s;
  } else if (nd->tag == TVAR) {
    return processIdentifier(nd->iname, TDOUBLE);
  }else {
    char *s1;
    char *s2;
    char *s3;
    struct Node *tmp;
    switch (nd->tag) {
      case TPLUS :
        s1 = toFortran(nd->children);
        s2 = toFortran(nd->children->next);
        return  F_plus(s1, s2);
      case TMINUS : return F_minus(toFortran(nd->children), toFortran(nd->children->next));
      case TMUL : return F_mul(toFortran(nd->children), toFortran(nd->children->next));
      case TDIV : return F_div(toFortran(nd->children), toFortran(nd->children->next));
      case TFOR :
        return  F_for(processIdentifier(nd->iname, TINT), toFortran(nd->children), toFortran(nd->children->next));
      case TWHILE : return  F_while(toFortran(nd->children), toFortran(nd->children->next));
      case TASSIGN :
        if (nd->children->next->tag == TARRAYINDEX) {
          if (strcmp(nd->children->next->iname, "zeros") == 0) {
            return F_zeros(nd->children->iname);
          }
        }
        return  F_assign(toFortran(nd->children), toFortran(nd->children->next));
      case TRANGE :
        if (nd->children->tag == TRANGE) {
          asprintf(&s1, "%s", toFortran(nd->children->children));
          asprintf(&s2, "%s", toFortran(nd->children->next));
          asprintf(&s3, "%s", toFortran(nd->children->children->next));
        } else {
          asprintf(&s1, "%s", toFortran(nd->children));
          asprintf(&s2, "%s", toFortran(nd->children->next));
          s3 = "";
        }
        return F_range(s1, s2, s3);
      case TOR : return F_or(toFortran(nd->children), toFortran(nd->children->next));
      case TAND : return F_or(toFortran(nd->children), toFortran(nd->children->next));
      case TEQ_OP : return F_eq_op(toFortran(nd->children), toFortran(nd->children->next));
      case TNE_OP : return F_ne_op(toFortran(nd->children), toFortran(nd->children->next));
      case TGT_OP : return F_gt_op(toFortran(nd->children), toFortran(nd->children->next));
      case TGE_OP : return F_ge_op(toFortran(nd->children), toFortran(nd->children->next));
      case TLT_OP : return F_lt_op(toFortran(nd->children), toFortran(nd->children->next));
      case TLE_OP : return F_le_op(toFortran(nd->children), toFortran(nd->children->next));
      case TIF : return  F_if(toFortran(nd->children), toFortran(nd->children->next));
      case TIFELSE : return  F_ifelse(toFortran(nd->children), toFortran(nd->children->next), toFortran(nd->children->next->next));
      case TIFELSEIF :
        s1 = "";
        tmp = nd->children->next->next;
        while (tmp != NULL) {
          asprintf(&s1, "%s%s", s1, toFortran(tmp));
          tmp = tmp->next;
        }
        return  F_ifelseif(toFortran(nd->children), toFortran(nd->children->next), s1);
      case TELSEIF : return  F_elseif(toFortran(nd->children), toFortran(nd->children->next));
      case TIFELSEIFELSE :
        s1 = "";
        tmp = nd->children->next->next;
        while (tmp->next != NULL) {
          asprintf(&s1, "%s%s", s1, toFortran(tmp));
          tmp = tmp->next;
        }
        return  F_ifelseifelse(toFortran(nd->children), toFortran(nd->children->next), s1, toFortran(tmp));
      case TARRAYINDEX : return  F_arrayindex(processIdentifier(nd->iname, TINT), toFortran(nd->children));
      default: fprintf(warn, "Warning: Ignoring unknown expression.\n"); return  "";
    }
    free(s1);
    free(s2);
    free(s3);
  }
  return "";
}

char *F_plus(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s + %s)", s1, s2);
  return s;
}

char *F_minus(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s - %s)", s1, s2);
  return s;
}

char *F_mul(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s * %s)", s1, s2);
  return s;
}

char *F_div(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s / %s)", s1, s2);
  return s;
}

char *F_or(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .or. %s)", s1, s2);
  return s;
}

char *F_and(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .and. %s)", s1, s2);
  return s;
}

char *F_eq_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .eq. %s)", s1, s2);
  return s;
}

char *F_ne_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .ne. %s)", s1, s2);
  return s;
}

char *F_gt_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .gt. %s)", s1, s2);
  return s;
}

char *F_ge_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .ge. %s)", s1, s2);
  return s;
}

char *F_lt_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .lt. %s)", s1, s2);
  return s;
}

char *F_le_op(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s .le. %s)", s1, s2);
  return s;
}

char *F_assign(char *s1, char *s2) {
  char *s;
  asprintf(&s, "%s = %s", s1, s2);
  return line(0, s);
}

char *F_for(char *s1, char *s2, char *s3) {
  char *s, *l1, *l2, *l3;
  asprintf(&l1, "do %d %s = %s", labelcount, s1, s2);
  asprintf(&l2, "%s", s3);
  asprintf(&l3, "continue");
  asprintf(&s, "%s%s%s", line(0, l1), l2, line(labelcount, l3));
  labelcount += 10;
  free(l1); free(l2); free(l3);
  return s;
}

char *F_range(char *s1, char *s2, char *s3) {
  char *s;
  if (s3 == "") {
    asprintf(&s, "%s, %s", s1, s2);
  } else {
    asprintf(&s, "%s, %s, %s", s1, s2, s3);
  }
  return s;
}

char *F_while(char *s1, char *s2) {
  char *s, *l1, *l2, *l3, *l4;
  asprintf(&l1, "if (.not. %s) go to %d", s1, labelcount+10);
  asprintf(&l2, "%s", s2);
  asprintf(&l3, "goto %d", labelcount);
  asprintf(&l4, "continue");
  asprintf(&s, "%s%s%s%s", line(labelcount, l1), l2, line(0, l3), line(labelcount+10, l4));
  labelcount += 20;
  free(l1); free(l2); free(l3); free(l4);
  return s;
}

char *F_if(char *s1, char *s2) {
  char *s, *l1, *l2, *l3;
  asprintf(&l1, "if %s then", s1);
  asprintf(&l2, "%s", s2);
  asprintf(&l3, "end if");
  asprintf(&s, "%s%s%s", line(0, l1), l2, line(0, l3));
  free(l1); free(l2); free(l3);
  return s;
}

char *F_ifelse(char *s1, char *s2, char *s3) {
  char *s, *l1, *l2, *l3, *l4, *l5;
  asprintf(&l1, "if %s then", s1);
  asprintf(&l2, "%s", s2);
  asprintf(&l3, "else");
  asprintf(&l4, "%s", s3);
  asprintf(&l5, "end if");
  asprintf(&s, "%s%s%s%s%s", line(0, l1), l2, line(0, l3), l4, line(0, l5));
  free(l1); free(l2); free(l3); free(l4); free(l5);
  return s;
}

char *F_ifelseif(char *s1, char *s2, char *s3) {
  char *s, *l1, *l2, *l3, *l4;
  asprintf(&l1, "if %s then", s1);
  asprintf(&l2, "%s", s2);
  asprintf(&l3, "%s", s3);
  asprintf(&l4, "end if");
  asprintf(&s, "%s%s%s%s", line(0, l1), l2, l3, line(0, l4));
  free(l1); free(l2); free(l3); free(l4);
  return s;
}

char *F_elseif(char *s1, char *s2) {
  char *s, *l1, *l2;
  asprintf(&l1, "else if %s then", s1);
  asprintf(&l2, "%s", s2);
  asprintf(&s, "%s%s", line(0, l1), l2);
  free(l1); free(l2);
  return s;
}

char *F_ifelseifelse(char *s1, char *s2, char *s3, char *s4) {
  char *s, *l1, *l2, *l3, *l4, *l5, *l6;
  asprintf(&l1, "if %s then", s1);
  asprintf(&l2, "%s", s2);
  asprintf(&l3, "%s", s3);
  asprintf(&l4, "else");
  asprintf(&l5, "%s", s4);
  asprintf(&l6, "end if");
  asprintf(&s, "%s%s%s%s%s%s", line(0, l1), l2, l3, line(0, l4), l5, line(0, l6));
  free(l1); free(l2); free(l3); free(l4); free(l5); free(l6);
  return s;
}

char *F_arrayindex(char *s1, char *s2) {
  char *s;
  asprintf(&s, "%s(%s)", s1, s2);
  return s;
}

char *F_zeros(char *s1) {
  char *s, *l1, *l2, *l3;
  asprintf(&l1, "do %d i = 1, neq", labelcount);
  asprintf(&l2, "ydot(i) = 0.0d0");
  asprintf(&l3, "continue");
  asprintf(&s, "%s%s%s", line(0, l1), line(0, l2), line(labelcount, l3));
  labelcount += 10;
  free(l1); free(l2); free(l3);
  return s;
}

char *line(int label, char *content) {
  char *s = "";
  int l = strlen(content);
  int i;
  for (i = 0; i <= ((l-1)/66); i++) {
    int sz = MIN(66, l-(66*i));
    char *substr = emalloc(66);
    strncpy(substr, content + (66*i), sz);
    substr[sz] = '\0';
    if (i == 0) {
      if (label == 0) {
        asprintf(&s, "%s      %s\n", s, substr);
      } else {
        asprintf(&s, "%s %3d  %s\n", s, label, substr);
      }
    } else {
      asprintf(&s, "%s     +%s\n", s, substr);
    }
    free(substr);
  }
  return s;
}
