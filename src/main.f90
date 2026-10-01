program summarize_observations
    use io_mod, only: read_config, read_observations, write_summary
    use stats_mod, only: summarize, mean_from_total
    implicit none
    
    real, allocatable :: observations(:)
    real :: mean, minimum, maximum, total
    integer :: nvalid
    ! namelist variables
    character(len=200) :: input_file
    character(len=200) :: output_file
    character(len=80) :: dataset_name
    character(len=20) :: units
    real :: missing_value
    
    call read_config("config.nml", input_file, output_file, &
        dataset_name, units, missing_value)

    call read_observations(input_file, observations)
    
    call summarize(observations, missing_value, total, minimum, maximum, nvalid)
    mean = mean_from_total(total, nvalid, missing_value)

    call write_summary(output_file, dataset_name, units, &
        minimum, maximum, mean, nvalid)


end program summarize_observations
