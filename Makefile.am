# Makefile.am for feram
# Process this file with automake to create Makefile.in
# Time-stamp: <2011-12-24 17:28:52 takeshi>
# Author: Takeshi NISHIMATSU
##
AUTOMAKE_OPTIONS = foreign
SUBDIRS = src libbuilt_in_fft
EXTRA_DIST = README.en \
             index.en.html \
             README.ja \
             index.ja.html \
             TODO \
             ChangeLog \
             Changes \
             Development.txt \
             style.css \
             doc \
             parameters \
             animations \
             logo.eps \
             logo.jpg \
             logo.obj
CLEANFILES = *.html
SNAPSHOT_NAME=$(PACKAGE)-$(VERSION)_`date +"%Y-%m-%d_%H"`
SOURCEFORGE_FERAM=web.sourceforge.net:/home/groups/l/lo/loto/htdocs/feram

sf: sourceforge
sourceforge: index.en.html README.en index.ja.html README.ja COPYING style.css favicon.ico logo.jpg index.var dot.htaccess
	scp $<                            $(SOURCEFORGE_FERAM)/index.html
	scp dot.htaccess                  $(SOURCEFORGE_FERAM)/.htaccess
	scp $^                            $(SOURCEFORGE_FERAM)
	scp libblaslapack/COPYING         $(SOURCEFORGE_FERAM)/libblaslapack
#	cd  doc && $(MAKE) sourceforge

logo.jpg: logo.eps
	gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r120x120 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q $< \
	 | pnmcrop -white | cjpeg -quality 80 > $@

index.%.html: README.%
	ruby -I ~/ruby/ulmul/trunk/lib $< $< | sed -e 's%</h1>%</h1><div class="navi">[<a href="index.en.html">English</a>/<a href="index.ja.html">Japanese</a>]</div>%' > $@

dist-hook:
	rm -rf `find $(distdir) -type d -name .svn`
#	cd $(distdir)/doc        && $(MAKE)
#	cd $(distdir)/parameters && $(MAKE)

.PHONY: snapshot
snapshot:
	$(MAKE) dist distdir=$(SNAPSHOT_NAME)
	mpack -s $(SNAPSHOT_NAME).tar.xz $(SNAPSHOT_NAME).tar.xz takeshi@example.com
