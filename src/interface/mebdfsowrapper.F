c-----------------------------------------------------------------------
c 
c                              PPODE SUITE                              
c
c-----------------------------------------------------------------------
c
c Copyright (c) 2014, Pascal Pieters, All rights reserved.
c 
c This library is free software; you can redistribute it and/or
c modify it under the terms of the GNU Lesser General Public
c License as published by the Free Software Foundation; either
c version 3.0 of the License, or (at your option) any later version.
c
c This library is distributed in the hope that it will be useful,
c but WITHOUT ANY WARRANTY; without even the implied warranty of
c MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
c Lesser General Public License for more details.
c
c You should have received a copy of the GNU Lesser General Public
c License along with this library.
c
c-----------------------------------------------------------------------


c-----------------------------------------------------------------------
c
c MEBDFSOW - MEBDFSO Wrapper
c
c DEVELOPED BY:
c
c   Pascal Pieters <p.a.pieters@student.tue.nl>
c
c-----------------------------------------------------------------------
c 
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c    neq :in    Number of states/equations.
c   atol :in    Absolute tolerance.
c   rtol :in    Relative tolerance.
c   nout :in    Number of output time points.
c  times :in    Vector of time points to calculate the ODEs at. times
c               should be a noutx1 or 1xnout vector.
c   npar :in    Number of parameters in the system.
c    par :in    Vector of parameter values. par should be a nparx1 or
c               1xnpar vector.
c     y0 :in    Initial values of the states of the system. y0 should be
c               a neqx1 or 1xneq vector.
c   tret :out   Vector that will hold the time point values where the
c               ODEs of the system have been calculated.
c   yret :out   A vector of the values of all states corresponing to the
c               time points of tret.
c
c-----------------------------------------------------------------------
#include <fintrf.h>
#include "defs.h"

      subroutine mebdfsow(neq, atol, rtol, nout, times, npar, par, y0,
     + tret, yret, oret)

c-----------------------------------------------------------------------
c
c Declare all variables.
c
c-----------------------------------------------------------------------

c Declare externals.
      external mebdfsofunc, pderv, h0est, mebjac, mebnonzero, jac
c Declare input arguments.
      integer, intent(in) :: neq, npar, nout

      double precision, intent(in) :: atol, rtol
      double precision, intent(in) :: y0(neq), times(nout)
      double precision, intent(in), target :: par(npar)
c Declare output arguments.
      real*8, intent(out) :: tret(nout), yret(nout, neq)
#ifdef TIMING
      double precision, intent(out) :: oret(nout)
#else
      double precision, intent(out) :: oret(*)
#endif
c Declare local variables.
      integer :: iwork(6*neq+2*(neq*5)+15), ipar(1)
      integer i, iopar, iopt, iout, istate, itask, itol, leniw, lenrw,
     1 jt, ml, mu, nerr, nfe, nfea, nje, nqu, nst, lrw, liw, np, j,
     2 ierr, nnz, nsp
      integer, parameter :: stderr = 20

      double precision, pointer :: p(:)
      double precision :: dtout, er, erm, ero, hu, tout, t, rtols,
     1 tolsf, atols, t0, h0, tend, maxint
      double precision :: y(neq)
      double precision :: rpar(1),
     1 rwork((33*neq+2*(neq*5)+(8*neq+2+2*(neq*5))+3))
#ifdef MAXTIME
      real maxt0, maxt1
#endif
#ifdef TIMING
      real bench0, bench1
#endif
c Delcare variables used for printing tret in MEX.
      character*200 line
      integer*4 k
      integer*4 mexPrintf
c The following code can be used to print variable values.
c#      write(line,*) 'neq = ',neq
c#      k = mexPrintf(line//achar(13))
c Common variables used for passing parameters to
c ODE function.
      COMMON  /funcpar/ np, p

#ifdef MAXTIME
c Initialize time tracking.
      call cpu_time(maxt0)
#endif

