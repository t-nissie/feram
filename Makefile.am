# Makefile.am for feram
# Process this file with automake to create Makefile.in
# Time-stamp: <2016-09-20 12:24:39 takeshi>
# Author: Takeshi NISHIMATSU
##
AUTOMAKE_OPTIONS = foreign
SUBDIRS = src
EXTRA_DIST = README.en \
             index.en.html \
             README.ja \
             index.ja.html \
             README.md \
             INSTALL \
             INSTALL.html \
             favicon.ico \
             feram_logo.svg \
             Autotools-memo.ja \
             Autotools-memo.ja.html \
             TODO \
             ChangeLog \
             style.css \
             doc \
             parameters \
             animations \
             in-place-FFT.ja.txt
CLEANFILES = *.html
SNAPSHOT_NAME=$(PACKAGE)-$(VERSION)_`date +"%Y-%m-%d_%H"`
SOURCEFORGE_FERAM=web.sourceforge.net:/home/groups/l/lo/loto/htdocs/feram

sf: sourceforge
sourceforge: index.en.html README.en index.ja.html README.ja INSTALL.html INSTALL COPYING style.css favicon.ico index.var dot.htaccess Autotools-memo.ja Autotools-memo.ja.html
	scp $<                            $(SOURCEFORGE_FERAM)/index.html
	scp dot.htaccess                  $(SOURCEFORGE_FERAM)/.htaccess
	scp $^                            $(SOURCEFORGE_FERAM)
#	cd  doc && $(MAKE) sourceforge

index.%.html: README.%
	ruby $< $< | sed -e 's%</h1>%</h1><div class="navi">[<a href="index.en.html">English</a>/<a href="index.ja.html">Japanese</a>]</div> <figure><img src="feram_logo.svg" width=300 alt="feram logo" /></figure>%' > $@

INSTALL.html: INSTALL
	ulmul2html5 -s style.css -n 'Takeshi Nishimatsu' $< > $@

tutorial.%.html: tutorial.%.txt
	ulmul2html5 -s style.css -n 'Takeshi Nishimatsu' $< > $@

Autotools-memo.%.html: Autotools-memo.%
	ulmul2html5 -s style.css\
                    -l `basename $< | sed 's/Autotools-memo\.//'`\
                    -n 'Takeshi Nishimatsu' $< > $@

dist-hook:
	rm -rf `find $(distdir) -type d -name .svn`
#	cd $(distdir)/doc        && $(MAKE)
	cd $(distdir)/parameters && $(MAKE)

.PHONY: snapshot
snapshot:
	$(MAKE) dist distdir=$(SNAPSHOT_NAME)
	mpack -s $(SNAPSHOT_NAME).tar.xz $(SNAPSHOT_NAME).tar.xz takeshi@example.com
