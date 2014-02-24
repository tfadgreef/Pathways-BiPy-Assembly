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
c RKSUITEW - RKSUITE Wrapper
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

      subroutine rksuitew(neq, atol, rtol, nout, times, npar, par, y0,
     + tret, yret, oret)

c-----------------------------------------------------------------------
c
c Declare all variables.
c
c-----------------------------------------------------------------------

c Declare externals.
      external rkfunc, func, dummy
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
      integer i, iopar, iopt, iout, istate, itask, itol, leniw, lenrw,
     1 jt, ml, mu, nerr, nfe, nfea, nje, nqu, nst, lrw, liw, np, j,
     2 method, outch, err, neqrk

      double precision, pointer :: p(:)
      double precision :: dtout, er, erm, ero, hu, tout, t, tend,
     1 hstart, mcheps, dwarf, maxint
      double precision :: y(neq), rwork(32*neq),
     1 yp(neq), ymax(neq), atols(neq)

      logical errass, message, caterr
#ifdef MAXTIME
      real maxt0, maxt1
#endif
#ifdef TIMING
      real bench0, bench1
#endif
c Delcare variables used for printing tret in MEX.
      character*120 line
      integer*4 k
      integer*4 mexPrintf
c The following code can be used to print variable values.
c#      write(line,*) 'neq = ',neq
c#      k = mexPrintf(line//achar(13))
c Common variables used for passing parameters to
c ODE function.
      common  /funcpar/ np, p
      common  /rkcom/ neqrk

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

      neqrk = neq

c Calculate the correct size of the iwork and rwork
c variables, based on the description of the RKSUITE
c function.
      lrw = 32*neq
c The first time to output is the first value in the times
c vector.
      tout = times(1)

c Make the pointer p point to the vector of parameters. the
c pointer can be accessed in the ODE function via the 
c /funcpar/ common block.
      np = npar
      p => par

      do 70 i=5, 10
        rwork(i) = 0.0d0
  70  continue
c Always start at t=0.
      t = 0.0d0
c Initial value for the ODE problem.
      y = y0
c Intial value of istate should be 1.
c (istate = 2 for subsequent calls)
      istate = 1
c Keep track of the maximum error.
      ero = 0.0d0

      errass = .false.
      message = .false.
      caterr = .false.

#if defined(RK23SOLVER)
      method = 1
#elif defined(RK45SOLVER)
      method = 2
#elif defined(RK78SOLVER)
      method = 3
#endif

      tend = times(nout)
      hstart = 0.0d0

c Set the output variables to zeros.
      do 110 i=1, nout
        tret(i) = 0.0d0
        do 100 j=1, neq
          yret(i,j) = 0.0d0
  100   continue
  110 continue


      do 60 i=1, neq
        atols(i) = atol
  60  continue

#ifdef DEBUG
      call softfl(.false., .true.)

      call envirn(outch,mcheps,dwarf)

      write(6,*) 'outch=',outch,'; mcheps=',mcheps,'; dwarf=',dwarf 
      flush(6)

      write(6,*) 'neq=',neq,'; t=',t,'; y0(1)=',y0(1),'; rtol=',rtol 
      flush(6)
      write(6,*) 'atols(1)=',atols(1),'; method=',method
      flush(6)
      write(6,*) 'errass=',errass,'; message=',message
      flush(6)
      write(6,*) 'hstart=',hstart,'; lrw=',lrw
      flush(6)
#endif
      call setup(neq,t,y0,tend,rtol,atols,method,'Usual Task',
     + errass,hstart,rwork,lrw,message)
#ifdef DEBUG
      call chkfl(.true., err)

      flush(6)
      write(6,*) 'error=',err
#endif

c-----------------------------------------------------------------------
c
c Loop through al desired output points.
c
c-----------------------------------------------------------------------

      do 175 iout = 1,nout
#ifdef TIMING
c Benchmarking
        call cpu_time(bench0)
#endif
        call softfl(.false., .true.)
c Call the solver
        call ut(rkfunc,tout,t,y,yp,ymax,rwork,istate)
c Copy the value of y(:) to the output vector.
        yret(iout, :) = y
c Copy this time point to the output vector of times.
        tret(iout) = t

#ifdef TIMING
c Benchmarking
        call cpu_time(bench1)
        oret(iout) = (bench1-bench0)
#endif

        call chkfl(.true., caterr)
c Check whether the solver was successful.
        if ((istate .gt. 4) .or. caterr) then
          select case (istate)
            case(5)
              write(line,8005) istate
            case(6)
              write(line,8006) istate
            case(911)
              write(line,8911) istate
            case default
              write(line,8000) istate
              if (caterr) then
                write(line,8911) istate
              endif
          end select
          k = mexPrintf(line//achar(13))
          go to 400
        endif

#ifdef MAXTIME
c Check whether the passed time is below the maximum time.
        call cpu_time(maxt1)
        if ((maxt1-maxt0) .ge. MAXTIME) then
          write(line,9001) 1, (maxt1-maxt0)
          k = mexPrintf(line//achar(13))
          go to 400
        endif
#endif

c Get the new time point.
 170    tout = times(iout+1)

 175  continue

c Check for errors one more time
c      if (istate .lt. 0) nerr = nerr + 1

c-----------------------------------------------------------------------
c
c Calculate some stats of the solver/solution.
c
c-----------------------------------------------------------------------

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

 8000 format('ERROR[',i2,']: Unknown error.')
 8005 format('ERROR[',i2,']: You are asking for too much accuracy.'
     +       'You cannot continue integrating this problem.')
 8006 format('ERROR[',i2,']: The global error assessment may not be '
     +       'reliable beyond the current point in the integration.'
     +       'You cannot continue integrating this problem.')
 8911 format('ERROR[',i2,']: The nature of the catastrophe is reported '
     +       'on the standard output channel. Unless special '
     +       'provision was made in advance (see rksuite.doc), '
     +       'the computation then comes to a STOP.')

c
c Warning messages
c

 9001 format('WARNING[',i2,']: Maximum time exceeded. After ', d10.2
     +       ' seconds the last time point was not reached.')


      end


      subroutine rkfunc (t, y, ydot)
      integer neqrk
      double precision t, y(*), ydot(*)
      common  /rkcom/ neqrk

      call func(neqrk, t, y, ydot)

      return
      end

