c-----------------------------------------------------------------------
c 
c                               LSODAMEX                                
c
c-----------------------------------------------------------------------
c
c Copyright (c) 2014, Pascal Pieters, All rights reserved.
c 
c This library is free software; you can redistribute it and/or
c modify it under the terms of the GNU Lesser General Public
c License as published by the Free Software Foundation; either
c version 3.0 of the License, or (at your option) any later version.
c
c This library is distributed in the hope that it will be useful,
c but WITHOUT ANY WARRANTY; without even the implied warranty of
c MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
c Lesser General Public License for more details.
c
c You should have received a copy of the GNU Lesser General Public
c License along with this library.
c
c-----------------------------------------------------------------------


c-----------------------------------------------------------------------
c
c LSODA ODE function - GSDim
c   Nucleation-Elongation model (with dimensions) by 
c   Goldstein and Stryer.
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
c   p(1) :in    s   : Number of monomers of the nucleus.
c   p(2) :in    kp  : Forward reaction rate until the nucleus.
c   p(3) :in    km  : Backward reaction rate until the nucleus.
c   p(4) :in    gp  : Forward reaction rate after the nucleus.
c   p(5) :in    gm  : Backward reaction rate after the nucleus.
c
c-----------------------------------------------------------------------

      subroutine func (neq, t, y, ydot)
      integer neq, i, s, np
      double precision t, y, ydot, kp, km
     1 h1, h2, gp, gm
      double precision, pointer :: p(:)
      dimension y(neq), ydot(neq)
      COMMON  /funcpar/ np, p

      s = int(p(1))
      kp = p(2)
      km = p(3)
      gp = p(4)
      gm = p(5)

c Help variable 1
      h1 = 0
      do 200 i=2, (s-1)
        h1 = h1 + y(i);
 200  continue

c Help variable 2
      h2 = 0
      do 220 i=(s+1), neq
        h2 = h2 + y(i);
 220  continue

c First equation is special
      ydot(1) = -2.0d0 * kp * y(1) * y(1) + km * y(2) +
     + km * (h1 + y(s)) + gm * h2 - kp * y(1) * h1 -
     + gp * y(1) * (y(s) + h2)

c Until the nucleus
      do 240 i=2, (s-1)
        ydot(i) = kp * y(1) * (y(i-1) - y(i)) +
     +  km * (y(i+1) - y(i))
 240  continue

c The nucleus
      ydot(s) = y(1) * (kp * y(s-1) - gp* y(s)) + gm * y(s+1) +
     + km * y(s)

c After the nucleus, until N-1
      do 260 i=(s+1), (neq-1)
        ydot(i) = gp * y(1) * (y(i-1) - y(i)) + gm* (y(i+1) - y(i))
 260  continue

c The last one
      ydot(neq) = gp * y(1) * (y(i-1) - y(i))

      return
      end
