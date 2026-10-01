module io_mod
    use iso_fortran_env, only: iostat_end
    implicit none
    private
    ! Add each name after its procedure has been written:
    public :: read_config
    public :: read_observations
    public :: write_summary
    
contains
    
    ! procedure implementations go here
    subroutine read_config(filename, input_file, output_file, &
        dataset_name, units, missing_value)
        character(len=*), intent(in) :: filename
        character(len=*), intent(out) :: input_file, output_file
        character(len=*), intent(out) :: dataset_name, units
        real, intent(out) :: missing_value
        ! local variables
        integer :: unit ! unit number
        integer :: ios ! status flag
        character(len=200) :: message

        namelist /config/ input_file, output_file, dataset_name, &
            units, missing_value

        open(newunit=unit, file=filename, status="old", &
            action="read", iostat=ios, iomsg=message)
        if (ios /= 0) error stop "Could not open config.nml: " // trim(message)
        read(unit, nml=config, iostat=ios, iomsg=message)
        if (ios /= 0) error stop "Could not read config.nml: " // trim(message)
        
        close(unit, iostat=ios, iomsg=message)
        if (ios /= 0) error stop "Could not close config.nml: " // trim(message)

    end subroutine read_config

    subroutine read_observations(filename, values)
        character(len=*), intent(in) :: filename
        real, allocatable, intent(out) :: values(:)
        ! local variables
        integer :: unit ! unit number
        integer :: ios ! status flag
        integer :: i, n
        character(len=200) :: message
        real :: value

        ! open file
        open(newunit=unit, file=filename, &
            status="old", action="read", iostat=ios, iomsg=message)
        if (ios /= 0) then
            error stop "Could not open input file: " // trim(message)
        end if
        
        ! count records
        n=0
        do
            read(unit, *, iostat=ios, iomsg=message) value
            if (ios == iostat_end) exit
            if (ios /= 0) then
                error stop "Invalid data record: " // trim(message)
            end if
            n=n+1
        end do
        
        ! rewind
        rewind(unit, iostat=ios, iomsg=message)
        if (ios /= 0) error stop "Could not rewind: " // trim(message)
        
        ! allocate values
        allocate(values(n))
        ! read values
        do i = 1, n
            read(unit, *, iostat=ios, iomsg=message) values(i)
            if (ios /= 0) then
                error stop "Could not read observation: " // trim(message)
            end if
        end do
        
        ! close file
        close(unit, iostat=ios, iomsg=message)
        if (ios /= 0) then
            error stop "Could not close file: " // trim(message)
        end if
        
    end subroutine read_observations

    subroutine write_summary(filename, dataset_name, units, &
        minimum, maximum, mean, nvalid)
        character(len=*), intent(in) :: filename
        character(len=*), intent(in) :: dataset_name, units
        real, intent(in) :: minimum, maximum, mean
        integer, intent(in) :: nvalid
        ! local variables
        integer :: unit ! unit number
        integer :: ios ! status flag
        character(len=200) :: message

        open(newunit=unit, file=filename, &
            status="replace", action="write", iostat=ios, iomsg=message)
        if (ios /= 0) then
            error stop "Could not open output file: " // trim(message)
        end if
        
        write(unit, '(a, a)')     "Dataset: ", trim(dataset_name)
        write(unit, '(a, a)')     "Units:   ", trim(units)
        write(unit, '(a, i10)')   "Valid:   ", nvalid
        write(unit, '(a, f10.3)') "Minimum: ", minimum
        write(unit, '(a, f10.3)') "Maximum: ", maximum
        write(unit, '(a, f10.3)') "Mean:    ", mean


        ! close output file
        close(unit, iostat=ios, iomsg=message)
        if (ios /= 0) error stop "Could not close output/summary.txt: " // trim(message)
        
    end subroutine write_summary
    
end module io_mod
