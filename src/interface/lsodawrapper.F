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
c LSODAW - LSODA Wrapper
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
#include "defs.h"

      subroutine lsodaw(neq, atol, rtol, nout, times, npar, par, y0,
     + tret, yret, oret)

c-----------------------------------------------------------------------
c
c Declare all variables.
c
c-----------------------------------------------------------------------

c Declare externals.
      external lsfunc, dummy, lsodesjac, lsodesnonzero, lsjac
c Declare input arguments.
      integer, intent(in) :: neq, npar, nout

      double precision, intent(in) :: atol, rtol
      double precision, intent(in) :: y0(neq), times(nout)
      double precision, intent(in), target :: par(npar)
c Declare output arguments.
      real*8, intent(out) :: tret(nout), yret(nout, neq)
#ifdef TIMING
      double precision, intent(out) :: oret(nout)
#endif
c Declare local variables.
      integer, allocatable :: iwork(:)
      integer i, iopar, iopt, iout, istate, itask, itol, leniw, lenrw,
     1 jt, ml, mu, nerr, nfe, nfea, nje, nqu, nst, lrw, liw, np, j, nnz

      double precision, pointer :: p(:)
      double precision :: dtout, er, erm, ero, hu, tout, t, rtols,
     1 tolsf, atols, maxint
      double precision :: y(neq)
      double precision, allocatable :: rwork(:)
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
      open(unit=6, file="lsode.log", form="formatted")

c-----------------------------------------------------------------------
c
c Initialize all variables.
c
c-----------------------------------------------------------------------

      maxint = dble(huge(iwork(6)))

c Calculate the correct size of the iwork and rwork
c variables, based on the description of the LSODA
c function.
#if defined(STIFFSOLVER)
      lrw = 22 +  9*neq + neq**2
      liw = 22 + neq
#elif defined(NONSTIFFSOLVER)
      lrw = 20 + 16 * neq
      liw = 20
#elif defined(SWITCHINGSOLVER)
      lrw = 22 + neq * max(16, neq + 9)
      liw = 20 + neq
