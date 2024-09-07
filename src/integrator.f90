module integrator
    use kind_parameter, only: dp, i4
    use strings, only: string
    use forces
    
    implicit none
    private

    public :: symp_integrator, force_func

    abstract interface
        real(dp) function force_func(dy, dx, k, alpha) result(force)
            import :: dp
            !y1, y2: displacements
            real(dp), intent(in) :: dy, dx, k, alpha
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
    
    type(string) function symp_integrator(str, force, int_order, dt) result(res)

        type(string), intent(in) :: str
        procedure(force_func) :: force
        integer(i4), intent(in) :: int_order
        real(dp), intent(in) :: dt

        integer(i4) :: i, j
        real(dp), allocatable, dimension(:) :: f, f_tot, dy

        allocate(f(str%N), f_tot(str%N), dy(str%N))

        f = 0
        f_tot = 0
        dy = 0

        res = str

        if (int_order > max_order .or. int_order < 1) then
            write(*, *) "warning: symp_integrator cannot handle supplied order."
            return 
        end if

        do i = 1, int_order
            res%y = res%y + dt * symp_c(i, int_order) * res%v

            dy = [(res%y(j + 1) - res%y(j), j = 1, str%N - 1)]

            ! force on particles 1...(size - 1) from particle on the right
            f = [(force(dy(j), str%dx, str%k, str%alpha), j = 1, str%N - 1)]

            ! net force on particles 2...(size - 1)
            f_tot(2:str%N - 1) = [(-f(j - 1) + f(j), j = 2, str%N - 1)]

            ! acceleration on the same particles            
            res%a = f_tot / str%m
            
            res%v = res%v + dt * symp_d(i, int_order) * res%a

            ! check fixed BC
            if (any(res%y([1, str%N]) /= 0)) then
                write(*, *) "warning: displacement changed on fixed boundary."
                return
            end if
        end do
    end function

end module
