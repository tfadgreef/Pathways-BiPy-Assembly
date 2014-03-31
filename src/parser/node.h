#ifndef NODE_H
#define NODE_H

//! Tags the Node struct uses to specify its type or purpose.
enum NodeTag {
  TPLUS,            //!< Plus operation (a+b), two children.
  TMINUS,           //!< Minus operation (a-b), two children.
  TMUL,             //!< Multiplication operation (a*b), two children.
  TDIV,             //!< Division operation (a/b), two children.
  TPOW,             //!< Power operation (a^b; a**b), two children
  TNUM,             //!< Number, no children. Node::ival should be specified.
  TVAR,             //!< Variable, no children. Node::iname should be specified.
  TFOR,             //!< For statement, at least 2 children. Node#iname
                    //!< should be specified. The first child specifies a range,
                    //!< the subsequent statements are sub-statements of
                    //!< the for loop.
  TWHILE,           //!< While statement, at least 2 children. The first
                    //!< child has to specify the condition of the loop.
                    //!< The subsequent statements are sub-statements of
                    //!< the while loop.
  TASSIGN,          //!< Assign statement (a = b), 2 children.
  TRANGE,           //!< Range operation (a:b), 2 children.
  TOR,              //!< OR operation (a || b; a OR b), 2 children.
  TAND,             //!< AND operation (a && b; a AND b), 2 children.
  TEQ_OP,           //!< EQUAL operation (a == b), 2 children.
  TNE_OP,           //!< NOT EQUAL operation (a ~= b; a != b), 2 children.
  TGT_OP,           //!< GREATER THAN operation (a > b), 2 children.
  TLT_OP,           //!< LESSER THAN operation (a < b), 2 children.
  TGE_OP,           //!< GREATER OR EQUAL operation (a >= b), 2 children.
  TLE_OP,           //!< LESSER OR EQUAL operation (a <= b), 2 children.
  TIF,              //!< If statement.
  TIFELSE,          //!< If-else statement.
  TIFELSEIF,        //!< If-elseif statement.
  TELSEIF,          //!< Elseif statement.
  TIFELSEIFELSE,    //!< If-elseif-else statement.
  TARRAYINDEX,      //!< Array index operation, (k[a]), one child.
                    //!< Node#iname should be specified.
  TLIST,            //!< List/tuple operation (a,b).
  TFUNCDEC,         //!< Function declaration.
  TMISC,            //!< Miscelaneous, internal usage.
  TCOMBINE,         //!< Groups various statements. That is, a child of
                    //!< TCOMBINE actually belongs one level higher in
                    //!< the tree.
  TNOT,             //!< NOT operation (!a, ~a, NOT a), one child.
  TNEGATIVE,        //!< Negative sign operation (-a), one child.
  TFUNCTION         //!< A recognized Matlab function.
};

//! A two dimensional node/tree data.
/*!
 * This data structure consists of nodes that specify their neighbours.
 * Each node has a left neighbour, right neighbour, parent and children,
 * resulting in a structure like this:
\verbatim
node-1
  |-> node-1.1
  |-> node-1.2 
\endverbatim
 * Where node-1 has no neighbours, but two Node#children: node-1.1 and 
 * node-1.2. node-1.1 is positioned Node#previous of node-1.2, whereas 
 * node-1.2 is the Node#next node relative to node-1.1. Both node-1.1 
 * and node-1.2 have node-1 as Node#parent.
 * 
 * Each node also has a Node#tag, defining the type of the node.
 * Examples of tags are ::TPLUS and ::TMUL, specifying a plus (+) or
 * multiplication (*) operation respectively.
 * 
 * If the node specifies a number (i.e. the tag is ::TNUM),
 * Node#ival will hold the value of this number. Every number is 
 * interpreted as a double precision number, since Matlab does not
 * really distinguishes between integers and floating point numbers 
 * either.
 *
 * The Node#iname property can be used in combination with the ::TVAR,
 * ::TARRAYINDEX or ::TFOR tags to specify the name of the identifier used.
 * 
 * The Node#ignore property can be used to ignore Matlab specific
 * assignments that should not be translated to Fortran code.
 * 
 * @sa copyNode, removeNode, createOperation, createConstant,
 *     createVariable, appendChild, print_tree
 */
