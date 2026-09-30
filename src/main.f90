program summarize_observations
    use stats_mod, only: summarize, mean_from_total
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
