! filename_check.F -*-f90-*-
! Time-stamp: <2018-03-21 08:22:33 takeshi>
! Author: Takeshi NISHIMATSU
!!
program filename_check
  use filename_module
  implicit none
  character(len=FILE_NAME_LEN), parameter :: foo = '../../foo.txt'
  if (.not.suffix_is(foo,'.txt')                       ) stop 1
  if (     suffix_is(foo,'.exe')                       ) stop 2
  if (delete_suffix(foo,'.txt')    .ne. '../../foo'    ) stop 3
  if (delete_suffix(foo,'.exe')    .ne. '../../foo.txt') stop 4
  if (delete_suffix(foo,'')        .ne. '../../foo.txt') stop 5
  if (basename(foo)                .ne.       'foo.txt') stop 6
  if (basename(basename(foo))      .ne.       'foo.txt') stop 7
  if (basename(foo, suffix='.txt') .ne.       'foo'    ) stop 8
  if (basename(foo, suffix='.exe') .ne.       'foo.txt') stop 9
  if (basename(foo, '')            .ne.       'foo.txt') stop 10
end program filename_check
!Local variables:
!  compile-command: "make filename_check && ./filename_check"
!End:
