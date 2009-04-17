! displacement.F -*-f90-*-
! Time-stamp: <2009-04-17 11:05:22 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: ./displacement < perovskite.out
!!
program displacement
  implicit none
  integer           :: io
  integer           :: i
  character(len=50) :: xred_dataset
  character(len=200):: str
  real*8            :: xred(3,5)

  do
     read(5, '(a)', IOSTAT=io) str
     if (index(str,'after computation').ne.0) exit
  end do

  do
     read(5, '(a)', IOSTAT=io) str
     if (io.ne.0) exit
     if (index(str,'xred').ne.0) then
        read(str,*) xred_dataset,xred(1:3,1)
        do i=2,5
           read(5,*) xred(1:3,i)
        end do
        call xred2displacement(xred_dataset,xred)
     end if
  end do
end program displacement

subroutine xred2displacement(xred_dataset,xred)
  implicit none
  character(len=*), intent(in) :: xred_dataset
  real*8, intent(in) ::            xred(3,5)
  real*8             ::            disp(3,5)
  real*8             :: normalized_disp(3,5)
  real*8, parameter  :: centrosymmetric(3,5) = reshape((/0.0d0,0.0d0,0.0d0, &
                                                         0.5d0,0.5d0,0.5d0, &
                                                         0.0d0,0.5d0,0.5d0, &
                                                         0.5d0,0.0d0,0.5d0, &
                                                         0.5d0,0.5d0,0.0d0/),(/3,5/))
  integer :: i
  real*8  :: norm, translation

  disp = xred - centrosymmetric
  do i=1,3
     translation = sum(disp(i,:))/5
     disp(i,:) = disp(i,:) - translation
     norm = sum(disp(i,:)*disp(i,:))
     if (norm>1.0d-30) then
        norm = sqrt(norm)
     else
        norm = 1.0d0
     end if
     normalized_disp(i,:) = disp(i,:)/norm
  end do
  write(6,'(a7,5f7.3,2(f10.3,4f7.3))') xred_dataset, normalized_disp(1,:), normalized_disp(2,:), normalized_disp(3,:)
end subroutine xred2displacement



!local variables:
!  compile-command: "make -k displacement && ./displacement < ~/Desktop/perovskite-optcell2-110.out"
!End:
