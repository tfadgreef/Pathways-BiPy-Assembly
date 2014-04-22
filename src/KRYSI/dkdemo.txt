c-----------------------------------------------------------------------
c Demonstration program for KRYSI.
c ODE system from ns-species interaction PDE in 2 dimensions.
c
c This is the version of 5 August 2002.
c
c This version is in double precision.
c-----------------------------------------------------------------------
c This program solves a stiff ode system that arises from a system
c of partial differential equations.  The PDE system is a food web
c population model, with predator-prey interaction and diffusion on
c the unit square in two dimensions.  The dependent variable vector is
c
c         1   2        ns
c   c = (c , c , ..., c  )
c
c and the PDEs are as follows..
c
c     i               i      i
c   dc /dt  =  d(i)*(c    + c   )  +  f (x,y,c)  (i=1,...,ns)
c                     xx     yy        i
c
c where
c                  i          ns         j
c   f (x,y,c)  =  c *(b(i) + sum a(i,j)*c )
c    i                       j=1
c
C the number of species is ns = 2*np, with the first np being prey and
c the last np being predators.  The coefficients a(i,j), b(i), d(i) are
c
c   a(i,i) = -a  (all i)
c   a(i,j) = -g  (i .le. np, j .gt. np)
c   a(i,j) =  e  (i .gt. np, j .le. np)
c   b(i) =  b*(1 + alpha*x*y)  (i .le. np)
c   b(i) = -b*(1 + alpha*x*y)  (i .gt. np)
c   d(i) = dprey  (i .le. np)
c   d(i) = dpred  (i .gt. np)
c
c The various scalar parameters are set in subroutine setpar.
c
c The boundary conditions are.. normal derivative = 0.
c A polynomial in x and y is used to set the initial conditions.
c
c The PDEs are discretized by central differencing on a mx by my mesh.
c
c The ODE system is solved by KRYSI with a final time of tmax = 10.
c
c Two preconditioner matrices are used.  One uses a fixed number of
c Gauss-Seidel iterations based on the diffusion terms only.
c The other preconditioner is a block-diagonal matrix based on
c the partial derivatives of the interaction terms f only, using
c block-grouping (computing only a subset of the ns by ns blocks).
c These two preconditioners are applied on the left and right,
c respectively.
c
c Two output files are written.. one with the problem description and
c and performance statistics on unit 6, and one with solution profiles
c at selected output times on unit 8.
c-----------------------------------------------------------------------
c Note.. In addition to the main program and 11 subroutines
c given below, this program requires the LINPACK subroutines
c DGEFA and DGESL, and the BLAS routine DAXPY.
c-----------------------------------------------------------------------
c Reference:
c    Alan C. Hindmarsh and Syvert Paul Norsett,
c    KRYSI, An ODE Solver Combining a Semi-Implicit 
c    Runge-Kutta Method and a Preconditioned Krylov Method,
c    NTH, Trondheim, 1987 (Mathematics of Computation Report 
c    No. 8/87); also available as LLNL Report UCID-21422, May 1988.
c-----------------------------------------------------------------------
      external fweb, jacbg, solsbg, outdem
      integer ns, mx, my, mxns,
     1        mp, mq, mpsq, itmax,
     2        meshx,meshy,ngx,ngy,ngrp,mxmp,jgx,jgy,jigx,jigy,jxr,jyr
      double precision aa, ee, gg, bb, dprey, dpred,
     1     ax, ay, acoef, bcoef, dx, dy, alph, diff, cox, coy,
     2     uround, srur,
     3     crates
      double precision aeps, apre, avdim, cc, dumach,
     1   reps, work, wk, t, tend
c
c the problem common blocks below allow for up to 20 species,
c up to a 50x50 mesh, and up to a 20x20 group structure.
      common /pcom0/ aa, ee, gg, bb, dprey, dpred
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
      common /pcom2/ mp, mq, mpsq, itmax, uround, srur
      common /pcom3/ meshx, meshy, ngx, ngy, ngrp, mxmp,
     2   jgx(21), jgy(21), jigx(50), jigy(50), jxr(20), jyr(20)
c the length of the following block must be at least ns.
      common /pcom4/ crates(20)
      common /pcom5/ iout
c the krysi statistics common block is invoked, but with the
c step count ns changed to nst to avoid a conflict.
      common /stats/ nst,nfx,nf,nni,nns,nli,npe,npf,nps,ncfl
c
c the dimension of aeps and cc below must be .ge. n = ns*mx*my.
c the dimension of work must be .ge. 14*n.
c the dimension of apre must be .ge. ns*ns*ngrp.
c the dimension of ipre must be .ge. ns*ngrp.
c the dimension of wk must be .ge. 7*n + 46.
      dimension aeps(288), apre(256), cc(288), work(4032), ipre(32),
     1   wk(2062), iwk(2)
c
c set up output files
c
      open (unit=6, file='demout',  status='new')
      open (unit=8, file='demcout', status='new')
c
c call setpar to set problem parameters.
      ax = 1.0d0
      ay = 1.0d0
      call setpar
