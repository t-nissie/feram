! write_system.F -*-f90-*-
! Time-stamp: <2015-10-19 19:44:06 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#include "define.h"

subroutine write_system(p,c,fn)
  use, intrinsic :: iso_c_binding
  use Param_module
  use Coord_module
  use msg_module
  implicit none
  type(Param_type), intent(in) :: p
  type(Coord_type), intent(inout) :: c
  character(len=*) :: fn
  character(len=FILE_NAME_LEN) :: coord_directory_fn
  integer alpha,ix,iy,iz
  include 'fftw3.f03'

  call msg(UNIT_LOG, __FILE__, __LINE__, 'BEGIN', '')

  if (p%coord_directory.eq.'never') then
     call msg(UNIT_LOG, __FILE__, __LINE__, 'END', 'never write .coord files.')
     return
  else if (p%coord_directory.eq.'') then
     coord_directory_fn = trim(fn)
  else
     coord_directory_fn = trim(p%coord_directory) // '/' // trim(fn)
  end if
  
  if (p%mass_acou <= 0.0d0) then
!$omp parallel do
     do iz = 0,p%Lz-1
        c%acouK(:,:,:,iz) = (0.0d0, -1.0d0) * c%acouK(:,:,:,iz)
     end do
!$omp end parallel do

     call fftw_execute_dft_c2r(c%plan_c2r_3_out, c%acouK, c%acouR)

!$omp parallel do
     do iz = 0,p%Lz-1
        c%acouR(:,:,:,iz) = c%acouR(:,:,:,iz) * p%Ninv
     end do
!$omp end parallel do
  end if

  open(unit=UNIT_SYSTEM, file=coord_directory_fn, status='replace')
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           write(UNIT_SYSTEM,'(i4,2i5,3f10.6,9e14.6,3f13.6)') ix, iy, iz, &
                & (c%dipoR(alpha,ix,iy,iz)         ,alpha=1,3),&
                & (c%dipoP(alpha,ix,iy,iz)/c%s_Nose,alpha=1,3),&
                & (c%dVddi(alpha,ix,iy,iz)         ,alpha=1,3),&
                & (c%acouR(alpha,ix,iy,iz)         ,alpha=1,3),&
                & (c%acouP(alpha,ix,iy,iz)         ,alpha=1,3)
        end do
     end do
  end do
  close(UNIT_SYSTEM)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(coord_directory_fn))
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine write_system
