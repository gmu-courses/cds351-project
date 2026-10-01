# Assignment 1 sample solution
Student Name: C. Cruz
Assignment Number: 1
GNU Fortran (Homebrew GCC 16.2.0) 16.2.0

## Baseline Experiment (1.2)

###Baseline vs Column-major order

#### Compile and run


```bash
gfortran -Wall -Wextra -fcheck=all -g -O0 matrix_multiply.f90 -o matrix_multiply.x
./matrix_multiply.x


 baseline time (s):   5.36260843
 column-major time (s):   5.29511261
```

As expected, the timings for the two orderings differ very little here. The reason
is that compiler optimization, specified by the compiler flags, is very important and
in our case we have turned it off - that's the -O0 flag. Therefore, the timings
are dominated by the iteration overhead.

## Optimization Experiment (1.3)

Compute matmul() and error values. Then, build an optimized executable:

#### Compile and run


```bash
gfortran -O3 matrix_multiply.f90 -o matrix_multiply_opt.x
./matrix_multiply_opt.x


 baseline time (s):  0.870159030
 column-major time (s):  0.847732067
 intrinsic function time (s):   2.06450224E-02
 error_loop:   5.03540039E-04
 error_fast:   5.03540039E-04
 normalization factor:   283.166565
 normalized error_loop:   1.77824677E-06
```

#### Shell timings

```bash
❯ /usr/bin/time -p ./matrix_multiply.x
 baseline time (s):   5.29593992
 column-major time (s):   5.20388842
real 10.51
user 10.49
sys 0.01

❯ /usr/bin/time -p ./matrix_multiply_opt.x
 baseline time (s):  0.870613992
 column-major time (s):  0.847719014
 intrinsic function time (s):   2.10009813E-02
 error_loop:   5.18798828E-04
 error_fast:   5.18798828E-04
 normalization factor:   281.666748
 normalized error_loop:   1.84188877E-06
real 1.75
user 1.74
sys 0.00
```

As noted in the assignment text the default build is slow for two reasons:
it is unoptimized, and -fcheck=all verifies every array reference.
With optimization enabled, the -O3 falg, the two loop orderings usually separate
sharply, often by a factor of ten or more. How? That's the job of the compiler!

#### Notes:
How large are the results? Each Cij is a sum of 1,000 products. Each factor is
uniform on [0, 1) with mean 0.5, so each product averages 0.25, and a typical
element is about 1000 × 0.25 = 250. The largest element, which is what maxval
returns, is somewhat larger (about 280 in a typical run).

On the absolute errors: Default real carries about 7 significant decimal digits
~1.2 × 10−7. Near 250, neighboring representable reals are ~1.5 x 10−5 apart,
so every addition at this magnitude may be rounded by about that much.
Each element takes 1,000 additions. When matmul adds the same terms in a
different order, its rounding errors differ from yours, and the differences
accumulate. The largest difference over all 10^6 elements is then typically a
few times 10−4. A run at N = 1000 gave about 5 x 10−4.

The normalized error. (5 x 10−4)/250 ~ 2 x 10−6. That is what you should expect
from 1,000 rounded additions in a type that holds about seven. A rounding difference.

Why the scale matters: If the results were of order 10−3,the same absolute
difference would give (5 x 10−4)/10−3 = 0.5, i.e, the two answers would disagree
by 50%. At that size a difference of 5 × 10−4 cannot come from rounding which would
imply an error in the algorithm.

### Known limitations.

I'll mention one:

I ran this on my laptop. I have a ton of applications running, i.e. it is not
a dedicated system for scientific computing!

The same is true of the CDS cluster. Therefore, all the runs are competing with
other running applications. This is an important consideration when running an HPC
application.




