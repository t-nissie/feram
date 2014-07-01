! wave_module.f -*-f90-*-
! Time-stamp: <2014-07-01 20:38:24 takeshi>
! Author: Takeshi NISHIMATSU
! Usage: a = wave(wave_type, i_step, n_thermalize, period, amplitude)
!!
module wave_module
contains
  function wave(wave_type, i_step, n_thermalize, period, amplitude)
    implicit none
    real*8                       :: wave(3)
    character(len=*), intent(in) :: wave_type
    integer,          intent(in) :: i_step
    integer,          intent(in) :: n_thermalize
    integer,          intent(in) :: period
    real*8,           intent(in) :: amplitude(3)
    real*8                       :: tmp
    integer                      :: i

    if (   amplitude(1).eq.0.0d0 .and.&
         & amplitude(2).eq.0.0d0 .and.&
         & amplitude(3).eq.0.0d0   ) then
       wave = amplitude
       return
    end if

    select case (wave_type)
    case ('triangular_cos', 'triangular_sin')
       if (mod(period,4).ne.0) then
          write(0,'(a,a,i2,a)') __FILE__, ':', __LINE__, ': period must be divided by 4.'
          stop 1
       end if
       i = i_step - n_thermalize
       if (i<0) i=0
       if (wave_type.eq.'triangular_cos') then
          tmp = abs(mod((i)           ,period)-period/2) - period/4
       else
          tmp = abs(mod((i+3*period/4),period)-period/2) - period/4
       end if
       wave = amplitude * tmp / (period/4.0)
       return
    case ('ramping_on')
       if (i_step<n_thermalize) then
          wave = amplitude * i_step / n_thermalize
          write(6,*) wave
       else
          wave = amplitude
       end if
       return
    case ('ramping_off')
       if (i_step<n_thermalize) then
          wave = amplitude * (n_thermalize-i_step) / n_thermalize
       else
          wave = 0.0d0
       end if
       return
    case default
       wave = amplitude
       return
    end select
  end function wave
end module wave_module
