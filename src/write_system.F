! write_system.F -*-f90-*-
! Time-stamp: <2015-03-27 14:06:51 t-nissie>
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
  implicit none
  type(Param_type), intent(in) :: p
  type(Coord_type), intent(inout) :: c
  character(len=*) :: fn
  character(len=FILE_NAME_LEN) :: coord_directory_fn
  integer ix,iy,iz,i
#if defined(HAVE_LIBFFTW3)
  include 'fftw3.f03'
#endif

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
     do i = 0,p%Lz-1
        c%acouK(:,:,:,i) = (0.0d0, -1.0d0) * c%acouK(:,:,:,i)
     end do
!$omp end parallel do

#  if defined(HAVE_LIBFFTW3)
     call fftw_execute_dft_c2r(c%plan_acouC2R, c%acouK, c%acouR)
#  else
#    error "Not implemented yet."
       ! do alpha = 1, 3
       !    call fft_3d_r2c_or_c2r_out_of_place(.false., p%Lx, p%Ly, p%Lz, &
       !         & c%acouR(0,0,0,alpha), c%acouK(0,0,0,alpha))
       ! end do
#  endif

!$omp parallel do
     do i = 0,p%Lz-1
        c%acouR(:,:,:,i) = c%acouR(:,:,:,i) * p%Ninv
     end do
!$omp end parallel do
  end if

  open(unit=UNIT_SYSTEM, file=coord_directory_fn, status='replace')
  do iz = 0, p%Lz-1
     do iy = 0, p%Ly-1
        do ix = 0, p%Lx-1
           write(UNIT_SYSTEM,'(i4,2i5,3f10.6,6e13.5,6f11.6)') ix, iy, iz, &
                & (c%dipoR(i,ix,iy,iz)         ,i=1,3),&
                & (c%dipoP(i,ix,iy,iz)/c%s_Nose,i=1,3),&
                & (c%dVddi(i,ix,iy,iz)         ,i=1,3),&
                & (c%acouR(i,ix,iy,iz)         ,i=1,3),&
                & (c%acouP(i,ix,iy,iz)         ,i=1,3)
        end do
     end do
  end do
  close(UNIT_SYSTEM)
  call msg(UNIT_LOG, __FILE__, __LINE__, 'FILE', trim(coord_directory_fn))
  call msg(UNIT_LOG, __FILE__, __LINE__, 'END', '')
end subroutine write_system
