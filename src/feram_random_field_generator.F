! random_field_generator.f -*-f90-*-
! Time-stamp: <2013-10-10 18:06:26 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: ./random_field_generator Lx Ly Lz  mu_x mu_y mu_z  sigma_x sigma_y sigma_z  seed1 seed2
!        ./random_field_generator 32 32 243  0.0 0.0 0.0  0.0005 0.0005 0.0005  123456789 987654321
!!
#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif
program random_field_generator
  use marsaglia_tsang_uni64_module
  implicit none
  integer :: Lx,Ly,Lz
  integer :: ix,iy,iz
  real*8  :: mu_x, mu_y, mu_z
  real*8  :: sigma_x, sigma_y, sigma_z
  real*8  :: dmy
  integer :: seed1, seed2
  integer :: argn, command_argument_count
  character(len=100) :: tmp

  argn = command_argument_count()
  if (argn.ne.11) stop 1

  call get_command_argument( 1,tmp); read(tmp,*) Lx
  call get_command_argument( 2,tmp); read(tmp,*) Ly
  call get_command_argument( 3,tmp); read(tmp,*) Lz

  call get_command_argument( 4,tmp); read(tmp,*) mu_x
  call get_command_argument( 5,tmp); read(tmp,*) mu_y
  call get_command_argument( 6,tmp); read(tmp,*) mu_z

  call get_command_argument( 7,tmp); read(tmp,*) sigma_x
  call get_command_argument( 8,tmp); read(tmp,*) sigma_y
  call get_command_argument( 9,tmp); read(tmp,*) sigma_z

  call get_command_argument(10,tmp); read(tmp,*) seed1
  call get_command_argument(11,tmp); read(tmp,*) seed2

  dmy = normal_dist(mu_x, sigma_x, seed1, seed2)
  do iz = 0, Lz-1
     do iy = 0, Ly-1
        do ix = 0, Lx-1
           write(6,'(i3,2i4,3f15.10)') ix,iy,iz, &
                & normal_dist(mu_x, sigma_x), &
                & normal_dist(mu_y, sigma_y), &
                & normal_dist(mu_z, sigma_z)
        end do
     end do
  end do
end program random_field_generator
!local variables:
!  compile-command: "make -k random_field_generator"
!End:
