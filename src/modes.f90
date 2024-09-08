module modes
    use kind_parameter, only: dp, i4
    use strings, only: string
    use constants

    implicit none

contains

    real(dp) function get_nth_period(str, mode) result(period)
        type(string) :: str
        integer(i4) :: mode
        
        real(dp) :: wvec, omega

        ! wvec for wavevector, to differentiate from spring constant k
        wvec = mode * PI / str%l
        omega = wvec * sqrt(str%k / str%rho) 
        
        period = 2 * PI / omega
    end function

    type(string) function gen_nth_normal(str, mode, amp) result(res)
        type(string), intent(in) :: str
        integer(i4), intent(in) :: mode ! n-th normal mode
        real(dp), intent(in), optional :: amp     ! amplitude

        integer(i4) :: i
        ! wavevector, amplitude used
        real(dp) :: k, A
        ! displacement along the chain for each particle
        real(dp), dimension(:), allocatable :: x !, res

        res = str  

        if (.not. present(amp)) then
            ! so that mode is normalised
            ! we don't do any normalisation when finding dot product
            A = sqrt(2.0_dp /(real(str%N, dp) - 1))
        else
            A = amp
        end if

        allocate(x(str%N))
        
        ! can set lat_param to 1 but lets stay physical
        x = [(i, i = 0, str%N - 1)] * str%dx
        k = mode * PI / str%l
        
        ! working with fixed boundaries so not changing them
        res%y(2:str%N - 1) = A * sin(k * x(2:str%N - 1))
    end function

    real(dp) function get_comp(str, mode) result(res)
        type(string), intent(in) :: str
        integer(i4), intent(in) :: mode
        
        type(string) :: nth_normal

        nth_normal = gen_nth_normal(str, mode)
        res = dot_product(nth_normal%y, str%y) / sqrt(dot_product(str%y, str%y))
    end function

    function decompose(str, num_modes) result(res)
        type(string), intent(in) :: str
        ! number of modes to calculate component for
        integer(i4), intent(in) :: num_modes
        real(dp), allocatable, dimension(:) :: res

        integer(i4) :: mode

        allocate(res(num_modes))
        res = [(get_comp(str, mode), mode = 1, num_modes)]
    end function

end module
