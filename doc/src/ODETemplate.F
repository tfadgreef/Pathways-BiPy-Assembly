c-----------------------------------------------------------------------
c
c PPODE ODE function - Model Name
c   Short model description.
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
c      t :in    Current time point.
c      y :in    Vector of the current values of the states.
c   ydot :out   Vector of the numerical derivatives of the states.
c
c PARAMETERS:
c
c   p(1) :in    s   : Parameter description.
c   p(2) :in    kp  : ...
c
c-----------------------------------------------------------------------

      subroutine func (neq, t, y, ydot)
      integer neq, i, s, np
      double precision t, y, ydot, kp
      double precision , pointer :: p(:)
      dimension y(neq), ydot(neq)
      common  /funcpar/ np, p

      s = int(p(1))
      kp = p(2)
      ...
      ydot(i) = ...
      ...
      return
      end
