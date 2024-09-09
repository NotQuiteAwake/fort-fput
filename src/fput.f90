program fput
    use kind_parameter, only: dp, i4
    use strings
    use io
    use configs
    use evolver

    implicit none

    type(string) :: str 
    type(config) :: conf
    real(dp) :: t = 0.0_dp

    call read_params(conf, str)
    call write_params(conf)

    call evolve_while_thresh_met(str, t, conf)
    call evolve_outside_thresh(str, t, conf)
    call evolve_while_thresh_met(str, t, conf)
end program
