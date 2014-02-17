c-----------------------------------------------------------------------
c 
c                               LSODAMEX                                
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
     + tret, yret)

c-----------------------------------------------------------------------
c
c Declare all variables.
c
c-----------------------------------------------------------------------

c Declare externals.
      external func, dummy
c Declare input arguments.
      integer, intent(in) :: neq, npar, nout

      double precision, intent(in) :: atol, rtol
      double precision, intent(in) :: y0(neq), times(nout)
      double precision, intent(in), target :: par(npar)
c Declare output arguments.
      real*8, intent(out) :: tret(nout), yret(nout, neq)
c Declare local variables.
      integer :: iwork(22 + neq)
      integer i, iopar, iopt, iout, istate, itask, itol, leniw, lenrw,
     1 jt, ml, mu, nerr, nfe, nfea, nje, nqu, nst, lrw, liw, np, j

      double precision, pointer :: p(:)
      double precision :: dtout, er, erm, ero, hu, tout, t
      double precision :: y(neq), rwork(22 + neq * max(16, neq + 9))
c Delcare variables used for printing tret in MEX.
      character*120 line
      integer*4 k
      integer*4 mexPrintf
c The following code can be used to print variable values.
c#      write(line,*) 'neq = ',neq
c#      k = mexPrintf(line//achar(13))
c Common variables used for passing parameters to
c ODE function.
      COMMON  /funcpar/ np, p

c Redirect all output of the LSODE solver to a file.
      open(unit=6, file="lsode.log", form="formatted")

c-----------------------------------------------------------------------
c
c Initialize all variables.
c
c-----------------------------------------------------------------------

c Calculate the correct size of the iwork and rwork
c variables, based on the description of the LSODA
c function.
      lrw = 22 + neq * max(16, neq + 9)
      liw = 22 + neq
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
c Define the Jacobian type (full).
      jt = 2

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
#endif
#ifdef DEBUG
      iwork(5) = 1
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

      do 170 iout = 1,nout
c Call the solver
        call dlsoda(func, neq, y, t, tout, itol, rtol, atol, itask,
     1   istate, iopt, rwork, lrw, iwork, liw, dummy, jt)
c Copy the value of y(:) to the output vector.
        yret(iout, :) = y
c Copy this time point to the output vector of times.
        tret(iout) = t

c Check whether the solver was successful.
        if (istate .lt. 0) go to 175
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
c Get the new time point.
 170    tout = times(iout+1)

 175  continue

c Check for errors one more time
      if (istate .lt. 0) nerr = nerr + 1

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
      rewind 6
      do
        read(6,'(a)',end=500) line
        k = mexPrintf(line//achar(13))
      enddo
  500 close(unit=6, status='delete')

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