c
      write(6,10)ns
 10   format('Demonstration program for KRYSI package'//
     1       ' Food web problem with ns species, ns =',i4/
     2     ' Predator-prey interaction and diffusion on a 2-D square'//)
      write(6,14) aa,ee,gg,bb,dprey,dpred
 14   format(' Matrix parameters..  a =',e12.4,'   e =',e12.4,
     1       '   g =',e12.4//' b parameter =',e12.4//
     2       ' Diffusion coefficients.. dprey =',e12.4,
     3       '   dpred =',e12.4/)
      write(6,16) alph
 16   format(' Rate parameter alpha =',e12.4//)
c
c set remaining problem parameters.
      n = ns*mx*my
      mxns = mx*ns
      dx = ax/(mx-1)
      dy = ay/(my-1)
      do 20 i = 1,ns
        cox(i) = diff(i)/dx**2
        coy(i) = diff(i)/dy**2
 20     continue
c
      tend = 10.0d0
      write(6,25) mx,my,n,tend
 25   format(' Mesh dimensions (mx,my) =',2i4//
     1       ' Total system size is n =',i7/' tend =',e14.6//)
c
c set krysi inputs and remaining method parameters.
      t = 0.0d0
      reps = 1.0d-4
      do 30 i = 1,n
 30     aeps(i) = reps
      iopt = 0
      jpre = 3
      ipt = 1
      iout = 0
c
      mp = ns
      mq = mx*my
      mpsq = ns*ns
      uround = dumach()
      srur = dsqrt(uround)
      meshx = mx
      meshy = my
      mxmp = meshx*mp
      ngx = 2
      ngy = 2
      ngrp = ngx*ngy
      call gset (meshx, ngx, jgx, jigx, jxr)
      call gset (meshy, ngy, jgy, jigy, jyr)
      itmax = 5
      write(6,40)ngrp,ngx,ngy,itmax,reps
 40   format(' Preconditioning uses interaction-only block-diagonal',
     1   ' matrix'/' with block-grouping, and G-S iterations'//
     2   ' Number of diagonal block groups = ngrp =',i4,
     3   '   (ngx by ngy, ngx =',i2,'  ngy =',i2,' )'//
     4   ' G-S preconditioner uses itmax iterations, itmax =',i3///
     5   ' Tolerance parameters.. reps = aeps(i) =',e10.2//)
c
      call cinit (cc)
c
c call krysi
c
      call krysi (n, fweb, jacbg, solsbg, cc, t, tend, aeps, reps,
     1      apre, ipre, work, wk, iwk, iopt, jpre, iflag, outdem, ipt)
c
      call outdem (t, cc)
c
      write(6,70)iflag
 70   format(/' KRYSI returned iflag =',i3/)
c
      lenrw = 14*n + ns*ns*ngrp + 7*n + 46
      leniw = ns*ngrp + 2
      if (nns .gt. 0) avdim = real(nli)/real(nns)
      write (6,80) lenrw,leniw,nst,nfx,nf,nni,nns,nli,
     1   npe,npf,nps,avdim,ncfl
 80   format(//' Final statistics for this run..'/
     1       ' total size of real work space     =',i8/
     1       ' total size of integer work space  =',i8/
     2       ' number of time steps              =',i5/
     2       ' number of fixpoint steps          =',i5/
     3       ' number of f evaluations           =',i5/
     4       ' number of nonlinear iterations    =',i5/
     4       ' number of newton iterations       =',i5/
     4       ' number of linear iterations       =',i5/
     5       ' number of preconditioner evals.   =',i5/
     5       ' number of precond. factorizations =',i5/
     5       ' number of preconditioner solves   =',i5/
     6       ' average krylov subspace dimension =',f8.4/
     7       ' number of linear conver. failures =',i5)
c
      stop
c------  end of main program for krysi demonstration program -----------
      end
      subroutine setpar
c-----------------------------------------------------------------------
c this routine sets the problem parameters.
c it set ns, mx, my, and problem coefficients acoef, bcoef, diff, alph,
c using parameters np, aa, ee, gg, bb, dprey, dpred.
c-----------------------------------------------------------------------
      integer ns, mx, my, mxns
      integer i, j, np
      double precision aa, ee, gg, bb, dprey, dpred,
     1     ax, ay, acoef, bcoef, dx, dy, alph, diff, cox, coy
      common /pcom0/ aa, ee, gg, bb, dprey, dpred
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
c
      np = 4
      mx = 6
      my = 6
      aa = 1.0d0
      ee = 1000.0d0
      gg = 0.5d-6
      bb = 1.0d0
      dprey = 1.0d0
      dpred = 0.05d0
      alph = 1.0d0
      ns = 2*np
      do 70 j = 1,np
        do 60 i = 1,np
          acoef(np+i,j) = ee
          acoef(i,np+j) = -gg
 60       continue
        acoef(j,j) = -aa
        acoef(np+j,np+j) = -aa
        bcoef(j) = bb
        bcoef(np+j) = -bb
        diff(j) = dprey
        diff(np+j) = dpred
 70     continue
c
      return
c------------  end of subroutine setpar  -------------------------------
      end
      subroutine gset (m, ng, jg, jig, jr)
c-----------------------------------------------------------------------
c this routine sets arrays jg, jig, and jr describing
c a uniform partition of (1,2,...,m) into ng groups.
c-----------------------------------------------------------------------
      integer m, ng, jg, jig, jr
      dimension jg(1), jig(1), jr(1)
      integer ig, j, len1, mper, ngm1
c
      mper = m/ng
      do 10 ig = 1,ng
 10     jg(ig) = 1 + (ig - 1)*mper
      jg(ng+1) = m + 1
c
      ngm1 = ng - 1
      len1 = ngm1*mper
      do 20 j = 1,len1
 20     jig(j) = 1 + (j-1)/mper
      len1 = len1 + 1
      do 25 j = len1,m
 25     jig(j) = ng
c
      do 30 ig = 1,ngm1
 30     jr(ig) = 0.5d0 + (ig - 0.5d0)*mper
      jr(ng) = 0.5d0*(1 + ngm1*mper + m)
c
      return
c------------  end of subroutine gset  ---------------------------------
      end
      subroutine cinit (cc)
c-----------------------------------------------------------------------
c this routine computes and loads the vector of initial values.
c-----------------------------------------------------------------------
      double precision cc
      dimension cc(1)
      integer ns, mx, my, mxns
      integer i, ici, ioff, iyoff, jx, jy
      double precision ax,ay,acoef,bcoef,dx,dy,alph,diff,cox,coy
      double precision argx, argy, x, y
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
c
        do 20 jy = 1,my
          y = (jy-1)*dy
          argy = 16.0d0*y*y*(ay-y)*(ay-y)
          iyoff = mxns*(jy-1)
          do 10 jx = 1,mx
            x = (jx-1)*dx
            argx = 16.0d0*x*x*(ax-x)*(ax-x)
            ioff = iyoff + ns*(jx-1)
            do 5 i = 1,ns
              ici = ioff + i
              cc(ici) = 10.0d0 + i*argx*argy
  5           continue
 10         continue
 20       continue
      return
c------------  end of subroutine cinit  --------------------------------
      end
      subroutine outdem (t, cc)
      double precision t, cc
      dimension cc(1)
c
      double precision ax, ay, acoef, bcoef, dx,dy, alph, diff, cox,coy
      double precision avdim
c
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
      common /pcom5/ iout
      common /stats/ nst,nfx,nf,nni,nns,nli,npe,npf,nps,ncfl
c
c print statistics on unit 6 and solution values on unit 8.
c
c on first call, initialize counters and print heading
c
      if (iout .gt. 0) go to 20
      nlio = 0
      nnso = 0
      write(6,10)
 10   format('   t',8x,'nst  nfx   nf  nni  nns  nli  npe  npf',
     1       '  nps  ncfl    avdim'/)
c
 20   continue
        nnsdif = nns - nnso
        nnso = nns
        nlidif = nli - nlio
        nlio = nli
        avdim = 0.0d0
        if (nnsdif .gt. 0) avdim = real(nlidif)/real(nnsdif)
        write(6,50)t,nst,nfx,nf,nni,nns,nli,npe,npf,nps,ncfl,avdim
 50     format(e10.2,10i5,f10.4)
        imod3 = iout - 3*(iout/3)
        if (imod3 .eq. 0) call outweb (t, cc, ns, mx, my, 8)
c
        if (t .gt. 0.9d0) t = t + 1.0d0
        if (t .lt. 0.9d0) t = t*10.0d0
        if (iout .eq. 0) t = 1.0d-8
c
      iout = iout + 1
c
      return
c------------  end of subroutine outdem  -------------------------------
      end
      subroutine outweb (t, c, ns, mx, my, lun)
c-----------------------------------------------------------------------
c this routine prints the values of the individual species densities
c at the current time t.
c the write statements use unit lun.
c-----------------------------------------------------------------------
      integer ns, mx, my, lun
      double precision t, c
      dimension c(ns,mx,my)
      integer i, jx, jy
c
      write(lun,10) t
 10   format(/80('-')/30x,'At time t = ',e16.8/80('-') )
c
      do 40 i = 1,ns
        write(lun,20) i
 20     format(' the species c(',i2,') values are')
        do 30 jy = my,1,-1
          write(lun,25) (c(i,jx,jy),jx=1,mx)
 25       format(6(1x,g12.6))
 30       continue
        write(lun,35)
 35     format(80('-'),/)
 40     continue
c
      return
c------------  end of subroutine outweb  -------------------------------
      end
      subroutine fweb (t, cc, cdot)
c-----------------------------------------------------------------------
c this routine computes the derivative of cc and returns it in cdot.
c the interaction rates are computed by calls to webr.
c-----------------------------------------------------------------------
      double precision t, cc, cdot
      dimension cc(1), cdot(1)
      integer ns, mx, my, mxns
      integer i, ic, ici, idxl, idxu, idyl, idyu, iyoff, jx, jy
      double precision ax,ay,acoef,bcoef,dx,dy,alph,diff,cox,coy
      double precision dcxli, dcxui, dcyli, dcyui, x, y
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
c
      do 100 jy = 1,my
        y = (jy-1)*dy
        iyoff = mxns*(jy-1)
        idyu = mxns
        if (jy .eq. my) idyu = -mxns
        idyl = mxns
        if (jy .eq. 1) idyl = -mxns
        do 90 jx = 1,mx
          x = (jx-1)*dx
          ic = iyoff + ns*(jx-1) + 1
c get interaction rates at one point (x,y)
          call webr (x, y, t, cc(ic), cdot(ic))
          idxu = ns
          if (jx .eq. mx) idxu = -ns
          idxl = ns
          if (jx .eq. 1) idxl = -ns
          do 80 i = 1,ns
            ici = ic + i - 1
c do differencing in y
            dcyli = cc(ici) - cc(ici-idyl)
            dcyui = cc(ici+idyu) - cc(ici)
c do differencing in x
            dcxli = cc(ici) - cc(ici-idxl)
            dcxui = cc(ici+idxu) - cc(ici)
c collect terms and load cdot elements
            cdot(ici) = coy(i)*(dcyui - dcyli) + cox(i)*(dcxui - dcxli)
     1                  + cdot(ici)
 80         continue
 90       continue
 100    continue
      return
c------------  end of subroutine fweb  ---------------------------------
      end
      subroutine webr (x, y, t, c, rate)
c-----------------------------------------------------------------------
c this routine computes the interaction rates for the species
c c(1),...,c(ns), at one spatial point and at time t.
c-----------------------------------------------------------------------
      double precision x, y, t, c, rate
      dimension c(1), rate(1)
      integer ns, mx, my, mxns
      integer i
      double precision ax,ay,acoef,bcoef,dx,dy,alph,diff,cox,coy
      double precision fac
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
c
      do 10 i = 1,ns
 10     rate(i) = 0.0d0
      do 15 i = 1,ns
        call daxpy (ns, c(i), acoef(1,i), 1, rate, 1)
 15     continue
      fac = 1.0d0 + alph*x*y
      do 20 i = 1,ns
 20     rate(i) = c(i)*(bcoef(i)*fac + rate(i))
      return
c------------  end of subroutine webr  ---------------------------------
      end
      subroutine jacbg (f, n, t, cc, ewt, f0, f1, gah, bd, ipbd, jflag)
c-----------------------------------------------------------------------
c this routine generates part of the block-diagonal part of the
c jacobian, multiplies by -gah, adds the identity matrix,
c and calls dgefa to do lu decomposition of each diagonal block.
c the computation of the diagonal blocks uses the block and grouping
c information in /pcom2/ and /pcom3/.  one block per group is computed.
c the jacobian elements are generated by difference quotients
c using calls to the routine fbg and stored base values in /pcom4/.
c this version of this routine ignores the input value of jflag and
c evaluates the appropriate jacobian elements on every call.
c on return, jflag is set to 2 if successful, or to -3 if a
c diagonal block was found to be singular.
c-----------------------------------------------------------------------
c the two common blocks below are used for internal communication.
c the variables used are..
c   mp     = size of blocks in block-diagonal preconditioning matrix.
c   mq     = number of blocks in each direction (n = mp*mq).
c   mpsq   = mp*mp.
c   uround = unit roundoff, generated by a call uround = dumach().
c   srur   = sqrt(uround).
c   meshx  = x mesh size
c   meshy  = y mesh size (mesh is meshx by meshy)
c   ngx    = no. groups in x direction in block-grouping scheme.
c   ngy    = no. groups in y direction in block-grouping scheme.
c   ngrp   = total number of groups = ngx*ngy.
c   mxmp   = meshx*mp.
c   jgx    = length ngx+1 array of group boundaries in x direction.
c            group igx has x indices jx = jgx(igx),...,jgx(igx+1)-1.
c   jigx   = length meshx array of x group indices vs x node index.
c            x node index jx is in x group jigx(jx).
c   jxr    = length ngx array of x indices representing the x groups.
c            the index for x group igx is jx = jxr(igx).
c   jgy, jigy, jyr = analogous arrays for grouping in y direction.
c-----------------------------------------------------------------------
      external f
      integer n, ipbd, jflag
      double precision t, cc, ewt, f0, f1, gah, bd
      dimension cc(1), ewt(1), f0(1), f1(1), bd(1), ipbd(1)
      integer mp, mq, mpsq, itmax,
     2        meshx,meshy,ngx,ngy,ngrp,mxmp,jgx,jgy,jigx,jigy,jxr,jyr
      integer i, ibd, idiag, if0, if00, ig, igx, igy, iip,
     1   j, jj, jx, jy
      double precision uround, srur,  crates
      double precision ccjj, fac, r, r0
c
      common /pcom2/ mp, mq, mpsq, itmax, uround, srur
      common /pcom3/ meshx, meshy, ngx, ngy, ngrp, mxmp,
     1   jgx(21), jgy(21), jigx(50), jigy(50), jxr(20), jyr(20)
      common /pcom4/ crates(20)
c
c-----------------------------------------------------------------------
c make mp+1 calls to fbg to approximate each diagonal block of jacobian.
c r0 is a minimum increment factor for the difference quotient.
c-----------------------------------------------------------------------
      jflag = 2
c
      r0=0.01d0
      ibd = 0
      do 240 igy = 1,ngy
        jy = jyr(igy)
        if00 = (jy - 1)*mxmp
        do 230 igx = 1,ngx
          jx = jxr(igx)
          if0 = if00 + (jx - 1)*mp
          call fbg (n, t, cc, jx, jy, crates)
          do 220 j = 1,mp
            jj = if0 + j
            ccjj = cc(jj)
            r = dmax1(srur*dabs(ccjj),r0*ewt(jj))
            cc(jj) = cc(jj) + r
            fac = -gah/r
            call fbg (n, t, cc, jx, jy, f1)
            do 210 i = 1,mp
 210          bd(ibd+i) = (f1(i) - crates(i))*fac
            cc(jj) = ccjj
            ibd = ibd + mp
 220        continue
 230      continue
 240    continue
c
c add identity matrix and do lu decompositions on blocks. --------------
      ibd = 1
      iip = 1
      do 280 ig = 1,ngrp
        idiag = ibd
        do 270 i = 1,mp
          bd(idiag) = bd(idiag) + 1.0d0
 270      idiag = idiag + (mp + 1)
        call dgefa (bd(ibd), mp, mp, ipbd(iip), ier)
        if (ier .ne. 0) go to 290
        ibd = ibd + mpsq
        iip = iip + mp
 280    continue
      return
c
 290  jflag = -3
      return
c------------  end of subroutine jacbg  --------------------------------
      end
      subroutine fbg (n, t, cc, jx, jy, cdot)
c-----------------------------------------------------------------------
c this routine computes one block of the interaction terms of the
c system, namely block (jx,jy), for use in preconditioning.
c-----------------------------------------------------------------------
      integer n, jx, jy
      double precision t, cc, cdot
      dimension cc(1), cdot(1)
      integer ns, mx, my, mxns
      integer iblok, ic
      double precision ax,ay,acoef,bcoef,dx,dy,alph,diff,cox,coy
      double precision x, y
c
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
c
      iblok = jx + (jy-1)*mx
        y = (jy-1)*dy
          x = (jx-1)*dx
          ic = ns*(iblok-1) + 1
          call webr (x, y, t, cc(ic), cdot)
      return
c------------  end of subroutine fbg  ----------------------------------
      end
      subroutine solsbg (n, t, cc, f0, wk, gah, bd, ipbd, v, lr, ier)
c-----------------------------------------------------------------------
c this routine applies one or two inverse preconditioner matrices
c to the array v, using the interaction-only block-diagonal jacobian
c with block-grouping, and gauss-seidel applied to the diffusion terms.
c when lr = 1 or 3, it calls gs for a gauss-seidel approximation
c to ((i-gah*jd)-inverse)*v, and stores the result in v.
c when lr = 2 or 3, it computes ((i-gah*dg/dc)-inverse)*v, using lu
c factors of the blocks in bd, and pivot information in ipbd.
c in both cases, the array v is overwritten with the solution.
c-----------------------------------------------------------------------
      integer n, ipbd, lr, ier
      double precision t, cc, f0, wk, gah, bd, v
      dimension cc(1), f0(1), wk(1), bd(1), ipbd(1), v(1)
      integer mp, mq, mpsq, itmax,
     2        meshx,meshy,ngx,ngy,ngrp,mxmp,jgx,jgy,jigx,jigy,jxr,jyr
      integer ibd, ig0, igm1, igx, igy, iip, iv, jx, jy
      double precision uround, srur
c
      common /pcom2/ mp, mq, mpsq, itmax, uround, srur
      common /pcom3/ meshx, meshy, ngx, ngy, ngrp, mxmp,
     1   jgx(21), jgy(21), jigx(50), jigy(50), jxr(20), jyr(20)
c
      ier = 0
c
      if (lr .eq. 1 .or. lr .eq. 3) then
        call gs (n, gah, v, wk, ier)
        endif
      if (lr .eq. 2 .or. lr .eq. 3) then
        iv = 1
        do 20 jy = 1,meshy
          igy = jigy(jy)
          ig0 = (igy - 1)*ngx
          do 10 jx = 1,meshx
            igx = jigx(jx)
            igm1 = igx - 1 + ig0
            ibd = 1 + igm1*mpsq
            iip = 1 + igm1*mp
            call dgesl (bd(ibd), mp, mp, ipbd(iip), v(iv), 0)
            iv = iv + mp
 10         continue
 20       continue
        endif
c
      return
c------------  end of subroutine solsbg  -------------------------------
      end
      subroutine gs (n, gah, z, x, ier)
c-----------------------------------------------------------------------
c this routine performs itmax gauss-seidel iterations
c to compute an approximation to p-inverse*z, where p = i - gah*j, and
c jd represents the diffusion contributions to the jacobian.
c z contains the answer on return.
c the dimensions below assume ns .le. 20.
c-----------------------------------------------------------------------
      integer n, ier
      double precision gah, z, x
      dimension z(1), x(1)
      integer ns, mx, my, mxns,
     1        mp, mq, mpsq, itmax
      integer i, ic, ici, iter, iyoff, jx, jy
      double precision ax,ay,acoef,bcoef,dx,dy,alph,diff,cox,coy,
     2     uround, srur
      double precision beta,beta2,cof1,elamda,gamma,gamma2
      dimension beta(20), gamma(20), beta2(20), gamma2(20), cof1(20)
      common /pcom1/ ax, ay, acoef(20,20), bcoef(20), dx, dy,
     1               alph, diff(20), cox(20), coy(20), ns, mx, my, mxns
      common /pcom2/ mp, mq, mpsq, itmax, uround, srur
c
c-----------------------------------------------------------------------
c write matrix as p = d - l - u.
c load local arrays beta, beta2, gamma, gamma2, and cof1.
c-----------------------------------------------------------------------
      do 10 i = 1,ns
        elamda = 1.d0/(1.d0 + 2.d0*gah*(cox(i) + coy(i)))
        beta(i) = gah*cox(i)*elamda
        beta2(i) = 2.d0*beta(i)
        gamma(i) = gah*coy(i)*elamda
        gamma2(i) = 2.d0*gamma(i)
        cof1(i) = elamda
 10     continue
c-----------------------------------------------------------------------
c begin iteration loop.
c load array x with (d-inverse)*z for first iteration.
c-----------------------------------------------------------------------
      iter = 1
c
      do 50 jy = 1,my
        iyoff = mxns*(jy-1)
        do 40 jx = 1,mx
          ic = iyoff + ns*(jx-1)
          do 30 i = 1,ns
            ici = ic + i
            x(ici) = cof1(i)*z(ici)
            z(ici) = 0.d0
 30         continue
 40       continue
 50     continue
      go to 160
c-----------------------------------------------------------------------
c calculate (d-inverse)*u*x.
c-----------------------------------------------------------------------
 70   continue
      iter = iter + 1
      jy = 1
        jx = 1
        ic = ns*(jx-1)
        do 75 i = 1,ns
          ici = ic + i
 75       x(ici) = beta2(i)*x(ici+ns) + gamma2(i)*x(ici+mxns)
        do 85 jx = 2,mx-1
          ic = ns*(jx-1)
          do 80 i = 1,ns
            ici = ic + i
 80         x(ici) = beta(i)*x(ici+ns) + gamma2(i)*x(ici+mxns)
 85       continue
        jx = mx
        ic = ns*(jx-1)
        do 90 i = 1,ns
          ici = ic + i
 90       x(ici) = gamma2(i)*x(ici+mxns)
      do 115 jy = 2,my-1
        iyoff = mxns*(jy-1)
          jx = 1
          ic = iyoff
          do 95 i = 1,ns
            ici = ic + i
 95         x(ici) = beta2(i)*x(ici+ns) + gamma(i)*x(ici+mxns)
          do 105 jx = 2,mx-1
            ic = iyoff + ns*(jx-1)
            do 100 i = 1,ns
              ici = ic + i
 100          x(ici) = beta(i)*x(ici+ns) + gamma(i)*x(ici+mxns)
 105        continue
          jx = mx
          ic = iyoff + ns*(jx-1)
          do 110 i = 1,ns
            ici = ic + i
 110        x(ici) = gamma(i)*x(ici+mxns)
 115      continue
      jy = my
      iyoff = mxns*(jy-1)
        jx = 1
        ic = iyoff
        do 120 i = 1,ns
          ici = ic + i
 120      x(ici) = beta2(i)*x(ici+ns)
        do 130 jx = 2,mx-1
          ic = iyoff + ns*(jx-1)
          do 125 i = 1,ns
            ici = ic + i
 125      x(ici) = beta(i)*x(ici+ns)
 130      continue
        jx = mx
        ic = iyoff + ns*(jx-1)
        do 135 i = 1,ns
          ici = ic + i
 135      x(ici) = 0.0d0
c-----------------------------------------------------------------------
c calculate (i - (d-inverse)*l)*x.
c-----------------------------------------------------------------------
 160  continue
      jy = 1
        do 175 jx = 2,mx-1
          ic = ns*(jx-1)
          do 170 i = 1,ns
            ici = ic + i
 170        x(ici) = x(ici) + beta(i)*x(ici-ns)
 175      continue
        jx = mx
        ic = ns*(jx-1)
        do 180 i = 1,ns
          ici = ic + i
 180      x(ici) = x(ici) + beta2(i)*x(ici-ns)
      do 210 jy = 2,my-1
        iyoff = mxns*(jy-1)
          jx = 1
          ic = iyoff
          do 185 i = 1,ns
            ici = ic + i
 185        x(ici) = x(ici) + gamma(i)*x(ici-mxns)
          do 200 jx = 2,mx-1
            ic = iyoff + ns*(jx-1)
            do 195 i = 1,ns
              ici = ic + i
              x(ici) = (x(ici) + beta(i)*x(ici-ns))
     1             + gamma(i)*x(ici-mxns)
 195          continue
 200        continue
            jx = mx
            ic = iyoff + ns*(jx-1)
            do 205 i = 1,ns
              ici = ic + i
              x(ici) = (x(ici) + beta2(i)*x(ici-ns))
     1             + gamma(i)*x(ici-mxns)
 205          continue
 210        continue
      jy = my
      iyoff = mxns*(jy-1)
        jx = 1
        ic = iyoff
        do 215 i = 1,ns
          ici = ic + i
 215      x(ici) = x(ici) + gamma2(i)*x(ici-mxns)
        do 225 jx = 2,mx-1
          ic = iyoff + ns*(jx-1)
          do 220 i = 1,ns
            ici = ic + i
            x(ici) = (x(ici) + beta(i)*x(ici-ns))
     1           + gamma2(i)*x(ici-mxns)
 220        continue
 225      continue
        jx = mx
        ic = iyoff + ns*(jx-1)
        do 230 i = 1,ns
          ici = ic + i
          x(ici) = (x(ici) + beta2(i)*x(ici-ns))
     1         + gamma2(i)*x(ici-mxns)
 230      continue
c-----------------------------------------------------------------------
c add increment x to z.
c-----------------------------------------------------------------------
      do 300 i = 1,n
 300    z(i) = z(i) + x(i)
c
      if (iter .lt. itmax) go to 70
      return
c------------  end of subroutine gs  -----------------------------------
      end
Demonstration program for KRYSI package

 Food web problem with ns species, ns =   8
 Predator-prey interaction and diffusion on a 2-D square


 Matrix parameters..  a =  0.1000E+01   e =  0.1000E+04   g =  0.5000E-06

 b parameter =  0.1000E+01

 Diffusion coefficients.. dprey =  0.1000E+01   dpred =  0.5000E-01

 Rate parameter alpha =  0.1000E+01


 Mesh dimensions (mx,my) =   6   6

 Total system size is n =    288
 tend =  0.100000E+02


 Preconditioning uses interaction-only block-diagonal matrix
 with block-grouping, and G-S iterations

 Number of diagonal block groups = ngrp =   4   (ngx by ngy, ngx = 2  ngy = 2 )

 G-S preconditioner uses itmax iterations, itmax =  5


 Tolerance parameters.. reps = aeps(i) =  0.10E-03


   t        nst  nfx   nf  nni  nns  nli  npe  npf  nps  ncfl    avdim

  0.00E+00    0    0    0    0    0    0    0    0    0    0    0.0000
  0.10E-07    1    1    6    6    0    0    0    0    0    0    0.0000
  0.10E-06    3    3   12   12    0    0    0    0    0    0    0.0000
  0.10E-05    4    4   18   18    0    0    0    0    0    0    0.0000
  0.10E-04    9    9   63   63    0    0    0    0    0    0    0.0000
  0.10E-03   53   53  459  459    0    0    0    0    0    0    0.0000
  0.10E-02  124  121 1094 1081   15   13    3    3   44    0    0.8667
  0.10E-01  128  121 1142 1105   39   37    4    4  116    0    1.0000
  0.10E+00  145  121 1309 1213  141   96    7    7  338    0    0.5784
  0.10E+01  176  121 1712 1405  327  307   12   12  948    0    1.1344
  0.20E+01  186  121 1868 1468  387  400   15   15 1204    0    1.5500
  0.30E+01  191  121 1953 1498  417  455   15   15 1362    0    1.8333
  0.40E+01  194  121 2011 1516  435  495   16   16 1474    0    2.2222
  0.50E+01  196  121 2053 1528  447  525   17   17 1558    0    2.5000
  0.60E+01  198  121 2081 1536  455  545   17   17 1614    0    2.5000
  0.70E+01  203  121 2117 1552  471  565   20   20 1686    0    1.2500
  0.80E+01  208  121 2153 1568  487  585   23   23 1758    0    1.2500
  0.90E+01  209  121 2161 1571  490  590   24   24 1774    0    1.6667
  0.10E+02  209  121 2161 1571  490  590   25   25 1774    0    0.0000

 KRYSI returned iflag =  2



 Final statistics for this run..
 total size of real work space     =    6350
 total size of integer work space  =      34
 number of time steps              =  209
 number of fixpoint steps          =  121
 number of f evaluations           = 2161
 number of nonlinear iterations    = 1571
 number of newton iterations       =  490
 number of linear iterations       =  590
 number of preconditioner evals.   =   25
 number of precond. factorizations =   25
 number of preconditioner solves   = 1774
 average krylov subspace dimension =  1.2041
 number of linear conver. failures =    0

--------------------------------------------------------------------------------
                              At time t =   0.00000000E+00
--------------------------------------------------------------------------------
 the species c( 1) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      10.1678      10.3775      10.3775      10.1678      10.0000    
  10.0000      10.3775      10.8493      10.8493      10.3775      10.0000    
  10.0000      10.3775      10.8493      10.8493      10.3775      10.0000    
  10.0000      10.1678      10.3775      10.3775      10.1678      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 2) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      10.3355      10.7550      10.7550      10.3355      10.0000    
  10.0000      10.7550      11.6987      11.6987      10.7550      10.0000    
  10.0000      10.7550      11.6987      11.6987      10.7550      10.0000    
  10.0000      10.3355      10.7550      10.7550      10.3355      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 3) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      10.5033      11.1325      11.1325      10.5033      10.0000    
  10.0000      11.1325      12.5480      12.5480      11.1325      10.0000    
  10.0000      11.1325      12.5480      12.5480      11.1325      10.0000    
  10.0000      10.5033      11.1325      11.1325      10.5033      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 4) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      10.6711      11.5099      11.5099      10.6711      10.0000    
  10.0000      11.5099      13.3974      13.3974      11.5099      10.0000    
  10.0000      11.5099      13.3974      13.3974      11.5099      10.0000    
  10.0000      10.6711      11.5099      11.5099      10.6711      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 5) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      10.8389      11.8874      11.8874      10.8389      10.0000    
  10.0000      11.8874      14.2467      14.2467      11.8874      10.0000    
  10.0000      11.8874      14.2467      14.2467      11.8874      10.0000    
  10.0000      10.8389      11.8874      11.8874      10.8389      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 6) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      11.0066      12.2649      12.2649      11.0066      10.0000    
  10.0000      12.2649      15.0961      15.0961      12.2649      10.0000    
  10.0000      12.2649      15.0961      15.0961      12.2649      10.0000    
  10.0000      11.0066      12.2649      12.2649      11.0066      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 7) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      11.1744      12.6424      12.6424      11.1744      10.0000    
  10.0000      12.6424      15.9454      15.9454      12.6424      10.0000    
  10.0000      12.6424      15.9454      15.9454      12.6424      10.0000    
  10.0000      11.1744      12.6424      12.6424      11.1744      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------

 the species c( 8) values are
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
  10.0000      11.3422      13.0199      13.0199      11.3422      10.0000    
  10.0000      13.0199      16.7948      16.7948      13.0199      10.0000    
  10.0000      13.0199      16.7948      16.7948      13.0199      10.0000    
  10.0000      11.3422      13.0199      13.0199      11.3422      10.0000    
  10.0000      10.0000      10.0000      10.0000      10.0000      10.0000    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.10000000E-05
