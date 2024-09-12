module evolver
    use kind_parameter, only: dp, i4
    use integrator, only: symp_integrator
    use forces, only: nonlinear_f
    use strings
    use modes
    use configs
    use io, only: log

    implicit none

contains

    subroutine evolve_outside_thresh(str, t, conf, output)
        type(string), intent(inout) :: str
        real(dp), intent(inout) :: t
        type(config), intent(in) :: conf
        logical, intent(in) :: output

        do while (.not. thresh_met(str, conf%init_mode, conf%recur_thresh))
            if (output) then
                call log(str)
            end if

            call evolve(str, conf%int_order, conf%dt)
            t = t + conf%dt
        end do
    end subroutine

    subroutine evolve_while_thresh_met(str, t, conf, output)
        type(string), intent(inout) :: str
        real(dp), intent(inout) :: t
        type(config), intent(in) ::conf
        logical, intent(in) :: output

        real(dp) :: last, period

        period = get_nth_period(str, conf%init_mode)
        last = t 

        do while (t - last <= period * 2)
            if (output) then
                call log(str)
            end if

            call evolve(str, conf%int_order, conf%dt)
            t = t + conf%dt
            if (thresh_met(str, conf%init_mode, conf%recur_thresh)) then
                last = t
            end if
        end do
    end subroutine

    logical function thresh_met(str, init_mode, recur_thresh)
        type(string), intent(in) :: str
        integer(i4), intent(in) :: init_mode
        real(dp), intent(in) :: recur_thresh

        thresh_met = abs(get_comp(str, init_mode)) > recur_thresh
    end function

    subroutine evolve(str, int_order, dt)
        type(string), intent(inout) :: str
        integer(i4), intent(in) :: int_order
        real(dp), intent(in) :: dt

        str = symp_integrator(str, nonlinear_f, int_order, dt)
    end subroutine

end module
