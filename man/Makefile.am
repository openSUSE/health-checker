#
# Copyright (c) 2017 Thorsten Kukuk, Germany
#
# Author: Thorsten Kukuk <kukuk@suse.de>
#

plugindir = ${libexecdir}/health-checker

CLEANFILES = $(MANS) $(DATA) health-checker.index.xml

EXTRA_DIST = $(MANS) $(DATA) custom-html.xsl health-checker.8.xml.in \
	make-man-index.py xml_helper.py health-checker.index.xml

man_MANS = health-checker.8 health-checker.service.8

noinst_DATA = health-checker.8.html health-checker.service.8.html \
	health-checker.index.html

XMLS = health-checker.8.xml

XSLTPROC_FLAGS_HTML = \
	--nonet \
	--xinclude \
	--stringparam man.authors.section.enabled 0 \
	--stringparam man.copyright.section.enabled 0 \
	--stringparam package.name $(PACKAGE) \
	--stringparam package.version $(VERSION) \
	--stringparam chunker.output.encoding UTF-8 \
	$(srcdir)/custom-html.xsl


if ENABLE_REGENERATE_MAN
define html-alias
	$(LN_S) -f $(notdir $<) $@
endef

health-checker.index.xml: make-man-index.py $(XMLS)
	python3 $(srcdir)/make-man-index.py $@ $(XMLS)

health-checker.index.html: health-checker.index.xml custom-html.xsl
	$(XSLTPROC) -o $@ --path $(srcdir) $(XSLTPROC_FLAGS_HTML) $<

health-checker.8.xml: health-checker.8.xml.in
	sed 's|@PLUGINDIR@|${plugindir}|g' $(srcdir)/health-checker.8.xml.in > health-checker.8.xml

health-checker.8: health-checker.8.xml
	$(XSLTPROC) -o $@ --path $(srcdir) --xinclude --nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<

health-checker.8.html: health-checker.8.xml custom-html.xsl
	$(XSLTPROC) -o $@ --path $(srcdir) $(XSLTPROC_FLAGS_HTML) $<

health-checker.service.8.html: health-checker.8.html
	$(html-alias)

endif
