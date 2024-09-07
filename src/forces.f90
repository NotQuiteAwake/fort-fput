module forces
    use kind_parameter, only: i4, dp

    implicit none
    public

contains

    real(dp) function nonlinear_f(dy, dx, k, alpha) result(res)
        real(dp), intent(in) :: dy, dx, k, alpha
        real(dp) :: yp  ! y_prime, or dy/dx

        yp = dy / dx
        res = k * (yp + alpha * (yp ** 2))
    end function

end module
