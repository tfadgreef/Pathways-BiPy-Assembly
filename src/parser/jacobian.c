#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "jacobian.h"
#include "simplify.h"
#include "fortran.h"
#include "tree.h"
#include "node.h"

char *D(char *name) {
  char *s;
  asprintf(&s, "%s01D", name);
  return s;
}

void functionToJacobian(struct Node *t) {
  struct Node *jac = NULL;
  struct Node *nodep = t;
  while (nodep != NULL) {
    jac = appendStatement(jac, derivative(nodep, NULL));
    nodep = nodep->next;
  }
  
  simplifyStructure(jac);
  
  printFortranFunction(jac, 1);
}

struct Node *derivative(struct Node *n, struct Node *j) {
  struct Node *tmp;
  struct Node *tmp2;
  if (n->ignore == 0) {
    switch (n->tag) {
      case TASSIGN :
        if (n->children->next->tag == TARRAYINDEX) {
          if (strcmp(n->children->next->iname, "zeros") == 0) {
            tmp = createOperation(TCOMBINE);
            appendChild(tmp, copyNode(n));
            appendChild(tmp, D_zeros(n->children->iname, n->children->next->children));
            return tmp;
          }
        }
//         if (n->children->next->tag == TARRAYINDEX) {
//           if (strcmp(n->children->next->iname, func->x) == 0) {
//             struct Variable *var = registerVariable(n->children->iname, TDOUBLE); // Should just find the variable, not register.
//             if (var != NULL) {
//               if (var->type == TDOUBLEARRAY) {
//                 return copyNode(n);
//               }
//             }
//           }
//         }
        tmp = createOperation(TCOMBINE);
        appendChild(tmp, copyNode(n));
        appendChild(tmp, D_assign(n->children, n->children->next));
        return tmp;
      case TNUM :
        return createConstant(0.0);
      case TVAR :
        return D_var(n);
      case TARRAYINDEX :
        if (n->parent->tag == TASSIGN && n->parent->children == n) {
          // Left hand side of assign
          return D_arrayindex(n->iname, n->children);
        } else {
          // Right hand side of assign
          if (strcmp(n->iname, func->p) == 0) {
            return createConstant(0.0);
          } else if (strcmp(n->iname, func->x) == 0) {
            tmp = j;
            while (tmp != NULL){
              if (compareNodes(n, tmp->children) == 1) {
                return createConstant(1.0);
              }
              tmp = tmp->next;
            }
            return createConstant(0.0);
          }
          
//           tmp = j;
//           while (tmp != NULL){
//               if (compareNodes(n, tmp->children) == 1) {
//                 return D_arrayindex(n->iname, n->children);
//               }
//             tmp = tmp->next;
//           }
//           return createConstant(0.0);
          return D_arrayindex(n->iname, n->children);
        }
//         if (n->parent->tag == TASSIGN && n->parent->children == n) {
//           // Left hand side of assign
//           return D_arrayindex(n->iname, n->children);
//         } else {
//           // Right hand side of assign
//           if (strcmp(n->iname, func->p) == 0) {
//             return createConstant(0.0);
//           } else if (strcmp(n->iname, func->x) == 0) {
//             tmp = j;
//             while (tmp != NULL){
//               if (compareNodes(n, tmp->children) == 1) {
//                 return createConstant(1.0);
//               }
//               tmp = tmp->next;
//             }
//             return createConstant(0.0);
//           } else {
//             struct Node *rel = getRelativeToY(n->iname);
//             if (rel != NULL) {
//               if (j == NULL) {
//                 return createConstant(0.0);
//               } else {
//                 tmp = j;
//                 while (tmp != NULL){
//                   if (compareNodes(n->children, tmp->children) == 1) {
//                     return createConstant(1.0);//D_arrayindex(n->iname, n->children);//createConstant(1.0);
//                   }
//                   tmp = tmp->next;
//                 }
//                 return D_arrayindex(n->iname, n->children);
//               }
//               //return D_arrayindex(D(n->iname), n->children);
//               //return createConstant(0.0);
//             }
//             return createConstant(0.0);
//             //return D_arrayindex(n->iname, n->children);
//           }
//         }
      case TPLUS : return D_plus(n->children, n->children->next, j);
      case TMINUS : return D_minus(n->children, n->children->next, j);
      case TNEGATIVE : return D_negative(n->children, j);
      case TMUL : return D_mul(n->children, n->children->next, j);
      case TDIV : return D_div(n->children, n->children->next, j);
      case TPOW : return D_pow(n->children, n->children->next, j);
      case TRANGE : fatalError("Internal error: can not compute derivative of range.");
      case TNOT : fatalError("Internal error: can not compute derivative of NOT.");
      case TOR : fatalError("Internal error: can not compute derivative of OR.");
      case TAND : fatalError("Internal error: can not compute derivative of AND.");
      case TEQ_OP : fatalError("Internal error: can not compute derivative of EQ.");
      case TNE_OP : fatalError("Internal error: can not compute derivative of NE.");
      case TGT_OP : fatalError("Internal error: can not compute derivative of GT.");
      case TGE_OP : fatalError("Internal error: can not compute derivative of GE.");
      case TLT_OP : fatalError("Internal error: can not compute derivative of LT.");
      case TLE_OP : fatalError("Internal error: can not compute derivative of LE.");
      case TIF : return  D_if(n->children, n->children->next, j);
      case TIFELSE : return  D_ifelse(n->children, n->children->next, n->children->next->next, j);
      case TFOR : return D_for(n->iname, n->children, n->children->next);
      case TIFBODY :
        tmp2 = createOperation(TIFBODY);
        tmp = n->children;
        while (tmp != NULL) {
          appendChild(tmp2, derivative(tmp, NULL));
          tmp = tmp->next;
        }
        return tmp2;
      case TCOMBINE :
        /*fprintf(warn, "\n"); print_tree(0, n); fprintf(warn, "\n");*/
        fatalError("Internal error: TCOMBINE should not occur here.");
      case TFUNCTION : return D_function(n->iname, n->children, j);
      default : fatalError("Undefined derivative.");
    }
  }
  return createOperation(TMISC);
}

