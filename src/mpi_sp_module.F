! mpi_sp_module.F -*-f90-*-
! MPI Serial/Parallel module
! Time-stamp: <2007-05-07 12:03:16 t-nissie>
! Author: Takeshi NISHIMATSU
!!
module mpi_sp_module
  implicit none
#ifdef MPI_SP_MODULE
  include 'mpif.h'
  integer mpi_sp_my_rank
  integer mpi_sp_n_processor
  integer i_error
  character (len=MPI_MAX_PROCESSOR_NAME) :: mpi_sp_my_hostname
#else
  integer, parameter :: mpi_sp_my_rank = 0
  integer, parameter :: mpi_sp_n_processor = 1
#endif
end module mpi_sp_module
