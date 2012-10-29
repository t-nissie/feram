! distribution3d2ppm.F -*-f90-*-
! Time-stamp: <2012-10-19 20:36:33 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined(__PGI) || defined(__sparc)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program distribution3d2ppm
  implicit none
  integer i, argn, command_argument_count
  character(len=300) :: fn
  argn = command_argument_count()
  do i=1,argn
     call get_command_argument(i,fn)
     call distribution3d2ppm_main(fn)
  end do
end program distribution3d2ppm

subroutine distribution3d2ppm_main(fn)
  use rgb_module
  use average_module, only : max_k
  implicit none
  character(len=*)     :: fn
  character(len=300)   :: fn_ppm
  real*8, allocatable  :: distribution3d(:,:,:)
  real*8               :: x
  integer              :: kx,ky,kz,i
  type(rgb_type)       :: a
  allocate(distribution3d(-max_k:max_k,-max_k:max_k,-max_k:max_k))

  !write(6,*)
  !write(6,'(a)') '==> ' // trim(fn) // ' <=='

  open(7,FILE=fn, status='old', action='read')
  do i=1,(max_k*2+1)**3
     read(7, *) kx,ky,kz,x
     distribution3d(kx,ky,kz) = x
  end do
  close(7)

  fn_ppm = trim(fn) // '.y0.ppm'
  open(unit=8,file=fn_ppm, status='REPLACE')
  write(8,'(a)') 'P6'
  write(8,'(a,a)') '# ', trim(fn_ppm)
  write(8,'(i3,i4)') max_k*2+1, max_k*2+1
  write(8,'(a)') '255'
  do kz = max_k, -max_k, -1
     do kx = -max_k, max_k
        x = sqrt(dble(distribution3d(kx,0,kz))) / 108 - 1.0d0/1275
        call double2rgb(x, a)
        if (kz.eq.0 .or. kx.eq.0) then
           write(8,'(a,a,a,$)') char(255), char(255), char(255)
        else
           write(8,'(a,a,a,$)') char(a%r), char(a%g), char(a%b)
        end if
     end do
  end do
  close(8)

  fn_ppm = trim(fn) // '.110.ppm'
  open(unit=8,file=fn_ppm, status='REPLACE')
  write(8,'(a)') 'P6'
  write(8,'(a,a)') '# ', trim(fn_ppm)
  write(8,'(i3,i4)') max_k*2+1, max_k*2+1
  write(8,'(a)') '255'
  do kz = max_k, -max_k, -1
     do kx = -max_k, max_k
        x = sqrt(dble(distribution3d(kx,kx,kz))) / 108 - 1.0d0/1275
        call double2rgb(x, a)
        if (kz.eq.0 .or. kx.eq.0) then
           write(8,'(a,a,a,$)') char(255), char(255), char(255)
        else
           write(8,'(a,a,a,$)') char(a%r), char(a%g), char(a%b)
        end if
     end do
  end do
  close(8)

  deallocate(distribution3d)
end subroutine distribution3d2ppm_main