#elif defined(BDFSPARSESOLVER)
c      call nonzero(neq, npar, par, nnz)
c      write(line,*) 'Supplied NNZ = ', nnz
c      k = mexPrintf(line//achar(13))
      call lsodesnonzero(neq, y0, npar, par, nnz)

#if defined(DEBUG)
      write(line,*) 'Calculated NNZ = ', nnz
      k = mexPrintf(line//achar(13))
#endif

      lrw = 20 + 3*nnz + 20*neq
      liw = 30
#endif

      allocate(rwork(lrw))
      allocate(iwork(liw))
c The first time to output is the first value in the times
c vector.
      tout = times(1)
c Make the pointer p point to the vector of parameters. the
c pointer can be accessed in the ODE function via the 
c /funcpar/ common block.
      np = npar
      p => par
c Initialize the error counter.
      nerr = 0
c Specify tolerance as a scalar (2 for vector/array).
      itol = 1
c      itol = 2
c Define the Jacobian type (full).
      jt = 2

c Start with the given tolerances.
      atols = atol
      rtols = rtol

#ifdef OPTIONALINPUTS
c Optional inputs.
      iopt = 1
c Set all optional inputs to default.
      do 70 i=5, 10
        rwork(i) = 0.0d0
        iwork(i) = 0
  70  continue
#ifdef MAXSTEPS
      iwork(6) = MAXSTEPS
#else
      iwork(6) = 1000
#endif

#ifdef SWITCHINGSOLVER
#ifdef MAXORDER1
      iwork(9) = MAXORDER1
#endif
#ifdef MAXORDER2
      iwork(8) = MAXORDER2
#endif
#else
#ifdef MAXORDER1
      iwork(5) = MAXORDER1
#endif
#endif

#ifdef DEBUG
#ifdef SWITCHINGSOLVER
      iwork(5) = 1
#endif
#endif

#else
c No optional inputs.
      iopt = 0
#endif

c Always start at t=0.
      t = 0.0d0
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

c-----------------------------------------------------------------------
c
c Loop through al desired output points.
c
c-----------------------------------------------------------------------

      do 175 iout = 1,nout

#ifdef IMAXSTEPS
        if ((IMAXSTEPS*times(iout)) .gt. maxint) then
          iwork(6) = maxint
        else
          iwork(6) = (IMAXSTEPS*times(iout))
        endif
#endif

#ifdef TIMING
c Benchmarking
        call cpu_time(bench0)
#endif
c Call the solver
#if defined(STIFFSOLVER)
#if defined(USERSUPPLIEDJAC)
        call dlsode(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, lsjac, 21)
#else
        call dlsode(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, 22)
#endif
#elif defined(NONSTIFFSOLVER)
        call dlsode(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, 10)
#elif defined(BDFSPARSESOLVER)
#if defined(USERSUPPLIEDJAC)
        call dlsodes(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, lsodesjac, 221)
#else
        call dlsodes(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, 222)
#endif
#elif defined(SWITCHINGSOLVER)
        call dlsoda(lsfunc, neq, y, t, tout, itol, rtols, atols, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, jt)
#endif
c Copy the value of y(:) to the output vector.
        yret(iout, :) = y
c Copy this time point to the output vector of times.
        tret(iout) = t

#ifdef TIMING
c Benchmarking
          call cpu_time(bench1)
          oret(iout) = (bench1-bench0)
#endif

c Check whether the solver was successful.
        if (istate .lt. 0) then
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
            case default
              write(line,8000) istate
          end select
          k = mexPrintf(line//achar(13))
          go to 400
        endif
#ifdef DEBUG
        iopar = iout - 2*(iout/2)
        if (iopar .ne. 0) go to 170
        er = abs(y(1))/atol
        ero = max(ero,er)
        if (er .gt. 1000.0d0) then
c          write(line,*) 'Warning: error exceeds 1000 * tolerance.'
c          k = mexPrintf(line//achar(13))
          nerr = nerr + 1
        endif
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
      write(line,*) 'number of steps = ', nst
      k = mexPrintf(line//achar(13))
      write(line,*) 'number of f-s = ', nfe
      k = mexPrintf(line//achar(13))
      write(line,*) 'number of J-s = ', nje
      k = mexPrintf(line//achar(13))
      write(line,*) 'error overrun = ', ero
      k = mexPrintf(line//achar(13))
#endif

c Print the LSODE output.
  400 rewind 6
      do
        read(6,'(a)',end=500) line
        k = mexPrintf(line//achar(13))
      enddo
  500 close(unit=6, status='delete')

      return
c
c Error messages
c

 8000 format('ERROR(LSODE)[',i2,']: Unknown error.')
 8001 format('ERROR(LSODE)[',i2,']: Excess work done. Maybe a '
     +       'different solver is able to solve this problem.')
 8002 format('ERROR(LSODE)[',i2,']: Excess accuracy requested. The '
     +       'tolerances are set too small.')
 8003 format('ERROR(LSODE)[',i2,']: Illegal input detected.')
 8004 format('ERROR(LSODE)[',i2,']: Repeated error test failures.')
 8005 format('ERROR(LSODE)[',i2,']: Repeated convergence failures. Try '
     +       'other choices of solver or tolerances.')
 8006 format('ERROR(LSODE)[',i2,']: Error weight became zero during '
     +       'problem.')

c
c Warning messages
c

 9001 format('WARNING(LSODE)[',i2,']: Maximum time exceeded. After ',
     +       d10.2, ' seconds the last time point was not reached.')

      end

      subroutine lsfunc (neq,t,y,ydot)
      external func
      integer neq, np
      double precision t(*), y(*), ydot(*)
      double precision, pointer :: p(:)
      COMMON  /funcpar/ np, p

      call func(neq, t, y, np, p, ydot)

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

#ifdef USERSUPPLIEDJAC
#ifdef BDFSPARSESOLVER
c--
c--
      subroutine lsodesjac (neq, t, y, j, ia, ja, pdj)
      external jac
      double precision t(*), y(*), pdj(*), ia(*), ja(*)
      integer neq, np
      double precision, pointer :: p(:)
      common  /funcpar/ np, p

      call jac(neq, t, y, np, p, j, pdj)

      return
      end
#else
      subroutine lsjac (neq, t, y, ml, mu, pd, nrowpd)
      external jac
      double precision t, y(*), pd(nrowpd, *), pdj(neq)
      integer neq, np, ml, mu, nrowpd, j, i
      double precision, pointer :: p(:)
      common  /funcpar/ np, p

      do 550 j = 1, neq
       do 540 i = 1, neq
         pdj(i) = 0
  540  continue

       call jac(neq, t, y, np, p, j, pdj)

       pd(:, j) = pdj
  550 continue

      return
      end
#endif
#endif

c--
c--
      subroutine lsodesnonzero (neq, y, np, p, nnz)
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


