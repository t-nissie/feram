! coord2deviation.F -*-f90-*-
! Time-stamp: <2012-10-15 20:35:27 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program coord2deviation
  implicit none
  integer i, argn, command_argument_count
  character(len=300) :: fn
  argn = command_argument_count()
  do i=1,argn
     call get_command_argument(i,fn)
     call coord2deviation_main(fn)
  end do
end program coord2deviation

subroutine coord2deviation_main(fn)
  use rgb_module
  implicit none
  character(len=*)     :: fn
  character(len=300)   :: fn_distribution3d
  integer              :: N, ix,iy,iz, ios, k(3), kx,ky,kz
  real*8               :: u(3), sum_u(3), sum_uu(3), avg_u(3), deviation(3)

  real*8,  parameter   :: step     = 0.01d0
  real*8,  parameter   :: step_inv = 1.0d0/step
  integer, parameter   :: max_k    = 50
  integer, allocatable :: distribution3d(:,:,:)
  type(rgb_type)       :: a
  allocate(distribution3d(-max_k:max_k,-max_k:max_k,-max_k:max_k))

  write(6,*)
  write(6,'(a)') '==> ' // trim(fn) // ' <=='

  open(7,FILE=fn, status='old', action='read')
  N = 0
  sum_u( 1:3) = 0.0d0
  sum_uu(1:3) = 0.0d0
  distribution3d(:,:,:) = 0
  do
     read(7, *, IOSTAT=ios) ix,iy,iz,u(1:3)
     if (ios.ne.0) exit
     N = N+1
     sum_u( 1:3) = sum_u( 1:3) + u(1:3)
     sum_uu(1:3) = sum_uu(1:3) + u(1:3)*u(1:3)
     k(:) = nint(u(:)*step_inv)
     if (maxval(abs(k(:)))>max_k) then
        write(0,'(a,a,i2,a,3i5)') __FILE__, ':', __LINE__, ': Out of range.', k(:)
        cycle
     end if
     distribution3d(k(1),k(2),k(3)) = distribution3d(k(1),k(2),k(3)) + 1
  end do
  close(7)

  avg_u(1:3) = sum_u(1:3)/N
  deviation(1:3) = sqrt(sum_uu(1:3)/N - avg_u(1:3)*avg_u(1:3))

  write(6,'(i10)') N
  write(6,'(3f10.6)') avg_u(1:3)
  write(6,'(3f10.6)') deviation(1:3)

  fn_distribution3d = trim(fn) // '.distribution3d'
  open(unit=8,file=fn_distribution3d, status='REPLACE')
  do kz = -max_k, max_k
     do ky = -max_k, max_k
        do kx = -max_k, max_k
           write(8,'(f6.3,f7.3,f7.3,e14.7)') step*kx, step*ky, step*kz, dble(distribution3d(kx,ky,kz)) * step_inv**3 / N
        end do
     end do
  end do
  close(8)

  fn_distribution3d = trim(fn) // '.y0.ppm'
  open(unit=8,file=fn_distribution3d, status='REPLACE')
  write(8,'(a)') 'P6'
  write(8,'(a,a)') '# ', trim(fn_distribution3d)
  write(8,'(i3,i4)') max_k*2+1, max_k*2+1
  write(8,'(a)') '255'
  do kz = max_k, -max_k, -1
     do kx = -max_k, max_k
        call double2rgb(dble(distribution3d(kx,0,kz)) * step_inv**3 / (N*350) - 1.0d0/1275, a)
        if (kz.eq.0 .or. kx.eq.0) then
           write(8,'(a,a,a,$)') char(255), char(255), char(255)
        else
           write(8,'(a,a,a,$)') char(a%r), char(a%g), char(a%b)
        end if
     end do
  end do
  close(8)

  deallocate(distribution3d)
 end subroutine coord2deviation_main
