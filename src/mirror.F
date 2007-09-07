! mirror.F -*-f90-*-
! Time-stamp: <2007-07-12 17:33:32 t-nissie>
! Author: Takeshi NISHIMATSU
!!
subroutine mirror(p, dipo)
  use Param_module
  implicit none
  !--- arguments -------------------------------------
  type(Param_type),   intent(in)    :: p
  real*8 :: dipo(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3)
  !eal*8 :: acou(0:p%Lx-1, 0:p%Ly-1, 0:p%Lz-1, 3)
  integer iz, i
  ! In the case of FILM of film_thickness = 7, gap = 1
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  f  f  f  f  f  f  f  g  f  f  f  f  f  f  f
  ! In the case of FILM of film_thickness = 5, gap = 3
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  f  f  f  f  f  g  g  g  f  f  f  f  f  g
  ! In the case of FILM of film_thickness = 3, gap = 5
  !  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
  !  g  g  g  f  f  f  g  g  g  g  g  f  f  f  g  g
  !!!call msg(6, __FILE__, __LINE__, 'BEGIN', '')
  if (p%gap.eq.0) then
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
        do iz = (p%gap+1)/2, p%gap/2+p%film_thickness
           dipo(:,:,p%Lz-iz,i) = -dipo(:,:,iz,i)
           !acou(:,:,p%Lz-iz,i) =  acou(:,:,iz,i)
        end do
        !$omp end parallel do
     end do
     !$omp parallel do
     do    iz = (p%gap+1)/2, p%gap/2+p%film_thickness
        dipo(:,:,p%Lz-iz,3) =  dipo(:,:,iz,3)
        !acou(:,:,p%Lz-iz,3) = -acou(:,:,iz,3)
     end do
     !$omp end parallel do

     do iz = 0, p%gap/2
        do i = 1, 3
           dipo(:,:,iz                       ,i)=0.0d0
           dipo(:,:,iz+p%film_thickness+p%gap,i)=0.0d0
        end do
        !do i = 1, 2
        !   acou(:,:,iz                       ,i)=acou(:,:,(p%gap+1)/2,i)
        !   acou(:,:,iz+p%film_thickness+p%gap,i)=acou(:,:, p%film_thickness+p%gap/2,i)
        !end do
        !do i = 3, 3
        !   acou(:,:,iz                       ,i)=0.0d0
        !   acou(:,:,iz+p%film_thickness+p%gap,i)=0.0d0
        !end do
     end do

     do iz = p%film_thickness+(p%gap+1)/2, p%film_thickness+p%gap-1
        do i = 1, 3
           dipo(:,:,iz                       ,i)=0.0d0
           dipo(:,:,iz+p%film_thickness+p%gap,i)=0.0d0
        end do
        !do i = 1, 2
        !   acou(:,:,iz                       ,i)=acou(:,:, p%film_thickness+p%gap/2,i)
        !   acou(:,:,iz+p%film_thickness+p%gap,i)=acou(:,:,(p%gap+1)/2,i)
        !end do
        !do i = 3, 3
        !   acou(:,:,iz                       ,i)=0.0d0
        !   acou(:,:,iz+p%film_thickness+p%gap,i)=0.0d0
        !end do
     end do
  end if
  !!!call msg(6, __FILE__, __LINE__, 'END', '')
end subroutine mirror
