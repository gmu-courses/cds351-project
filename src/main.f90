program summarize_observations
    implicit none

    real :: a, b, c
    real :: mean

    a = 1.3
    b = 4.1
    c = 0.6

    mean = (a + b + c) / 3.0

    print *, "Mean observation:", mean

end program summarize_observations
