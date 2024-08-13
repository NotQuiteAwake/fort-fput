program fput
    use kind_parameter, only: dp, i4
    use grids
    use integrator, only: symp_integrator
    use modes
    use forces

    implicit none

    logical :: verbose = .false.
    integer(i4) :: size, steps, order, mode, i
    integer(i4), parameter :: OUTLEN = 20
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
        write(*, '(A20, I8)') "Size: ", size
        write(*, '(A20, F8.3)') "Lattice parameter: ", lat_param
        write(*, '(A20, F8.3)') "Mass: ", mass
        write(*, '(A20, F8.3)') "Amplitude: ", amp
        write(*, '(A20, I8)') "Initial steps: ", steps
        write(*, '(A20, F8.3)') "Step size: ", step_size
        write(*, '(A20, I8)') "Integrator order: ", order
        write(*, '(A20, F8.3, F8.3)') "Force parameters: ", f_param%k, f_param%alpha
        write(*, '(A20, F8.3)') "Cycle threshold: ", cycle_threshold
    end if

    string = create_grid(size, lat_param, mass)
    string%y = gen_nth_normal(string, mode, amp)

    do i = 1, steps
        write(*, '(*(F7.4,2X))') decompose(string, 5)
        string = symp_integrator(string, nonlinear_f, f_param, step_size, order)     
    end do

    do while (abs(1 - abs(get_comp(string, mode))) > cycle_threshold)
        write(*, '(*(F7.4,2X))') decompose(string, 5)
        string = symp_integrator(string, nonlinear_f, f_param, step_size, order)     
    end do

end program
