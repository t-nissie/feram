# Makefile.am for feram
# Process this file with automake to create Makefile.in
# Time-stamp: <2007-09-07 07:33:43 takeshi>
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
             examples
CLEANFILES = *.html
SNAPSHOT_NAME=$(PACKAGE)-$(VERSION)_`date +"%Y-%m-%d_%H"`

index.html:   README         ulwmul2html.rb style.css
	ruby $< $<      > $@

#dist-hook:
#	cd $(distdir)/examples    && $(MAKE)     clean

#clean-local:
#	cd examples    && $(MAKE) clean
#	cd xmlf90-1.2g && $(MAKE) clean

.PHONY: snapshot
snapshot:
	$(MAKE) dist distdir=$(SNAPSHOT_NAME)
	mpack -s $(SNAPSHOT_NAME).tar.gz $(SNAPSHOT_NAME).tar.gz t_nissie@yahoo.co.jp
