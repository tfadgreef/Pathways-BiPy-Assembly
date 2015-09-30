      program testapp
      call test()
      end

      subroutine test()
      external dummy, func
      integer neq, itol, itask, istate, iopt, lrw, liw, iwork(30),
     1 nout, iout
      double precision y(100), rtols, atols, rwork(3120), t, tout
      INTEGER INIT, MXSTEP, MXHNIL, NHNIL, NSLAST, NYH, IOWNS,
     1   ICF, IERPJ, IERSL, JCUR, JSTART, KFLAG, L,
     2   LYH, LEWT, LACOR, LSAVF, LWM, LIWM, METH, MITER,
     3   MAXORD, MAXCOR, MSBP, MXNCF, N, NQ, NST, NFE, NJE, NQU
      INTEGER IPLOST, IESP, ISTATC, IYS, IBA, IBIAN, IBJAN, IBJGP,
     1   IPIAN, IPJAN, IPJGP, IPIGP, IPR, IPC, IPIC, IPISP, IPRSP, IPA,
     2   LENYH, LENYHM, LENWK, LREQ, LRAT, LREST, LWMIN, MOSS, MSBJ,
     3   NSLJ, NGP, NLU, NNZ, NSP, NZL, NZU, mf
      INTEGER I, I1, I2, IFLAG, IMAX, IMUL, IMXER, IPFLAG, IPGO, IREM,
     1   J, KGO, LENRAT, LENYHT, LENIW, LENRW, LF0, LIA, LJA,
     2   LRTEM, LWTEM, LYHD, LYHN, MF1, MORD, MXHNL0, MXSTP0, NCOLM
      DOUBLE PRECISION ROWNS,
     1   CCMAX, EL0, H, HMIN, HMXI, HU, RC, TN, UROUND
      DOUBLE PRECISION CON0, CONMIN, CCMXJ, PSMALL, RBIG, SETH
      DOUBLE PRECISION ATOLI, AYI, BIG, EWTI, H0, HMAX, HMX, RH, RTOLI,
     1   TCRIT, TDIST, TNEXT, TOL, TOLSF, TP, SIZE, SUM, W0
      COMMON /DLS001/ ROWNS(209),
     1   CCMAX, EL0, H, HMIN, HMXI, HU, RC, TN, UROUND,
     2   INIT, MXSTEP, MXHNIL, NHNIL, NSLAST, NYH, IOWNS(6),
     3   ICF, IERPJ, IERSL, JCUR, JSTART, KFLAG, L,
     4   LYH, LEWT, LACOR, LSAVF, LWM, LIWM, METH, MITER,
     5   MAXORD, MAXCOR, MSBP, MXNCF, N, NQ, NST, NFE, NJE, NQU
      COMMON /DLSS01/ CON0, CONMIN, CCMXJ, PSMALL, RBIG, SETH,
     1   IPLOST, IESP, ISTATC, IYS, IBA, IBIAN, IBJAN, IBJGP,
     2   IPIAN, IPJAN, IPJGP, IPIGP, IPR, IPC, IPIC, IPISP, IPRSP, IPA,
     3   LENYH, LENYHM, LENWK, LREQ, LRAT, LREST, LWMIN, MOSS, MSBJ,
     4   NSLJ, NGP, NLU, NNZ, NSP, NZL, NZU

      neq = 100
      lrw = 3120
      liw = 30
      itol = 1
      atols = 1d-4
      rtols = 1d-4
      iopt = 0
      t = 0.0D0
      itask = 1
      istate = 1
      nout = 100000
      tout = 1.0d0

      do 100 i=1, neq
        y(i) = 0.0d0
  100 continue
      y(1) = 100

      mf = 222
      tout = 0.1d0

      do 175 iout=1,nout
c        if (mf .eq. 222) then
c          mf = 10
c        else
c          mf = 222
c        end if
        call dlsodas(func, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, mf)
c        write(*,*) "tout=",tout
c        write(*,*) "mf=",mf
c        write(*,*) "istate=",istate
c        write(*,*) "----------------------------------"
        if (istate .eq. -42) then
          if (mf .eq. 222) then
            mf = 10
          else
            mf = 222
          end if
          istate = 3
        else
          tout = tout + 0.1d0
        end if
c Get the new time point.

 175  continue

c      write(*,*) "istate=",istate
c      write(*,*) "lenrw=",iwork(17)
c      write(*,*) "leniw=",iwork(18)
c      write(*,*) "LYH=",iwork(22)
c      write(*,*) "NYH=",NYH
c      write(*,*) "LWM=",LWM
c      write(*,*) "LEWT=",LEWT
c      write(*,*) "LSAVF=",LSAVF
c      write(*,*) "LACOR=",LACOR
c      write(*,*) "LREQ=",LREQ
c      write(*,*) "LF0=",LF0
c      write(*,*) "LREST=",LREST
c      write(*,*) "LWMIN=",LWMIN
c      write(*,*) "IPIAN=",IPIAN
c      write(*,*) "IPJAN=",IPJAN
c      write(*,*) "NNZ=",IWORK(19)

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
      double precision kp, km, h1
      integer ppodei, i
      dimension x(neq), dx(neq)

      kp = 1.0d0
      km = 1.0d0
      do 10 ppodei = 1, neq
      dx(ppodei) = 0.0d0
  10  continue
      h1 = 0
      do 20 i = 2, neq
      h1 = (h1 + x(i))
  20  continue
      dx(1) = ((((((-2) * kp) * (x(1) ** 2)) + (km * x(2))) + (km * h1))
     + - ((kp * x(1)) * h1))
      do 30 i = 2, (neq - 1)
      dx(i) = (((kp * x(1)) * (x((i - 1)) - x(i))) + (km * (x((i + 1)) -
     + x(i))))
  30  continue
      dx(neq) = ((kp * x(1)) * (x((i - 1)) - x(i)))
      return
      end

