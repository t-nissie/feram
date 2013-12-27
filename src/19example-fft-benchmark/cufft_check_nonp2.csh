#!/bin/csh
# Usage: ./cufft_check_nonp2.csh >cufft_check_nonp2.dat 2>cufft_check_nonp2.err &
##
./cufft_check  100000   30   30   30
./cufft_check   50000   48   48   48
./cufft_check   50000   54   54   54
./cufft_check   10000   32   32  243
./cufft_check   10000   72   72   72
echo            10000   75   75   75
./cufft_check    5000   80   80   80
echo             5000   81   81   81
./cufft_check    2000   96   96   96
./cufft_check    2000  100  100  100
./cufft_check    1000  120  120  120
./cufft_check     300  240  240  240
echo              100  243  243  243
./cufft_check     100  300  300  300
./cufft_check     100  320  320  320
./cufft_check      50  360  360  360
./cufft_check      50  400  400  400
echo               50  405  405  405
./cufft_check      50  432  432  432
./cufft_check      30  500  500  500
#/cufft_check      30  600  600  600
