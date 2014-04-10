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
c
c
c-----------------------------------------------------------------------
c
c PPODE MEX Interface
c   This subroutine handles the Matlab function call using a Fortran
c   subroutine. This function will result in a Matlab functino as 
c   described in section A. The description of the arguments of the
c   actual Fortran subroutine can be found in section B.
c
c DEVELOPED BY:
c
c   Pascal Pieters <p.a.pieters@student.tue.nl>
c
c-----------------------------------------------------------------------
c                               SECTION A
c-----------------------------------------------------------------------
c
c USAGE:
c
c   [tret yret iopt] = ppodemex(neq, atol, rtol, times, par, y0)
c
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c    neq :in    Number of states/equations. If the function expects the
c               number of nonzero elements of the Jacobian matrix to be
c               provided at function call, neq should be a vector of
c               which NNZ is the second element.
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
c [ iopt :out ] Optional output used to return the information of the
c               timing option.
c
c
c-----------------------------------------------------------------------
c                               SECTION B
c-----------------------------------------------------------------------
c
c DEFINITION:
c
c   mexfunction(nlhs, plhs, nrhs, prhs)
c
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c   nlhs :in    The number of input (left hand side) arguments of the
c               Matlab function.
c   plhs :in    The pointers to the input (left hand side) arguments 
c               of the Matlab function.
c   nrhs :in    The number of output (right hand side) arguments of the
c               Matlab function.
c   prhs :in    The pointers to the output (right hand side) arguments 
c               of the Matlab function.
c
c-----------------------------------------------------------------------

#include <fintrf.h>
#include "defs.h"
#include "predefs.h"

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
#ifdef TIMING
      mwpointer optp
#endif
c Declare the position of each input argument.
      integer, parameter :: argneq = 1, argatol = 2, argrtol = 3,
     + argtimes = 4, argpar = 5, argy0 = 6

c Declare local variables.
      mwsize m, n, nel, nel2
      real*8 noutr, atol, rtol, neqr(2)
      integer neq, nout, npars
      real*8, allocatable :: y0(:), times(:), par(:), t(:), y(:,:),
     + opt(:)
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
        call mexerrmsgtxt('PPODE requires 6 input arguments')
      elseif (nlhs .gt. OUTARGS) then
        call mexerrmsgtxt('PPODE requires OUTARGS output arguments')
      endif
c Get the number of equations.
#ifdef INPUTNONZERO
c If INPUTNONZERO is defined, the value of NNZ is the second element of
c the vector NEQ.
      m = mxgetm(prhs(argtimes))
      n = mxgetn(prhs(argtimes))
      if (max(m, n) .ne. 2) then
        call mexerrmsgtxt('PPODE requires NEQ to be a 2 x 1 vector if INPUTNONZERO is set.')
      end if
      nel = max(m, n)
#else
      nel = 1
#endif
      neqp = mxgetpr(prhs(argneq))
      call mxcopyptrtoreal8(neqp, neqr, nel)
      neq = int(neqr(1))

c Get the dimensions of y0.
      m = mxgetm(prhs(argy0))
      n = mxgetn(prhs(argy0))

c Check the size of y0.
      if ((max(m,n) .ne. neq) .or. (min(m,n) .ne. 1)) then
        call mexerrmsgtxt('PPODE requires that y0 is a N x 1 vector')
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
#ifdef TIMING
      allocate(opt(nout))
#else
c Still allocate one element to pass some information on to the
c function.
      allocate(opt(1))
#endif

#ifdef INPUTNONZERO
c If INPUTNONZERO is defined, the value of NNZ is the second element of
c the vector NEQ.
      opt(1) = neqr(2)
#endif

c Create a matrix for return arguments.
      nel = nout
      nel2 = 1
      plhs(1) = mxcreatedoublematrix(nel,nel2,0)
      nel2 = neq
      plhs(2) = mxcreatedoublematrix(nel,nel2,0)
#ifdef TIMING
      nel2 = 1
      plhs(3) = mxcreatedoublematrix(nel,nel2,0)
#endif

c Assign the remaining argument to the right pointers.
      atolp = mxgetpr(prhs(argatol))
      rtolp = mxgetpr(prhs(argrtol))

      timesp = mxgetpr(prhs(argtimes))
      parp = mxgetpr(prhs(argpar))

      y0p = mxgetpr(prhs(argy0))

      tp = mxgetpr(plhs(1))
      yp = mxgetpr(plhs(2))
#ifdef TIMING
      optp = mxgetpr(plhs(3))
#endif

c Copy the value of the arguments.
      nel = 1
      call mxcopyptrtoreal8(atolp, atol, nel)
      call mxcopyptrtoreal8(rtolp, rtol, nel)

      nel = neq
      call mxcopyptrtoreal8(y0p, y0, nel)

      nel = nout
      CALL mxcopyptrtoreal8(timesp, times, nel)

      nel = npars
      CALL mxcopyptrtoreal8(parp, par, nel)

c Call the correct solver.
#if defined(ODEPACK)
      call lsodew(neq, atol, rtol, nout, times, npar, par, y0, t, y,
     + opt)
#elif defined(RKSUITE)
      call rksuitew(neq, atol, rtol, nout, times, npar, par, y0, t, y,
     + opt)
#elif defined(MEBDFSO)
      call mebdfsow(neq, atol, rtol, nout, times, npar, par, y0, t, y,
     + opt)
