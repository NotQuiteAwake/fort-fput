program fput
    use kind_parameter, only: dp, i4
    use grids
    use integrator, only: symp_integrator
    use modes
    use forces
    use io

    implicit none

    logical :: verbose = .false.
    integer(i4) :: size, steps, order, mode, i
    integer(i4), parameter :: OUTLEN = 20, NUM_MODES = 20
    real(dp) :: step_size, lat_param, mass, amp, cycle_threshold
    type(grid) :: string 
    type(force_param) :: f_param

    read(*, *) verbose
    read(*, *) size, lat_param, mass
    read(*, *) steps, step_size, order
    read(*, *) mode, amp
    read(*, *) f_param%k, f_param%alpha
    read(*, *) cycle_threshold

    if (verbose) then
        call write_params()
    end if

    string = create_grid(size, lat_param, mass)
    string%y = gen_nth_normal(string, mode, amp)

    do i = 1, steps
        call log()
        call evolve()
    end do

    do while (abs(1 - abs(get_comp(string, mode))) > cycle_threshold)
        call log()
        call evolve()
    end do

contains

    subroutine write_params()
        call log_param("size", size)
        call log_param("lattice param", lat_param)
        call log_param("mass", mass)

        call log_param("steps", steps)
        call log_param("step size", step_size)
        call log_param("integrator order", order)

        call log_param("initial normal mode", mode)
        call log_param("amplitude of mode", amp)
        
        call log_param("force constant k", f_param%k)
        call log_param("force constant alpha", f_param%alpha)

        call log_param("full cycle threshold", cycle_threshold)
    end subroutine

    subroutine log()
        call write_sep()
        call log_dp_array(string%y)
        call log_dp_array(decompose(string, NUM_MODES))
    end subroutine

    subroutine evolve()
        string = symp_integrator(string, nonlinear_f, f_param, step_size, order)     
    end subroutine

end program
