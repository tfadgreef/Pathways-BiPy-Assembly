#include <fintrf.h>
C
C YPRIMEG.FOR - Gateway function for YPRIME.FOR
C
C This is an example of the FORTRAN code required for interfacing
C a .MEX file to MATLAB.
C
C This subroutine is the main gateway to MATLAB.  When a MEX function
C  is executed MATLAB calls the MEXFUNCTION subroutine in the corresponding
C  MEX file.  
C
C Copyright 1984-2006 The MathWorks, Inc.
C $Revision: 1.9.2.3 $
C
      SUBROUTINE MEXFUNCTION(NLHS, PLHS, NRHS, PRHS)
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER PLHS(*), PRHS(*)

C-----------------------------------------------------------------------
C

      INTEGER NLHS, NRHS
C
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER MXCREATEDOUBLEMATRIX, MXGETPR

C-----------------------------------------------------------------------
C

      MWSIZE MXGETM, MXGETN
C
C KEEP THE ABOVE SUBROUTINE, ARGUMENT, AND FUNCTION DECLARATIONS FOR USE
C IN ALL YOUR FORTRAN MEX FILES.
C---------------------------------------------------------------------
C
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER tp, yp, neqp, noutp, atolp, rtolp, timefp,
     + tbegp, tendp, y0p

C-----------------------------------------------------------------------
C

      MWSIZE M, N, NEL, NEL2
      REAL*8 neqr, noutr, atol, rtol, timefr,
     + tbeg, tend
      integer neq, nout, timef
      real*8, allocatable :: y0(:)
      real*8, allocatable :: t(:)
      real*8, allocatable :: y(:,:)
c MEX printing
!       character*120 line
!       integer*4 k
!       integer*4 mexPrintf
#if defined MSWIND
C For Windows only!
C This resets the floating point exception to allow divide by zero,
C overflow and invalid numbers. 
C
    INTEGER(2) CONTROL
    CALL GETCONTROLFPQQ(CONTROL)
    CONTROL = CONTROL .OR. FPCW$ZERODIVIDE
      CONTROL = CONTROL .OR. FPCW$INVALID
      CONTROL = CONTROL .OR. FPCW$OVERFLOW
    CALL SETCONTROLFPQQ(CONTROL)
#endif
C
C CHECK FOR PROPER NUMBER OF ARGUMENTS
C
      IF (NRHS .NE. 8) THEN
        CALL MEXERRMSGTXT('LSODAMEX requires 8 input arguments')
      ELSEIF (NLHS .GT. 2) THEN
        CALL MEXERRMSGTXT('LSODAMEX requires 2 output arguments')
      ENDIF
C
C CHECK THE DIMENSIONS OF Y.  IT CAN BE 4 X 1 OR 1 X 4.
C
      M = MXGETM(PRHS(8))
      N = MXGETN(PRHS(8))
C

c Get the number of equations
      NEL = 1
      neqp = MXGETPR(PRHS(1))
      CALL MXCOPYPTRTOREAL8(neqp, neqr, NEL)
      neq = int(neqr)

      IF ((MAX(M,N) .NE. neq) .OR. (MIN(M,N) .NE. 1)) THEN
        CALL MEXERRMSGTXT('LSODAMEX requires that y0 is a N x 1 vector')
      ENDIF

      NEL = 1
      noutp = MXGETPR(PRHS(5))
      CALL MXCOPYPTRTOREAL8(noutp, noutr, NEL)
      nout = int(noutr)

c Allocate arrays
      allocate(y0(nout))
      allocate(t(nout))
      allocate(y(nout,neq))

C
C CREATE A MATRIX FOR RETURN ARGUMENT
C
      NEL = nout
      NEL2 = 1
      PLHS(1) = MXCREATEDOUBLEMATRIX(NEL,NEL2,0)
      NEL2 = neq
      PLHS(2) = MXCREATEDOUBLEMATRIX(NEL,NEL2,0)

C
C ASSIGN POINTERS TO THE VARIOUS PARAMETERS
C

      atolp = MXGETPR(PRHS(2))
      rtolp = MXGETPR(PRHS(3))

      timefp = MXGETPR(PRHS(4))
      tbegp = MXGETPR(PRHS(6))
      tendp = MXGETPR(PRHS(7))

      y0p = MXGETPR(PRHS(8))

      tp = MXGETPR(PLHS(1))
      yp = MXGETPR(PLHS(2))

C
C COPY RIGHT HAND ARGUMENTS TO LOCAL ARRAYS OR VARIABLES
      NEL = 1
      CALL MXCOPYPTRTOREAL8(atolp, atol, NEL)
      CALL MXCOPYPTRTOREAL8(rtolp, rtol, NEL)

      CALL MXCOPYPTRTOREAL8(timefp, timefr, NEL)
      timef = int(timefr)
      CALL MXCOPYPTRTOREAL8(tbegp, tbeg, NEL)
      CALL MXCOPYPTRTOREAL8(tendp, tend, NEL)

      NEL = neq
      CALL MXCOPYPTRTOREAL8(y0p, y0, NEL)

C DO THE ACTUAL COMPUTATIONS IN A SUBROUTINE
C       CREATED ARRAYS.  
C
      call lsodaw(neq, atol, rtol, timef, nout,
     + tbeg, tend, y0, t, y)

      NEL = nout
      NEL2 = neq
      CALL MXCOPYREAL8TOPTR(t, tp, NEL)
      CALL MXCOPYREAL8TOPTR(y, yp, NEL*NEL2)

      RETURN
      END