--------------------------------------------------------------------------------
 the species c( 1) values are
  9.99991      9.99992      9.99993      9.99993      9.99993      9.99992    
  9.99992      10.1677      10.3774      10.3774      10.1677      9.99993    
  9.99993      10.3774      10.8492      10.8492      10.3774      9.99993    
  9.99993      10.3774      10.8492      10.8492      10.3774      9.99993    
  9.99992      10.1677      10.3774      10.3774      10.1677      9.99992    
  9.99991      9.99992      9.99993      9.99993      9.99992      9.99991    
--------------------------------------------------------------------------------

 the species c( 2) values are
  9.99991      9.99993      9.99995      9.99995      9.99993      9.99992    
  9.99993      10.3355      10.7549      10.7549      10.3355      9.99993    
  9.99995      10.7549      11.6985      11.6985      10.7549      9.99995    
  9.99995      10.7549      11.6985      11.6985      10.7549      9.99995    
  9.99993      10.3355      10.7549      10.7549      10.3355      9.99993    
  9.99991      9.99993      9.99995      9.99995      9.99993      9.99991    
--------------------------------------------------------------------------------

 the species c( 3) values are
  9.99991      9.99994      9.99997      9.99997      9.99994      9.99992    
  9.99994      10.5032      11.1323      11.1323      10.5032      9.99994    
  9.99997      11.1323      12.5478      12.5478      11.1323      9.99997    
  9.99997      11.1323      12.5478      12.5478      11.1323      9.99997    
  9.99994      10.5032      11.1323      11.1323      10.5032      9.99994    
  9.99991      9.99994      9.99997      9.99997      9.99994      9.99991    
