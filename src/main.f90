program summarize_observations
    implicit none
    real, parameter :: missing_value = -999.0
    real :: observations(6)
    real :: mean, minimum, maximum, total
    integer :: nvalid

    observations = [ 1.3, 4.1, 0.6, missing_value, &
        2.4, 3.2 ]
    
    call summarize(observations, missing_value, total, minimum, maximum, nvalid)
    mean = mean_from_total(total, nvalid, missing_value)
    call print_summary(minimum, maximum, mean, nvalid)
    
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

    subroutine print_summary(minimum, maximum, mean, nvalid)
        implicit none
        real, intent(in) :: minimum, maximum, mean
        integer, intent(in) :: nvalid
        
        if (nvalid > 0) then
            print *, "Number of observations:", size(observations)
            print *, "Valid observations:", nvalid
            print *, "Minimum:", minimum
            print *, "Maximum:", maximum
            print *, "Mean:", mean
        else
            print *, "No valid observations."
        end if
        
    end subroutine print_summary

end program summarize_observations