struct Node *D_zeros(char *iden, struct Node *n) {
  struct Node *r1 = createOperation(TARRAYINDEX);
  setIdentifier(r1, "zeros");
  appendChild(r1, copyNode(n));
  
  struct Node *r = createOperation(TASSIGN);
  appendChild(r, createVariable(D(iden)));
  appendChild(r, r1);
  
  return r;
}

struct Node *D_plus(struct Node *n1, struct Node *n2, struct Node *j) {
  struct Node *r = createOperation(TPLUS);
  appendChild(r, derivative(n1, j));
  appendChild(r, derivative(n2, j));
  return r;
}

struct Node *D_minus(struct Node *n1, struct Node *n2, struct Node *j) {
  struct Node *r = createOperation(TMINUS);
  appendChild(r, derivative(n1, j));
  appendChild(r, derivative(n2, j));
  return r;
}

struct Node *D_negative(struct Node *n1, struct Node *j) {
  struct Node *r = createOperation(TNEGATIVE);
  appendChild(r, derivative(n1, j));
  return r;
}

struct Node *D_mul(struct Node *n1, struct Node *n2, struct Node *j) {
  // Product rule
  struct Node *r1 = createOperation(TMUL);
  appendChild(r1, derivative(n1, j));
  appendChild(r1, copyNode(n2));
  
  struct Node *r2 = createOperation(TMUL);
  appendChild(r2, copyNode(n1));
  appendChild(r2, derivative(n2, j));
  
  struct Node *r = createOperation(TPLUS);
  appendChild(r, r1);
  appendChild(r, r2);
  
  return r;
}

struct Node *D_div(struct Node *n1, struct Node *n2, struct Node *j) {
  // Quotient rule
  struct Node *r1 = createOperation(TMUL);
  appendChild(r1, copyNode(n2));
  appendChild(r1, derivative(n1, j));
  