c Redirect all output of the LSODE solver to a file.
      open(unit=stderr, file="lsode.log", form="formatted")

c-----------------------------------------------------------------------
c
c Initialize all variables.
c
c-----------------------------------------------------------------------

      maxint = dble(huge(iwork(6)))

c Estimate nnz
c      call nonzero(neq, npar, par, nnz)
#if defined(INPUTNONZERO)
      nnz = int(oret(1))
#else
      call mebnonzero(neq, y0, npar, par, nnz)
#endif

#if defined(DEBUG)
      write(line,*) 'Calculated NNZ = ', nnz
      k = mexPrintf(line//achar(13))
#endif

c Calculate nsp based on the formula in the yale comments.
c nsp=8*{neq}+2+2*{nnz}
      nsp = 8*neq + 2 + 2*nnz

c Calculate the correct size of the iwork and rwork
c variables, based on the description of the LSODA
c function.
      lrw = (33*neq + 2*nnz + nsp + 3)
      liw = 6*neq + 2*nnz + 15
c The first time to output is the first value in the times
c vector.
      tout = times(1)
      tend = times(nout)
c Make the pointer p point to the vector of parameters. the
c pointer can be accessed in the ODE function via the 
c /funcpar/ common block.
      np = npar
      p => par
c Initialize the error counter.
      nerr = 0
c Specify tolerance as a scalar (2 for vector/array).
      itol = 1

c Start with the given tolerances.
      atols = atol
      rtols = rtol

      ierr = 0

c Always start at t=0.
      t = 0.0d0
c Estimate the initial step size
      call h0est(h0, neq, t, tout, y0, rtol, atol, stderr)
c      h0 = 1.0e-30
c Initial value for the ODE problem.
      y = y0
c Intial value of itask should be 1.
      itask = 1
c Intial value of istate should be 1.
c (istate = 2 for subsequent calls)
      istate = 1
c Keep track of the maximum error.
      ero = 0.0d0
c Set the output variables to zeros.
      do 110 i=1, nout
        tret(i) = 0.0d0
        do 100 j=1, neq
          yret(i,j) = 0.0d0
  100   continue
  110 continue

      do 120 i=1, liw
        iwork(i) = 0
  120 continue
      do 130 i=1, liw
        rwork(i) = 0.0d0
  130 continue

#ifdef MAXSTEPS
      iwork(11) = MAXSTEPS
#else
      iwork(11) = 1000
#endif

#ifdef MAXORDER1
      iwork(10) = MAXORDER1
#endif

c-----------------------------------------------------------------------
c
c Loop through al desired output points.
c
c-----------------------------------------------------------------------

      do 175 iout = 0,nout

#ifdef IMAXSTEPS
        if ((IMAXSTEPS*times(iout)) .gt. maxint) then
          iwork(11) = maxint
        else
          iwork(11) = (IMAXSTEPS*times(iout))
        endif
#endif

#ifdef TIMING
c Benchmarking
        call cpu_time(bench0)
#endif
c Call the solver
#if defined(USERSUPPLIEDJAC)
        call mebdfso(neq, t, h0, y, tout, tend, 25, istate, stderr,
     1   lrw, rwork, liw, iwork, 7, itol, rtols, atols, mebdfsofunc,
     2   mebjac, nsp, nnz, ipar, rpar, ierr)
#else
        call mebdfso(neq, t, h0, y, tout, tend, 26, istate, stderr,
     1   lrw, rwork, liw, iwork, 7, itol, rtols, atols, mebdfsofunc,
     2   pderv, nsp, nnz, ipar, rpar, ierr)
#endif


c         write(line,*) 'istate=',istate
c         k = mexPrintf(line//achar(13))

c         if (iout - 100*int(iout/100) .eq. 0) then
c           write(line,*) 'i=', iout, ',t=',t,',tout=',tout
c           k = mexPrintf(line//achar(13))
c         endif

c Check whether the solver was successful.
        if (iout .eq. 0) then
          istate = 0
          y = y0
c Skip the first output, the output time is not close to the desired
c time point.
c          go to 170
        elseif (istate .lt. 0) then
          select case (istate)
            case(-1)
              write(line,8001) istate
            case(-2)
              write(line,8002) istate
            case(-3)
              write(line,8003) istate
            case(-4)
              write(line,8004) istate
            case(-5)
              write(line,8005) istate
            case(-6)
              write(line,8006) istate
            case(-7)
              write(line,8007) istate
            case(-11)
              write(line,8011) istate
            case(-12)
              write(line,8012) istate
            case default
              write(line,8000) istate
          end select
          k = mexPrintf(line//achar(13))
          go to 400
        else
c Copy the value of y(:) to the output vector.
          yret(iout, :) = y
c Copy this time point to the output vector of times.
          tret(iout) = t
#ifdef TIMING
c Benchmarking
          call cpu_time(bench1)
          oret(iout) = (bench1-bench0)
#endif
        endif

#ifdef DEBUG
c        iopar = iout - 2*(iout/2)
c        if (iopar .ne. 0) go to 170
c        er = abs(y(1))/atol
c        ero = max(ero,er)
c        if (er .gt. 1000.0d0) then
c          write(line,*) 'Warning: error exceeds 1000 * tolerance.'
c          k = mexPrintf(line//achar(13))
c          nerr = nerr + 1
c        endif
#endif

#ifdef MAXTIME
c Check whether the passed time is below the maximum time.
        call cpu_time(maxt1)
        if ((maxt1-maxt0) .ge. MAXTIME) then
          write(line,9001) 1, (maxt1-maxt0)
          k = mexPrintf(line//achar(13))
          go to 180
        endif
#endif

c Get the new time point.
 170    tout = times(iout+1)

 175  continue

c Check for errors one more time
 180  if (istate .lt. 0) nerr = nerr + 1

c-----------------------------------------------------------------------
c
c Calculate some stats of the solver/solution.
c
c-----------------------------------------------------------------------

#ifdef DEBUG
c Number of steps
c      nst = iwork(11)
c Number of function evaluations
c      nfe = iwork(12)
c Number of jacobian evaluations
c      nje = iwork(13)
c RWork size (real)
c      lenrw = iwork(17)
c IWork size (int)
c      leniw = iwork(18)

c Print summary
c      write(line,*) 'number of steps = ', nst
c      k = mexPrintf(line//achar(13))
c      write(line,*) 'number of f-s = ', nfe
c      k = mexPrintf(line//achar(13))
c      write(line,*) 'number of J-s = ', nje
c      k = mexPrintf(line//achar(13))
c      write(line,*) 'error overrun = ', ero
c      k = mexPrintf(line//achar(13))
#endif

c Print the LSODE output.

  400 rewind stderr
      do
        read(stderr,'(a)',end=500) line
        k = mexPrintf(line//achar(13))
      enddo
  500 close(unit=stderr, status='delete')

      return
c
c Error messages
c

 8000 format('ERROR(MEBDFSO)[',i2,']: Unknown error.')
 8001 format('ERROR(MEBDFSO)[',i2,']: Time has been reduced by a '
     +       'factor of 1.0e10 from its initial value.')
 8002 format('ERROR(MEBDFSO)[',i2,']: Repeated error test failures.')
 8003 format('ERROR(MEBDFSO)[',i2,']: The integration was halted after '
     +       'failing to achieve corrector convergence even after '
     +       'reducing the time step by a factor of 1E10 from its '
     +       'initial value.')
 8004 format('ERROR(MEBDFSO)[',i2,']: Illegal values of input '
     +       'arguments.')
 8005 format('ERROR(MEBDFSO)[',i2,']: There were errors in the last '
     +       'step that have not been corrected.')
 8006 format('ERROR(MEBDFSO)[',i2,']: Maximum allowed number of '
     +       'integration steps exceeded.')
 8007 format('ERROR(MEBDFSO)[',i2,']: Step size too small compared to '
     +       'system precision.')
 8011 format('ERROR(MEBDFSO)[',i2,']: Insufficient real workspace.')
 8012 format('ERROR(MEBDFSO)[',i2,']: Insufficient integer workspace.')

c
c Warning messages
c

 9001 format('WARNING(MEBDFSO)[',i2,']: Maximum time exceeded. After ',
     +       d10.2, ' seconds the last time point was not reached.')


      end

      SUBROUTINE H0EST(H0, NEQ, T, TOUT, Y, RTOL, ATOL, STDERR)
c
c Adapted LSODA code
c
      DOUBLE PRECISION UROUND, H0, TDIST, TOL, RTOL, ATOL, AYI, W0,
     + SM, Y(NEQ), T, TOUT
      INTEGER NEQ, STDERR

      UROUND = DUMACH()
      TDIST = ABS(TOUT - T)
      W0 = MAX(ABS(T),ABS(TOUT))
      IF (TDIST .LT. 2.0D0*UROUND*W0) THEN
        write(STDERR,8100)
        H0 = 0
        GO TO 1180
      ENDIF
      TOL = RTOL
      IF (TOL .GT. 0.0D0) GO TO 1160
      DO 1150 I = 1,NEQ
        AYI = ABS(Y(I))
        IF (AYI .NE. 0.0D0) TOL = MAX(TOL,ATOL/AYI)
 1150 CONTINUE
 1160 TOL = MAX(TOL,100.0D0*UROUND)
      TOL = MIN(TOL,0.001D0)
      SM = 1.0D0/(TOL*W0*W0)
      H0 = 1.0D0/SQRT(SM)
      H0 = MIN(H0,TDIST)
      H0 = SIGN(H0,TOUT-T)

 1180 RETURN

 8100 FORMAT('ERROR[-]: Could not determine the initial time step.')

      END


      subroutine mebdfsofunc (neq,t,y,ydot,ipar,rpar,ierr)
      external func
      integer neq, ipar(*), ierr, np
      double precision t(*), y(*), ydot(*), rpar(*)
      double precision, pointer :: p(:)
      COMMON  /funcpar/ np, p

      call func(neq, t, y, np, p, ydot)
      ierr = 0

      return
      end     

c-----------------------------------------------------------------------
c
c Dummy routine that is passed since we are not using a analytical
c Jacobian function.
c
c-----------------------------------------------------------------------
      subroutine pderv (N,T,Y,J,PD,IPAR,RPAR,IERR)
      integer ierr
      ierr = 0
      return
      end

      subroutine mebjac (neq, t, y, j, pdj, ipar, rpar, ierr)
      external jac
      double precision t(*), y(*), pdj(*), rpar(*)
      integer neq, np, ipar(*)
      double precision, pointer :: p(:)
      common  /funcpar/ np, p

      call jac(neq, t, y, np, p, j, pdj)
      ierr = 0

      return
      end

c--
c--
      subroutine mebnonzero (neq, y, np, p, nnz)
      external jac
      double precision y(neq), pdj1(neq), pdj2(neq), p(np), y0(neq)
      integer neq, np, j, i, nnz

      nnz = 0

      do 600 i = 1, neq
       y0(i) = y(i) + 100.0d0 * rand()
  600 continue      

      do 700 j = 1, neq
       do 610 i = 1, neq
        pdj1(i) = 0.0d0
        pdj2(i) = 0.0d0
  610  continue

       call jac(neq, 0.0d0, y, np, p, j, pdj1)
       call jac(neq, 0.0d0, y0, np, p, j, pdj2)

       do 630 i = 1, neq
        if ((pdj1(i) .ne. 0.0d0) .or. (pdj2(i) .ne. 0.0d0)) then
         nnz = nnz + 1
        end if
  630  continue
       
  700 continue

      return
      end


