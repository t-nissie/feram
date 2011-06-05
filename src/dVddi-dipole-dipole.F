! dVddi-dipole-dipole.F -*-f90-*-
! Time-stamp: <2011-06-05 15:30:57 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine dVddi_dipole_dipole(p,c,e)
  use Param_module
  use Coord_module
  use Energy_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type), intent(in)    :: p
  type(Coord_type), intent(inout) :: c
  type(Energy_type), intent(out)  :: e
  !--- local -----------------------------------------
  complex*16, allocatable :: dipoT(:,:,:,:)
  integer alpha, ix, iy, iz
  !--- END of variable definitions -------------------
  !call msg(6, __FILE__, __LINE__, 'BEGIN', ': calc dVddi, calc e%dipo_dipo')
  allocate(dipoT(0:p%Lx/2, 0:p%Ly-1, 0:p%Lz-1, 3)) !"/2" See fft.F!
  !$omp parallel do private(iz,iy,ix,alpha)
  do iz=0, p%Lz-1
     do iy=0, p%Ly-1
        do ix=0, p%Lx/2
           do alpha = 1,3
              dipoT(ix,iy,iz,alpha) = sum(c%dipoI(ix,iy,iz,alpha,:)*c%dipoK(ix,iy,iz,:))
           end do
        end do
     end do
  end do
  !$omp end parallel do
  call fft_c2r(p, dipoT, c%dVddi, 3)
!POPTION COALESCING(2)
  c%dVddi(:,:,:,:) = c%dVddi(:,:,:,:) / p%N
  !if (p%bulk_or_film.eq.'film' .or. p%bulk_or_film.eq.'epit') thenx
  !   call mirror(p, c%dVddi)
  !end if

  !=== e%dipole_dipole = SUM( c%dipoR(:,:,:,:) * c%dVddi(:,:,:,:) ) / 2 ===========
  e%dipole_dipole = 0.0d0
!POPTION PSUM(e%dipole_dipole)
!POPTION COALESCING(2)
  do alpha = 1,3
     do iz=0, p%Lz-1
        do iy=0, p%Ly-1
           do ix=0, p%Lx-1
              e%dipole_dipole = e%dipole_dipole + c%dipoR(ix,iy,iz,alpha) * c%dVddi(ix,iy,iz,alpha)
           end do
        end do
     end do
  end do
  e%dipole_dipole = e%dipole_dipole / 2
  !================================================================================

  deallocate(dipoT)
  !call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine dVddi_dipole_dipole