  struct Node *r2 = createOperation(TMUL);
  appendChild(r2, copyNode(n1));
  appendChild(r2, derivative(n2, j));
  
  struct Node *r3 = createOperation(TMINUS);
  appendChild(r3, r1);
  appendChild(r3, r2);
  
  struct Node *r4 = createOperation(TPOW);
  appendChild(r4, copyNode(n2));
  appendChild(r4, createConstant(2));
  
  struct Node *r = createOperation(TDIV);
  appendChild(r, r3);
  appendChild(r, r4);
  
  return r;
}

struct Node *D_pow(struct Node *n1, struct Node *n2, struct Node *j) {
  // Find independent variable in power
  // If not found, just decrease power with one and multiply everything with power.
  // If found, generalized power rule. (Maybe first just show error message?)
  
  if (n2->tag == TNUM) {
    // f(x)^a => a*f'(x)*f(x)^(a-1)
    
    // mul1 = a*f'(x)
    struct Node *mul1 = createOperation(TMUL);
    appendChild(mul1, copyNode(n2));
    appendChild(mul1, derivative(n1, j));
    
    // pow1 = f(x)^(a-1)
    struct Node *pow1 = createOperation(TPOW);
    appendChild(pow1, copyNode(n1));
    appendChild(pow1, createConstant(n2->ival - 1.0));
    
    // mul1*pow1
    struct Node *n = createOperation(TMUL);
    appendChild(n, mul1);
    appendChild(n, pow1);
    
    return n;
  } else {
    // f(x)^g(x) => f(x)^g(x) * (((g(x)*f'(x)) / f(x)) + ln(f(x))*g'(x))
      
    // mul1 = g(x) * f'(x)
    struct Node *mul1 = createOperation(TMUL);
    appendChild(mul1, copyNode(n2));
    appendChild(mul1, derivative(n1, j));
      
    // div1 = mul1 / f(x)
    struct Node *div1 = createOperation(TDIV);
    appendChild(div1, mul1);
    appendChild(div1, copyNode(n1));
      
    // ln1 = ln(f(x))
    struct Node *ln1 = createOperation(TFUNCTION);
    setIdentifier(ln1, "ln");
    appendChild(ln1, copyNode(n1));
  //  struct Node *ln1 = copyNode(n1);
    
    // mul2 = ln1 * g'(x)
    struct Node *mul2 = createOperation(TMUL);
    appendChild(mul2, ln1);
    appendChild(mul2, derivative(n2, j));
      
    // pls1 = div1 + mul2
    struct Node *pls1 = createOperation(TPLUS);
    appendChild(pls1, div1);
    appendChild(pls1, mul2);
      
    // pow1 = f(x)^g(x)
    struct Node *pow1 = createOperation(TPOW);
    appendChild(pow1, copyNode(n1));
    appendChild(pow1, copyNode(n2));
      
    // pow1 * pls1
    struct Node *n = createOperation(TMUL);
    appendChild(n, pow1);
    appendChild(n, pls1);
        
    return n;
  }
}

struct Node *D_var(struct Node *n){
  return createVariable(D(n->iname));
}

struct Node *D_assign(struct Node *n1, struct Node *n2){
  // Find the occurences of the independent variable.
  struct Node *occ = findVariable(n2);
  struct Node *r = NULL;
  
  struct Node *dflt = createOperation(TASSIGN);
  appendChild(dflt, derivative(n1, NULL));
  appendChild(dflt, derivative(n2, NULL));
  r = appendStatement(r, dflt);
  
  struct Node *tmp = occ;
  
