#-*-Makefile-*- for 06example-BaTiO3-potential-surface-100
# Time-stamp: <2008-02-25 09:47:43 takeshi>
# Author: Takeshi NISHIMATSU
##
diff: potential-surface-100.sh all-potential-surface-100.gp
	diff -u ../05example-BaTiO3-potential-surface-110/potential-surface-110.sh     potential-surface-100.sh ; true
	diff -u ../05example-BaTiO3-potential-surface-110/all-potential-surface-110.gp all-potential-surface-100.gp ; true

potential-surface-100.sh: ../05example-BaTiO3-potential-surface-110/potential-surface-110.sh Makefile
	sed -e 's/-110/-100/g' -e 's/$$k_stripe $$k_stripe 0.0/$$k_stripe 0.0       0.0/' $< > $@

# all-potential-surface-100.gp: ../05example-BaTiO3-potential-surface-110/all-potential-surface-110.gp Makefile
# 	sed -e 's/-110/-100/g' \
#             -e 's%1/24 1/24 %1/24 0 %' \
#             -e 's%1/16 1/16 %1/16 0 %' \
#             -e 's%1/12 1/12 %1/12 0 %' \
#             -e 's%1/8 1/8 %1/8 0 %' \
#             -e 's%1/6 1/6 %1/6 0 %' \
#             -e 's%1/4 1/4 %1/4 0 %' \
#             $< > $@

all-potential-surface-100.ps: all-potential-surface-100.gp
	./$<

clean:
	rm -f feram.* *.ps *.pdf *110k*.dat
