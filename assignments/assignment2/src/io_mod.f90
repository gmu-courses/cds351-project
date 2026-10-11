module io_mod
   implicit none
   private

   public :: read_config, read_matrix, write_report

contains

   subroutine read_config(filename, matrix_a_file, matrix_b_file, output_file)
      character(len=*), intent(in) :: filename
      character(len=*), intent(out) :: matrix_a_file, matrix_b_file, output_file

      ! local variables
      integer :: unit, ios
      character(len=200) :: message
      namelist /config/ matrix_a_file, matrix_b_file, output_file

      open(newunit=unit, file=filename, status="old", action="read", &
           iostat=ios, iomsg=message)
      call error_stop(ios, "Error opening file", message)

      ! Note how we read a namelist, the format part is nml=config
      read(unit, nml=config, iostat=ios, iomsg=message)
      call error_stop(ios, "Error reading file", message, unit)

      close(unit, iostat=ios, iomsg=message)
      call error_stop(ios, "Could not close file", message)

   end subroutine read_config


   subroutine read_matrix(filename, matrix)
      character(len=*), intent(in) :: filename
      real, allocatable, intent(out) :: matrix(:,:)

      integer :: unit, ios, num_rows, num_cols, alloc_stat
      character(len=200) :: message  ! to capture error messages

      open(newunit=unit, file=filename, status="old", action="read", &
           iostat=ios, iomsg=message)
      call error_stop(ios, "Error opening file", message)

      ! Read matrix sizes (first line in the file)
      read(unit, *, iostat=ios, iomsg=message) num_rows, num_cols
      call error_stop(ios, "Error reading file", message, unit)

      ! Useful to check for bad inputs
      if (num_rows <= 0 .or. num_cols <= 0) then
         close(unit)
         error stop "Bad inputs: matrix dimensions must be positive."
      end if

      allocate(matrix(num_rows,num_cols), stat=alloc_stat, errmsg=message)
      call error_stop(alloc_stat, "Allocation error", message)

      ! Once matrix size is known, it can be read in one read()
      read(unit, *, iostat=ios, iomsg=message) matrix
      call error_stop(ios, "Error reading file", message, unit)

      close(unit, iostat=ios, iomsg=message)
      call error_stop(ios, "Could not close file", message)
   end subroutine read_matrix


   subroutine write_report(filename, a_file, b_file, a, b, c, error)
      character(len=*), intent(in) :: filename, a_file, b_file
      real, intent(in) :: a(:,:), b(:,:), c(:,:)
      real, intent(in) :: error

      integer :: unit, ios
      character(len=200) :: message

      open(newunit=unit, file=filename, status="replace", action="write", &
           iostat=ios, iomsg=message)
      call error_stop(ios, "Could not open file", message)

      write(unit, '(A,A)') "File 1: ", trim(a_file)
      write(unit, '(A,A)') "File 2: ", trim(b_file)
      ! Note the format:
      write(unit, '(A,2(I0,1X))') "Shape (a): ", shape(a)
      write(unit, '(A,2(I0,1X))') "Shape (b): ", shape(b)
      write(unit, '(A,2(I0,1X))') "Shape (c): ", shape(c)
      ! Using scientific notation
      write(unit, '(A,ES14.6)') "Sum (c): ", sum(c)
      write(unit, '(A,ES14.6)') "Relative error: ", error

      close(unit, iostat=ios, iomsg=message)
      call error_stop(ios, "Could not close file", message)
      
   end subroutine write_report

   subroutine error_stop(istatus, my_msg, message, unit)
       integer, intent(in) :: istatus
       character(len=*), intent(in) :: message, my_msg
       integer, intent(in), optional :: unit
       
       if (present(unit)) close(unit)
       if (istatus /= 0) error stop trim(my_msg) //": " // trim(message)
   end subroutine error_stop
   
end module io_mod

