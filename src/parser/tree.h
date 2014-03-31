#define MIN(x, y) (((x) < (y)) ? (x) : (y))

// Forward declartion
struct Node;
enum NodeTag;

// Whether to create a Jacobian function.
int createJac;

// Output streams for warnings and output.
FILE * warn;
FILE * out;

//! Counter for the label to use in the Fortran code.
int labelcount;

//! Variable types.
enum VariableType {
  TDOUBLE,        //!< Double precision floating point variable.
  TINT,           //!< Integer variable.
  TDOUBLEARRAY    //!< Array of double precision variables.
};

//! Datatype of a variable.
/*!
 * This datatype can hold information about the type and name of the
 * variable. It is also a linked list.
 */
struct Variable {
  //! Type of the variable.
  enum VariableType type;
  //! Pointer to the next variable in the linked list.
  struct Variable *next;
  //! Pointer to the previous variable in the linked list.
  struct Variable *previous;
  //! Name/identifier of the variable.
  char *iname;
  //! The relation of the variable to the independent variable of the ODE system.
  struct Node *rel;
  //! 1 when this variable is always zero, 0 otherwise.
  int zero;
};

struct MatlabFunction {
  char *name;
  char *fname;
  char *fder;
  struct MatlabFunction *next;
};
struct MatlabFunction *knownFunctions;

//! Datatype of a function definition. 
/*!
 * Holds the names of the various arguments of the ODE function.
 * In Matlab the ODE function should be defined as follows:
\code{.m}
dx = function(t, x, p, neq, np)
\endcode
 */
struct Function {
  //! Identifier of the independent variable.
  char *t;
  //! Identifier of the dependent variables.
  char *x;
  //! Identifier of the parameters.
  char *p;
  //! Identifier of the differential (dx = f(x(t))).
  char *dx;
  
  //! Identifier of the Number of EQations.
  char *neq;
  //! Identifier of the Number of Parameters.
  char *np;
  
  //! Identifier of the current Jacobian index.
  /*!
   * \note Does not occur in the function definition.
   */
  char *j;
};

//! Instance of the function definition.
struct Function *func;

//! Nicer memory allocation function.
void *emalloc(size_t nbytes);
//! Fatal error function.
/*!
 * Displays error \a message and then exits the application.
 * @param message Error message to display.
 */
void fatalError(char *message);
//! Print a tree view of a Node.
void print_tree(int d, struct Node *t);

//! Variables used in the ODE function.
struct Variable *vars;

enum NodeTag getIdentifierType(char *s);
struct MatlabFunction *getFunctionInformation(char *s);
void initializeKnownFunctions();

struct Variable *registerVariable(char *s, enum VariableType tp);
char *processIdentifier(char *nm, enum VariableType tp);

void processDependentVectorIdentifier(char *s, struct Node *rel);

void processFunctionHeader(struct Node* f);
struct Node *getRelativeToY(char *s);

