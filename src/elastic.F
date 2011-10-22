! elastic.F -*-f90-*-
! Time-stamp: <2011-10-22 14:45:49 takeshi>
! Author: Takeshi NISHIMATSU
! ref_1: R. D. King-Smith and David Vanderbilt: PRB Vol.49 p.5828 (1994)
!!
#include "define.h"
subroutine elastic(p,c)
  use Param_module
  use Coord_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  !--- local -----------------------------------------
  integer ix,iy,iz, alpha,beta, i, other1, other2
  real*8  k(0:3)
  integer, parameter :: ki(3,3) = reshape((/0,3,2, 3,0,1, 2,1,0/),(/3,3/))
  character (len=100) :: fn
  !--- END of variable definitions -------------------
  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', 'make elastic constant matrix.')

  ! homogeneous -----------------------------------
  c%homogeneous(:,:) = 0.0d0

  c%homogeneous(1,1) = p%B11*p%N
  c%homogeneous(2,2) = p%B11*p%N
  c%homogeneous(3,3) = p%B11*p%N

  c%homogeneous(4,4) = p%B44*p%N
  c%homogeneous(5,5) = p%B44*p%N
  c%homogeneous(6,6) = p%B44*p%N

  c%homogeneous(1,2) = p%B12*p%N
  c%homogeneous(1,3) = p%B12*p%N
  c%homogeneous(2,3) = p%B12*p%N
  c%homogeneous(2,1) = p%B12*p%N
  c%homogeneous(3,1) = p%B12*p%N
  c%homogeneous(3,2) = p%B12*p%N

  ! homogeneous_coupling_2 ------------------------
  c%homogeneous_coupling_2(:,:) = 0.0d0

  c%homogeneous_coupling_2(1,1) = p%B1xx / 2
  c%homogeneous_coupling_2(2,2) = p%B1xx / 2
  c%homogeneous_coupling_2(3,3) = p%B1xx / 2

  c%homogeneous_coupling_2(4,4) = p%B4yz
  c%homogeneous_coupling_2(5,5) = p%B4yz
  c%homogeneous_coupling_2(6,6) = p%B4yz

  c%homogeneous_coupling_2(1,2) = p%B1yy / 2
  c%homogeneous_coupling_2(1,3) = p%B1yy / 2
  c%homogeneous_coupling_2(2,3) = p%B1yy / 2
  c%homogeneous_coupling_2(2,1) = p%B1yy / 2
  c%homogeneous_coupling_2(3,1) = p%B1yy / 2
  c%homogeneous_coupling_2(3,2) = p%B1yy / 2
  ! See equation (A1) and (A2) of ref_1
!
  ! inhomo_K --------------------------------------
  do iz = 0, p%Lz-1
     k(3) = dble(iz)/p%Lz; if (k(3).gt.0.5d0) k(3)=k(3)-1.0d0
     k(3) = k(3) * M_2PI / p%a0
     do iy = 0, p%Ly-1
        k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
        k(2) = k(2) * M_2PI / p%a0
        do ix = 0, p%Lx/2
           k(1) = dble(ix) / p%Lx * M_2PI / p%a0
           do beta = 1, 3
              other1 = mod(beta+1,3)+1
              other2 = mod(beta,  3)+1
              do alpha = 1, 3
                 if (alpha.eq.beta) then
                    c%inhomo_K(alpha,beta, ix,iy,iz) = &
                         & p%B11 * k(alpha ) * k(alpha ) + &
                         & p%B44 * k(other1) * k(other1) + &
                         & p%B44 * k(other2) * k(other2)
                 else
                    c%inhomo_K(alpha,beta, ix,iy,iz) = &
                         & p%B12 * k(alpha ) * k( beta ) + &
                         & p%B44 * k(alpha ) * k( beta )
                 end if
              end do
           end do
        end do
     end do
  end do

  if (p%plot_dispersion) then
     write(fn,'(a,a)') trim(p%filename),'.inhomo-K.dat'
     call print_eigenvalues(p%Lx, p%Ly, p%Lz, c%inhomo_K, fn)
     call msg(UNIT_LOG, __FILE__, __LINE__, 'FILENAME',fn)
  end if

  ! inhomo_coup2_K -----------------------------
  k(0) = 0.0d0
  do i = 1, 6
     do alpha = 1, 3
        do iz = 0, p%Lz-1
           k(3) = dble(iz)/p%Lz; if (k(3).gt.0.5d0) k(3)=k(3)-1.0d0
           k(3) = k(3) * M_2PI / p%a0
           do iy = 0, p%Ly-1
              k(2) = dble(iy)/p%Ly; if (k(2).gt.0.5d0) k(2)=k(2)-1.0d0
              k(2) = k(2) * M_2PI / p%a0
              do ix = 0, p%Lx/2
                 k(1) = dble(ix) / p%Lx * M_2PI / p%a0
                 if (i.le.3) then
                    if (i.eq.alpha) then
                       c%inhomo_coup2_K(ix,iy,iz, alpha,i) = k(alpha)*p%B1xx/2
                    else
                       c%inhomo_coup2_K(ix,iy,iz, alpha,i) = k(alpha)*p%B1yy/2
                    end if
                 else
                    c%inhomo_coup2_K(ix,iy,iz, alpha,i)=k(ki(alpha,i-3))*p%B4yz
                 end if
              end do
           end do
        end do
     end do
  end do
  !write(6,'(6f10.5)') ((c%inhomo_coup2_K(1,1,1, alpha,i), i=1,6), alpha=1,3)

  call msg(UNIT_LOG, __FILE__, __LINE__, 'END',   '')
end subroutine elastic
