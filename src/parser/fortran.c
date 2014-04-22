#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "fortran.h"
#include "jacobian.h"
#include "tree.h"
#include "node.h"

void functionToFortran(struct Node *t) {
  printFortranFunction(t, 0);
}

void printFortranFunction(struct Node *t, int jac) {
  char *cont = "";
  struct Node *nd = t;
  while (nd != NULL) {
    asprintf(&cont, "%s%s", cont, toFortran(nd));
    nd = nd->next;
  }
  char *l;
  
  if (jac == 0) {
    asprintf(&l, "subroutine func (%s, %s, %s, %s, %s, %s)", func->neq, func->t, func->x, func->np, func->p, func->dx);
  } else {
    asprintf(&l, "subroutine jac (%s, %s, %s, %s, %s, %s, %s)", func->neq, func->t, func->x, func->np, func->p, func->j, D(func->dx));
  }
  fprintf(out, "%s", line(0, l));
  free(l);
  
  if (jac == 0) {
    asprintf(&l, "integer %s, %s", func->neq, func->np);
  } else {
    asprintf(&l, "integer %s, %s, %s", func->neq, func->np, func->j);
  }
  fprintf(out, "%s", line(0, l));
  free(l);
  
  if (jac == 0) {
    asprintf(&l, "double precision %s, %s, %s, %s", func->t, func->x, func->dx, func->p);
  } else {
    asprintf(&l, "double precision %s, %s, %s, %s, %s", func->t, func->x, func->dx, func->p, D(func->dx));
  }
  fprintf(out, "%s", line(0, l));
  free(l);
  
  struct Variable *tmp = vars;
  l = "double precision";
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
  if (first != 1) {
    fprintf(out, "%s", line(0, l));
  }
  
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
  if (first != 1) {
    fprintf(out, "%s", line(0, l));
  }
  
  l = "double precision, allocatable ::";
  tmp = vars;
  first = 1;
  while (tmp != NULL) {
    if (tmp->type == TDOUBLEARRAY) {
      if (first == 1) {
        asprintf(&l, "%s %s(:)", l, tmp->iname);
        first = 0;
      } else {
        asprintf(&l, "%s, %s(:)", l, tmp->iname);
      }
    }
    tmp = tmp->next;
  }
  if (first != 1) {
    fprintf(out, "%s", line(0, l));
  }
  
  if (jac == 0) {
    asprintf(&l, "dimension %s(%s), %s(%s), %s(%s)", func->x, func->neq, func->dx, func->neq, func->p, func->np);
  } else {
    asprintf(&l, "dimension %s(%s), %s(%s), %s(%s), %s(%s)", func->x, func->neq, func->dx, func->neq, func->p, func->np, D(func->dx), func->neq);
  }
  fprintf(out, "%s", line(0, l));
  free(l);

  fprintf(out, "\n");
  
  fprintf(out, "%s", cont);
  
  fprintf(out, "%s", line(0, "return"));
  fprintf(out, "%s", line(0, "end"));
  
  fprintf(out, "\n\n");
}

