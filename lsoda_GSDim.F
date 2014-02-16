
c-----------------------------------------------------------------------
c Basic LSODA call
c Pascal Pieters <p.a.pieters@student.tue.nl>
c-----------------------------------------------------------------------
c      program lsodac
c      call lsodaw(500, 1.0d-6, 1.0d-5, 2, 10000, -100.0d0,
c     + -1.0d0)
c      stop
c      end

      subroutine func (neq, t, y, ydot)
      integer neq, i, s
      double precision t, y, ydot, kp, km
     1 h1, h2, gp, gm
      dimension y(neq), ydot(neq)

      data s/2/, kp/1.0d5/, km/1.0d0/,
     + gp/1.0d5/, gm/1.0d-2/

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
