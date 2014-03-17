#ifndef SIMPLIFY_H
#define SIMPLIFY_H

struct Node;
struct Variable;
enum SimplifyState {
  ZeroAssignments = 0,
  ReplaceZeroAssignments = 1,
  RemovePlusZero = 2
};
enum SimplifyState simplifyStateSize;

void simplifyStructure(struct Node *t);

void registerZeroVar(char *name, int zero);
int getVariableZero(char *s);
void S_zeroAssignments(struct Node *t);
int S_replaceZeroAssignments(struct Node *t);
void S_removePlusZero(struct Node *t);

#endif // SIMPLIFY_H