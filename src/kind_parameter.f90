module kind_parameter
    implicit none
    public

    integer, parameter :: sp = selected_real_kind(6, 37)
    integer, parameter :: dp = selected_real_kind(15, 307)
    integer, parameter :: qp = selected_real_kind(33, 4931)

    integer, parameter :: i1 = selected_int_kind(2)
    integer, parameter :: i2 = selected_int_kind(4)
    integer, parameter :: i4 = selected_int_kind(9)  ! 32 bits
    integer, parameter :: i8 = selected_int_kind(18) ! 64 bits
end module kind_parameter