char *toFortran(struct Node *t) {
  struct Node *nd = t;
  if (nd->ignore == 1) {
    return "";
  }
  if (nd->tag == TNUM) {
    char *s;
    asprintf(&s, "%g", nd->ival);
    int i;
    for (i = 0; i < strlen(s); i++) {
      if (s[i] == 'e') {
        s[i] = 'd';
      }
    }
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
      case TMINUS :
        s1 = toFortran(nd->children);
        s2 = toFortran(nd->children->next);
        return  F_minus(s1, s2);
      case TMUL : return F_mul(toFortran(nd->children), toFortran(nd->children->next));
      case TDIV : return F_div(toFortran(nd->children), toFortran(nd->children->next));
      case TPOW : return F_pow(toFortran(nd->children), toFortran(nd->children->next));
      case TNOT : return F_not(toFortran(nd->children));
      case TNEGATIVE : return F_negative(toFortran(nd->children));
      case TFOR :
        s1 = "";
        tmp = nd->children->next;
        while (tmp != NULL) {
          asprintf(&s1, "%s%s", s1, toFortran(tmp));
          tmp = tmp->next;
        }
        return  F_for(processIdentifier(nd->iname, TINT), toFortran(nd->children), s1);
      case TWHILE :
        s1 = "";
        tmp = nd->children->next;
        while (tmp != NULL) {
          asprintf(&s1, "%s%s", s1, toFortran(tmp));
          tmp = tmp->next;
        }
        return  F_while(toFortran(nd->children), s1);
      case TASSIGN :
        if (nd->children->next->tag == TARRAYINDEX) {
          if (strcmp(nd->children->next->iname, "zeros") == 0) {
            registerVariable(nd->children->iname, TDOUBLEARRAY);
            if (strcmp(nd->children->iname, func->dx) == 0 || strcmp(nd->children->iname, D(func->dx)) == 0) {
              fprintf(warn, "Automatically set the size of '%s' to '%s'.\n", nd->children->iname, func->neq);
              return F_zeros(nd->children->iname, func->neq, 0);
            } else {
              return F_zeros(nd->children->iname, toFortran(nd->children->next->children), 1);
            }
          }
        }
        if (nd->children->next->tag == TARRAYINDEX) {
          if (strcmp(nd->children->next->iname, func->x) == 0) {
            struct Node *rel;
            if (nd->children->next->children->tag == TRANGE) {
              rel = nd->children->next->children->children;
            } else {
              rel = nd->children->next->children;
            }
            registerVariable(nd->children->iname, TDOUBLE);
            processDependentVectorIdentifier(nd->children->iname, rel);
          }
        }
        return  F_assign(toFortran(nd->children), toFortran(nd->children->next));
      case TRANGE :
        if (nd->parent->tag == TFOR) {
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
        } else {
          return F_indexrange(toFortran(nd->children), toFortran(nd->children->next));
        }
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
      case TCOMBINE :
        s1 = "";
        tmp = nd->children;
        while (tmp != NULL) {
          s1 = F_combine(s1, toFortran(tmp));
          tmp = tmp->next;
        }
        return s1;
      case TFUNCTION : return F_function(nd->iname, toFortran(nd->children));
      case TMISC : return "";
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

char *F_negative(char *s1) {
  char *s;
  asprintf(&s, "(-%s)", s1);
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

char *F_pow(char *s1, char *s2) {
  char *s;
  asprintf(&s, "(%s ** %s)", s1, s2);
  return s;
}

char *F_not(char *s1) {
  char *s;
  asprintf(&s, "(!%s)", s1);
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

char *F_indexrange(char *s1, char *s2) {
  char *s;
  asprintf(&s, "%s:%s", s1, s2);
  return s;
}

char *F_zeros(char *s1, char *s2, int allocate) {
  char *s, *l1, *l2, *l3, *l4;
  s = "";
  if (allocate == 1) {
    asprintf(&l1, "allocate(%s(%s))", s1, s2);
    asprintf(&s, "%s", line(0, l1));
    free(l1);
  }
  asprintf(&l2, "do %d ppodei = 1, %s", labelcount, s2);
  registerVariable("ppodei", TINT);
  asprintf(&l3, "%s(ppodei) = 0.0d0", s1);
  asprintf(&l4, "continue");
  asprintf(&s, "%s%s%s%s", s, line(0, l2), line(0, l3), line(labelcount, l4));
  labelcount += 10;
  free(l2); free(l3); free(l4);
  return s;
}

char *F_combine(char *s1, char *s2) {
  char *s;
  asprintf(&s, "%s%s", s1, s2);
  return s;
}

char *F_function(char *s1, char *s2) {
  char *s;
  struct MatlabFunction *f = getFunctionInformation(s1);
  asprintf(&s, "%s(%s)", f->fname, s2);
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
