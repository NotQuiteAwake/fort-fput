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

    select case (conf%operation)
        case ("simulate")
            call write_params(conf)

            call evolve_while_thresh_met(str, t, conf, .true.)
            call evolve_outside_thresh(str, t, conf, .true.)
            call evolve_while_thresh_met(str, t, conf, .true.)

        case ("time")
            call evolve_while_thresh_met(str, t, conf, .false.)
            call evolve_outside_thresh(str, t, conf, .false.)
            write(*, *) t

        case default
            write(*, *) "operation not available."
    end select
        
end program
