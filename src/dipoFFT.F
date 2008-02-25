! dipoFFT.F -*-f90-*-
! Time-stamp: <2008-02-25 14:10:07 takeshi>
! Author: Takeshi NISHIMATSU
!!
subroutine dipoFFT(p,c)
  use Param_module
  use Coord_module
  implicit none
  type(Param_type),  intent(in)    :: p
  type(Coord_type),  intent(inout) :: c
!  integer ix,iy,yy
!  logical, save :: is_first_call = .true.
!  character (len=100) :: fn

  call msg(6, __FILE__, __LINE__, 'BEGIN', ': dipoR -> dipoK, didiR, didiK')

  call fft_r2c(p, c%dipoR, c%dipoK, 3)

!   if (is_first_call) then
!      is_first_call = .false.
!      write(fn,'(a,a)') trim(p%filename), '.fft'
!      open(UNIT=12,FILE=fn)
!      do iy= -p%Ly/2, p%Ly/2
!         if (iy<0) then
!            yy=p%Ly+iy
!         else
!            yy=iy
!         end if
!         do ix=0, p%Lx/2
!            write(12,*) abs(c%dipoK(ix,yy,0,3)), c%dipoK(ix,yy,0,3)
!         end do
!         write(12,*) ''
!      end do
!   end if

  c%didiR(:,:,:,1) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,2) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,2)
  c%didiR(:,:,:,3) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,4) = c%dipoR(:,:,:,2) * c%dipoR(:,:,:,3)
  c%didiR(:,:,:,5) = c%dipoR(:,:,:,3) * c%dipoR(:,:,:,1)
  c%didiR(:,:,:,6) = c%dipoR(:,:,:,1) * c%dipoR(:,:,:,2)

  call fft_r2c(p, c%didiR, c%didiK, 6)

  call msg(6, __FILE__, __LINE__, 'END', &
       & ': didiR will be used in optimize-*-strain.F and dVddi-unharmonic.F.')
end subroutine dipoFFT
