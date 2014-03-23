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
c     np :in    Number of parameters.
c      p :in    Vector of the values of the parameters.
c   ydot :out   Vector of the numerical derivatives of the states.
c
c PARAMETERS:
c
c   p(1) :in    s   : Parameter description.
c   p(2) :in    kp  : ...
c
c-----------------------------------------------------------------------

      subroutine func (neq, t, y, np, p, ydot)
      integer neq, i, s, np
      double precision t, y, ydot, kp, par
      dimension y(neq), ydot(neq), par(np)

      s = int(p(1))
      kp = p(2)
      ...
      ydot(i) = ...
      ...

      return
      end
