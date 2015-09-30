#ifndef FORTRAN_H
#define FORTRAN_H

// Forward declaration
struct Node;

//! Recursively translate a Nodes to Fortran.
/*!
 * Translate Node \a t to fixed format Fortran 95 code and do the same
 * for its children.
 * @param t Node to translate.
 * @return String of Fortran code.
 */
char *toFortran(struct Node *t);
//! Translate a ODE function to Fortran.
/*!
 * Recursively translate the ODE function represented by \a t to Fortran
 * and print the generated code to the output stream #out.
 * @param t ODE function to translate.
 */
void functionToFortran(struct Node *t);
//! Translate a ODE or Jacobian function to Fortran.
/*!
 * Recursively translate the ODE or Jacobian function represented by
 * \a t to Fortran and print the generated code to the output stream
 * #out. \a jac should be 0 for ODE functions and 1 for Jacobian
 * functions.
 * @param t Function to translate.
 * @param jac Whether the function is a ODE (0) or Jacobian (1) function.
 */
void printFortranFunction(struct Node *t, int jac);
//! Fit a string into the Fortran fixed format.
/*!
 * Generates a Fortran fixed format output by distributing the \a content
 * over multiple lines if lines would exceed the 72 characters allowed
 * by this format. Furthermore the function takes care of the first six
 * control characters. A label will be added if \a label is not equal to
 * zero.
 * @param label Label to add to the line. 0 for no label.
 * @param content Actual code that should be fit into the format.
 * @return The fixed form of the code provided.
 */
char *line(int label, char *content);
//! Generate Fortran code representing a plus (+) operation.
/*!
 * Generate Fortran code that applies a plus (+) operation on the code
 * segments represented by \a s1 and \a s2 (s1 + s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_plus(char *s1, char *s2);
//! Generate Fortran code representing a minus (-) operation.
/*!
 * Generate Fortran code that applies a minus (-) operation on the code
 * segments represented by \a s1 and \a s2 (s1 - s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_minus(char *s1, char *s2);
//! Generate Fortran code representing a negative sign (-) operation.
/*!
 * Generate Fortran code that applies a negative sign (-) operation on 
 * the code segment represented by \a s1 (-s1).
 * @param s1 Code segment.
 * @return The Fortran code.
 */
char *F_negative(char *s1);
//! Generate Fortran code representing a multiplication (*) operation.
/*!
 * Generate Fortran code that applies a multiplication (*) operation on
 * the code segments represented by \a s1 and \a s2 (s1 * s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_mul(char *s1, char *s2);
//! Generate Fortran code representing a division (/) operation.
/*!
 * Generate Fortran code that applies a division (/) operation on
 * the code segments represented by \a s1 and \a s2 (s1 / s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_div(char *s1, char *s2);
//! Generate Fortran code representing a power (^) operation.
/*!
 * Generate Fortran code that applies a power (^) operation on
 * the code segments represented by \a s1 and \a s2 (s1^s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_pow(char *s1, char *s2);
//! Generate Fortran code representing a NOT (~, !) operation.
/*!
 * Generate Fortran code that applies a NOT (~, !) operation on 
 * the code segment represented by \a s1 (~s1, !s1).
 * @param s1 Code segment.
 * @return The Fortran code.
 */
