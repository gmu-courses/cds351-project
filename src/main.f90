program summarize_observations
    implicit none
    real, parameter :: missing_value = -999.0
    real :: observations(6)
    real :: mean, sum_value, minimum, maximum
    integer :: valid_count
    
    observations = [ 1.3, 4.1, 0.6, missing_value, &
        2.4, 3.2 ]
    
    valid_count = count(observations /= missing_value)
    
    if (valid_count > 0) then
        sum_value = sum(observations, mask = observations /= missing_value)
        minimum = minval(observations, mask = observations /= missing_value)
        maximum = maxval(observations, mask = observations /= missing_value)
        mean = sum_value / real(valid_count)
    end if

    if (valid_count > 0) then
        print *, "Number of observations:", size(observations)
        print *, "Valid observations:", valid_count
        print *, "Minimum:", minimum
        print *, "Maximum:", maximum
        print *, "Mean:", mean
    else
        print *, "No valid observations."
    end if
end program summarize_observations