#elif defined(VODE)
      call vodew(neq, atol, rtol, nout, times, npar, par, y0, t, y,
     + opt)
#elif defined(LSODAS)
      call lsodasw(neq, atol, rtol, nout, times, npar, par, y0, t, y,
     + opt)
#endif


c Copy the result.
      nel = nout
      nel2 = neq
      call mxcopyreal8toptr(t, tp, nel)
      call mxcopyreal8toptr(y, yp, nel*nel2)
#ifdef TIMING
      call mxcopyreal8toptr(opt, optp, nel)
#endif

      return
      end

#if ( defined(MEBDFSO) || defined(BDFSPARSESOLVER) || defined(SWITCHINGSPARSESOLVER))
c-----------------------------------------------------------------------
c
c NNZ from analytical Jacobian
c   This subroutine calculates the Number of Non-Zero (NNZ) elements of
c   the Jacobian matrix based on an analytical Jacobian subroutine. The
c   analytical Jacobian subroutine should be defined as follows:
c
c     subroutine jac(neq, t, y, np, par, j, pdj)
c
c   Where neq is the Number of EQuations, t the time, y the values of
c   the states, np the number of parameters, par the parameter values,
c   j the index of the state to take the derivative to and pdj the
c   derivatives of all equations to state j (pdj(i) = df(i)/dy(j)).
c
c DEVELOPED BY:
c
c   Pascal Pieters <p.a.pieters@student.tue.nl>
c
c-----------------------------------------------------------------------
c
c USAGE:
c
c   jacnonzero (neq, y, np, p, nnz)
c
c-----------------------------------------------------------------------
c
c ARGUMENTS:
c
c    neq :in    Number of states/equations.
c      y :in    Current values of all states.
c     np :in    Number of parameters.
c      p :in    Vector of parameter values.
c
c    nnz :out   The number of nonzero elements in the Jacobian matrix.
c
c-----------------------------------------------------------------------

      subroutine jacnonzero (neq, y, np, p, nnz)
      external jac
      double precision y(neq), pdj1(neq), pdj2(neq), p(np), y0(neq)
      integer neq, np, j, i, nnz

      nnz = 0

c Create another set of values based on random numbers. This might not
c always work, but generally it will.
      do 600 i = 1, neq
       y0(i) = y(i) + 100.0d0 * rand()
  600 continue      

c Iterate through all states and calculate the part of the Jacobian that
c represents the derivative to that state.
      do 700 j = 1, neq
c Start with all zeros.
       do 610 i = 1, neq
        pdj1(i) = 0.0d0
        pdj2(i) = 0.0d0
  610  continue

c Calculate for two series of values.
       call jac(neq, 0.0d0, y, np, p, j, pdj1)
       call jac(neq, 0.0d0, y0, np, p, j, pdj2)

c Add one to the number of non-zero elements if one of the two values of
c a certain position in the matrix is not zero.
       do 630 i = 1, neq
        if ((pdj1(i) .ne. 0.0d0) .or. (pdj2(i) .ne. 0.0d0)) then
         nnz = nnz + 1
        end if
  630  continue
       
  700 continue

      return
      end

! 
!       subroutine jacstructure (neq, y, np, p, nnz, ia, ja)
!       implicit none
!       external jac
!       double precision y(neq), pdj1(neq), pdj2(neq), p(np), y0(neq)
!       integer neq, np, j, i, nnz, ia(neq), jat(neq), nnzt
!       integer, allocatable :: jatt(:)
!       integer, allocatable, intent(out) :: ja(:)
!       nnz = 0
!       nnzt = neq
! 
!       if (allocated(ja)) then
!        deallocate(ja)
!       end if
! 
! c Create another set of values based on random numbers. This might not
! c always work, but generally it will.
!       do 600 i = 1, neq
!        y0(i) = y(i) + 100.0d0 * rand()
!   600 continue      
! 
! c Iterate through all states and calculate the part of the Jacobian that
! c represents the derivative to that state.
!       do 700 j = 1, neq
! c Start with all zeros.
!        do 605 i = 1, nnzt
!         jat(i) = 0.0d0
!   605  continue
!        nnzt = 0
!        do 610 i = 1, neq
!         pdj1(i) = 0.0d0
!         pdj2(i) = 0.0d0
!   610  continue
! 
! c Calculate for two series of values.
!        call jac(neq, 0.0d0, y, np, p, j, pdj1)
!        call jac(neq, 0.0d0, y0, np, p, j, pdj2)
! 
! c Add one to the number of non-zero elements if one of the two values of
! c a certain position in the matrix is not zero.
!        do 630 i = 1, neq
!         if ((pdj1(i) .ne. 0.0d0) .or. (pdj2(i) .ne. 0.0d0)) then
!          nnzt = nnzt + 1
!          jat(nnzt) = i
!         end if
!   630  continue
! 
!        ia(j) = nnz + 1
! 
!        if (nnz .eq. 0) go to 650
!        allocate(jatt(nnz))
!        jatt(1:nnz) = ja(1:nnz)
!        deallocate(ja)
! 
!   650  allocate(ja(nnz+nnzt))
!        if (nnz .eq. 0) go to 660
! 
!        ja(1:nnz) = jatt(1:nnz)
!        deallocate(jatt)
! 
!   660  ja((nnz+1):(nnz+nnzt)) = jat(1:nnzt)
! 
!        nnz = nnz + nnzt
!        
!   700 continue
! 
!       ia(neq+1) = nnz
! 
!       return
!       end

#endif
