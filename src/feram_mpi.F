! feram_mpi.F -*-f90-*-
! Time-stamp: <2011-06-15 16:24:42 takeshi>
! Author: Takeshi NISHIMATSU
!!
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

#if defined(__PGI) || defined(SR11000)
#  define command_argument_count iargc
#  define get_command_argument getarg
#endif

program feram_mpi
  implicit none
  include 'mpif.h'
  integer i, argn, command_argument_count
  integer i_error, my_mpi_rank, n_mpi_threads
  character(len=100) :: fn

  call MPI_INIT(i_error)
  call MPI_COMM_RANK(MPI_COMM_WORLD, my_mpi_rank,   i_error)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, n_mpi_threads, i_error)

  argn = command_argument_count()

  if (n_mpi_threads>argn .and. my_mpi_rank==0) then
     write(6,'(a,a,i2,a)') __FILE__,':', __LINE__, ': n_mpi_threads is larger than argn.'
     call MPI_ABORT(MPI_COMM_WORLD, 1)
  end if

  do i = my_mpi_rank+1, argn, n_mpi_threads
     call get_command_argument(i,fn)
     open(unit=8,file=fn,status='replace')
     write(8,*) my_mpi_rank, trim(fn)
     close(unit=8)
  end do

call MPI_FINALIZE(i_error)
end program feram_mpi
!Local variables:
!  compile-command: "mpif90 -ffree-form -Wall -g -o feram_mpi feram_mpi.F && mpirun -n 5 ./feram_mpi fn01 fn02 fn03 fn04 fn05 fn06 fn07 fn08 fn09 fn10 fn11 fn12 fn13 && head fn*"
!End:
