# Makefile.am for feram
# Process this file with automake to create Makefile.in
# Time-stamp: <2007-09-18 23:59:34 takeshi>
# Author: Takeshi NISHIMATSU
##
AUTOMAKE_OPTIONS = foreign
SUBDIRS = src libblaslapack libbuilt_in_fft
EXTRA_DIST = README \
             README.html \
             TODO \
             ulwmul2html.rb \
             ChangeLog \
             00MEMO \
             style.css \
             utils \
             examples \
             logo.eps \
             logo.jpg \
             logo.obj
CLEANFILES = *.html
SNAPSHOT_NAME=$(PACKAGE)-$(VERSION)_`date +"%Y-%m-%d_%H"`
SOURCEFORGE_FERAM=t-nissie@shell.sourceforge.net:/home/groups/l/lo/loto/htdocs/feram

sf: sourceforge
sourceforge: README.html COPYING style.css favicon.ico logo.jpg
	scp $<                            $(SOURCEFORGE_FERAM)/index.html
	scp $^                            $(SOURCEFORGE_FERAM)
	scp libblaslapack/COPYING         $(SOURCEFORGE_FERAM)/libblaslapack

logo.jpg: logo.eps
	gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r120x120 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q $< \
	 | pnmcrop -white | cjpeg -quality 80 > $@

README.html:  README         ulwmul2html.rb style.css
	ruby -I $(srcdir) $< $<                > $@

dist-hook:
	rm -rf `find $(distdir) -type d -name .svn`
	cd $(distdir)/examples && $(MAKE) clean

.PHONY: snapshot
snapshot:
	$(MAKE) dist distdir=$(SNAPSHOT_NAME)
	mpack -s $(SNAPSHOT_NAME).tar.gz $(SNAPSHOT_NAME).tar.gz t_nissie@yahoo.co.jp
