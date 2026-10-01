program matrix_multiply
    implicit none
    
    integer :: i, j, k
    integer, parameter :: N = 1000
    
    real, allocatable :: a(:,:), b(:,:)
    real, allocatable :: c_loop(:,:), c_fast(:,:)
    real, allocatable :: c_intrinsic(:,:)
    real :: t0, t1
    real :: error_loop , error_fast
    real :: error_scale
    
    allocate(a(N,N), b(N,N), c_loop(N,N), c_fast(N,N))
    allocate(c_intrinsic(N,N))
    
    ! Initialize sample data
    call random_number(a)
    call random_number(b)
    
    ! Initialize result matrices
    c_loop = 0.0 
    c_fast = 0.0
    
    call cpu_time(t0)
    ! Nested DO loops (not-optimized) - i-j-k order
    do i = 1, N
        do j = 1, N
            do k = 1, N
                c_loop(i, j) = c_loop(i, j) + a(i, k) * b(k, j)
            end do
        end do
    end do
    call cpu_time(t1)
    print *, "baseline time (s):", t1 - t0

    call cpu_time(t0)
    ! Nested DO loops (column-major) - j-i-k order
    do j = 1, N
        do i = 1, N
            do k = 1, N
                c_fast(i, j) = c_fast(i, j) + a(i,  k) * b(k, j)
            end do
        end do
    end do
    call cpu_time(t1)
    print *, "column-major time (s):", t1 - t0

    ! Optimization using intrinsic function
    call cpu_time(t0)
    c_intrinsic = matmul(a, b)
    call cpu_time(t1)
    print *, "intrinsic function time (s):", t1 - t0

    ! Compute largest differences (absolute errors) between loops and intrinsic
    error_loop = maxval(abs(c_loop - c_intrinsic))
    error_fast = maxval(abs(c_fast - c_intrinsic))
    print *, "error_loop:", error_loop
    print *, "error_fast:", error_fast

    ! size of the largest result
    error_scale = maxval(abs(c_intrinsic))
    print *, "normalization factor:", error_scale
    ! Example normalized error
    print *, "normalized error_loop:", error_loop / error_scale

    ! deallocate (this is always automatic at the end of a program)
    deallocate(c_loop, c_fast, c_intrinsic, a, b)
        
end program matrix_multiply

