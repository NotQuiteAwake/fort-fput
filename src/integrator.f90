module integrator
    use kind_parameter, only: dp, i4
    use grids, only: grid
    use forces
    
    implicit none
    private

    public :: symp_integrator, force_func

    abstract interface
        real(dp) function force_func(y1, y2, f_param) result(force)
            import :: dp
            import :: force_param
            !y1, y2: displacements
            real(dp), intent(in) :: y1, y2
            type(force_param), intent(in) :: f_param
        end function 
    end interface

    integer(i4), parameter :: max_order = 3
    real(dp), parameter, dimension(3, 3) :: symp_c = transpose(reshape([ &
        1.0_dp, 0.0_dp, 0.0_dp, &
        0.0_dp, 1.0_dp, 0.0_dp, &
        1.0_dp, -2.0_dp / 3.0_dp, 2.0_dp / 3.0_dp &
        ], [3, 3]))

    real(dp), parameter, dimension(3, 3) :: symp_d = transpose(reshape([ &
        1.0_dp, 0.0_dp, 0.0_dp, &
        0.5_dp, 0.5_dp, 0.0_dp, &
        1.0_dp / 24.0_dp , -3.0_dp / 4.0_dp, 7.0_dp / 24.0_dp &
        ], [3, 3]))

contains
    
    type(grid) function symp_integrator(string, force, f_param, step_size, &
            order) result(res)

        type(grid), intent(in) :: string
        procedure(force_func) :: force
        type(force_param), intent(in) :: f_param
        real(dp), intent(in) :: step_size
        integer(i4), intent(in) :: order

        integer(i4) :: i, j
        real(dp), allocatable, dimension(:) :: f, f_tot

        allocate(f(string%size), f_tot(string%size))

        f = 0
        f_tot = 0

        res = string

        if (order > max_order .or. order < 1) then
            write(*, *) "warning: symp_integrator cannot handle supplied order."
            return 
        end if

        do i = 1, order
            res%y = res%y + step_size * symp_c(i, order) * res%v

            ! force on particles 1...(size - 1) from particle on the right
            f = [(force(res%y(j), res%y(j + 1), f_param), j = 1, res%size - 1)]
            ! force on particles 2...(size - 1)
            f_tot(2:res%size - 1) = [(-f(j - 1) + f(j), j = 2, res%size - 1)]
            ! acceleration on the same particles            
            res%a = f_tot / res%mass 
            
            res%v = res%v + step_size * symp_d(i, order) * res%a

            ! check fixed BC
            if (any(res%y([1, res%size]) /= 0)) then
                write(*, *) "warning: displacement changed on fixed boundary."
                return
            end if
        end do
    end function

end module
