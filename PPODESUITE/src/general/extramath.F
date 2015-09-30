c Helper functions.
      function d01asin(x)
      double precision x
      d01asin = 1/dsqrt(1-(x**2))
      return
      end

      function d01cos(x)
      double precision x
      d01cos = -dsin(x)
      return
      end

      function d01acos(x)
      double precision x
      d01acos = -1/dsqrt(1-(x**2))
      return
      end

      function d01tan(x)
      double precision x
      d01tan = dsec(x) ** 2
      return
      end

      function d01atan(x)
      double precision x
      d01atan = 1/((x**2)+1)
      return
      end

      function dcot(x)
      double precision x
      dcot = 1.0/dtan(x)
      return
      end

      function d01cot(x)
      double precision x
      d01cot = -(dcsc(x) ** 2)
      return
      end

      function dsec(x)
      double precision x
      dsec = 1.0/dcos(x)
      return
      end

      function d01sec(x)
      double precision x
      d01sec = dsec(x) * dtan(x)
      return
      end

      function dcsc(x)
      double precision x
      dcsc = 1.0/dsin(x)
      return
      end

      function d01csc(x)
      double precision x
      d01csc = -dcsc(x) * dcot(x)
      return
      end

      function d01log(x)
      double precision x
      d01log = 1/x
      return
      end

      function d01sqrt(x)
      double precision x
      d01sqrt = 1/(2*dsqrt(x))
      return
      end

      function d01abs(x)
      double precision x
      d01abs = x/dsqrt(x ** 2)
      return
      end

      function d01cosh(x)
      double precision x
      d01cosh = -dsinh(x)
      return
      end

      function d01tanh(x)
      double precision x
      d01tanh = dsech(x) ** 2
      return
      end

      function dsech(x)
      double precision x
      dsech = 1/dcosh(x)
      return
      end

      function d01sech(x)
      double precision x
      d01sech = -dtanh(x)*dsech(x)
      return
      end

      function dcoth(x)
      double precision x
      dcoth = dcosh(x)/dsinh(x)
      return
      end

      function d01coth(x)
      double precision x
      d01coth = -(dcsch(x) ** 2)
      return
      end

      function dcsch(x)
      double precision x
      dcsch = 1/dsinh(x)
      return
      end

      function d01csch(x)
      double precision x
      d01csch = -dcoth(x)*dcsch(x)
      return
      end

      function dceiling(x)
      double precision x
      dceiling = dble(ceiling(x))
      return
      end

      function dfloor(x)
      double precision x
      dfloor = dble(floor(x))
      return
      end

      function dround(x)
      double precision x
      dround = dble(idnint(x))
      return
      end

      function dzero(x)
      double precision x
      dzero = 0.0d0
      return
      end

