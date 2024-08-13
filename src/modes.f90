module modes
    use kind_parameter, only: dp, i4
    use grids, only: grid
    use constants

    implicit none


contains

    function gen_nth_normal(string, mode, amp) result(res)
        type(grid), intent(in) :: string
        integer(i4), intent(in) :: mode ! n-th normal mode
        real(dp), intent(in), optional :: amp     ! amplitude

        integer(i4) :: i
        ! wavevector, amplitude used
        real(dp) :: k, A
        ! displacement(x) along the chain for each particle
        real(dp), dimension(:), allocatable :: disp, res

        if (.not. present(amp)) then
            ! so that mode is normalised
            ! we don't do any normalisation when finding dot product
            A = sqrt(2.0_dp /(real(string%size, dp) - 1))
        else
            A = amp
        end if

        allocate(disp(string%size))
        allocate(res(string%size))
        
        ! can set lat_param to 1 but lets stay physical
        disp = [(i - 1, i = 1, string%size)] * string%lat_param
        k = mode * PI / string%length
        
        ! working with fixed boundaries so not changing them
        res(2:string%size - 1) = A * sin(k * disp(2:string%size - 1))
        
        ! but if the boundary would have been significantly non-zero something
        ! is seriously wrong...
        if (abs(sin(k * string%length)) > EPS) then
            write(*, *) "warning: initialisation would alter boundary &
                & displacement" 
        end if
    end function

    real(dp) function get_norm(y) result(res)
        real(dp), dimension(:), intent(in) :: y 
        ! it is an easy operation, yes, but we need to fix our inner product
        ! convention. Here I simply use the dot product and ignore length scales
        res = sqrt(dot_product(y, y))
    end function

    real(dp) function get_comp(string, mode) result(res)
        type(grid), intent(in) :: string
        integer(i4), intent(in) :: mode
        
        ! nth normal mode, normalised y in string
        real(dp), allocatable, dimension(:) :: nth_normal, y_normal

        nth_normal = gen_nth_normal(string, mode)
        res = dot_product(nth_normal, string%y) / get_norm(string%y)
    end function

    function decompose(string, num_modes) result(res)
        type(grid), intent(in) :: string
        ! number of modes to calculate component for
        integer(i4), intent(in) :: num_modes
        real(dp), allocatable, dimension(:) :: res

        integer(i4) :: mode

        allocate(res(num_modes))
        res = [(get_comp(string, mode), mode = 1, num_modes)]
    end function

end module
