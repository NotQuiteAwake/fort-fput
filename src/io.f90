module io
    use strings
    use modes
    use configs
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

    subroutine read_params(conf, str)
        type(config), intent(inout) :: conf
        type(string), intent(inout) :: str
        real(dp) :: period

        read(*, *) conf%N, conf%dx, conf%rho
        read(*, *) conf%per_cycle, conf%int_order
        read(*, *) conf%init_mode, conf%A
        read(*, *) conf%k, conf%alpha
        read(*, *) conf%recur_thresh

        str = create_string(conf%N, conf%dx, conf%rho, conf%k, conf%alpha)
        str = gen_nth_normal(str, conf%init_mode, conf%A)

        ! for more comparable results when init_mode changes.
        ! since we use the fundamental the per_cycle must be large to preserve
        ! detail in the higher frequencies.
        conf%T = get_nth_period(str, 1)
        conf%dt = conf%T / conf%per_cycle
    end subroutine

    subroutine write_params(conf)
        type(config), intent(in) :: conf
        call log_param("N", conf%N)
        call log_param("dx", conf%dx)
        call log_param("rho", conf%rho)

        call log_param("per_cycle", conf%per_cycle)
        call log_param("int_order", conf%int_order)

        call log_param("init_mode", conf%init_mode)
        call log_param("A", conf%A)
        
        call log_param("k", conf%k)
        call log_param("alpha", conf%alpha)

        call log_param("recur_thresh", conf%recur_thresh)

        ! auxiliary info not part of the original config
        call log_param("dt", conf%dt)
        call log_param("T", conf%T)
    end subroutine

    subroutine log(str)
        type(string), intent(in) :: str

        call write_sep()
        call log_dp_array(str%y)
        call log_dp_array(decompose(str, NUM_MODES))
    end subroutine

end module

