! feram_mpi_common_check.F -*-f90-*-
! Time-stamp: <2015-11-10 12:06:24 takeshi>
! Author: Takeshi NISHIMATSU
!!
#include "define.h"
subroutine feram_mpi_common_check(fn)
  implicit none
  include 'mpif.h'
  integer i_error, my_mpi_rank
  logical, save :: flag_called = .false.
  character(len=FILE_NAME_LEN), intent(in) :: fn
  call MPI_COMM_RANK(MPI_COMM_WORLD, my_mpi_rank, i_error)
  write(6,'(i5,3a,L)') my_mpi_rank, ' ', trim(fn), ' ', flag_called
  flag_called = .true.
end subroutine feram_mpi_common_check
