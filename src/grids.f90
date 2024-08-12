module grids
    use kind_parameter, only: dp, i4
    use constants

    implicit none

    type :: grid
        ! size (length) of lattice
        integer(i4) :: size
        ! lattice parameter, mass per particle
        real(dp) :: lat_param, mass
        ! displacement, velocity, acceleration
        real(dp), allocatable, dimension(:) :: y, v, a
    end type

contains

    type(grid) function create_grid(size, lat_param, mass) result(string)
        integer(i4), intent(in) :: size
        real(dp), intent(in) :: lat_param
        real(dp), intent(in) :: mass
        
        allocate(string%y(size), string%v(size), string%a(size))

        string%size = size
        string%lat_param = lat_param
        string%mass = mass
        string%y = 0
        string%v = 0
        string%a = 0
    end function

    subroutine init_nth_normal(string, mode, amp)
        type(grid), intent(inout) :: string
        integer(i4), intent(in) :: mode ! n-th normal mode
        real(dp), intent(in) :: amp     ! amplitude
        
        integer(i4) :: i
        ! length of string, wavevector
        real(dp) :: length, k
        ! displacement(x) along the chain for each particle
        real(dp), dimension(:), allocatable :: disp
        
        length = (string%size - 1) * string%lat_param
        disp = [(i - 1, i = 1, string%size)] * string%lat_param
        k = mode * PI / length
        
        ! working with fixed boundaries so not changing them
        string%y(2:string%size - 1) = amp * sin(k * disp(2:string%size - 1))
        
        ! but if the boundary would have been significantly non-zero something
        ! is seriously wrong...
        if (abs(sin(k * length)) > EPS) then
            write(*, *) "warning: initialisation would alter boundary &
                & displacememt" 
        end if
    end subroutine

end module

