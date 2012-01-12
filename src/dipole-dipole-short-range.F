! dipole-dipole-short-range.F -*-f90-*-
! Time-stamp: <2012-01-12 16:52:25 t-nissie>
! Author: Takeshi NISHIMATSU
! ref_1: W. Zhong, David Vanderbilt and K. M. Rabe: PRB Vol.52 p.6301 (1995)
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif
#include "define.h"
subroutine dipole_dipole_short_range(p,short_range)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)  :: p
  real*8,           intent(out) :: short_range(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3) !"/2" See fft.F!
  !--- allocatable arrays ----------------------------
  real*8,     allocatable :: TMPreal(:,:,:,:,:)
  complex*16, allocatable :: TMPcomplex(:,:,:,:,:)
  !--- etc -------------------------------------------
  integer  ix, iy, iz, i(3), ii, indx(3), alpha, beta
  character(20), parameter :: fmt='(a,f8.4)'
  character(50)            :: message
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  allocate(   TMPreal(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3, 3))
  allocate(TMPcomplex(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3, 3)) !"/2" See fft.F!
  TMPreal(:,:,:,:,:)=0.0d0

  do alpha = 1, 3
     TMPreal(0, 0, 0, alpha, alpha) = p%P_kappa2 * 2
  end do

  do beta = 1, 3
     do alpha = 1, 3
        do iz = -1, 1
           i(3)=iz; if (iz.ge.0) then; indx(3)=iz; else; indx(3)=p%Lz+iz; end if
           do iy = -1, 1
              i(2)=iy; if (iy.ge.0) then; indx(2)=iy; else; indx(2)=p%Ly+iy; end if
              do ix = -1, 1
                 i(1)=ix; if (ix.ge.0) then; indx(1)=ix; else; indx(1)=p%Lx+ix; end if

                 ii = ix**2 + iy**2 + iz**2

                 if (ii.eq.1) then
                    ! first nearest neighbor
                    if (alpha.eq.beta) then
                       if (i(alpha).eq.0) then
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(1)
                       else
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(2)
                       end if
                    end if
                 else if (ii.eq.2) then
                    ! second nearest neighbor
                    if (alpha.eq.beta) then
                       if (i(alpha).eq.0) then
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(4)
                       else
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(3)
                       end if
                    else
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(5)*i(alpha)*i(beta)
                    end if
                 else if (ii.eq.3) then
                    ! third nearest neighbor
                    if (alpha.eq.beta) then
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(6)
                    else
                          TMPreal(indx(1), indx(2), indx(3), alpha, beta) = p%j(7)*i(alpha)*i(beta)
                    end if
                 end if

              end do
           end do
        end do
     end do
  end do

  write(message,fmt) 'TMPreal(   0,0,0,1,1) = 2P_kappa2 = ', TMPreal(     0,0,0,1,1)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(Lx-1,0,0,3,3) =  j(1)     = ', TMPreal(p%Lx-1,0,0,3,3)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   0,0,1,3,3) =  j(2)     = ', TMPreal(     0,0,1,3,3)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   1,0,1,3,3) =  j(3)     = ', TMPreal(     1,0,1,3,3)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   1,1,0,3,3) =  j(4)     = ', TMPreal(     1,1,0,3,3)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   1,0,1,3,1) =  j(5)     = ', TMPreal(     1,0,1,3,1)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   1,1,1,3,3) =  j(6)     = ', TMPreal(     1,1,1,3,3)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) 'TMPreal(   1,1,1,3,1) =  j(7)     = ', TMPreal(     1,1,1,3,1)
  call msg_ez(UNIT_LOG, message)

  write(message,fmt) '(a) Gamma = ', p%P_kappa2+2*p%j(1)+p%j(2)+4*p%j(3)+2*p%j(4)+4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(b) X_LO  = ', p%P_kappa2+2*p%j(1)-p%j(2)-4*p%j(3)+2*p%j(4)-4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(c) X_TO  = ', p%P_kappa2         +p%j(2)         -2*p%j(4)-4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(d) M_TO  = ', p%P_kappa2-2*p%j(1)+p%j(2)-4*p%j(3)+2*p%j(4)+4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(e) M_LO  = ', p%P_kappa2         -p%j(2)         -2*p%j(4)+4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(f) R     = ', p%P_kappa2-2*p%j(1)-p%j(2)+4*p%j(3)+2*p%j(4)-4*p%j(6)
  call msg_ez(UNIT_LOG, message)
  write(message,fmt) '(g) Sigma = ', p%P_kappa2/2 + p%j(1) - 2*p%j(5) - 4*p%j(7)
  call msg_ez(UNIT_LOG, message)
                 !(e) in TABLE 1 of ref_1 is incorrect.

  call fft_3d_3x3upper_r2c(p, TMPreal, TMPcomplex)
  short_range(:,:,:,:,:) = dble(TMPcomplex(:,:,:,:,:))
  deallocate(TMPreal,TMPcomplex)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine dipole_dipole_short_range
