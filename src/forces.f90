module forces
    use kind_parameter, only: i4, dp

    implicit none
    public

    type :: force_param
        ! stiffness and non-linearity
        real(dp) :: k, alpha
    end type

contains

    real(dp) function nonlinear_f(y1, y2, f_param) result(res)
        real(dp), intent(in) :: y1, y2
        type(force_param), intent(in) :: f_param 
        res = f_param%k * ((y2 - y1) + f_param%alpha * ((y2 - y1) ** 2))
    end function

end module
