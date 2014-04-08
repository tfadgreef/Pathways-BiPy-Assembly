      subroutine func (neq, t, y, np, par, dy)
      integer neq, np
      double precision t, y, dy, par
      integer ppodei
      dimension y(neq), dy(neq), par(np)

      do 10 ppodei = 1, neq
      dy(ppodei) = 0.0d0
  10  continue
      dy(1) = (y(2) * y(3))
      dy(2) = ((-y(1)) * y(3))
      dy(3) = ((par(1) * y(1)) * y(2))
      return
      end


      subroutine jac (neq, t, y, np, par, j, dy01D)
      integer neq, np, j
      double precision t, y, dy, par, dy01D
      integer ppodei
      dimension y(neq), dy(neq), par(np), dy01D(neq)

      do 20 ppodei = 1, neq
      dy(ppodei) = 0.0d0
  20  continue
      do 30 ppodei = 1, neq
      dy01D(ppodei) = 0.0d0
  30  continue
      dy(1) = (y(2) * y(3))
      dy01D(1) = 0
      if (j .eq. 2) then
      dy01D(1) = y(3)
      end if
      if (j .eq. 3) then
      dy01D(1) = y(2)
      end if
      dy(2) = ((-y(1)) * y(3))
      dy01D(2) = 0
      if (j .eq. 1) then
      dy01D(2) = ((-1) * y(3))
      end if
      if (j .eq. 3) then
      dy01D(2) = (-y(1))
      end if
      dy(3) = ((par(1) * y(1)) * y(2))
      dy01D(3) = 0
      if (j .eq. 1) then
      dy01D(3) = (par(1) * y(2))
      end if
      if (j .eq. 2) then
      dy01D(3) = (par(1) * y(1))
      end if
      return
      end


