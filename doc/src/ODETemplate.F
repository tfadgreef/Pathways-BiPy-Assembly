!-----------------------------------------------------------------------
!
! PPODE ODE function - Model Name
!   Short model description.
!
! DEVELOPED BY:
!
!   Pascal Pieters <p.a.pieters@student.tue.nl>
!
!-----------------------------------------------------------------------
!
! ARGUMENTS:
!
!    neq :in    Number of states/equations.
!      t :in    Current time point.
!      y :in    Vector of the current values of the states.
!   ydot :out   Vector of the numerical derivatives of the states.
!
! PARAMETERS:
!
!   p(1) :in    s   : Parameter description.
!   p(2) :in    kp  : ...
!
!-----------------------------------------------------------------------

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