  // Clean up
  while (tmp != NULL) {
    int equal = 0;
    struct Node *cmp = occ;
    while (cmp != tmp && equal == 0) {
      equal = compareNodes(tmp->children, cmp->children);
      cmp = cmp->next;
    }
    if (equal != 0) {
      if (tmp == occ) {
        occ = tmp->next;
        if (tmp->next != NULL) {
          tmp->next->previous = NULL;
        }
      } else {
        if (tmp->previous != NULL) {
          tmp->previous->next = tmp->next;
        }
        if (tmp->next != NULL) {
          tmp->next->previous = tmp->previous;
        }
      }
      struct Node *obs = tmp;
      tmp = tmp->next;
      free(obs);
    } else {
      tmp = tmp->next;
    }
  }

  tmp = occ;
  
  struct Node *rifs = NULL;
  
  while (tmp != NULL) {
    struct Node *tmp2 = tmp->next;
    while (tmp2 != NULL){
      struct Node *r1;
      struct Node *r11;
      struct Node *r12;
      if (rifs == NULL) {
        r1 = createOperation(TIF);
        rifs = r1;
      } else {
        rifs->tag = TIFELSEIF;
        r1 = createOperation(TELSEIF);
        appendChild(rifs, r1);
      }
      
      r11 = createOperation(TAND);
      
      struct Node *r1a = createOperation(TEQ_OP);
      appendChild(r1a, createVariable(func->j));
      struct Node *rely = getRelativeToY(tmp->children->iname);
      if (rely->tag == TNUM && rely->ival == 1) {
        if (tmp->children->tag == TARRAYINDEX) {
          appendChild(r1a, copyNode(tmp->children->children));
        } else {
          appendChild(r1a, copyNode(rely));
        }
      } else {
        if (tmp->children->tag == TARRAYINDEX) {
          struct Node *appendRely = createOperation(TPLUS);
          appendChild(appendRely, copyNode(rely));
          appendChild(appendRely, copyNode(tmp->children->children));
          struct Node *subOne = createOperation(TMINUS);
          appendChild(subOne, appendRely);
          appendChild(subOne, createConstant(1.0));
          
          appendChild(r1a, subOne);
        } else {
          appendChild(r1a, copyNode(rely));
        }
      }
      appendChild(r11, r1a);
      
      struct Node *r1a2 = createOperation(TEQ_OP);
      appendChild(r1a2, createVariable(func->j));
      struct Node *rely2 = getRelativeToY(tmp2->children->iname);
      if (rely2->tag == TNUM && rely2->ival == 1) {
        if (tmp2->children->tag == TARRAYINDEX) {
          appendChild(r1a2, copyNode(tmp2->children->children));
        } else {
          appendChild(r1a2, copyNode(rely2));
        }
      } else {
        if (tmp2->children->tag == TARRAYINDEX) {
          struct Node *appendRely2 = createOperation(TPLUS);
          appendChild(appendRely2, copyNode(rely2));
          appendChild(appendRely2, copyNode(tmp2->children->children));
          struct Node *subOne2 = createOperation(TMINUS);
          appendChild(subOne2, appendRely2);
          appendChild(subOne2, createConstant(1.0));
          
          appendChild(r1a2, subOne2);
        } else {
          appendChild(r1a2, copyNode(rely2));
        }
      }
      appendChild(r11, r1a2);
      
      appendChild(r1, r11);
      
      struct Node *r2 = createOperation(TASSIGN);
      appendChild(r2, derivative(n1, NULL));
      struct Node *deriv = copyNode(tmp);
      appendStatement(deriv, copyNode(tmp2));
      appendChild(r2, derivative(n2, deriv));
      appendChild(r1, r2);
      tmp2 = tmp2->next;
    }
    
    struct Node *r1;
    if (rifs == NULL) {
      r1 = createOperation(TIF);
      rifs = r1;
    } else {
      rifs->tag = TIFELSEIF;
      r1 = createOperation(TELSEIF);
      appendChild(rifs, r1);
    }
    
    struct Node *r1a = createOperation(TEQ_OP);
    appendChild(r1a, createVariable(func->j));
    struct Node *rely = getRelativeToY(tmp->children->iname);
    if (rely == NULL) {
      appendChild(r1a, createConstant(1.0));
    } else if (rely->tag == TNUM && rely->ival == 1) {
      if (tmp->children->tag == TARRAYINDEX) {
        appendChild(r1a, copyNode(tmp->children->children));
      } else {
        appendChild(r1a, copyNode(rely));
      }
    } else {
      if (tmp->children->tag == TARRAYINDEX) {
        struct Node *appendRely = createOperation(TPLUS);
        appendChild(appendRely, copyNode(rely));
        appendChild(appendRely, copyNode(tmp->children->children));
        struct Node *subOne = createOperation(TMINUS);
        appendChild(subOne, appendRely);
        appendChild(subOne, createConstant(1.0));
        
        appendChild(r1a, subOne);
      } else {
        appendChild(r1a, copyNode(rely));
      }
    }
    appendChild(r1, r1a);
    
    struct Node *r2 = createOperation(TASSIGN);
    appendChild(r2, derivative(n1, NULL));
    appendChild(r2, derivative(n2, copyNode(tmp)));
    appendChild(r1, r2);
    
    tmp = tmp->next;
  }
  