char *F_not(char *s1);
//! Generate Fortran code representing a EQUAL (==) operation.
/*!
 * Generate Fortran code that applies a EQUAL (==) operation on
 * the code segments represented by \a s1 and \a s2 (s1 == s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_eq_op(char *s1, char *s2);
//! Generate Fortran code representing a NOT EQUAL (~=, !=) operation.
/*!
 * Generate Fortran code that applies a NOT EQUAL (~=, !=) operation on
 * the code segments represented by \a s1 and \a s2 (s1 != s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_ne_op(char *s1, char *s2);
//! Generate Fortran code representing a GREATER THAN (>) operation.
/*!
 * Generate Fortran code that applies a GREATER THAN (>) operation on
 * the code segments represented by \a s1 and \a s2 (s1 > s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_gt_op(char *s1, char *s2);
//! Generate Fortran code representing a GREATER OR EQUAL (>=) operation.
/*!
 * Generate Fortran code that applies a GREATER OR EQUAL (>=) operation on
 * the code segments represented by \a s1 and \a s2 (s1 >= s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_ge_op(char *s1, char *s2);
//! Generate Fortran code representing a LESSER THAN (<) operation.
/*!
 * Generate Fortran code that applies a LESSER THAN (<) operation on
 * the code segments represented by \a s1 and \a s2 (s1 <= s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_lt_op(char *s1, char *s2);
//! Generate Fortran code representing a LESSER OR EQUAL (<=) operation.
/*!
 * Generate Fortran code that applies a LESSER OR EQUAL (<=) operation on
 * the code segments represented by \a s1 and \a s2 (s1 <= s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_le_op(char *s1, char *s2);
//! Generate Fortran code representing an assign (=) statement.
/*!
 * Generate Fortran code that applies an assign (=) statement on
 * the code segments represented by \a s1 and \a s2 (s1 = s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_assign(char *s1, char *s2);
//! Generate Fortran code representing a for statement.
/*!
 * Generate Fortran code that applies a for statement on
 * the code segments represented by \a s1, \a s2 and \a s3
 * (do *label* s1 = s2; s3; *label* continue).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @param s3 Third code segment.
 * @return The Fortran code.
 */
char *F_for(char *s1, char *s2, char *s3);
//! Generate Fortran code representing a range (:) operation.
/*!
 * Generate Fortran code that applies a range (:) operation on
 * the code segments represented by \a s1, \a s2 and \a s3, preparing
 * it for use in a for/do loop.
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @param s3 Second code segment.
 * @return The Fortran code.
 */
char *F_range(char *s1, char *s2, char *s3);
//! Generate Fortran code representing a while statement.
/*!
 * Generate Fortran code that applies a while statement on
 * the code segments represented by \a s1 and \a s2
 * (while (s1); s2; end while).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_while(char *s1, char *s2);
//! Generate Fortran code representing an AND (&&) operation.
/*!
 * Generate Fortran code that applies an AND (&&) operation on
 * the code segments represented by \a s1 and \a s2 (s1 && s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_and(char *s1, char *s2);
//! Generate Fortran code representing an OR (||) operation.
/*!
 * Generate Fortran code that applies an OR (||) operation on
 * the code segments represented by \a s1 and \a s2 (s1 && s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_or(char *s1, char *s2);
char *F_if(char *s1, char *s2);
char *F_ifelse(char *s1, char *s2, char *s3);
char *F_ifelseif(char *s1, char *s2, char *s3);
char *F_elseif(char *s1, char *s2);
char *F_ifelseifelse(char *s1, char *s2, char *s3, char *s4);
//! Generate Fortran code representing an array indexing (a[b]) operation.
/*!
 * Generate Fortran code that applies an array indexing (a[b]) operation on
 * the code segments represented by \a s1 and \a s2 (s1[s2]).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_arrayindex(char *s1, char *s2);
//! Generate Fortran code representing a range (:) operation.
/*!
 * Generate Fortran code that applies a range (:) operation on
 * the code segments represented by \a s1 and \a s2 preparing
 * it for use in an array indexing expression (s1:s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_indexrange(char *s1, char *s2);
char *F_zeros(char *s1, char *s2, int allocate);
//! Generate Fortran code representing the subsequent execution of two statements.
/*!
 * Generate Fortran code that subsequently executes \a s1 and \a s2 
 * (s1;s2).
 * @param s1 First code segment.
 * @param s2 Second code segment.
 * @return The Fortran code.
 */
char *F_combine(char *s1, char *s2);
//! Generate Fortran code representing a function call.
/*!
 * Generate Fortran code calls function \a s1 with arguments \a s2 (s1(s2)).
 * @param s1 Function name.
 * @param s1 Code segment.
 * @return The Fortran code.
 */
char *F_function(char *s1, char *s2);

#endif // FORTRAN_H