--------------------------------------------------------------------------------

 the species c( 4) values are
  9.99991      9.99995      9.99999      9.99999      9.99995      9.99992    
  9.99994      10.6710      11.5098      11.5098      10.6710      9.99995    
  9.99999      11.5098      13.3971      13.3971      11.5098      9.99999    
  9.99999      11.5098      13.3971      13.3971      11.5098      9.99999    
  9.99994      10.6710      11.5098      11.5098      10.6710      9.99995    
  9.99991      9.99994      9.99999      9.99999      9.99994      9.99991    
--------------------------------------------------------------------------------

 the species c( 5) values are
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
  10.4080      11.3000      12.4192      12.4192      11.3000      10.4080    
  10.4080      12.4192      14.9544      14.9544      12.4192      10.4080    
  10.4080      12.4192      14.9544      14.9544      12.4192      10.4080    
  10.4080      11.3000      12.4192      12.4192      11.3000      10.4080    
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
--------------------------------------------------------------------------------

 the species c( 6) values are
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
  10.4080      11.4749      12.8136      12.8136      11.4749      10.4080    
  10.4080      12.8136      15.8459      15.8459      12.8136      10.4080    
  10.4080      12.8136      15.8459      15.8459      12.8136      10.4080    
  10.4080      11.4749      12.8136      12.8136      11.4749      10.4080    
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
--------------------------------------------------------------------------------

 the species c( 7) values are
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
  10.4080      11.6498      13.2079      13.2079      11.6498      10.4080    
  10.4080      13.2079      16.7374      16.7374      13.2079      10.4080    
  10.4080      13.2079      16.7374      16.7374      13.2079      10.4080    
  10.4080      11.6498      13.2079      13.2079      11.6498      10.4080    
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
--------------------------------------------------------------------------------

 the species c( 8) values are
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
  10.4080      11.8247      13.6023      13.6023      11.8247      10.4080    
  10.4080      13.6023      17.6289      17.6289      13.6023      10.4080    
  10.4080      13.6023      17.6289      17.6289      13.6023      10.4080    
  10.4080      11.8247      13.6023      13.6023      11.8247      10.4080    
  10.4080      10.4080      10.4080      10.4080      10.4080      10.4080    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.10000000E-02
