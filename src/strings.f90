module strings
    use kind_parameter, only: dp, i4

    implicit none

    type :: string
        integer(i4) :: N
        real(dp) :: dx, rho, m, l, k, alpha
        real(dp), allocatable, dimension(:) :: y, v, a
    end type

contains

    ! when I use str and string as non-reserved words I am always afraid of
    ! getting hit by thunder...
    type(string) function create_string(N, dx, rho, k, alpha) result(str)
        integer(i4) :: N
        real(dp) :: dx, rho, k, alpha

        allocate(str%y(N), str%v(N), str%a(N))

        str%N = N
        str%k = k
        str%alpha = alpha

        str%dx = dx
        str%l = dx * (N - 1)

        str%rho = rho
        str%m = rho * dx

        str%y = 0
        str%v = 0
        str%a = 0
    end function

end module

