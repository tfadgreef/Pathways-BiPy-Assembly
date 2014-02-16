
c-----------------------------------------------------------------------
c Pascal Pieters <p.a.pieters@student.tue.nl>
c-----------------------------------------------------------------------

c-----------------------------------------------------------------------
c
c LSODAW - LSODA Wrapper
c 
c-----------------------------------------------------------------------
c ARGUMENTS:
c
c    neq : (int)  Number of states/equations.
c   atol : (real) Absolute tolerance.
c   rtol : (real) Relative tolerance.
c  timef : (int)  Time function to use:
c                 1 = Linear time function (t=dt*i)
c                 2 = Exponential timefunction (t=10**(dt*i))
c   nout : (int)  Number of output timepoints.
c   tbeg : (real) The first timepoint to return. For the linear time
c                 function t0=tbeg. For the exponential time function
c                 t0=10**tbeg.
c   tend : (real) The end time of the simulation. For the exponential
c                 time function the last timepoint will be 10**tend.
c-----------------------------------------------------------------------

      subroutine lsodaw(neq, atol, rtol, timef, nout,
     + tbeg, tend, y0, text, yext)

      external func, dummy
      integer i, iopar, iopt, iout, istate, itask, itol,
     1 leniw, lenrw, lout, jt, rout, ml, mu,
     2 neq, nerr, nfe, nfea, nje, nout, nqu, nst,
     3 timef, lrw, liw, iwork, cnout, ctimef
      double precision atol, dtout, er, erm, ero, hu, rtol,
     1 t, tout, tout1, y, timfun, rwork, satol, srtol,
     2 tbeg, tend, ctbeg, ctend, y0
c MEX printing
      character*120 line
      integer*4 k
      integer*4 mexPrintf
      real*8 text(nout), yext(nout,neq)

      COMMON  /opts/ ctimef, ctbeg, ctend, cnout

      dimension y(neq), rwork(22 + neq * max(16, neq + 9)),
     1 iwork(22 + neq), y0(neq)

      data lout/6/, rout/20/

      lrw = 22 + neq * max(16, neq + 9)
      liw = 22 + neq

      ctimef = timef
      cnout = nout
      ctbeg = tbeg
      ctend = tend

      tout1 = timfun(1)

c
c Some default values
c

      nerr = 0
c Specify tolerance as a scalar (2 for vector/array)
      itol = 1

c No optional inputs
      iopt = 0

c Define the Jacobian type (full)
      jt = 2

c Always start at t=0
      t = 0.0d0

c Initial values (start at 1 with arrays!)
      y = y0

      itask = 1
c Set as first call (istate = 2 for subsequent call)
      istate = 1

c First output time point
      tout = tout1

c Absolute tolerance can be adjusted
      satol = atol
      srtol = rtol

c Keep track of the maximum error
      ero = 0.0d0

c
c Open file for output
c

c      open (UNIT=rout, FILE="lsoda_out.txt",
c     + ACTION="write", STATUS="replace")

c
c Loop through al desired output points
c

      do 170 iout = 1,nout
c Call the solver
        call dlsoda(func,neq,y,t,tout,itol,srtol,
     1   satol,itask,istate,iopt,rwork,lrw,iwork,
     2   liw,dummy,jt)

c        write (lout,140) iwork(19), iwork(14), iwork(13),
c     1   iwork(12), rwork(13), rwork(11)
c 140    format(//'; Method: ',i4/
c     1   '; Order: ',i4/
c     2   '; J-evals (cumm.): ',i4/
c     3   '; evals (cumm.): ',i6/
c     4   '; TOLSF: ',d15.3/
c     5   '; dt: ',d15.3)

c Write the calculations to a file
c        write (rout,150) t,y(1),y(2)
c 150    format(d15.5,d16.5,d14.3)
        do 160 i = 1,neq
          yext(iout, i) = y(i)
 160    continue
        text(iout) = t

c        write (rout, "(d15.5)", advance="no") text(iout)
c        write( rout,*) (yext(iout,i), i=1,neq)

c        if ((istate .eq. -3) .or. (istate .eq. -2)) then
c          satol = satol * rwork(13)
c          srtol = srtol * rwork(13)
c          go to 170
c        endif


c If istate < 0: the call was unsuccessful
        if (istate .lt. 0) go to 175

 170    tout = timfun(iout + 1)
 175  continue

c Close the file
c      close (rout)

c Check for errors one more time
      if (istate .lt. 0) nerr = nerr + 1

c Number of steps
      nst = iwork(11)
c Number of function evaluations
      nfe = iwork(12)
c Number of jacobian evaluations
      nje = iwork(13)
c RWork size (real)
      lenrw = iwork(17)
c IWork size (int)
      leniw = iwork(18)

c Print summary
      write (lout,180) lenrw,leniw,nst,nfe,nje,ero
 180  format(//' Final statistics for this run:'/
     1  ' rwork size =',i4,'   iwork size =',i4/
     2  ' number of steps =',i5/
     3  ' number of f-s   =',i5/
     4  ' number of J-s   =',i5/
     5  ' error overrun =',d10.2)

      return
      end

      double precision function timfun (i)
      double precision ctbeg, ctend, a
      integer i, ctimef, cnout
      COMMON  /opts/ ctimef, ctbeg, ctend, cnout

      if (ctimef .eq. 1) then
        timfun = i * ((ctend-ctbeg)/cnout) + ctbeg
      elseif (ctimef .eq. 2) then
        a = i * ((ctend-ctbeg)/cnout)
        timfun = 10.0d0 ** (a + ctbeg)
      else
        print *, "ERROR: Unknown time function."
        stop
        return
      endif

      return
      end


      subroutine dummy (neq, t, y, ml, mu, pd, nrowpd)
      return
      end