--------------------------------------------------------------------------------
 the species c( 1) values are
  9.91066      9.92029      9.93202      9.93399      9.92618      9.92038    
  9.91836      10.0785      10.2809      10.2825      10.0833      9.92618    
  9.92812      10.2789      10.7227      10.7239      10.2825      9.93399    
  9.92811      10.2785      10.7218      10.7227      10.2809      9.93202    
  9.91833      10.0773      10.2785      10.2789      10.0785      9.92029    
  9.91061      9.91833      9.92811      9.92812      9.91836      9.91066    
--------------------------------------------------------------------------------

 the species c( 2) values are
  9.91106      9.92839      9.94990      9.95187      9.93429      9.92078    
  9.92647      10.2451      10.6482      10.6499      10.2500      9.93429    
  9.94599      10.6461      11.5316      11.5329      10.6499      9.95187    
  9.94598      10.6457      11.5307      11.5316      10.6482      9.94990    
  9.92644      10.2439      10.6457      10.6461      10.2451      9.92839    
  9.91101      9.92644      9.94598      9.94599      9.92647      9.91106    
--------------------------------------------------------------------------------

 the species c( 3) values are
  9.91145      9.93650      9.96776      9.96973      9.94240      9.92117    
  9.93457      10.4117      11.0153      11.0170      10.4167      9.94240    
  9.96385      11.0131      12.3391      12.3406      11.0170      9.96973    
  9.96384      11.0126      12.3382      12.3391      11.0153      9.96776    
  9.93454      10.4105      11.0126      11.0131      10.4117      9.93650    
  9.91140      9.93454      9.96384      9.96385      9.93457      9.91145    
