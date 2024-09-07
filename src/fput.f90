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
    integer :: i
    type(config) :: conf

    conf = read_params()
    call write_params()

    str = create_string(conf%N, conf%dx, conf%rho, conf%k, conf%alpha)
    str = gen_nth_normal(str, conf%init_mode, conf%A)

    do i = 1, conf%init_steps
        call log()
        call evolve()
    end do

    do while (abs(1 - abs(get_comp(str, conf%init_mode))) > conf%recur_thresh)
        call log()
        call evolve()
    end do

contains

    type(config) function read_params() result(conf)
        read(*, *) conf%N, conf%dx, conf%rho
        read(*, *) conf%init_steps, conf%dt, conf%int_order
        read(*, *) conf%init_mode, conf%A
        read(*, *) conf%k, conf%alpha
        read(*, *) conf%recur_thresh
    end function

    subroutine write_params()
        call log_param("N", conf%N)
        call log_param("a", conf%dx)
        call log_param("rho", conf%rho)

        call log_param("init_steps", conf%init_steps)
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
