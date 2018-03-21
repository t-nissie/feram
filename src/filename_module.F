! filename_module.F -*-f90-*-
! Time-stamp: <2018-03-21 08:15:32 takeshi>
! Author: Takeshi NISHIMATSU
!!
module filename_module
integer, parameter :: FILE_NAME_LEN = 300
contains
  logical function suffix_is(path, suffix)
    implicit none
    character(len=*), intent(in) :: path
    character(len=*), intent(in) :: suffix
    suffix_is = index(path,suffix,back=.true.) .eq. len_trim(path)-len_trim(suffix)+1
  end function suffix_is

  function delete_suffix(path, suffix)
    implicit none
    character(len=FILE_NAME_LEN) :: delete_suffix
    character(len=*), intent(in) :: path
    character(len=*), intent(in) :: suffix
    if (suffix_is(path,suffix)) then
       delete_suffix = path(1:len_trim(path)-len_trim(suffix))
    else
       delete_suffix = path
    end if
  end function delete_suffix

  function basename(path, suffix)
    implicit none
    character(len=FILE_NAME_LEN) :: basename
    character(len=*),           intent(in) :: path
    character(len=*), optional, intent(in) :: suffix
    integer :: pos
    character(len=FILE_NAME_LEN) :: tmp
    pos = index(path,'/',back=.true.)
    if (pos.gt.0) then
       tmp = path(pos+1:len_trim(path))
    else
       tmp = path
    end if
    if (present(suffix)) then
       basename = delete_suffix(tmp,suffix)
    else
       basename = tmp
    end if
  end function basename
end module filename_module