--------------------------------------------------------------------------------

 the species c( 4) values are
  9.91184      9.94460      9.98562      9.98760      9.95051      9.92157    
  9.94267      10.5782      11.3820      11.3838      10.5833      9.95051    
  9.98170      11.3798      13.1454      13.1470      11.3838      9.98760    
  9.98169      11.3793      13.1443      13.1454      11.3820      9.98562    
  9.94264      10.5770      11.3793      11.3798      10.5782      9.94460    
  9.91179      9.94264      9.98169      9.98170      9.94267      9.91184    
--------------------------------------------------------------------------------

 the species c( 5) values are
  39652.8      39735.5      39838.4      39845.9      39757.9      39689.7    
  39728.1      41321.1      43335.3      43341.9      41339.8      39757.9    
  39823.5      43327.1      47752.8      47758.2      43341.9      39845.9    
  39823.5      43325.5      47749.1      47752.8      43335.3      39838.4    
  39728.0      41316.4      43325.5      43327.1      41321.1      39735.5    
  39652.6      39728.0      39823.5      39823.5      39728.1      39652.8    
--------------------------------------------------------------------------------

 the species c( 6) values are
  39652.8      39735.5      39838.4      39845.9      39757.9      39689.7    
  39728.1      41321.1      43335.3      43341.9      41339.9      39757.9    
  39823.5      43327.1      47752.8      47758.2      43341.9      39845.9    
  39823.5      43325.5      47749.1      47752.8      43335.3      39838.4    
  39728.0      41316.4      43325.5      43327.1      41321.1      39735.5    
  39652.6      39728.0      39823.5      39823.5      39728.1      39652.8    
--------------------------------------------------------------------------------

 the species c( 7) values are
  39652.8      39735.5      39838.4      39845.9      39757.9      39689.7    
  39728.1      41321.1      43335.3      43341.9      41339.9      39757.9    
  39823.5      43327.1      47752.8      47758.2      43341.9      39845.9    
  39823.5      43325.5      47749.1      47752.8      43335.3      39838.4    
  39728.0      41316.4      43325.5      43327.1      41321.1      39735.5    
  39652.6      39728.0      39823.5      39823.5      39728.1      39652.8    
--------------------------------------------------------------------------------

 the species c( 8) values are
  39652.8      39735.5      39838.4      39845.9      39757.9      39689.7    
  39728.1      41321.1      43335.3      43341.9      41339.9      39757.9    
  39823.5      43327.1      47752.8      47758.2      43341.9      39845.9    
  39823.5      43325.5      47749.1      47752.8      43335.3      39838.4    
  39728.0      41316.4      43325.5      43327.1      41321.1      39735.5    
  39652.6      39728.0      39823.5      39823.5      39728.1      39652.8    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.10000000E+01
--------------------------------------------------------------------------------
 the species c( 1) values are
  1.64428      1.65539      1.67845      1.70551      1.72903      1.74055    
  1.64099      1.65103      1.67220      1.69709      1.71864      1.72903    
  1.63295      1.64113      1.65865      1.67932      1.69709      1.70551    
  1.62325      1.62938      1.64277      1.65865      1.67220      1.67845    
  1.61525      1.61955      1.62938      1.64113      1.65103      1.65539    
  1.61199      1.61525      1.62325      1.63295      1.64099      1.64428    
--------------------------------------------------------------------------------

 the species c( 2) values are
  1.64635      1.65747      1.68056      1.70764      1.73118      1.74272    
  1.64305      1.65311      1.67430      1.69922      1.72079      1.73118    
  1.63500      1.64320      1.66074      1.68142      1.69922      1.70764    
  1.62530      1.63143      1.64484      1.66074      1.67430      1.68056    
  1.61729      1.62159      1.63143      1.64320      1.65311      1.65747    
  1.61402      1.61729      1.62530      1.63500      1.64305      1.64635    
--------------------------------------------------------------------------------

 the species c( 3) values are
  1.64830      1.65943      1.68254      1.70965      1.73322      1.74477    
  1.64500      1.65507      1.67628      1.70122      1.72281      1.73322    
  1.63695      1.64515      1.66271      1.68341      1.70122      1.70965    
  1.62723      1.63337      1.64680      1.66271      1.67628      1.68254    
  1.61922      1.62353      1.63337      1.64515      1.65507      1.65943    
  1.61595      1.61922      1.62723      1.63695      1.64500      1.64830    
