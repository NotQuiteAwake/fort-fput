module grids
    use kind_parameter, only: dp, i4

    implicit none

    type :: grid
        ! size (length) of lattice
        integer(i4) :: size
        ! lattice parameter, mass per particle
        real(dp) :: lat_param, mass, length
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
        string%length = lat_param * (size - 1)
        string%mass = mass
        string%y = 0
        string%v = 0
        string%a = 0
    end function

end module

