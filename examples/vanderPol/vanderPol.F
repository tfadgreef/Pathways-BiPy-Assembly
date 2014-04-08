      subroutine func (neq, t, y, np, par, dy)
      integer neq, np
      double precision t, y, dy, par
      integer ppodei
      dimension y(neq), dy(neq), par(np)

      do 10 ppodei = 1, neq
      dy(ppodei) = 0.0d0
  10  continue
      dy(1) = y(2)
      dy(2) = (((par(1) * (1 - (y(1) * y(1)))) * y(2)) - y(1))
      return
      end


