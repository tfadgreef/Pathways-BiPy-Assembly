#ifndef FORTRAN_H
#define FORTRAN_H

struct Node;
struct NumSpec;

char *toFortran(struct Node *t);
void functionToFortran(struct Node *f, struct Node *t);

char *line(int label, char *content);

char *F_plus(char *s1, char *s2);
char *F_minus(char *s1, char *s2);
char *F_mul(char *s1, char *s2);
char *F_div(char *s1, char *s2);
char *F_eq_op(char *s1, char *s2);
char *F_ne_op(char *s1, char *s2);
char *F_gt_op(char *s1, char *s2);
char *F_ge_op(char *s1, char *s2);
char *F_lt_op(char *s1, char *s2);
char *F_le_op(char *s1, char *s2);
char *F_assign(char *s1, char *s2);
char *F_for(char *s1, char *s2, char *s3);
char *F_range(char *s1, char *s2, char *s3);
char *F_while(char *s1, char *s2);
char *F_and(char *s1, char *s2);
char *F_or(char *s1, char *s2);
char *F_if(char *s1, char *s2);
char *F_ifelse(char *s1, char *s2, char *s3);
char *F_ifelseif(char *s1, char *s2, char *s3);
char *F_elseif(char *s1, char *s2);
char *F_ifelseifelse(char *s1, char *s2, char *s3, char *s4);
char *F_arrayindex(char *s1, char *s2);
char *F_zeros(char *s1);

#endif // FORTRAN_H