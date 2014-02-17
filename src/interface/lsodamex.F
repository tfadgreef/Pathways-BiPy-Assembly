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
c
c
c-----------------------------------------------------------------------
c
c LSODA MEX Interface
c
c DEVELOPED BY:
c
c   Pascal Pieters <p.a.pieters@student.tue.nl>
c
c-----------------------------------------------------------------------
c
c USAGE:
c
c   [tret yret] = lsodamex(neq, atol, rtol, times, par, y0)
c
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c    neq :in    Number of states/equations.
c   atol :in    Absolute tolerance.
c   rtol :in    Relative tolerance.
c  times :in    Vector of time points to calculate the ODEs at.
c    par :in    Vector of parameter values.
c     y0 :in    Initial values of the states of the system. y0 should be
c               a neqx1 or 1xneq vector.
c
c   tret :out   Vector that will hold the time point values where the
c               ODEs of the system have been calculated.
c   yret :out   A vector of the values of all states corresponing to the
c               time points of tret.
c
c-----------------------------------------------------------------------
#include <fintrf.h>

      subroutine mexfunction(nlhs, plhs, nrhs, prhs)

c-----------------------------------------------------------------------
c
c Declare all variables.
c
c-----------------------------------------------------------------------

c Declare input arguments.
      mwpointer plhs(*), prhs(*)
      integer nlhs, nrhs

c Declare some MEX functions.
      mwpointer mxcreatedoublematrix, mxgetpr
      mwsize mxgetm, mxgetn

c Declare pointers for the input arguments.
      mwpointer tp, yp, neqp, atolp, rtolp, timesp,
     + y0p, parp
c Declare the position of each input argument.
      integer, parameter :: argneq = 1, argatol = 2, argrtol = 3,
     + argtimes = 4, argpar = 5, argy0 = 6

c Declare local variables.
      mwsize m, n, nel, nel2
      real*8 neqr, noutr, atol, rtol
      integer neq, nout, npars
      real*8, allocatable :: y0(:)
      real*8, allocatable :: times(:)
      real*8, allocatable :: par(:)
      real*8, allocatable :: t(:)
      real*8, allocatable :: y(:,:)
c MEX printing
      character*120 line
      integer*4 k
      integer*4 mexPrintf

c For those who use M$ DOS...
#if defined MSWIND
c For Windows only!
c This resets the floating point exception to allow divide by zero,
c overflow and invalid numbers. 
    integer(2) control
    call getcontrolfpqq(control)
    control = control .or. fpcw$zerodivide
      control = control .or. fpcW$invalid
      control = control .or. fpcW$overflow
    call setcontrolfpqq(control)
#endif
c Check for the proper number of arguments.
      if (nrhs .ne. 6) then
        call mexerrmsgtxt('LSODAMEX requires 6 input arguments')
      elseif (nlhs .gt. 2) then
        call mexerrmsgtxt('LSODAMEX requires 2 output arguments')
      endif
c Get the dimensions of y0.
      m = mxgetm(prhs(argy0))
      n = mxgetn(prhs(argy0))
c Get the number of equations.
      nel = 1
      neqp = mxgetpr(prhs(argneq))
      call mxcopyptrtoreal8(neqp, neqr, nel)
      neq = int(neqr)
c Check the size of y0.
      if ((max(m,n) .ne. neq) .or. (min(m,n) .ne. 1)) then
        call mexerrmsgtxt('LSODAMEX requires that y0 is a N x 1 vector')
      endif
c Get the number of output time points.
      m = mxgetm(prhs(argtimes))
      n = mxgetn(prhs(argtimes))
      nout = max(m,n)
c Get the number of paramters.
      m = mxgetm(prhs(argpar))
      n = mxgetn(prhs(argpar))
      npars = max(m,n)

c Allocate arrays
      allocate(y0(neq))
      allocate(times(nout))
      allocate(t(nout))
      allocate(y(nout,neq))
      allocate(par(npars))

c Create a matrix for return arguments.
      nel = nout
      nel2 = 1
      plhs(1) = mxcreatedoublematrix(nel,nel2,0)
      nel2 = neq
      plhs(2) = mxcreatedoublematrix(nel,nel2,0)

c Assign the remaining argument to the right pointers.
      atolp = mxgetpr(prhs(argatol))
      rtolp = mxgetpr(prhs(argrtol))

      timesp = mxgetpr(prhs(argtimes))
      parp = mxgetpr(prhs(argpar))

      y0p = mxgetpr(prhs(argy0))

      tp = mxgetpr(plhs(1))
      yp = mxgetpr(plhs(2))

c Copy the value of the arguments to the pointers.
      nel = 1
      call mxcopyptrtoreal8(atolp, atol, nel)
      call mxcopyptrtoreal8(rtolp, rtol, nel)

      nel = neq
      call mxcopyptrtoreal8(y0p, y0, nel)

      nel = nout
      CALL mxcopyptrtoreal8(timesp, times, nel)

      nel = npars
      CALL mxcopyptrtoreal8(parp, par, nel)

c Call the LSODA wrapper, which will call the LSODA solver.
      call lsodaw(neq, atol, rtol, nout, times, npar, par, y0, t, y)

c Copy the result.
      nel = nout
      nel2 = neq
      call mxcopyreal8toptr(t, tp, nel)
      call mxcopyreal8toptr(y, yp, nel*nel2)

      return
      end

