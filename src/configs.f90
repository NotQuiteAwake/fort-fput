! Of course one can pass the type around to do anything but it should in
! principle only be used for storing read-in values, or you risk:
!
! - unclear function signatures, because evertying just takes in a "conf" 
! - serious dependency problems on the type(config) making changes impossible
! - Storing and using the same value (eg rho) in different variables

module configs
    use kind_parameter, only: dp, i4

    implicit none
    public

    integer(i4), parameter :: OUTLEN = 20, NUM_MODES = 20
    
    type :: config
        integer(i4) :: N, init_steps, init_mode, int_order
        real(dp) :: dt, dx, rho, A, recur_thresh
        ! k understood as string tension;
        ! alpha is dimensionless nonlinearity coefficient
        real(dp) :: k, alpha
    end type

end module
