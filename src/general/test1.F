      program testapp
      call test()
      end

      subroutine test()
      external dummy, func
      integer neq, itol, itask, istate, iopt, lrw, liw, iwork(922),
     1 nout, iout
      double precision y(100), rtols, atols, rwork(10922), t, tout
      INTEGER INIT, MXSTEP, MXHNIL, NHNIL, NSLAST, NYH, IOWNS,
     1   ICF, IERPJ, IERSL, JCUR, JSTART, KFLAG, L,
     2   LYH, LEWT, LACOR, LSAVF, LWM, LIWM, METH, MITER,
     3   MAXORD, MAXCOR, MSBP, MXNCF, N, NQ, NST, NFE, NJE, NQU
      INTEGER I, I1, I2, IFLAG, IMXER, KGO, LF0,
     1   LENIW, LENRW, LENWM, ML, MORD, MU, MXHNL0, MXSTP0
      DOUBLE PRECISION ROWNS,
     1   CCMAX, EL0, H, HMIN, HMXI, HU, RC, TN, UROUND
      DOUBLE PRECISION ATOLI, AYI, BIG, EWTI, H0, HMAX, HMX, RH, RTOLI,
     1   TCRIT, TDIST, TNEXT, TOL, TOLSF, TP, SIZE, SUM, W0
      COMMON /DLS001/ ROWNS(209),
     1   CCMAX, EL0, H, HMIN, HMXI, HU, RC, TN, UROUND,
     2   INIT, MXSTEP, MXHNIL, NHNIL, NSLAST, NYH, IOWNS(6),
     3   ICF, IERPJ, IERSL, JCUR, JSTART, KFLAG, L,
     4   LYH, LEWT, LACOR, LSAVF, LWM, LIWM, METH, MITER,
     5   MAXORD, MAXCOR, MSBP, MXNCF, N, NQ, NST, NFE, NJE, NQU

      neq = 100
      lrw = 10922
      liw = 120
      itol = 1
      atols = 1d-4
      rtols = 1d-4
      iopt = 0
      t = 0.0D0
      itask = 1
      istate = 1
      nout = 10
      tout = 0.1d0

      do 100 i=1, neq
        y(i) = 0.0d0
  100 continue
      y(1) = 100

      do 175 iout=1,nout
        call dlsode(func, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, 22)
        write(*,*) "tout=",tout
c Get the new time point.
 170    tout = tout + 0.1d0

 175  continue

      write(*,*) "istate=",istate
      write(*,*) "lenrw=",iwork(17)
      write(*,*) "leniw=",iwork(18)
      write(*,*) "LYH=",LYH
      write(*,*) "NYH=",NYH
      write(*,*) "LWM=",LWM
      write(*,*) "LEWT=",LEWT
      write(*,*) "LSAVF=",LSAVF
      write(*,*) "LACOR=",LACOR

      return
      end

c-----------------------------------------------------------------------
c
c Dummy routine that is passed since we are not using a analytical
c Jacobian function.
c
c-----------------------------------------------------------------------
      subroutine dummy (neq, t, y, ml, mu, pd, nrowpd)
      return
      end

      subroutine func (neq, t, x, dx)
      integer neq
      double precision t, x, dx
      double precision kp, km
      integer ppodei, i
      dimension x(neq), dx(neq)

      kp = 1.0d0
      km = 1.0d0
      do 10 ppodei = 1, neq
      dx(ppodei) = 0.0d0
  10  continue

      dx(1) = (((((-2) * kp) * (x(1) ** 2)) + (km * x(2))))
      do 30 i = 2, (neq - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
  30  continue
      dx(neq) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      return
      end

