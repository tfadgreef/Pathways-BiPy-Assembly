      subroutine func (N, t, x, np, par, dx)
      integer N, np
      double precision t, x, dx, par
      double precision kp, km, h1
      integer i
      dimension x(N), dx(N), par(np)

      kp = par(1)
      km = par(2)
      dx(:) = 0
      h1 = 0
      do 10 i = 2, N
      h1 = (h1 + x(i))
  10  continue
      dx(1) = ((((((-2) * kp) * (x(1) ** 2)) + (km * x(2))) + (km * h1))
     + - ((kp * x(1)) * h1))
      do 20 i = 2, (N - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
  20  continue
      dx(N) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      return
      end


      subroutine jac (N, t, x, np, par, j, dx01D)
      integer N, np, j
      double precision t, x, dx, par, dx01D, x01D
      double precision kp, km, h1, h101D
      integer i
      dimension x(N), dx(N), par(np), dx01D(N), x01D(N)

      x01D(:) = 0
      x01D(j) = 1
      kp = par(1)
      km = par(2)
      dx(:) = 0
      dx01D(:) = 0
      h1 = 0
      h101D = 0
      do 30 i = 2, N
      h1 = (h1 + x(i))
      h101D = (h101D + x01D(i))
  30  continue
      dx(1) = ((((((-2) * kp) * (x(1) ** 2)) + (km * x(2))) + (km * h1))
     + - ((kp * x(1)) * h1))
      dx01D(1) = ((((((-2) * kp) * ((2 * x01D(1)) * x(1))) + (km * x01D(
     +2))) + (km * h101D)) - (((kp * x01D(1)) * h1) + ((kp * x(1)) * h10
     +1D)))
      do 40 i = 2, (N - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
      dx01D(i) = ((((kp * x01D(1)) * (x((i - 1)) - x(i))) + ((kp * x(1))
     + * (x01D((i - 1)) - x01D(i)))) + (km * (x01D((i + 1)) - x01D(i))))
  40  continue
      dx(N) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      dx01D(N) = (((kp * x01D(1)) * (x((i - 1)) - x(i))) + ((kp * x(1)) 
     +* (x01D((i - 1)) - x01D(i))))
      return
      end