  r = appendStatement(r, rifs);
  
  return r;
}

struct Node *D_if(struct Node *n1, struct Node *n2, struct Node *j) {
  struct Node *r = createOperation(TIF);
  appendChild(r, copyNode(n1));
  appendChild(r, derivative(n2, j));
  return r;
}

struct Node *D_ifelse(struct Node *n1, struct Node *n2, struct Node *n3, struct Node *j) {
  struct Node *r = createOperation(TIFELSE);
  appendChild(r, copyNode(n1));
  appendChild(r, derivative(n2, j));
  appendChild(r, derivative(n3, j));
  return r;
}

struct Node *D_arrayindex(char *iden, struct Node *n) {
  struct Node *r = createOperation(TARRAYINDEX);
  setIdentifier(r, D(iden));
  appendChild(r, copyNode(n));
  return r;
}

struct Node *D_for(char *iden, struct Node *n1, struct Node *n2){
  struct Node *r = createOperation(TFOR);
  setIdentifier(r, iden);
  appendChild(r, copyNode(n1));

  struct Node *r1 = NULL;
  struct Node *tmp = n2;
  while (tmp != NULL) {
    r1 = appendStatement(r1, derivative(tmp, NULL));
    tmp = tmp->next;
  }
  appendChild(r, r1);
  
  return r;
}

struct Node *D_function(char *iden, struct Node *n, struct Node *j) {
  fprintf(warn, "FUNCTION: %s\n", iden);
  struct MatlabFunction *mf = getFunctionInformation(iden);
  
  struct Node *r = createOperation(TMUL);
  appendChild(r, derivative(n, j));
  appendChild(r, createOperation(TFUNCTION));
  setIdentifier(r->children->next, mf->fder);
  appendChild(r->children->next, copyNode(n));
  
  return r;
}

/*int main(void) {
  warn = stderr;
  out = stdout;
  labelcount = 10;
  func = emalloc(sizeof(*func));
  func->t = "t";
  func->x = "x";
  func->p = "p";
  func->dx = "dx";
  func->neq = "neq";
  func->np = "np";
  func->j = "j";
  vars = NULL;
  
  struct Node *test = createOperation(TPLUS);
  appendChild(test, createConstant(12.01));
  
  struct Node *testsub1 = createOperation(TARRAYINDEX);
  setIdentifier(testsub1, "x");
  appendChild(testsub1, createConstant(2));
  
  appendChild(test, testsub1);
  
  struct Node *assignTest = createOperation(TASSIGN);
  appendChild(assignTest, createVariable("dxA"));
  appendChild(assignTest, test);
  
  char *s1 = toFortran(assignTest);
  fprintf(warn, "%s\n", s1);
  free(s1);
  
  struct Node *result = derivative(assignTest, NULL);
  while (result != NULL) {
    fprintf(warn, "%s", toFortran(result));
    result = result->next;
  }
  
  exit(0);
}
*/