module stats_mod
    implicit none
    private
    public :: mean_from_total
    public :: summarize
    
contains
    
    pure function mean_from_total(total, nvalid, missing_value) result(mean)
        implicit none
        real, intent(in) :: total
        real, intent(in) :: missing_value
        integer, intent(in) :: nvalid
        real :: mean
        
        if (nvalid > 0) then
            mean = total / real(nvalid)
        else
            mean = missing_value
        end if
        
    end function mean_from_total
    
    subroutine summarize(values, missing_value, total, minimum, maximum, nvalid)
        implicit none
        real, intent(in) :: values(:)
        real, intent(in) :: missing_value
        real, intent(out) :: total, minimum, maximum
        integer, intent(out) :: nvalid
        integer :: i
        
        nvalid = 0
        total = 0.0
        minimum = huge(0.0)
        maximum = -huge(0.0)
        do i = 1, size(values)
            if (values(i) == missing_value) cycle
            nvalid = nvalid + 1
            total = total + values(i)
            minimum = min(minimum, values(i))
            maximum = max(maximum, values(i))
        end do
        
    end subroutine summarize


end module stats_mod
