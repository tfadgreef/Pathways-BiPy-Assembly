      subroutine func (neq, t, y, np, par, dy)
      integer neq, np
      double precision t, y, dy, par
      dimension y(neq), dy(neq), par(np)

      dy(:) = 0
      dy(1) = (y(2) * y(3))
      dy(2) = ((-y(1)) * y(3))
      dy(3) = ((par(1) * y(1)) * y(2))
      return
      end


      subroutine jac (neq, t, y, np, par, j, dy01D)
      integer neq, np, j
      double precision t, y, dy, par, dy01D, y01D
      dimension y(neq), dy(neq), par(np), dy01D(neq), y01D(neq)

      y01D(:) = 0
      y01D(j) = 1
      dy(:) = 0
      dy01D(:) = 0
      dy(1) = (y(2) * y(3))
      dy01D(1) = ((y01D(2) * y(3)) + (y(2) * y01D(3)))
      dy(2) = ((-y(1)) * y(3))
      dy01D(2) = (((-y01D(1)) * y(3)) + ((-y(1)) * y01D(3)))
      dy(3) = ((par(1) * y(1)) * y(2))
      dy01D(3) = (((par(1) * y01D(1)) * y(2)) + ((par(1) * y(1)) * y01D(
     +2)))
      return
      end


