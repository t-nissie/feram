program fft_check_mpi
  ! See:
  !  http://www.fftw.org/doc/Transposed-distributions.html
  !  http://www.fftw.org/doc/Combining-MPI-and-Threads.html
  use, intrinsic :: iso_c_binding
  implicit none
  include 'mpif.h'
  include 'fftw3-mpi.f03'
  integer(C_INTPTR_T)                :: Lx
  integer(C_INTPTR_T)                :: Ly
  integer(C_INTPTR_T)                :: Lz
  real*8                             :: N_inv
  type(C_PTR)                        :: plan_r2c, plan_c2r, rdata, cdata
  real(C_DOUBLE),            pointer :: r(:,:,:)
  complex(C_DOUBLE_COMPLEX), pointer :: c(:,:,:)
  integer(C_INTPTR_T)                :: i, alloc_local, local_Lz, local_z_offset
  integer(C_INTPTR_T)                ::                 local_Ly, local_y_offset
  integer                            :: n, N_TIMES, i_error, my_mpi_rank, n_mpi_procs
  character(len=100)                 :: str

# if defined(_OPENMP)
  integer                            :: provided, OMP_GET_MAX_THREADS
  call MPI_INIT_THREAD(MPI_THREAD_FUNNELED, provided, i_error)
  call dfftw_init_threads(i_error)
  call dfftw_plan_with_nthreads(OMP_GET_MAX_THREADS())
  write(6,'(a,i7,a,i3)') '_OPENMP =', _OPENMP, ',    OMP_GET_MAX_THREADS =', OMP_GET_MAX_THREADS()
# else
  call MPI_INIT(i_error)
# endif
  call MPI_COMM_RANK(MPI_COMM_WORLD, my_mpi_rank, i_error)
  call MPI_COMM_SIZE(MPI_COMM_WORLD, n_mpi_procs, i_error)

  n = command_argument_count()
  if (n.eq.0) then
     ! default values
     N_TIMES = 1000
     Lx =  60
     Ly =  80
     Lz = 100
  else if (n.eq.4) then
     call get_command_argument(1,str); read(str,*) N_TIMES
     call get_command_argument(2,str); read(str,*) Lx
     call get_command_argument(3,str); read(str,*) Ly
     call get_command_argument(4,str); read(str,*) Lz
  else
     write(0,'(a,a,i3,a)') __FILE__, ':', __LINE__, ': Illegal number of arguments.'
     stop 1
  end if
  N_inv = 1.0d0/Lx/Ly/Lz

  !   get local data size and allocate (note dimension reversal)
  alloc_local = fftw_mpi_local_size_3d_transposed(Lz, Ly, Lx/2+1, MPI_COMM_WORLD, &
       & local_Lz, local_z_offset, &
       & local_Ly, local_y_offset)
  rdata = fftw_alloc_real(2 * alloc_local); call c_f_pointer(rdata, r, [2*(Lx/2+1),Ly,local_Lz])
  cdata = fftw_alloc_complex( alloc_local); call c_f_pointer(cdata, c, [   Lx/2+1, Lz,local_Ly])

  !   create MPI plan for in-place forward DFT (note dimension reversal)
  plan_r2c = fftw_mpi_plan_dft_r2c_3d(Lz, Ly, Lx, r, c, MPI_COMM_WORLD, ior(FFTW_MEASURE,FFTW_MPI_TRANSPOSED_OUT))
  plan_c2r = fftw_mpi_plan_dft_c2r_3d(Lz, Ly, Lx, c, r, MPI_COMM_WORLD, ior(FFTW_MEASURE,FFTW_MPI_TRANSPOSED_IN))

  !   initialization and first-touch of array r(:,:,:) with a wave
!$omp parallel do
  do i = 1, local_Lz
     if (mod(i+local_z_offset,2).eq.1) then
        r(:, :, i) = 0.1d0
     else
        r(:, :, i) = 0.0d0
     end if
  end do
!$omp end parallel do

  !   first-touch of array c(:,:,:)
!$omp parallel do
  do i = 1, local_Ly
     c(:, :, i) = (0.0d0, 0.0d0)
  end do
!$omp end parallel do

  !   compute transform
  do n = 1, n_times
     call fftw_mpi_execute_dft_r2c(plan_r2c, r, c)
     ! write(6,'(a,i2,a,i2,2(a,i5),a,2e23.15)') 'my_mpi_rank/size =', my_mpi_rank, '/', n_mpi_procs, &
     !      &                               ',  local_Ly =', local_Ly, &
     !      &                               ',  local_y_offset =', local_y_offset, &
     !      &                               ',   c(1,Lz/2+1,1) =', c(1,Lz/2+1,1)
!$omp parallel do
     do i = 1, local_Ly
        c(:, :, i) = c(:, :, i) * N_inv
     end do
!$omp end parallel do
     call fftw_mpi_execute_dft_c2r(plan_c2r, c, r)
  end do
  write(6,'(a,i2,a,i2,a,f10.2)')          'my_mpi_rank/size =', my_mpi_rank, '/', n_mpi_procs, &
       &',                                             r(1,1,1)      =', r(1,1,1)


  !   let them free
  call fftw_destroy_plan(plan_r2c)
  call fftw_destroy_plan(plan_c2r)
  call fftw_free(rdata)
  call fftw_free(cdata)

  call MPI_FINALIZE(i_error)
end program fft_check_mpi
!Local variables:
!  compile-command: "mpif90 -Wall -O3 -I/home/t-nissie/Linux-x86_64/include -ffree-form -fopenmp -o fft_check_mpi fft_check_mpi.F -lfftw3 -lfftw3_mpi -L/home/t-nissie/Linux-x86_64/lib -lfftw3_omp"
!End:
