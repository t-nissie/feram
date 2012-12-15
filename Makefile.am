# Makefile.am for feram
# Process this file with automake to create Makefile.in
# Time-stamp: <2012-12-15 16:00:43 takeshi>
# Author: Takeshi NISHIMATSU
##
AUTOMAKE_OPTIONS = foreign
SUBDIRS = src
EXTRA_DIST = README.en \
             index.en.html \
             README.ja \
             index.ja.html \
             INSTALL \
             INSTALL.html \
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
sourceforge: index.en.html README.en index.ja.html README.ja INSTALL.html INSTALL COPYING style.css favicon.ico logo.jpg index.var dot.htaccess
	scp $<                            $(SOURCEFORGE_FERAM)/index.html
	scp dot.htaccess                  $(SOURCEFORGE_FERAM)/.htaccess
	scp $^                            $(SOURCEFORGE_FERAM)
#	cd  doc && $(MAKE) sourceforge

logo.jpg: logo.eps
	gs -q -sDEVICE=ppm -sPAPERSIZE=a4 -r120x120 -dSAFER -dNOPAUSE -dBATCH -sOutputFile=- -q $< \
	 | pnmcrop -white | cjpeg -quality 80 > $@

index.%.html: README.%
	ruby -I ~/ruby/ulmul/trunk/lib $< $< | sed -e 's%</h1>%</h1><div class="navi">[<a href="index.en.html">English</a>/<a href="index.ja.html">Japanese</a>]</div>%' > $@

INSTALL.html: INSTALL
	ulmul2html5 -s style.css -n 'Takeshi Nishimatsu' $< > $@

autotools-memo.%.html: autotools-memo.%
	ulmul2html5 -s style.css\
                    -l `echo $< | sed 's/autotools-memo\.//'`\
                    -n 'Takeshi Nishimatsu' $< > $@

dist-hook:
	rm -rf `find $(distdir) -type d -name .svn`
#	cd $(distdir)/doc        && $(MAKE)
#	cd $(distdir)/parameters && $(MAKE)

.PHONY: snapshot
snapshot:
	$(MAKE) dist distdir=$(SNAPSHOT_NAME)
	mpack -s $(SNAPSHOT_NAME).tar.xz $(SNAPSHOT_NAME).tar.xz takeshi@example.com
