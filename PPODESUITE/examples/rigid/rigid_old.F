c-----------------------------------------------------------------------
c 
c                              PPODE SUITE                              
c
c-----------------------------------------------------------------------

c-----------------------------------------------------------------------
c
c PPODE ODE function - Rigid
c   Example ODE syste.
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
c   ydot :out   Vector of the numerical derivatives of the states (dy/dt).
c
c PARAMETERS:
c
c   p(1) :in    p1  : The only parameter of the system.
c
c-----------------------------------------------------------------------

      subroutine func (neq, t, y, ydot)
      integer neq, i, s, np
      double precision t, y, ydot, p1
      double precision, pointer :: p(:)
      dimension y(neq), ydot(neq)
      COMMON  /funcpar/ np, p

      p1 = p(1)

      ydot(1) = y(2) * y(3)
      ydot(2) = -y(1) * y(3)
      ydot(3) = p1 * y(1) * y(2)

      return
      end
