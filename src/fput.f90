program fput
    use kind_parameter, only: dp, i4
    use strings
    use integrator, only: symp_integrator
    use modes
    use forces
    use io
    use configs

    implicit none

    type(string) :: str 
    type(config) :: conf
    real(dp) :: last = 0.0_dp, t = 0.0_dp, period

    call read_params(conf, str)
    call write_params()

    period = get_nth_period(str, conf%init_mode)

    ! add patience for string to evolve out of initial eigenmode
    do while (t - last <= period)
        call log()
        call evolve()
        t = t + conf%dt
        if (thresh_met(str, conf%init_mode, conf%recur_thresh)) then
            last = t
        end if
    end do

    do while (.not. thresh_met(str, conf%init_mode, conf%recur_thresh))
        call log()
        call evolve()
    end do

contains

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
        period = get_nth_period(str, 1)
        
        conf%dt = period / conf%per_cycle
    end subroutine

    logical function thresh_met(str, init_mode, recur_thresh)
        type(string) :: str
        integer(i4) :: init_mode
        real(dp) :: recur_thresh

        thresh_met = abs(get_comp(str, init_mode)) > recur_thresh
    end function

    subroutine write_params()
        call log_param("N", conf%N)
        call log_param("dx", conf%dx)
        call log_param("rho", conf%rho)

        call log_param("per_cycle", conf%per_cycle)
        call log_param("dt", conf%dt)
        call log_param("int_order", conf%int_order)

        call log_param("init_mode", conf%init_mode)
        call log_param("A", conf%A)
        
        call log_param("k", conf%k)
        call log_param("alpha", conf%alpha)

        call log_param("recur_thresh", conf%recur_thresh)
    end subroutine

    subroutine log()
        call write_sep()
        call log_dp_array(str%y)
        call log_dp_array(decompose(str, NUM_MODES))
    end subroutine

    subroutine evolve()
        str = symp_integrator(str, nonlinear_f, conf%int_order, conf%dt)
    end subroutine

end program