struct Node {
  //! The tag of the Node, specifying the type of the node.
  enum NodeTag tag;
  //! Pointer to the next Node.
  /*!
   * NULL when the Node does not have a next neighbour.
   */
  struct Node *next;
  //! Pointer to the previous Node.
  /*!
   * NULL when the Node does not have a previous neighbour.
   */
  struct Node *previous;
  //! Pointer to the first child Node.
  /*!
   * All other children can be accessed using the Node#next properties
   * of the children. Null when the Node does not have children.
   */
  struct Node *children;
  //! Pointer to the previous Node.
  /*!
   * NULL when the Node is the topmost Node.
   */
  struct Node *parent;
  //! Value of the number represented by this Node.
  /*!
   * This property is only set when the tag of the Node is ::TNUM.
   */
  double ival;
  //! The name of the identifier represented by this Node.
  /*!
   * This property is only set when the tag of the Node is either ::TVAR,
   * TARRAYINDEX or ::TFOR. In the case of ::TVAR and TARRAYINDEX, this
   * property specifies the name of the variable. When the tag is ::TFOR,
   * this property specifies the name of the variable that is used by the
   * for statement.
   */
  char *iname;
  //! Property that will make parsers ignore the current assignment if set to 1.
  int ignore;
};

//! Create a Node of the specified operation type.
/*!
 * Create a Node of the specified operation, whilst setting all other
 * properties to zero or NULL.
 * @param op Operation type of the Node to be created.
 * @return The created Node instance.
 */
struct Node *createOperation(enum NodeTag op);
//! Append a child Node to a parent Node.
/*!
 * Append the Node \a child to the list of children of Node \a parent
 * and sets \a parent as the parent Node of \a child.
 * @param parent Node where the \a child Node is to be appended to.
 * @param child Node to be appended to the children of \a parent.
 */
void appendChild(struct Node *parent, struct Node *child);
//! Set the identifier of a Node.
/*!
 * Set the identifier (Node#iname) of Node \a node to \a identifier.
 * @param node Node to set the identifier of.
 * @param identifier Name of the identifier.
 */
void setIdentifier(struct Node *node, char *identifier);
//! Find the last Node on the same level as the specified Node.
/*!
 * Search the last Node on the same level as Node \a t.
 * @param t Node of which to find the last neighbour/peer.
 * @return The last Node on the same level as Node \a t.
 */
struct Node *last(struct Node *t);
//! Create a Node representing a constant number.
/*!
 * Create a Node representing the number \a num.
 * @param num The value of the constant.
 * @return Pointer to the created Node instance.
 */
struct Node *createConstant(double num);
//! Create a Node representing a variable.
/*!
 * Create a Node representing a variable with the name \a varname.
 * @param varname The name of the variable.
 * @return Pointer to the created Node instance.
 */
struct Node *createVariable(char *varname);
//! Append a statement to a list of statements.
/*!
 * Appends the statement \a newnode to the list of statements \a prevnodes.
 * \a prevnodes does not have to point at the last Node of that level.
 * This function will find the last Node of the same level and append
 * the \a newnode there.
 * @param prevnodes Pointer to a Node on which level the Node \a newnode
 *                  should be added.
 * @param newnode Node to add to the linked list.
 * @return Pointer to a Node of the level where \a newnode was added.
 */
struct Node *appendStatement(struct Node *prevnodes, struct Node *newnode);
//! Copies the data of a Node to a new Node instance.
/*!
 * Copy the contents of Node \a n to a new Node and recursively does
 * the same to all children. The neighbours of Node \a n will not be
 * copied.
 * @param n Node to copy.
 * @return Pointer to the new Node with the same data as \a n.
 */
struct Node *copyNode(struct Node *n);
//! Remove an Node instance and free the memory it used.
/*!
 * Removes Node \a n and all its children.
 * @param n Node to remove.
 */
void removeNode(struct Node *n);
//! \todo Describe this function
struct Node *findVariable(struct Node *n);
//! Compare two Nodes and their children to check whether they are equivalent.
/*!
 * Compare the Nodes \a n1 and \a n2 and their children to check whether
 * they are equivalent. All properties of the Node struct are compared,
 * just like the complete structure the Nodes represent.
 * @param n1 First Node.
 * @param n2 Second Node.
 * @return 1 when the first and second Node are equivalent, 0 otherwise.
 */
int compareNodes(struct Node *n1, struct Node *n2);

#endif // NODE_H