! f90_wisdom.F -*-f90-*-
! Time-stamp: <2012-07-05 15:25:09 t-nissie>
! Author: Takeshi NISHIMATSU
! Original: fftw-3.3.2/doc/f77_wisdom.f
!!
! Original Copyright notice: 
!
! Copyright (c) 2003, 2007-11 Matteo Frigo
! Copyright (c) 2003, 2007-11 Massachusetts Institute of Technology
! 
! This program is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 2 of the License, or
! (at your option) any later version.
! 
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
! 
! You should have received a copy of the GNU General Public License
! along with this program; if not, write to the Free Software
! Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
!
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! 
! This is an example implementation of Fortran wisdom export/import
! to/from a Fortran unit (file), exploiting the generic
! dfftw_export_wisdom/dfftw_import_wisdom functions.
! 
! We cannot compile this file into the FFTW library itself, lest all
! FFTW-calling programs be required to link to the Fortran I/O
! libraries.
! 
!ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
#if defined HAVE_CONFIG_H
#  include "config.h"
#endif

subroutine f90_wisdom_dummy()
  write(6,*) 'This is a dummy subroutine.'
end subroutine f90_wisdom_dummy

#if defined(HAVE_LIBFFTW3)
! Strictly speaking, the '$' format specifier, which allows us to
! write a character without a trailing newline, is not standard F77.
! However, it seems to be a nearly universal extension
subroutine write_char(c, iunit)
  implicit none
  character c
  integer iunit
  write(iunit,'(a,$)') c
end subroutine write_char

subroutine export_wisdom_to_file(iunit)
  implicit none
  integer iunit
  external write_char
  call dfftw_export_wisdom(write_char, iunit)
end subroutine export_wisdom_to_file

! Fortran 77 does not have any portable way to read an arbitrary
! file one character at a time.  The best alternative seems to be to
! read a whole line into a buffer, since for fftw-exported wisdom we
! can bound the line length.  (If the file contains longer lines,
! then the lines will be truncated and the wisdom import should
! simply fail.)  Ugh.
subroutine read_char(ic, iunit)
  implicit none
  integer ic
  integer iunit
  character*256 buf
  save buf
  integer ibuf
  data ibuf/257/
  save ibuf
  if (ibuf .lt. 257) then
     ic = ichar(buf(ibuf:ibuf))
     ibuf = ibuf + 1
     return
  endif
  read(unit=iunit,fmt='(a256)',end=666) buf
  ic = ichar(buf(1:1))
  ibuf = 2
  return
666 ic = -1
  ibuf = 257
end subroutine read_char
      
subroutine import_wisdom_from_file(isuccess, iunit)
  implicit none
  integer isuccess
  integer iunit
  external read_char
  call dfftw_import_wisdom(isuccess, read_char, iunit)
end
#endif
