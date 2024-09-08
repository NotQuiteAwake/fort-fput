module io
    use grids
    use kind_parameter, only: i4, dp

    implicit none

    interface log_param
        module procedure log_param_dp, log_param_int
    end interface

contains

    subroutine log_param_dp(name, param)
        character(*), intent(in) :: name
        real(dp), intent(in) :: param

        write(*, '(A2, A15, F10.4)') '% ', name, param
    end subroutine

    subroutine log_param_int(name, param)
        character(*), intent(in) :: name
        integer(i4), intent(in) :: param

        write(*, '(A2, A15, I10)') '% ', name, param
    end subroutine

    subroutine log_dp_array(array)
        real(dp), dimension(:), intent(in) :: array
        write(*, '(*(F9.6,2X))') array
    end subroutine

    subroutine write_sep(sep, num)
        character, intent(in), optional :: sep
        integer(dp), intent(in), optional :: num

        character :: sep_used
        integer(dp) :: num_used

        if (.not. present(sep)) then
            sep_used = '-'
        else
            sep_used = sep
        end if

        if (.not. present(num)) then
            num_used = 5
        else
            num_used = num
        end if

        write(*, *) repeat(sep_used, num_used)
    end subroutine



end module

