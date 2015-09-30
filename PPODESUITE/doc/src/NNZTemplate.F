c-----------------------------------------------------------------------
c
c PPODE nonzero function - Model Name
c   Model description.
c
c DEVELOPED BY:
c
c   Pascal Pieters <p.a.pieters@student.tue.nl>
c
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c    neq :in    Number of states/equations.
c   npar :in    Number of parameters.
c    par :in    Vector of parameter values.
c    nnz :out   Number of nonzero elements of the Jacobian matrix.
c
c-----------------------------------------------------------------------

      subroutine nonzero(neq, npar, par, nnz)

c Declare input arguments.
      integer, intent(in) :: neq, npar
      double precision, intent(in) :: par(*)

c Delcare output arguments.
      integer, intent(out) :: nnz

c ydot(1) is dependent on all y(i). ydot(i) for 1 < i < N is dependent
c on y(1), y(i-1), y(i) and y(i+1). ydot(N) is dependent on y(1), 
c y(i-1) and y(i).
      nnz = neq + (neq-1)*4 + 3

      return
      end
