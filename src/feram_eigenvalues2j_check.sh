#!/bin/sh
# feram_eigenvalues2j_check.sh
##
cat > feram_eigenvalues2j_check.in <<-EOF
	DDB_a = -3.812330
	DDB_b = 34.256065
	DDB_c = -2.844881
	DDB_d = -2.285745
	DDB_e = 32.665721
	DDB_f = 27.741413
	DDB_g =  0.0
	a0          = 3.98596961387263
	Z_star      = 10.33
	epsilon_inf = 6.8691464565
EOF
./feram_eigenvalues2j feram_eigenvalues2j_check.in
grep 61134 feram_eigenvalues2j_check.in.log
