dnl Process this file with autoconf to produce a configure script.
AC_INIT(health-checker, 1.5)
AM_INIT_AUTOMAKE
AC_PREFIX_DEFAULT(/usr)

AC_SUBST(PACKAGE)
AC_SUBST(VERSION)

PKG_CHECK_VAR([systemdsystemunitdir], [systemd], [systemdsystemunitdir], [],
	[AC_MSG_ERROR([Could not determine value for 'systemdsystemunitdir' - is the 'systemd.pc' file installed?])])
PKG_CHECK_VAR([dracutmodulesdir], [dracut], [dracutmodulesdir], [],
	[AC_MSG_ERROR([Could not determine value for 'dracutmodulesdir' - is the 'dracut.pc' file installed?])])

AC_PROG_INSTALL
AC_PROG_LN_S

dnl
dnl Check for xsltproc
dnl
enable_man=yes
AC_PATH_PROG([XSLTPROC], [xsltproc])
if test -z "$XSLTPROC"; then
     enable_man=no
fi
AC_PATH_PROG([XMLLINT], [xmllint],[/bin/true])
dnl check for DocBook DTD and stylesheets in the local catalog.
JH_CHECK_XML_CATALOG([-//OASIS//DTD DocBook XML V4.3//EN],
                [DocBook XML DTD V4.3], [], enable_man=no)
JH_CHECK_XML_CATALOG([http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl],
                [DocBook XSL Stylesheets], [], enable_man=no)
AM_CONDITIONAL(ENABLE_REGENERATE_MAN, test x$enable_man != xno)

AC_OUTPUT([Makefile sbin/Makefile man/Makefile systemd/Makefile \
	plugins/Makefile dracut/Makefile grub/Makefile])
