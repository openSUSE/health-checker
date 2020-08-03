#
# Copyright (c) 2017 Thorsten Kukuk <kukuk@suse.de>
#

sbin_SCRIPTS = health-checker
CLEANFILES = $(sbin_SCRIPTS)
EXTRA_DIST = health-checker.in

plugindir = ${libexecdir}/health-checker

health-checker: health-checker.in
	sed 's|@PLUGINDIR@|${plugindir}|g' $(srcdir)/health-checker.in > health-checker
	chmod +x health-checker
