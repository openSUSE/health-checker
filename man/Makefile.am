#
# Copyright (c) 2016, 2017 Thorsten Kukuk, Germany
#
# Author: Thorsten Kukuk <kukuk@suse.de>
#

CLEANFILES = $(MANS) $(DATA) health-check.index.xml

EXTRA_DIST = $(MANS) $(XMLS) custom-html.xsl \
	make-man-index.py xml_helper.py health-check.index.xml

man_MANS = issue.d.5 issue-generator.8 issue-generator.service.8 \
	issue-add-ssh-keys.service.8 90-issue-generator.rules.8 \
	issue-generator.conf.8
noinst_DATA = issue.d.5.html issue-generator.8.html \
	issue-generator.service.8.html issue-add-ssh-keys.service.8.html \
	90-issue-generator.rules.8.html issue-generator.conf.8.html
XMLS = issue.d.5.xml issue-generator.8.xml

XSLTPROC_FLAGS_HTML = \
	--nonet \
	--xinclude \
	--stringparam man.authors.section.enabled 0 \
	--stringparam man.copyright.section.enabled 0 \
	--stringparam issue-generator.version $(VERSION) \
	--stringparam chunker.output.encoding UTF-8 \
	$(srcdir)/custom-html.xsl


if ENABLE_REGENERATE_MAN

define html-alias
	$(LN_S) -f $(notdir $<) $@
endef

issue-generator.index.xml: make-man-index.py $(XMLS)
	python $(srcdir)/make-man-index.py $(srcdir)/$@ $(XMLS)

issue.d.5: issue.d.5.xml
	$(XSLTPROC) -o $(srcdir)/$@ --path $(srcdir) --xinclude --nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<

issue.d.5.html: issue.d.5.xml custom-html.xsl
	$(XSLTPROC) -o $(srcdir)/$@ --path $(srcdir) $(XSLTPROC_FLAGS_HTML) $<

issue-generator.8: issue-generator.8.xml
	$(XSLTPROC) -o $(srcdir)/$@ --path $(srcdir) --xinclude --nonet http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<

issue-generator.8.html: issue-generator.8.xml custom-html.xsl
	$(XSLTPROC) -o $(srcdir)/$@ --path $(srcdir) $(XSLTPROC_FLAGS_HTML) $<

90-issue-generator.rules.8.html: issue-generator.8.html
	$(html-alias)

issue-generator.conf.8.html: issue-generator.8.html
	$(html-alias)

issue-generator.service.8.html: issue-generator.8.html
	$(html-alias)

issue-add-ssh-keys.service.8.html: issue-generator.8.html
	$(html-alias)

endif
