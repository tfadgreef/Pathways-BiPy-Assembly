#ifndef JACOBIAN_H
#define JACOBIAN_H

struct Node;

void functionToJacobian(struct Node *t);

struct Node *derivative(struct Node *n, struct Node *j);
char *D(char *name);

struct Node *D_plus(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_minus(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_negative(struct Node *n1, struct Node *j);
struct Node *D_mul(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_div(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_pow(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_var(struct Node *n);
struct Node *D_assign(struct Node *n1, struct Node *n2);
struct Node *D_if(struct Node *n1, struct Node *n2, struct Node *j);
struct Node *D_ifelse(struct Node *n1, struct Node *n2, struct Node *n3, struct Node *j);
struct Node *D_for(char *iden, struct Node *n1, struct Node *n2);
struct Node *D_zeros(char *iden, struct Node *n);
struct Node *D_arrayindex(char *iden, struct Node *n);
struct Node *D_function(char *iden, struct Node *n, struct Node *j);

//int main(void);

#endif // JACOBIAN_H