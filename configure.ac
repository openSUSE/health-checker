dnl Process this file with autoconf to produce a configure script.
AC_INIT(caasp-health-check, 0.1)
AM_INIT_AUTOMAKE
AC_CONFIG_SRCDIR([sbin/caasp-health-check.in])
AC_PREFIX_DEFAULT(/usr)

AC_SUBST(PACKAGE)
AC_SUBST(VERSION)

if test ${libexecdir} = '${exec_prefix}/libexec'
then
  libexecdir='${exec_prefix}/lib'
  if test "${exec_prefix}" = "NONE"
  then
    TMPFILESDIR=${prefix}/lib/tmpfiles.d
    SYSTEMDDIR=${prefix}/lib/systemd/system
  else
    TMPFILESDIR=${exec_prefix}/lib/tmpfiles.d
    SYSTEMDDIR=${exec_prefix}/lib/systemd/system
  fi
else
  TMPFILESDIR=${libexecdir}/tmpfiles.d
  SYSTEMDDIR=${libexecdir}/systemd/system
fi
AC_SUBST(TMPFILESDIR)
AC_SUBST(SYSTEMDDIR)

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
	sbin/caasp-health-check])
