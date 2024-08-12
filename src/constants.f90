module constants
    use kind_parameter, only: dp, i4

    implicit none
    
    real(dp), parameter :: PI = 4.0_dp * atan(1.0_dp)
    real(dp), parameter :: EPS = 1D-6
end module
