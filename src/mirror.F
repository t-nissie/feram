! mirror.F -*-f90-*-
! Time-stamp: <2010-05-20 17:54:15 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine mirror(p, dipo)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),   intent(in)    :: p
  real*8 :: dipo(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3)
  integer iz, i
  ! In the case of FILM of film_thickness = 7, gap_thickness = 1
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  f  f  f  f  f  f  f  g  f  f  f  f  f  f  f
  ! In the case of FILM of film_thickness = 5, gap_thickness = 3
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  f  f  f  f  f  g  g  g  f  f  f  f  f  g
  ! In the case of FILM of film_thickness = 3, gap_thickness = 5
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  g  f  f  f  g  g  g  g  g  f  f  f  g  g
  !!!call msg(6, __FILE__, __LINE__, 'BEGIN', '')
  if (p%gap_thickness.eq.0) then
     !$omp parallel do
     do iz = 0, p%film_thickness-1
        dipo(:,:,p%Lz-1-iz,1) = -dipo(:,:,iz,1)
        dipo(:,:,p%Lz-1-iz,2) = -dipo(:,:,iz,2)
        dipo(:,:,p%Lz-1-iz,3) =  dipo(:,:,iz,3)
     end do
     !$omp end parallel do
  else
     do i = 1, 2
        !$omp parallel do
        do iz = (p%gap_thickness+1)/2, p%gap_thickness/2+p%film_thickness
           dipo(:,:,p%Lz-iz,i) = -dipo(:,:,iz,i)
        end do
        !$omp end parallel do
     end do
     !$omp parallel do
     do    iz = (p%gap_thickness+1)/2, p%gap_thickness/2+p%film_thickness
        dipo(:,:,p%Lz-iz,3) =  dipo(:,:,iz,3)
     end do
     !$omp end parallel do

     do iz = 0, p%gap_thickness/2
        do i = 1, 3
           dipo(:,:,iz                                 ,i)=p%gap_dipole_u(i)
           dipo(:,:,iz+p%film_thickness+p%gap_thickness,i)=p%gap_dipole_u(i)
        end do
     end do

     do iz = p%film_thickness+(p%gap_thickness+1)/2, p%film_thickness+p%gap_thickness-1
        do i = 1, 3
           dipo(:,:,iz                                 ,i)=p%gap_dipole_u(i)
           dipo(:,:,iz+p%film_thickness+p%gap_thickness,i)=p%gap_dipole_u(i)
        end do
     end do
  end if
  !!!call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine mirror