--------------------------------------------------------------------------------

 the species c( 4) values are
  1.65015      1.66129      1.68443      1.71156      1.73515      1.74671    
  1.64685      1.65692      1.67816      1.70312      1.72473      1.73515    
  1.63879      1.64700      1.66457      1.68529      1.70312      1.71156    
  1.62907      1.63521      1.64865      1.66457      1.67816      1.68443    
  1.62105      1.62535      1.63521      1.64700      1.65692      1.66129    
  1.61777      1.62105      1.62907      1.63879      1.64685      1.65015    
--------------------------------------------------------------------------------

 the species c( 5) values are
  6588.52      6632.81      6725.00      6833.17      6927.18      6973.13    
  6575.31      6615.40      6700.03      6799.59      6885.74      6927.18    
  6543.12      6575.79      6645.85      6728.50      6799.59      6833.17    
  6504.29      6528.74      6582.33      6645.85      6700.03      6725.00    
  6472.25      6489.42      6528.74      6575.79      6615.40      6632.81    
  6459.17      6472.25      6504.29      6543.12      6575.31      6588.52    
--------------------------------------------------------------------------------

 the species c( 6) values are
  6588.52      6632.81      6725.00      6833.17      6927.18      6973.13    
  6575.31      6615.40      6700.03      6799.59      6885.74      6927.18    
  6543.12      6575.79      6645.85      6728.50      6799.59      6833.17    
  6504.29      6528.74      6582.33      6645.85      6700.03      6725.00    
  6472.25      6489.42      6528.74      6575.79      6615.40      6632.81    
  6459.17      6472.25      6504.29      6543.12      6575.31      6588.52    
--------------------------------------------------------------------------------

 the species c( 7) values are
  6588.52      6632.81      6725.00      6833.17      6927.18      6973.13    
  6575.31      6615.40      6700.03      6799.59      6885.74      6927.18    
  6543.12      6575.79      6645.85      6728.50      6799.59      6833.17    
  6504.29      6528.74      6582.33      6645.85      6700.03      6725.00    
  6472.25      6489.42      6528.74      6575.79      6615.40      6632.81    
  6459.17      6472.25      6504.29      6543.12      6575.31      6588.52    
--------------------------------------------------------------------------------

 the species c( 8) values are
  6588.52      6632.81      6725.00      6833.17      6927.18      6973.13    
  6575.31      6615.40      6700.03      6799.59      6885.74      6927.18    
  6543.12      6575.79      6645.85      6728.50      6799.59      6833.17    
  6504.29      6528.74      6582.33      6645.85      6700.03      6725.00    
  6472.25      6489.42      6528.74      6575.79      6615.40      6632.81    
  6459.17      6472.25      6504.29      6543.12      6575.31      6588.52    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.40000000E+01
--------------------------------------------------------------------------------
 the species c( 1) values are
  1.23915      1.24778      1.26584      1.28706      1.30549      1.31446    
  1.23650      1.24433      1.26092      1.28049      1.29739      1.30549    
  1.23004      1.23644      1.25021      1.26650      1.28049      1.28706    
  1.22224      1.22705      1.23764      1.25021      1.26092      1.26584    
  1.21582      1.21922      1.22705      1.23644      1.24433      1.24778    
  1.21320      1.21582      1.22224      1.23004      1.23650      1.23915    
--------------------------------------------------------------------------------

 the species c( 2) values are
  1.23917      1.24781      1.26586      1.28709      1.30552      1.31449    
  1.23653      1.24436      1.26095      1.28051      1.29742      1.30552    
  1.23007      1.23646      1.25024      1.26653      1.28051      1.28709    
  1.22227      1.22707      1.23766      1.25024      1.26095      1.26586    
  1.21584      1.21924      1.22707      1.23646      1.24436      1.24781    
  1.21323      1.21584      1.22227      1.23007      1.23653      1.23917    
--------------------------------------------------------------------------------

 the species c( 3) values are
  1.23920      1.24783      1.26589      1.28712      1.30555      1.31451    
  1.23656      1.24438      1.26098      1.28054      1.29745      1.30555    
  1.23010      1.23649      1.25027      1.26655      1.28054      1.28712    
  1.22230      1.22710      1.23769      1.25027      1.26098      1.26589    
  1.21587      1.21927      1.22710      1.23649      1.24438      1.24783    
  1.21325      1.21587      1.22230      1.23010      1.23656      1.23920    
--------------------------------------------------------------------------------

 the species c( 4) values are
  1.23923      1.24786      1.26592      1.28714      1.30557      1.31454    
  1.23658      1.24441      1.26100      1.28057      1.29747      1.30557    
  1.23012      1.23651      1.25029      1.26658      1.28057      1.28714    
  1.22232      1.22713      1.23771      1.25029      1.26100      1.26592    
  1.21589      1.21929      1.22713      1.23651      1.24441      1.24786    
  1.21328      1.21589      1.22232      1.23012      1.23658      1.23923    
--------------------------------------------------------------------------------

 the species c( 5) values are
  4955.77      4990.09      5062.11      5146.81      5220.31      5255.97    
  4945.20      4976.33      5042.55      5120.63      5188.09      5220.31    
  4919.35      4944.80      4999.78      5064.79      5120.63      5146.81    
  4888.14      4907.28      4949.56      4999.78      5042.55      5062.11    
  4862.44      4876.00      4907.28      4944.80      4976.33      4990.09    
  4851.98      4862.44      4888.14      4919.35      4945.20      4955.77    
--------------------------------------------------------------------------------

 the species c( 6) values are
  4955.77      4990.09      5062.11      5146.81      5220.31      5255.97    
  4945.20      4976.33      5042.55      5120.63      5188.09      5220.31    
  4919.35      4944.80      4999.78      5064.79      5120.63      5146.81    
  4888.14      4907.28      4949.56      4999.78      5042.55      5062.11    
  4862.44      4876.00      4907.28      4944.80      4976.33      4990.09    
  4851.98      4862.44      4888.14      4919.35      4945.20      4955.77    
--------------------------------------------------------------------------------

 the species c( 7) values are
  4955.77      4990.09      5062.11      5146.81      5220.31      5255.97    
  4945.20      4976.33      5042.55      5120.63      5188.09      5220.31    
  4919.35      4944.80      4999.78      5064.79      5120.63      5146.81    
  4888.14      4907.28      4949.56      4999.78      5042.55      5062.11    
  4862.44      4876.00      4907.28      4944.80      4976.33      4990.09    
  4851.98      4862.44      4888.14      4919.35      4945.20      4955.77    
--------------------------------------------------------------------------------

 the species c( 8) values are
  4955.77      4990.09      5062.11      5146.81      5220.31      5255.97    
  4945.20      4976.33      5042.55      5120.63      5188.09      5220.31    
  4919.35      4944.80      4999.78      5064.79      5120.63      5146.81    
  4888.14      4907.28      4949.56      4999.78      5042.55      5062.11    
  4862.44      4876.00      4907.28      4944.80      4976.33      4990.09    
  4851.98      4862.44      4888.14      4919.35      4945.20      4955.77    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.70000000E+01
--------------------------------------------------------------------------------
 the species c( 1) values are
  1.23216      1.24075      1.25871      1.27983      1.29817      1.30709    
  1.22953      1.23731      1.25382      1.27329      1.29011      1.29817    
  1.22310      1.22946      1.24316      1.25937      1.27329      1.27983    
  1.21533      1.22011      1.23065      1.24316      1.25382      1.25871    
  1.20893      1.21232      1.22011      1.22946      1.23731      1.24075    
  1.20633      1.20893      1.21533      1.22310      1.22953      1.23216    
--------------------------------------------------------------------------------

 the species c( 2) values are
  1.23216      1.24075      1.25871      1.27983      1.29817      1.30709    
  1.22953      1.23731      1.25383      1.27329      1.29011      1.29817    
  1.22310      1.22946      1.24316      1.25937      1.27329      1.27983    
  1.21533      1.22011      1.23065      1.24316      1.25383      1.25871    
  1.20893      1.21232      1.22011      1.22946      1.23731      1.24075    
  1.20633      1.20893      1.21533      1.22310      1.22953      1.23216    
