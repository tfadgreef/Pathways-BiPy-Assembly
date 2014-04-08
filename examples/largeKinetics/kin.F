      subroutine func (N, t, x, np, par, dx)
      integer N, np
      double precision t, x, dx, par
      double precision kp, km, h1
      integer ppodei, i
      dimension x(N), dx(N), par(np)

      kp = par(1)
      km = par(2)
      do 10 ppodei = 1, N
      dx(ppodei) = 0.0d0
  10  continue
      h1 = 0
      do 20 i = 2, N
      h1 = (h1 + x(i))
  20  continue
      dx(1) = ((((((-2) * kp) * (x(1) ** 2)) + (km * x(2))) + (km * h1))
     + - ((kp * x(1)) * h1))
      do 30 i = 2, (N - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
  30  continue
      dx(N) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      return
      end


      subroutine jac (N, t, x, np, par, j, dx01D)
      integer N, np, j
      double precision t, x, dx, par, dx01D
      double precision kp, km, h1, kp01D, km01D, h101D
      integer ppodei, i
      dimension x(N), dx(N), par(np), dx01D(N)

      kp = par(1)
      km = par(2)
      do 40 ppodei = 1, N
      dx(ppodei) = 0.0d0
  40  continue
      do 50 ppodei = 1, N
      dx01D(ppodei) = 0.0d0
  50  continue
      h1 = 0
      h101D = 0
      do 60 i = 2, N
      h1 = (h1 + x(i))
      h101D = h101D
      if (j .eq. i) then
      h101D = (h101D + 1)
      end if
  60  continue
      dx(1) = ((((((-2) * kp) * (x(1) ** 2)) + (km * x(2))) + (km * h1))
     + - ((kp * x(1)) * h1))
      dx01D(1) = (((((-2) * kp) * (0 / (2 ** 2))) + (km * h101D)) - ((kp
     + * x(1)) * h101D))
      if (j .eq. 1) then
      dx01D(1) = (((((-2) * kp) * (2 / (2 ** 2))) + (km * h101D)) - ((kp
     + * h1) + ((kp * x(1)) * h101D)))
      end if
      if (j .eq. 2) then
      dx01D(1) = ((((((-2) * kp) * (0 / (2 ** 2))) + km) + (km * h101D))
     + - ((kp * x(1)) * h101D))
      end if
      do 70 i = 2, (N - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
      dx01D(i) = 0
      if (j .eq. 1) then
      dx01D(i) = (kp * (x((i - 1)) - x(i)))
      end if
      if (j .eq. (i - 1)) then
      dx01D(i) = (kp * x(1))
      end if
      if (j .eq. i) then
      dx01D(i) = (((kp * x(1)) * (0 - 1)) + (km * (0 - 1)))
      end if
      if (j .eq. (i + 1)) then
      dx01D(i) = km
      end if
  70  continue
      dx(N) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      dx01D(N) = 0
      if (j .eq. 1) then
      dx01D(N) = (kp * (x((i - 1)) - x(i)))
      end if
      if (j .eq. (i - 1)) then
      dx01D(N) = (kp * x(1))
      end if
      if (j .eq. i) then
      dx01D(N) = ((kp * x(1)) * (0 - 1))
      end if
      return
      end


