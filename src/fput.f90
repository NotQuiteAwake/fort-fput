program fput
    use kind_parameter, only: dp, i4
    use grids
    use integrator, only: symp_integrator

    implicit none

    integer(i4) :: size, steps, mode
    integer(i4), parameter :: OUTLEN = 20
    real(dp) :: step_size, lat_param, mass, amp
    type(grid) :: string 

    read(*, *) size, lat_param, mass
    read(*, *) steps, step_size
    read(*, *) mode, amp

    write(*, '(A20, I8)') "Size: ", size
    write(*, '(A20, F8.3)') "Lattice parameter: ", lat_param
    write(*, '(A20, F8.3)') "Mass: ", mass
    write(*, '(A20, I8)') "Steps: ", steps
    write(*, '(A20, F8.3)') "Step size: ", step_size

    string = create_grid(size, lat_param, mass)
    call init_nth_normal(string, 1, 1.0_dp)

    write(*, "(*(F4.2,X))") string%y

contains

end program
