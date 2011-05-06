! feram.F -*-f90-*-
! Time-stamp: <2011-05-06 15:58:42 t-nissie>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(__PGI) || defined(SR11000)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program feram
  use Param_module
  use Coord_module
  implicit none
  type(Param_type) :: p
  type(Coord_type) :: c
  character(70) message
  integer i, fd, argn, command_argument_count

  write(message,'(a,a)') ': Version ', PACKAGE_VERSION
  call msg(6, __FILE__, __LINE__, 'BEGIN', message)

  !call get_environment_variable('OMP_NUM_THREADS', message)
  !read(message,*,iostat=info) nthreads
  !if (info.ne.0 .or. nthreads.lt.1) nthreads = 1
  !write(message,'(a,i3)') 'nthreads =', nthreads
  !call msg_ez(6, message)

  argn = command_argument_count()

  if (argn.eq.0) then
     argn = 1
     fd = 5
  else
     fd = 7
  end if

  do i=1,argn
     if (fd.eq.5) then
        p%filename = 'stdin'
     else
        call get_command_argument(i,p%filename)
        open(fd, FILE=p%filename, STATUS='OLD')
     end if
     call msg(6, __FILE__, __LINE__, 'FILENAME: ', trim(p%filename))

     call  read_Param(p,fd)
     call  make_Param(p)
     call write_Param(p)
     call alloc_Coord(p,c)
     call  potentials(p,c)
     !Instead, read_defects_u(p,c) is called in initialize_dipoR()! call make_mass_matrix(p,c)

     if (p%method.eq.'md ' .or. p%method.eq.'lf ') then
        call molecular_dynamics(p,c)
     else if (p%method.eq.'hl ') then
        call hysteresis_loop(p,c)
     else
        write(message,'(a,a,a)') &
             ": '", p%method, "' is an illegal or not-yet-implemented method. Stop."
        call msg(6, __FILE__, __LINE__, 'FATAL', message)
        stop
     end if
  end do

  call msg(6, __FILE__, __LINE__, 'END', '')
end program feram
