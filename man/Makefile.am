#
# Copyright (c) 2017 Thorsten Kukuk, Germany
#
# Author: Thorsten Kukuk <kukuk@suse.de>
#

plugindir = ${libexecdir}/health-checker

CLEANFILES = $(MANS) $(DATA) health-checker.index.xml

EXTRA_DIST = $(MANS) $(DATA) health-checker.8.xml.in

man_MANS = health-checker.8 health-checker.service.8

XMLS = health-checker.8.xml

if ENABLE_REGENERATE_MAN
health-checker.8.xml: health-checker.8.xml.in
	sed 's|@PLUGINDIR@|${plugindir}|g' $(srcdir)/health-checker.8.xml.in > health-checker.8.xml

health-checker.8: health-checker.8.xml
	$(XSLTPROC) -o $@ --path $(srcdir) --xinclude --nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<
endif