--------------------------------------------------------------------------------

 the species c( 3) values are
  1.23216      1.24075      1.25871      1.27983      1.29817      1.30709    
  1.22953      1.23731      1.25383      1.27329      1.29011      1.29817    
  1.22310      1.22946      1.24316      1.25937      1.27329      1.27983    
  1.21533      1.22011      1.23065      1.24316      1.25383      1.25871    
  1.20893      1.21232      1.22011      1.22946      1.23731      1.24075    
  1.20633      1.20893      1.21533      1.22310      1.22953      1.23216    
--------------------------------------------------------------------------------

 the species c( 4) values are
  1.23216      1.24075      1.25871      1.27983      1.29817      1.30709    
  1.22953      1.23731      1.25383      1.27329      1.29011      1.29817    
  1.22310      1.22946      1.24316      1.25937      1.27329      1.27983    
  1.21533      1.22011      1.23065      1.24316      1.25383      1.25871    
  1.20893      1.21232      1.22011      1.22946      1.23731      1.24075    
  1.20633      1.20893      1.21533      1.22310      1.22953      1.23216    
--------------------------------------------------------------------------------

 the species c( 5) values are
  4927.64      4961.79      5033.44      5117.72      5190.86      5226.34    
  4917.13      4948.09      5013.98      5091.67      5158.79      5190.86    
  4891.40      4916.71      4971.42      5036.11      5091.67      5117.72    
  4860.33      4879.37      4921.44      4971.42      5013.98      5033.44    
  4834.74      4848.24      4879.37      4916.71      4948.09      4961.79    
  4824.33      4834.74      4860.33      4891.40      4917.13      4927.64    
--------------------------------------------------------------------------------

 the species c( 6) values are
  4927.64      4961.79      5033.44      5117.72      5190.86      5226.34    
  4917.13      4948.09      5013.98      5091.67      5158.79      5190.86    
  4891.40      4916.71      4971.42      5036.11      5091.67      5117.72    
  4860.33      4879.37      4921.44      4971.42      5013.98      5033.44    
  4834.74      4848.24      4879.37      4916.71      4948.09      4961.79    
  4824.33      4834.74      4860.33      4891.40      4917.13      4927.64    
--------------------------------------------------------------------------------

 the species c( 7) values are
  4927.64      4961.79      5033.44      5117.72      5190.86      5226.34    
  4917.13      4948.09      5013.98      5091.67      5158.79      5190.86    
  4891.40      4916.71      4971.42      5036.11      5091.67      5117.72    
  4860.33      4879.37      4921.44      4971.42      5013.98      5033.44    
  4834.74      4848.24      4879.37      4916.71      4948.09      4961.79    
  4824.33      4834.74      4860.33      4891.40      4917.13      4927.64    
--------------------------------------------------------------------------------

 the species c( 8) values are
  4927.64      4961.79      5033.44      5117.72      5190.86      5226.34    
  4917.13      4948.09      5013.98      5091.67      5158.79      5190.86    
  4891.40      4916.71      4971.42      5036.11      5091.67      5117.72    
  4860.33      4879.37      4921.44      4971.42      5013.98      5033.44    
  4834.74      4848.24      4879.37      4916.71      4948.09      4961.79    
  4824.33      4834.74      4860.33      4891.40      4917.13      4927.64    
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
                              At time t =   0.10000000E+02
--------------------------------------------------------------------------------
 the species c( 1) values are
  1.23199      1.24058      1.25854      1.27966      1.29800      1.30692    
  1.22936      1.23714      1.25365      1.27312      1.28994      1.29800    
  1.22293      1.22929      1.24299      1.25920      1.27312      1.27966    
  1.21516      1.21994      1.23048      1.24299      1.25365      1.25854    
  1.20877      1.21215      1.21994      1.22929      1.23714      1.24058    
  1.20616      1.20877      1.21516      1.22293      1.22936      1.23199    
--------------------------------------------------------------------------------

 the species c( 2) values are
  1.23199      1.24058      1.25854      1.27966      1.29800      1.30692    
  1.22936      1.23714      1.25365      1.27312      1.28994      1.29800    
  1.22293      1.22929      1.24299      1.25920      1.27312      1.27966    
  1.21516      1.21994      1.23048      1.24299      1.25365      1.25854    
  1.20877      1.21215      1.21994      1.22929      1.23714      1.24058    
  1.20616      1.20877      1.21516      1.22293      1.22936      1.23199    
--------------------------------------------------------------------------------

 the species c( 3) values are
  1.23199      1.24058      1.25854      1.27966      1.29800      1.30692    
  1.22936      1.23714      1.25365      1.27312      1.28994      1.29800    
  1.22293      1.22929      1.24299      1.25920      1.27312      1.27966    
  1.21516      1.21994      1.23048      1.24299      1.25365      1.25854    
  1.20877      1.21215      1.21994      1.22929      1.23714      1.24058    
  1.20616      1.20877      1.21516      1.22293      1.22936      1.23199    
--------------------------------------------------------------------------------

 the species c( 4) values are
  1.23199      1.24058      1.25854      1.27966      1.29800      1.30692    
  1.22936      1.23714      1.25365      1.27312      1.28994      1.29800    
  1.22293      1.22929      1.24299      1.25920      1.27312      1.27966    
  1.21516      1.21994      1.23048      1.24299      1.25365      1.25854    
  1.20877      1.21215      1.21994      1.22929      1.23714      1.24058    
  1.20616      1.20877      1.21516      1.22293      1.22936      1.23199    
--------------------------------------------------------------------------------

 the species c( 5) values are
  4926.97      4961.11      5032.76      5117.03      5190.16      5225.63    
  4916.45      4947.42      5013.30      5090.98      5158.10      5190.16    
  4890.73      4916.04      4970.74      5035.43      5090.98      5117.03    
  4859.66      4878.70      4920.77      4970.74      5013.30      5032.76    
  4834.07      4847.57      4878.70      4916.04      4947.42      4961.11    
  4823.66      4834.07      4859.66      4890.73      4916.45      4926.97    
--------------------------------------------------------------------------------

 the species c( 6) values are
  4926.97      4961.11      5032.76      5117.03      5190.16      5225.63    
  4916.45      4947.42      5013.30      5090.98      5158.10      5190.16    
  4890.73      4916.04      4970.74      5035.43      5090.98      5117.03    
  4859.66      4878.70      4920.77      4970.74      5013.30      5032.76    
  4834.07      4847.57      4878.70      4916.04      4947.42      4961.11    
  4823.66      4834.07      4859.66      4890.73      4916.45      4926.97    
--------------------------------------------------------------------------------

 the species c( 7) values are
  4926.97      4961.11      5032.76      5117.03      5190.16      5225.63    
  4916.45      4947.42      5013.30      5090.98      5158.10      5190.16    
  4890.73      4916.04      4970.74      5035.43      5090.98      5117.03    
  4859.66      4878.70      4920.77      4970.74      5013.30      5032.76    
  4834.07      4847.57      4878.70      4916.04      4947.42      4961.11    
  4823.66      4834.07      4859.66      4890.73      4916.45      4926.97    
--------------------------------------------------------------------------------

 the species c( 8) values are
  4926.97      4961.11      5032.76      5117.03      5190.16      5225.63    
  4916.45      4947.42      5013.30      5090.98      5158.10      5190.16    
  4890.73      4916.04      4970.74      5035.43      5090.98      5117.03    
  4859.66      4878.70      4920.77      4970.74      5013.30      5032.76    
  4834.07      4847.57      4878.70      4916.04      4947.42      4961.11    
  4823.66      4834.07      4859.66      4890.73      4916.45      4926.97    
--------------------------------------------------------------------------------

